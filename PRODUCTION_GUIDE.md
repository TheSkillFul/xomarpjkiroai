# AccountPro Production Deployment Guide

## 🚀 Complete Production Setup

### Prerequisites
- Docker & Docker Compose
- Node.js 18+ (for development)
- Git
- SSL certificates (for production)

### Quick Production Deployment

1. **Clone and Setup:**
```bash
git clone <repository-url>
cd accountpro-dashboard
```

2. **Run Deployment Script:**
```bash
# Make script executable (Linux/Mac)
chmod +x scripts/deploy.sh

# Run deployment
./scripts/deploy.sh
```

3. **Manual Setup (Windows/Alternative):**
```bash
# Create environment file
cp .env.example .env

# Edit .env with your settings
# Generate secure passwords for production

# Start services
docker-compose up -d --build
```

### Environment Configuration

Create `.env` file in root directory:

```env
# Production Environment
NODE_ENV=production
DOMAIN=your-domain.com

# Database
DB_PASSWORD=your_secure_db_password

# Security
JWT_SECRET=your_super_secure_jwt_secret_key_64_chars_minimum

# Redis
REDIS_PASSWORD=your_redis_password

# Email Configuration
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
```

### SSL Configuration

For production, replace self-signed certificates:

```bash
# Place your SSL certificates
cp your-cert.pem nginx/ssl/cert.pem
cp your-key.pem nginx/ssl/key.pem

# Update nginx.conf to enable HTTPS
# Uncomment HTTPS server block in nginx/nginx.conf
```

### Database Backup Strategy

```bash
# Automated backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker exec accountpro-db pg_dump -U postgres accountpro > backup_$DATE.sql

# Restore from backup
docker exec -i accountpro-db psql -U postgres accountpro < backup_file.sql
```

### Monitoring & Logging

1. **Application Logs:**
```bash
# View all logs
docker-compose logs -f

# View specific service
docker-compose logs -f app
docker-compose logs -f postgres
```

2. **Health Monitoring:**
```bash
# Check service health
curl http://localhost/health
curl http://localhost:5000/api/health
```

### Security Checklist

- [ ] Change default admin password
- [ ] Configure proper SSL certificates
- [ ] Set up firewall rules
- [ ] Enable database encryption
- [ ] Configure backup encryption
- [ ] Set up intrusion detection
- [ ] Enable audit logging
- [ ] Configure rate limiting
- [ ] Set up monitoring alerts

### Performance Optimization

1. **Database Optimization:**
```sql
-- Add indexes for frequently queried columns
CREATE INDEX CONCURRENTLY idx_invoices_created_at ON invoices(created_at);
CREATE INDEX CONCURRENTLY idx_users_last_login ON users(last_login);

-- Analyze query performance
EXPLAIN ANALYZE SELECT * FROM invoices WHERE status = 'paid';
```

2. **Redis Caching:**
```javascript
// Cache frequently accessed data
const redis = require('redis');
const client = redis.createClient({
  host: 'redis',
  password: process.env.REDIS_PASSWORD
});

// Cache user sessions, API responses
```

3. **CDN Setup:**
```nginx
# Configure CDN for static assets
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    # Add CDN headers
}
```

### Scaling Architecture

#### For 250+ Users:
- Single server deployment
- PostgreSQL with connection pooling
- Redis for session storage
- Nginx load balancing

#### For 1000+ Users:
```yaml
# docker-compose.scale.yml
version: '3.8'
services:
  app:
    deploy:
      replicas: 3
  
  postgres:
    deploy:
      replicas: 1
    # Consider read replicas
  
  redis:
    deploy:
      replicas: 1
    # Consider Redis Cluster
```

#### For 5000+ Users:
- Microservices architecture
- Database sharding
- Message queues (RabbitMQ/Kafka)
- Container orchestration (Kubernetes)
- Separate services for:
  - Authentication
  - Invoice processing
  - Document management
  - Notifications

### Backup & Recovery

1. **Automated Backups:**
```bash
# Add to crontab
0 2 * * * /path/to/backup-script.sh

# Backup script
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
docker exec accountpro-db pg_dump -U postgres accountpro | gzip > /backups/db_$DATE.sql.gz
docker exec accountpro-redis redis-cli --rdb /data/dump_$DATE.rdb
```

2. **Disaster Recovery:**
```bash
# Full system restore
docker-compose down
docker volume rm accountpro_postgres_data
docker-compose up -d postgres
# Wait for postgres to start
gunzip -c backup.sql.gz | docker exec -i accountpro-db psql -U postgres accountpro
docker-compose up -d
```

### Maintenance Tasks

1. **Regular Updates:**
```bash
# Update system
git pull origin main
docker-compose build --no-cache
docker-compose up -d

# Database maintenance
docker exec accountpro-db psql -U postgres -c "VACUUM ANALYZE;"
```

2. **Log Rotation:**
```bash
# Configure logrotate
/var/log/accountpro/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
```

### Troubleshooting

1. **Common Issues:**
```bash
# Service won't start
docker-compose logs app

# Database connection issues
docker exec accountpro-db psql -U postgres -c "SELECT 1;"

# Permission issues
sudo chown -R 1001:1001 uploads/
```

2. **Performance Issues:**
```sql
-- Check slow queries
SELECT query, mean_time, calls 
FROM pg_stat_statements 
ORDER BY mean_time DESC 
LIMIT 10;

-- Check database size
SELECT pg_size_pretty(pg_database_size('accountpro'));
```

### Support & Maintenance

1. **Health Checks:**
```bash
# Automated health monitoring
#!/bin/bash
if ! curl -f http://localhost/health; then
    echo "Service down, restarting..."
    docker-compose restart app
fi
```

2. **Performance Monitoring:**
```bash
# Monitor resource usage
docker stats accountpro-app
docker stats accountpro-db
```

### Production Checklist

Before going live:

- [ ] SSL certificates configured
- [ ] Database passwords changed
- [ ] Email configuration tested
- [ ] Backup strategy implemented
- [ ] Monitoring set up
- [ ] Security scan completed
- [ ] Performance testing done
- [ ] Documentation updated
- [ ] Team training completed
- [ ] Support procedures defined

### Contact & Support

For production support:
- Check logs first: `docker-compose logs -f`
- Review health endpoints
- Check resource usage
- Consult troubleshooting guide
- Contact system administrator

---

**Remember:** Always test deployments in a staging environment before production!