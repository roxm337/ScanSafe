# ScanSafe

A comprehensive mobile application for scanning product barcodes to analyze ingredient safety based on user dietary preferences. Built with Laravel backend and Flutter frontend.

## 🚀 Features

- **Secure Authentication**: User registration and login with Laravel Sanctum tokens
- **Barcode Scanning**: Real-time camera scanning with mobile_scanner + manual EAN input
- **Multi-API Product Data**: Fetches from Open Food Facts, Open Beauty Facts, and Open Pet Food Facts
- **Smart Compliance Analysis**: Ingredient filtering based on dietary restrictions (vegan, gluten-free, nut allergy, lactose intolerance)
- **Material 3 UI**: Modern, clean interface with Gen Z-focused design
- **Offline Ready**: Hive-based caching for previously scanned products
- **Cross-Platform**: Flutter app runs on iOS and Android

## 🛠️ Tech Stack

### Backend (Laravel)
- **Framework**: Laravel 11
- **Language**: PHP 8.3
- **Database**: MySQL/SQLite
- **Authentication**: Laravel Sanctum
- **APIs**: RESTful JSON API

### Frontend (Flutter)
- **Framework**: Flutter 3.8+
- **Language**: Dart
- **State Management**: GetX
- **HTTP Client**: Dio
- **Barcode Scanning**: mobile_scanner
- **Storage**: shared_preferences, Hive
- **UI**: Material 3

### External APIs
- Open Food Facts (food & beverages)
- Open Beauty Facts (cosmetics & personal care)
- Open Pet Food Facts (pet food)

## 📋 Prerequisites

- PHP 8.3 or higher
- Composer
- Flutter 3.8+ SDK
- Dart SDK
- MySQL or SQLite database
- iOS Simulator / Android Emulator (for testing)

## 🔧 Installation & Setup

### Backend Setup

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Install PHP dependencies**:
   ```bash
   composer install
   ```

3. **Environment configuration**:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **Database setup**:
   - Configure database credentials in `.env` file
   - Run migrations:
     ```bash
     php artisan migrate
     ```

5. **Start the server**:
   ```bash
   php artisan serve
   ```
   Server runs on `http://127.0.0.1:8000`

### Frontend Setup

1. **Navigate to frontend directory**:
   ```bash
   cd frontend
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 📖 Usage

### User Flow
1. **Launch App**: Splash screen checks authentication status
2. **Authentication**: Register or login with email/password
3. **Set Preferences**: Configure dietary restrictions in profile
4. **Scan Products**: Use camera to scan barcode or enter EAN manually
5. **View Results**: See product details, ingredients, allergens, and compliance status

### API Endpoints

#### Authentication
- `POST /api/register` - User registration
- `POST /api/login` - User login
- `POST /api/logout` - User logout (requires auth)

#### Preferences
- `GET /api/preferences` - Get user preferences (requires auth)
- `POST /api/preferences` - Update user preferences (requires auth)

#### Products
- `GET /api/product/{ean}` - Fetch product information (requires auth)

#### Scans
- `GET /api/scans` - Get user's scan history (requires auth)
- `POST /api/scan` - Scan product by EAN (requires auth)

## 🏗️ Architecture

### Backend Structure
```
backend/
├── app/
│   ├── Http/Controllers/     # API Controllers
│   ├── Models/              # Eloquent Models
│   ├── Services/            # ProductService
│   └── Providers/           # API Providers
├── database/migrations/     # Database schemas
├── routes/api.php          # API routes
└── config/                 # Configuration files
```

### Frontend Structure
```
frontend/
├── lib/
│   ├── controllers/         # GetX Controllers
│   ├── models/             # Data Models
│   ├── providers/          # API Provider
│   ├── screens/            # UI Screens
│   └── main.dart           # App Entry Point
├── pubspec.yaml            # Dependencies
└── android/ios/            # Platform specific
```

## 🔍 Data Models

### User
```dart
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com"
}
```

### Product
```dart
{
  "ean": "737628064502",
  "name": "Thai Peanut Noodle Kit",
  "brand": "Simply Asia",
  "image_url": "https://...",
  "ingredients_text": "Rice Noodles...",
  "allergens": ["en:peanuts", "en:sesame-seeds"],
  "compliance": {
    "compliant": false,
    "issues": [{"flag": "nut_allergy", "ingredient": "peanuts"}],
    "advice": "This product may not be suitable for your preferences."
  }
}
```

