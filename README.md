# Anushri Vaidya — Developer Portfolio

A full-stack developer portfolio built with Flutter Web, FastAPI, and MongoDB.
The portfolio includes a public-facing website and an authenticated admin CMS
for managing portfolio content dynamically.

## 🌐 Live Demo

[View Live Portfolio](https://anushri-vaidya-portfolio-frontend.onrender.com)

## ✨ Features

### Public Portfolio
- Responsive Flutter Web interface
- About Me section
- Technical skills
- Education
- Experience
- Projects
- Achievements
- Contact section
- Responsive desktop and mobile layouts

### Admin CMS
- Secure admin login
- Dashboard
- Manage skills
- Manage education
- Manage experience
- Manage projects
- Manage achievements
- View contact messages
- CRUD-based content management

### Backend
- RESTful API using FastAPI
- MongoDB database
- CORS configuration
- Environment-based configuration
- Dynamic portfolio data

## 🏗️ Architecture

Flutter Web
↓
FastAPI REST API
↓
MongoDB Atlas

## 🛠️ Tech Stack

### Frontend
- Flutter
- Dart
- Material UI

### Backend
- Python
- FastAPI
- Uvicorn
- REST APIs

### Database
- MongoDB Atlas

### Tools & Deployment
- Git
- GitHub
- Render
- Postman

## 📁 Project Structure

```text
my_portfolio/
├── lib/
│   ├── models/
│   ├── screens/
│   ├── services/
│   ├── widgets/
│   └── main.dart
│
├── portfolio_backend/
│   └── app/
│       ├── main.py
│       ├── models/
│       ├── routes/
│       └── services/
│
├── web/
├── pubspec.yaml
├── .gitignore
└── README.md