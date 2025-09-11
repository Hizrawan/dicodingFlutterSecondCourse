import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/main.dart';
import 'package:restaurant_app/provider/auth/auth_provider.dart';
import 'package:restaurant_app/provider/auth/onboarding_provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/provider/theme/theme_provider.dart';
import 'package:restaurant_app/services/api_service.dart';
import 'package:restaurant_app/services/local_database_service.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app/provider/notification/local_notification_provider.dart';

void main() {
  group('MyApp Widget', () {
    testWidgets('should build without crashing', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should have correct title', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Restaurant App');
    });

    testWidgets('should have correct initial route', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.initialRoute, '/onboarding');
    });

    testWidgets('should have all required routes', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.routes, isNotNull);
      expect(materialApp.routes!.containsKey('/onboarding'), isTrue);
      expect(materialApp.routes!.containsKey('/login'), isTrue);
      expect(materialApp.routes!.containsKey('/main'), isTrue);
      expect(materialApp.routes!.containsKey('/detail'), isTrue);
    });

    testWidgets('should have light and dark themes', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme, isNotNull);
      expect(materialApp.darkTheme, isNotNull);
    });

    testWidgets('should provide all required providers', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      expect(find.byType(MultiProvider), findsOneWidget);
    });

    testWidgets('should have AuthProvider', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final authProvider = Provider.of<AuthProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(authProvider, isNotNull);
    });

    testWidgets('should have OnboardingProvider', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final onboardingProvider = Provider.of<OnboardingProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(onboardingProvider, isNotNull);
    });

    testWidgets('should have IndexNavProvider', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final indexNavProvider = Provider.of<IndexNavProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(indexNavProvider, isNotNull);
    });

    testWidgets('should have ThemeProvider', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final themeProvider = Provider.of<ThemeProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(themeProvider, isNotNull);
    });

    testWidgets('should have ApiServices', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final apiServices = Provider.of<ApiServices>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(apiServices, isNotNull);
    });

    testWidgets('should have RestaurantListProvider', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final restaurantListProvider = Provider.of<RestaurantListProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(restaurantListProvider, isNotNull);
    });

    testWidgets('should have RestaurantDetailProvider', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final restaurantDetailProvider = Provider.of<RestaurantDetailProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(restaurantDetailProvider, isNotNull);
    });

    testWidgets('should have LocalDatabaseService', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final localDatabaseService = Provider.of<LocalDatabaseService>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(localDatabaseService, isNotNull);
    });

    testWidgets('should have LocalDatabaseProvider', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final localDatabaseProvider = Provider.of<LocalDatabaseProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(localDatabaseProvider, isNotNull);
    });

    testWidgets('should have LocalNotificationService', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final localNotificationService = Provider.of<LocalNotificationService>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(localNotificationService, isNotNull);
    });

    testWidgets('should have LocalNotificationProvider', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(const MyApp());

      // Assert
      final localNotificationProvider = Provider.of<LocalNotificationProvider>(tester.element(find.byType(MaterialApp)), listen: false);
      expect(localNotificationProvider, isNotNull);
    });
  });
}
