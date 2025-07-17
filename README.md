# AccountPro Dashboard 🧑‍💼  Copyright © 2025 . All Rights Reserved To SkyWebHosting

A modern, responsive web dashboard for accountant firms with role-based access control supporting up to 250+ active users.

## Features

### 🔐 Admin Panel
- Dashboard with analytics (users, invoices, clients)
- Invoice management (Create, Track, Assign)
- User management (CRUD operations)
- Netherlands map with client locations
- Tax knowledgebase management

### 👤 User Panel
- Personal dashboard
- View paid invoices
- Request invoices
- Company profile management
- Chat with assigned accountant
- Notification center

### 🧾 Invoice System
- Status flow: Draft → Sent → Awaiting Payment → Paid
- Dutch VAT support (21%, 9%, 0%)
- PDF export and file history
- Role-based visibility

### 📚 Knowledgebase
- Tax articles and guides
- Dutch VAT (BTW) explanations
- Freelance/ZZP rules
- Expense deductions
- Search and filter capabilities

### 🗺️ Netherlands Map
- Interactive map with client pins
- Postal code/city-based locations
- Client details on pin click

## Tech Stack

- **Frontend**: React.js + Tailwind CSS
- **Backend**: Node.js + Express
- **Database**: PostgreSQL
- **Authentication**: JWT + Role-based access
- **PDF Generation**: jsPDF
- **Maps**: Leaflet + OpenStreetMap

## Getting Started

```bash
npm install
npm run dev
```

## Scaling Beyond 250 Users

- Database indexing and optimization
- Redis caching layer
- Load balancing with multiple server instances
- CDN for static assets
- Database sharding for large datasets