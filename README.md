# Flutter Todo App

A cross-platform Todo application built with Flutter, using FastAPI as the backend for authentication and todo management.

## Features

- User registration and login (JWT authentication)
- Secure token storage using flutter_secure_storage
- Add, update, delete, and list todos via FastAPI backend
- Error handling and loading states
- Logout functionality
- State management with Bloc
- Responsive UI

## Getting Started
### Prerequisites
- Flutter SDK
- A running FastAPI backend
- The backend should be accessible at http://localhost:8000 (or update the URL in todo_api_service.dart and auth_api_service.dart)

### Installation
1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```
3. Run the app:
```bash
flutter run
```