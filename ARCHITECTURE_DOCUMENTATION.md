# Organic Plants - Architecture Documentation

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture Overview](#architecture-overview)
3. [Directory Structure](#directory-structure)
4. [Feature-Based Architecture](#feature-based-architecture)
5. [State Management](#state-management)
6. [Data Layer](#data-layer)
7. [Presentation Layer](#presentation-layer)
8. [Technology Stack](#technology-stack)
9. [Code Patterns](#code-patterns)
10. [Best Practices](#best-practices)
11. [Development Guidelines](#development-guidelines)

---

## 🎯 Project Overview

**Organic Plants** is a modern Flutter-based e-commerce application for organic plants, featuring:
- Firebase integration for authentication and real-time database
- Product browsing with detailed plant information
- Shopping cart and wishlist functionality
- User profile management
- Push notifications
- Responsive Material Design 3 UI

---

## 🏗️ Architecture Overview

The project follows a **Feature-Based Architecture** with elements of **Clean Architecture** principles, emphasizing:
- **Separation of Concerns**
- **Feature Isolation**
- **Scalability**
- **Maintainability**

### Architecture Principles
1. **Feature-First Organization**: Code is organized by business features rather than technical layers
2. **Unidirectional Data Flow**: Data flows from UI → Provider → Service → Data Source
3. **Dependency Injection**: Provider pattern for state management and dependency injection
4. **Reactive Programming**: ChangeNotifier for reactive state updates

---

## 📁 Directory Structure

```
lib/
├── core/                    # Core functionality
│   ├── services/           # API services, cache management
│   │   ├── all_plants_global_data.dart
│   │   ├── app_sizes.dart
│   │   ├── my_custom_cache_manager.dart
│   │   ├── plant_filter_service.dart
│   │   └── plant_services.dart
│   └── theme/              # App themes and styling
│       ├── app_shadows.dart
│       ├── app_theme.dart
│       ├── appcolors.dart
│       ├── dark_theme_colors.dart
│       └── light_theme_colors.dart
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   │   ├── data/
│   │   ├── logic/
│   │   │   └── auth_service.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── forgot_password_screen.dart
│   │       │   ├── loginscreen.dart
│   │       │   └── signup_screen.dart
│   │       └── widgets/
│   ├── cart/              # Shopping cart
│   │   ├── data/
│   │   │   └── cart_model.dart
│   │   ├── logic/
│   │   │   └── cart_provider.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── cart_screen.dart
│   │       │   └── checkout_screen.dart
│   │       └── widgets/
│   │           ├── card_tile.dart
│   │           └── cart_bottom_sheet.dart
│   ├── entry/             # App entry point
│   ├── home/              # Home screen
│   ├── notifications/     # Push notifications
│   ├── onboarding/        # Onboarding flow
│   ├── product/           # Product details
│   ├── profile/           # User profile
│   ├── search/            # Search functionality
│   ├── splash/            # Splash screen
│   ├── store/             # Store catalog
│   └── wishlist/          # Wishlist management
├── models/                # Global data models
│   └── all_plants_model.dart
├── shared/                # Shared components
│   ├── buttons/           # Custom buttons
│   │   ├── add_to_cart_button.dart
│   │   ├── cart_icon_with_badge.dart
│   │   ├── custombutton.dart
│   │   ├── searchbutton.dart
│   │   ├── submit_custom_buttons.dart
│   │   ├── wishlist_icon_button.dart
│   │   └── wishlist_icon_with_badge.dart
│   ├── logic/             # Shared providers
│   │   ├── theme_provider.dart
│   │   └── user_profile_provider.dart
│   └── widgets/           # Reusable widgets
│       ├── active_filters_widget.dart
│       ├── custom_dialog.dart
│       ├── custom_snackbar.dart
│       ├── custom_textfield.dart
│       ├── filter_bottom_sheet.dart
│       ├── gesture_detector_button.dart
│       ├── no_result_found.dart
│       ├── plant_card_grid.dart
│       ├── plantcategory.dart
│       ├── productcard.dart
│       └── simple_plant_card.dart
└── main.dart              # App entry point
```

---

## 🎯 Feature-Based Architecture

### Feature Structure Pattern
Each feature follows a consistent **3-layer structure**:

```
feature/
├── data/                  # Data layer
│   └── [feature]_model.dart
├── logic/                 # Business logic layer
│   └── [feature]_provider.dart
└── presentation/          # UI layer
    ├── screens/          # Main screens
    └── widgets/          # Feature-specific widgets
```

### Feature Examples

#### 1. Cart Feature
```
cart/
├── data/
│   └── cart_model.dart           # Data model for cart items
├── logic/
│   └── cart_provider.dart        # Business logic and state management
└── presentation/
    ├── screens/
    │   ├── cart_screen.dart      # Main cart screen
    │   └── checkout_screen.dart  # Checkout process
    └── widgets/
        ├── card_tile.dart        # Cart item widget
        └── cart_bottom_sheet.dart # Cart summary widget
```

#### 2. Auth Feature
```
auth/
├── data/                         # Minimal data layer (uses shared models)
├── logic/
│   └── auth_service.dart         # Authentication business logic
└── presentation/
    ├── screens/
    │   ├── loginscreen.dart      # Login screen
    │   ├── signup_screen.dart    # Signup screen
    │   └── forgot_password_screen.dart
    └── widgets/                  # Auth-specific widgets
```

---

## 🔄 State Management

### Provider Pattern Implementation
The project uses **Provider** (^6.1.4) with **ChangeNotifier** for state management:

#### Global State Setup (main.dart)
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => OnboardingProvider()),
    ChangeNotifierProvider(create: (_) => BottomNavProvider()),
    ChangeNotifierProvider(create: (_) => SearchScreenProvider()),
    ChangeNotifierProvider(create: (_) => HintTextProvider()),
    ChangeNotifierProvider(create: (_) => WishlistProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => CarouselProvider()),
    ChangeNotifierProvider(create: (_) => UserProfileProvider()),
    ChangeNotifierProvider(create: (_) => AddressProvider()),
    ChangeNotifierProvider(create: (_) => FeedbackProvider()),
    ChangeNotifierProvider(create: (_) => OrderHistoryProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
  ],
  child: const MyApp(),
)
```

#### Provider Pattern Example (CartProvider)
```dart
class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _cartItems = [];
  
  List<CartItemModel> get itemList => _cartItems;
  
  Future<void> addToCart(String plantId) async {
    // Business logic implementation
    notifyListeners(); // Triggers UI updates
  }
}
```

#### Consumer Pattern in UI
```dart
Consumer<CartProvider>(
  builder: (context, cartProvider, child) {
    return Text('${cartProvider.itemList.length} items');
  },
)
```

---

## 🗄️ Data Layer

### Service Layer Pattern
The data layer follows a **Service Layer Pattern** with multiple data sources:

#### 1. Firebase Services
- **Firebase Authentication**: User management
- **Firebase Firestore**: Real-time database
- **Firebase Cloud Messaging**: Push notifications

#### 2. HTTP API Services
```dart
class PlantServices {
  static Future<List<AllPlantsModel>> loadAllPlantsApi() async {
    final allPlantsResponse = await http.get(Uri.parse(baseUrl));
    if (allPlantsResponse.statusCode == 200) {
      List<dynamic> allPlantsList = json.decode(allPlantsResponse.body);
      return allPlantsList.map((e) => AllPlantsModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to Load plants data');
    }
  }
}
```

#### 3. Local Storage
- **SharedPreferences**: User preferences and settings
- **Custom Cache Manager**: Image caching for better performance

### Data Models
```dart
class CartItemModel {
  final String plantId;
  final String plantName;
  final String imageUrl;
  final double originalPrice;
  final double offerPrice;
  final double discount;
  final double rating;
  final int quantity;

  // Constructor, copyWith, fromMap, toMap methods
}
```

---

## 🎨 Presentation Layer

### Widget Architecture
The presentation layer follows **Widget-based UI** with Material Design 3:

#### 1. Screen Structure
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App bar implementation
      ),
      body: Column(
        children: [
          // Widget composition
        ],
      ),
    );
  }
}
```

#### 2. Custom Widgets
- **Reusable Components**: Shared widgets in `shared/widgets/`
- **Feature-Specific Widgets**: Widgets specific to features
- **Responsive Design**: Using Flutter ScreenUtil for scaling

#### 3. Theme Implementation
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeProvider.themeMode,
  // App configuration
)
```

---

## 🛠️ Technology Stack

### Frontend Framework
- **Flutter** (SDK: ^3.7.2)
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
- **HTTP API** integration for external data

### UI & UX
- **Flutter ScreenUtil** for responsive design
- **Cached Network Image** for image caching
- **Shimmer** for loading states
- **Lottie** for animations
- **Carousel Slider** for image carousels

### Development Tools
- **Flutter Lints** for code quality
- **Provider** for dependency injection
- **Shared Preferences** for local storage

---

## 📝 Code Patterns

### 1. Provider Pattern
```dart
// Provider definition
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    notifyListeners();
  }
}

// Provider usage
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return IconButton(
      onPressed: themeProvider.toggleTheme,
      icon: Icon(themeProvider.themeMode == ThemeMode.light 
          ? Icons.dark_mode 
          : Icons.light_mode),
    );
  },
)
```

### 2. Service Pattern
```dart
class AuthService {
  static Future<void> loginWithEmailAndPassword(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // Navigation logic
    } on FirebaseAuthException catch (e) {
      CustomSnackBar.showError(context, e.message.toString());
    }
  }
}
```

### 3. Model Pattern
```dart
class UserProfileModel {
  final String uid;
  final String fullName;
  final String email;
  final String fcmToken;
  final String profileImageUrl;
  final DateTime createdAt;

  UserProfileModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.fcmToken,
    required this.profileImageUrl,
    required this.createdAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'fcmToken': fcmToken,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
```

---

## ✅ Best Practices

### 1. Code Organization
- **Feature-based structure** for better maintainability
- **Consistent naming conventions** across the project
- **Separation of concerns** between data, logic, and presentation

### 2. State Management
- **Single source of truth** for each feature
- **Reactive updates** using ChangeNotifier
- **Proper error handling** in providers

### 3. UI/UX
- **Responsive design** using Flutter ScreenUtil
- **Consistent theming** with Material Design 3
- **Loading states** and error handling
- **Accessibility** considerations

### 4. Performance
- **Image caching** for better performance
- **Lazy loading** where appropriate
- **Efficient widget rebuilding** with Consumer pattern

### 5. Security
- **Firebase Authentication** for secure user management
- **Input validation** on forms
- **Secure API calls** with proper error handling

---

## 🚀 Development Guidelines

### 1. Adding New Features
1. Create feature directory in `lib/features/`
2. Follow the 3-layer structure (data/logic/presentation)
3. Create provider for state management
4. Add provider to main.dart MultiProvider
5. Implement UI components

### 2. Code Standards
- Use **StatelessWidget** when possible
- Prefer **Consumer** over **Provider.of** for reactive UI
- Follow **Dart naming conventions**
- Add **proper documentation** for complex methods

### 3. Testing Strategy
- **Unit tests** for providers and services
- **Widget tests** for UI components
- **Integration tests** for feature workflows

### 4. Performance Considerations
- **Minimize widget rebuilds** with proper Consumer usage
- **Use const constructors** where possible
- **Implement proper disposal** in providers
- **Optimize image loading** with caching

### 5. Error Handling
- **Try-catch blocks** in async operations
- **User-friendly error messages**
- **Proper logging** for debugging
- **Graceful degradation** for network issues

---

## 📊 Architecture Benefits

### 1. Scalability
- **Easy to add new features** without affecting existing code
- **Feature isolation** prevents coupling issues
- **Modular structure** supports team development

### 2. Maintainability
- **Clear separation of concerns**
- **Consistent patterns** across features
- **Reusable components** reduce code duplication

### 3. Testability
- **Isolated feature modules** are easier to test
- **Provider pattern** supports unit testing
- **Clear dependencies** make mocking straightforward

### 4. Team Collaboration
- **Feature-based organization** allows parallel development
- **Clear ownership** of feature modules
- **Consistent patterns** reduce learning curve

---

## 🔮 Future Considerations

### 1. Potential Improvements
- **Repository Pattern** for data layer abstraction
- **BLoC Pattern** for complex state management
- **Dependency Injection** framework for better testability
- **Code generation** for boilerplate reduction

### 2. Scalability Enhancements
- **Microservices architecture** for backend
- **Caching strategies** for better performance
- **Offline-first approach** with local database
- **Progressive Web App** capabilities

### 3. Monitoring & Analytics
- **Crash reporting** integration
- **Performance monitoring**
- **User analytics** tracking
- **A/B testing** framework

---

*This documentation provides a comprehensive overview of the Organic Plants Flutter application architecture, serving as a reference for developers working on the project.* 