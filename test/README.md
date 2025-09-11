# Restaurant App Testing Guide

This directory contains comprehensive tests for the Restaurant App, including unit tests, widget tests, and integration tests.

## Test Structure

```
test/
├── unit/                           # Unit tests for business logic
│   ├── api_service_test.dart      # API service tests
│   ├── restaurant_model_test.dart # Restaurant model tests
│   ├── restaurant_list_provider_test.dart # Provider tests
│   └── local_database_service_test.dart # Database service tests
├── widget/                         # Widget tests for UI components
│   ├── restaurant_card_widget_test.dart # Restaurant card widget tests
│   ├── favorite_icon_widget_test.dart # Favorite icon widget tests
│   └── main_app_test.dart         # Main app widget tests
├── integration/                    # Integration tests (moved to integration_test/)
└── test_runner.dart               # Test runner for all tests
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Categories
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests
flutter test integration_test/
```

### Run Individual Test Files
```bash
# Example: Run API service tests
flutter test test/unit/api_service_test.dart

# Example: Run restaurant card widget tests
flutter test test/widget/restaurant_card_widget_test.dart
```

## Test Types

### Unit Tests
Unit tests focus on testing individual functions, methods, and classes in isolation.

- **API Service Tests**: Test HTTP requests, response handling, and error scenarios
- **Model Tests**: Test data model serialization/deserialization and validation
- **Provider Tests**: Test state management and business logic
- **Database Service Tests**: Test local database operations

### Widget Tests
Widget tests verify that UI components render correctly and respond to user interactions.

- **Restaurant Card Widget**: Test restaurant information display and tap handling
- **Favorite Icon Widget**: Test favorite functionality and state changes
- **Main App Widget**: Test app initialization and provider setup

### Integration Tests
Integration tests verify complete user flows and app functionality.

- **App Flow Tests**: Test complete user journeys from onboarding to restaurant details
- **Restaurant Detail Flow**: Test navigation to and interaction with restaurant details
- **Error Handling**: Test app behavior under error conditions

## Test Dependencies

The following packages are used for testing:

- `flutter_test`: Core Flutter testing framework
- `integration_test`: Integration testing framework
- `mockito`: Mocking framework for unit tests
- `http_mock_adapter`: HTTP request mocking
- `fake_async`: Async testing utilities
- `sqflite_common_ffi`: SQLite testing support

## Writing New Tests

### Unit Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/services/api_service.dart';

void main() {
  group('ApiService', () {
    test('should return success when API call succeeds', () async {
      // Arrange
      final apiService = ApiServices();
      
      // Act
      final result = await apiService.getRestaurantList();
      
      // Assert
      expect(result, isA<Success<RestaurantListResponse>>());
    });
  });
}
```

### Widget Test Example
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';

void main() {
  testWidgets('should display restaurant name', (WidgetTester tester) async {
    // Arrange
    final restaurant = Restaurant(/* ... */);
    
    // Act
    await tester.pumpWidget(
      MaterialApp(home: RestaurantCard(restaurant: restaurant))
    );
    
    // Assert
    expect(find.text(restaurant.name), findsOneWidget);
  });
}
```

### Integration Test Example
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete user flow', (WidgetTester tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();
    
    // Perform user actions
    // ...
    
    // Verify results
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
```

## Best Practices

1. **Test Naming**: Use descriptive test names that explain what is being tested
2. **Arrange-Act-Assert**: Structure tests with clear setup, execution, and verification phases
3. **Mocking**: Use mocks for external dependencies to ensure tests are isolated
4. **Coverage**: Aim for high test coverage, especially for critical business logic
5. **Maintenance**: Keep tests up to date with code changes
6. **Performance**: Write tests that run quickly and don't depend on external services

## Continuous Integration

These tests are designed to run in CI/CD pipelines. Make sure to:

1. Run tests before merging code
2. Fix failing tests immediately
3. Add tests for new features
4. Update tests when refactoring code

## Troubleshooting

### Common Issues

1. **Test Timeout**: Increase timeout for slow tests
2. **Mock Issues**: Ensure mocks are properly configured
3. **Widget Not Found**: Use `pumpAndSettle()` to wait for async operations
4. **Integration Test Failures**: Check device/emulator setup

### Debug Tips

1. Use `debugDumpApp()` to inspect widget tree
2. Add `print()` statements for debugging
3. Use `tester.pump()` vs `tester.pumpAndSettle()` appropriately
4. Check test logs for detailed error information
