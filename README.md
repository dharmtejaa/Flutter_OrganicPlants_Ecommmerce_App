# 🌱 Organic Plants - Flutter E-commerce App

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7.2-blue.svg)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![Provider](https://img.shields.io/badge/State%20Management-Provider-green.svg)](https://pub.dev/packages/provider)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A modern, feature-rich Flutter e-commerce application for organic plants, featuring Firebase integration, user authentication, product browsing, cart management, wishlist functionality, and smooth UI animations.

## 📱 App Overview

Organic Plants is a comprehensive mobile application that allows users to browse, search, and purchase various types of organic plants. The app provides detailed plant information, care guides, and a seamless shopping experience with modern UI/UX design.

### 🌟 Key Highlights
- **Modern Material Design 3** implementation
- **Firebase-powered** authentication and data management
- **Real-time** cart and wishlist synchronization
- **Responsive design** for all screen sizes
- **Dark/Light theme** support
- **Push notifications** for order updates
- **Offline-first** approach with local caching

## ✨ Features

### 🔐 Authentication & User Management
- **Email/Password Authentication** using Firebase Auth
- **Google Sign-In** integration
- **Password Reset** functionality
- **User Profile Management** with personal details
- **Address Management** for delivery
- **Session Management** with automatic login

### 🛍️ E-commerce Features
- **Product Catalog** with categorized plant listings
- **Advanced Search & Filtering** by plant categories and attributes
- **Shopping Cart** with quantity management and real-time sync
- **Wishlist** functionality with Firebase integration
- **Checkout Process** with address selection and payment methods
- **Order History** with detailed tracking
- **Product Reviews** and ratings system

### 🌿 Plant Information & Care
- **Detailed Plant Profiles** with scientific names, care guides, and benefits
- **Plant Categories**: Bonsai, Flowering Plants, Herbs, Indoor Plants, Medicinal Plants, Outdoor Plants, Succulents & Cacti
- **Care Guides** including watering, lighting, temperature, and humidity requirements
- **Plant Attributes** (pet-friendly, air-purifying, low-maintenance, etc.)
- **Plant Care Tips** and maintenance schedules
- **FAQs** for each plant species

### 🎨 UI/UX Features
- **Modern Material Design 3** implementation
- **Dark & Light Theme** support with dynamic switching
- **Responsive Design** using Flutter ScreenUtil
- **Smooth Animations** and transitions
- **Image Caching** for better performance
- **Custom Components** and reusable widgets
- **Loading States** with shimmer effects
- **Error Handling** with user-friendly messages

### 🔧 Technical Features
- **State Management** using Provider pattern
- **Firebase Integration** for authentication, Firestore, and hosting
- **HTTP API Integration** for plant data
- **Local Storage** with SharedPreferences
- **Image Caching** with custom cache manager
- **Push Notifications** with Firebase Cloud Messaging
- **Responsive Layout** support for different screen sizes
- **Offline Support** with local data persistence

## 🏗️ Project Architecture

The project follows a **Feature-Based Architecture** with clean separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── services/           # API services, cache management
│   ├── theme/              # App themes and styling
│   └── constants/          # App constants and configurations
├── features/               # Feature modules
│   ├── auth/              # Authentication (login, signup, forgot password)
│   ├── cart/              # Shopping cart management
│   ├── entry/             # App entry point and navigation
│   ├── home/              # Home screen and dashboard
│   ├── onboarding/        # Onboarding flow
│   ├── notifications/     # Push notifications
│   ├── product/           # Product details and information
│   ├── profile/           # User profile and settings
│   ├── search/            # Search and filtering
│   ├── splash/            # Splash screen
│   ├── store/             # Store and product catalog
│   └── wishlist/          # Wishlist management
├── models/                # Data models and entities
├── shared/                # Shared components
│   ├── buttons/           # Custom buttons
│   ├── logic/             # Shared providers
│   └── widgets/           # Reusable widgets
└── main.dart              # App entry point
```

### 📁 Feature Structure
Each feature follows a consistent structure:
```
feature/
├── data/                  # Data layer (models, repositories)
├── logic/                 # Business logic (providers, services)
└── presentation/          # UI layer (screens, widgets)
    ├── screens/          # Main screens
    └── widgets/          # Feature-specific widgets
```

## 🛠️ Technology Stack

### Frontend
- **Flutter** (SDK: ^3.7.2) - Cross-platform UI framework
- **Dart** programming language
- **Material Design 3** for UI components

### State Management
- **Provider** (^6.1.4) for state management
- **ChangeNotifier** for reactive UI updates
- **ValueNotifier** for simple state management

### Backend & Services
- **Firebase Authentication** for user management
- **Firebase Firestore** for real-time database
- **Firebase Cloud Messaging** for push notifications
- **Firebase Hosting** for static file hosting
- **HTTP** package for API calls
- **SharedPreferences** for local storage

### UI & Animation
- **Lottie** (^3.3.1) for animations
- **Carousel Slider** (5.1.1) for image carousels
- **Smooth Page Indicator** (^1.2.1) for pagination
- **Animated Text Kit** (^4.2.3) for text animations
- **Shimmer** (^3.0.0) for loading effects
- **Cached Network Image** (^3.3.1) for image caching

### Development Tools
- **Flutter Lints** (^5.0.0) for code quality
- **Flutter Test** for unit testing
- **Dart Analysis** for static analysis

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (3.7.2 or higher)
- **Dart SDK** (3.7.2 or higher)
- **Android Studio** / **VS Code** with Flutter extensions
- **Firebase Project** setup
- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/organicplants.git
   cd organicplants
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password, Google Sign-In)
   - Enable Firestore Database
   - Enable Cloud Messaging
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders

4. **Configure Firebase**
   - Update Firebase configuration in `lib/core/services/`
   - Set up Firestore security rules
   - Configure Cloud Messaging for notifications

5. **Run the app**
   ```bash
   flutter run
   ```

### Environment Setup

#### Android
- Minimum SDK: 21
- Target SDK: 33
- Add `google-services.json` to `android/app/`

#### iOS
- Minimum iOS: 12.0
- Add `GoogleService-Info.plist` to `ios/Runner/`

## 📱 App Screenshots

### Authentication Flow
- Splash Screen with animated logo
- Onboarding screens for first-time users
- Login/Signup with email and Google authentication
- Forgot password functionality

### Main App Features
- Home screen with featured plants and categories
- Product catalog with advanced filtering
- Product details with care guides
- Shopping cart with real-time updates
- Wishlist management
- User profile and settings

## 🔧 Development Guidelines

### Code Style
- Follow **Dart Style Guide**
- Use **Flutter Lints** for code quality
- Implement **null safety** throughout
- Use **async/await** for asynchronous operations
- Follow **Provider pattern** for state management

### Architecture Principles
- **Separation of Concerns**: UI, Business Logic, Data layers
- **Single Responsibility**: Each class has one purpose
- **Dependency Injection**: Use Provider for dependency management
- **Clean Code**: Readable, maintainable, and testable code

### State Management
- Use **Provider** for global state
- Use **ValueNotifier** for simple local state
- Implement proper **dispose** methods
- Handle **loading states** and **error states**

### Error Handling
- Implement **try-catch** blocks for async operations
- Show **user-friendly error messages**
- Log errors for debugging
- Handle **network errors** gracefully

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 📦 Build & Deploy

### Android Build
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS Build
```bash
flutter build ios --release
```

### Web Build
```bash
flutter build web --release
```

## 🔒 Security

### Firebase Security Rules
- Implement proper Firestore security rules
- Restrict access based on user authentication
- Validate data on both client and server
- Use Firebase Auth for user management

### Data Protection
- Encrypt sensitive data
- Use secure storage for tokens
- Implement proper session management
- Follow GDPR compliance guidelines

## 📈 Performance Optimization

### Image Optimization
- Use **Cached Network Image** for efficient image loading
- Implement **image compression**
- Use **placeholder images** during loading
- Implement **lazy loading** for large lists

### Code Optimization
- Use **const constructors** where possible
- Implement **widget keys** for efficient rebuilds
- Use **ListView.builder** for large lists
- Minimize **setState** calls

### Memory Management
- Properly **dispose** of controllers and listeners
- Cancel **StreamSubscriptions** in dispose methods
- Use **weak references** where appropriate
- Implement **garbage collection** best practices

## 🤝 Contributing

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Review Guidelines
- Follow **Flutter best practices**
- Write **comprehensive tests**
- Update **documentation** as needed
- Ensure **backward compatibility**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Firebase Team** for the backend services
- **Material Design** for the design system
- **Open Source Community** for the packages used

## 📞 Support

For support, email dharmateja238@gmail.com or join our Slack channel.

---

**Made with ❤️ by dharma teja**

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
