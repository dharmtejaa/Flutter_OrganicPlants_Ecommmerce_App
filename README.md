# 🌱 Organic Plants - Complete Flutter E-commerce App

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
- **Dark/Light theme** support with local persistence
- **Push notifications** for order updates
- **Offline-first** approach with local caching
- **Comprehensive plant care guides** and customer support

## ✨ Features Overview

### 🔐 **Authentication & User Management**
- **Email/Password Authentication** using Firebase Auth
- **Google Sign-In** integration
- **Password Reset** functionality with email verification
- **User Profile Management** with personal details and image upload
- **Address Management** for delivery (Home/Work addresses)
- **Session Management** with automatic login state detection
- **Persistent User Sessions** with reactive auth state changes

### 🛍️ **E-commerce Features**
- **Product Catalog** with categorized plant listings
- **Advanced Search & Filtering** by plant categories, attributes, and benefits
- **Real-time Search Suggestions** with recent search history
- **Shopping Cart** with quantity management and real-time sync
- **Wishlist** functionality with Firebase integration
- **Checkout Process** with address selection and multiple payment methods
- **Order History** with detailed tracking and status updates
- **Order Tracking** with real-time delivery status
- **Product Reviews** and ratings system

### 🌿 **Plant Information & Care**
- **Detailed Plant Profiles** with scientific names, care guides, and benefits
- **Plant Categories**: Bonsai, Flowering Plants, Herbs, Indoor Plants, Medicinal Plants, Outdoor Plants, Succulents & Cacti
- **Comprehensive Care Guides** including watering, lighting, temperature, and humidity requirements
- **Plant Attributes** (pet-friendly, air-purifying, low-maintenance, etc.)
- **Plant Care Tips** and maintenance schedules
- **Plant Care Guide Screen** with detailed instructions
- **FAQs** for each plant species with searchable content

### 🎨 **UI/UX Features**
- **Modern Material Design 3** implementation
- **Dark & Light Theme** support with dynamic switching and local persistence
- **Responsive Design** using Flutter ScreenUtil for perfect scaling
- **Smooth Animations** and transitions with Lottie animations
- **Image Caching** for better performance with custom cache manager
- **Custom Components** and reusable widgets
- **Loading States** with shimmer effects
- **Error Handling** with user-friendly messages and retry options
- **Gesture-based Navigation** with custom gesture detectors

### 🔔 **Notifications & Communication**
- **Real-time Push Notifications** with Firebase Cloud Messaging
- **Order Update Notifications** for status changes
- **Promotional Notifications** for sales and new products
- **Plant Care Reminders** and tips
- **Notification Settings** with granular control
- **Notification History** with clear all functionality

### 👤 **User Profile & Settings**
- **Personal Information Management** with profile editing
- **Address Management** with CRUD operations for delivery addresses
- **Payment Methods** management with multiple options
- **Order History** with detailed tracking
- **Real-time Stats** showing live counts for orders, wishlist, and cart
- **Theme Preferences** with system/light/dark mode options
- **Notification Settings** with granular control
- **Customer Support** integration with multiple channels

### 🛠️ **Customer Support & Help**
- **Live Chat Support** integration
- **Email Support** with direct email composition
- **Phone Support** with direct calling
- **WhatsApp Integration** for instant messaging
- **FAQ System** with categorized and searchable questions
- **Feedback System** with user feedback collection
- **Plant Care Guides** with comprehensive instructions
- **About Screen** with app information and version details

### 🔧 **Technical Features**
- **State Management** using Provider pattern with ChangeNotifier
- **Firebase Integration** for authentication, Firestore, and Cloud Messaging
- **HTTP API Integration** for plant data with error handling
- **Local Storage** with SharedPreferences for theme and user preferences
- **Image Caching** with custom cache manager for optimized performance
- **Push Notifications** with Firebase Cloud Messaging
- **Responsive Layout** support for different screen sizes
- **Offline Support** with local data persistence
- **Error Handling** with comprehensive try-catch blocks
- **Performance Optimization** with efficient widget rebuilding

## 🏗️ Project Architecture

The project follows a **Feature-Based Architecture** with clean separation of concerns:

```
lib/
├── core/                    # Core functionality
│   ├── services/           # API services, cache management, plant data
│   ├── theme/              # App themes, colors, and styling
│   └── constants/          # App constants and configurations
├── features/               # Feature modules
│   ├── auth/              # Authentication (login, signup, forgot password)
│   ├── cart/              # Shopping cart management with checkout
│   ├── entry/             # App entry point and bottom navigation
│   ├── home/              # Home screen with featured plants and categories
│   ├── onboarding/        # Onboarding flow with animations
│   ├── notifications/     # Push notifications and settings
│   ├── product/           # Product details, care guides, and suggestions
│   ├── profile/           # User profile, settings, and account management
│   ├── search/            # Search, filtering, and discovery
│   ├── splash/            # Splash screen with loading
│   ├── store/             # Store and product catalog
│   └── wishlist/          # Wishlist management
├── models/                # Data models and entities
├── shared/                # Shared components
│   ├── buttons/           # Custom buttons and interactive elements
│   ├── logic/             # Shared providers and state management
│   └── widgets/           # Reusable widgets and components
└── main.dart              # App entry point with provider setup
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
- **Dart** programming language with null safety
- **Material Design 3** for UI components and theming

### State Management
- **Provider** (^6.1.4) for state management
- **ChangeNotifier** for reactive UI updates
- **ValueNotifier** for simple state management
- **MultiProvider** for complex state orchestration

### Backend & Services
- **Firebase Authentication** for user management and session handling
- **Firebase Firestore** for real-time database and data synchronization
- **Firebase Cloud Messaging** for push notifications
- **Firebase Hosting** for static file hosting
- **HTTP** package for API calls with error handling
- **SharedPreferences** for local storage and theme persistence

### UI & Animation
- **Lottie** (^3.3.1) for smooth animations and onboarding
- **Carousel Slider** (5.1.1) for image carousels and banners
- **Smooth Page Indicator** (^1.2.1) for pagination
- **Animated Text Kit** (^4.2.3) for text animations
- **Shimmer** (^3.0.0) for loading effects
- **Cached Network Image** (^3.3.1) for image caching and optimization
- **flutter_screenutil** for responsive design

### Development Tools
- **Flutter Lints** (^5.0.0) for code quality and consistency
- **Flutter Test** for unit testing
- **Dart Analysis** for static analysis and error detection

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (3.7.2 or higher)
- **Dart SDK** (3.7.2 or higher)
- **Android Studio** / **VS Code** with Flutter extensions
- **Firebase Project** setup with Authentication, Firestore, and Cloud Messaging
- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/dharmtejaa/Flutter_OrganicPlants_Ecommmerce_App.git
   cd organicplants
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password, Google Sign-In)
   - Enable Firestore Database with security rules
   - Enable Cloud Messaging for push notifications
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the respective platform folders

4. **Configure Firebase**
   - Update Firebase configuration in `lib/main.dart`
   - Set up Firestore security rules for user data protection
   - Configure Cloud Messaging for notifications
   - Set up Firebase Hosting if needed

5. **Run the app**
   ```bash
   flutter run
   ```

### Environment Setup

#### Android
- Minimum SDK: 21
- Target SDK: 33
- Add `google-services.json` to `android/app/`
- Configure signing for release builds

#### iOS
- Minimum iOS: 12.0
- Add `GoogleService-Info.plist` to `ios/Runner/`
- Configure signing and capabilities

## 📱 App Screenshots & Features

### Authentication Flow
- **Splash Screen** with animated logo and loading
- **Onboarding Screens** for first-time users with Lottie animations
- **Login/Signup** with email and Google authentication
- **Forgot Password** functionality with email verification
- **Session Management** with automatic login state detection

### Main App Features
- **Home Screen** with featured plants, categories, and personalized greeting
- **Product Catalog** with advanced filtering and search
- **Product Details** with care guides, features, and suggestions
- **Shopping Cart** with real-time updates and quantity management
- **Wishlist Management** with Firebase synchronization
- **User Profile** with comprehensive account management
- **Search & Discovery** with real-time suggestions and history

### Advanced Features
- **Order Tracking** with real-time delivery status
- **Customer Support** with multiple communication channels
- **Plant Care Guides** with detailed instructions
- **FAQ System** with searchable content
- **Theme Management** with system/light/dark mode
- **Push Notifications** with granular control

## 🔧 Development Guidelines

### Code Style
- Follow **Dart Style Guide** and Flutter conventions
- Use **Flutter Lints** for code quality and consistency
- Implement **null safety** throughout the codebase
- Use **async/await** for asynchronous operations
- Follow **Provider pattern** for state management
- Write **comprehensive comments** for complex logic

### Architecture Principles
- **Separation of Concerns**: UI, Business Logic, Data layers
- **Single Responsibility**: Each class has one clear purpose
- **Dependency Injection**: Use Provider for dependency management
- **Clean Code**: Readable, maintainable, and testable code
- **Feature-Based Organization**: Logical grouping of related functionality

### State Management
- Use **Provider** for global state management
- Use **ValueNotifier** for simple local state
- Implement proper **dispose** methods for memory management
- Handle **loading states** and **error states** consistently
- Use **Consumer** widgets for reactive UI updates

### Error Handling
- Implement **try-catch** blocks for async operations
- Show **user-friendly error messages** with retry options
- Log errors for debugging and monitoring
- Handle **network errors** gracefully with offline support
- Provide **fallback UI** for error states

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
- Implement proper Firestore security rules for user data protection
- Restrict access based on user authentication status
- Validate data on both client and server sides
- Use Firebase Auth for secure user management

### Data Protection
- Encrypt sensitive data in local storage
- Use secure storage for authentication tokens
- Implement proper session management with automatic logout
- Follow GDPR compliance guidelines for user data

## 📈 Performance Optimization

### Image Optimization
- Use **Cached Network Image** for efficient image loading
- Implement **image compression** and optimization
- Use **placeholder images** during loading states
- Implement **lazy loading** for large product lists

### Code Optimization
- Use **const constructors** where possible for better performance
- Implement **widget keys** for efficient rebuilds
- Use **ListView.builder** for large lists to avoid memory issues
- Minimize **setState** calls and use Provider for state updates

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
- Follow **Flutter best practices** and conventions
- Write **comprehensive tests** for new features
- Update **documentation** as needed
- Ensure **backward compatibility** when possible
- Test on **multiple devices** and screen sizes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** for the amazing cross-platform framework
- **Firebase Team** for the comprehensive backend services
- **Material Design** for the beautiful design system
- **Open Source Community** for the excellent packages used
- **Plant Enthusiasts** for inspiration and feedback

## 📞 Support

For support, email dharmateja238@gmail.com or join our community discussions.

---

**Made with ❤️ by dharma teja**

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
