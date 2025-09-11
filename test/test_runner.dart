// Test runner for all tests in the restaurant app
// This file can be used to run all tests together

import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'unit/restaurant_model_test.dart' as restaurant_model_test;
import 'unit/restaurant_list_provider_test.dart' as restaurant_list_provider_test;
import 'widget/restaurant_card_widget_test.dart' as restaurant_card_widget_test;
import 'widget/favorite_icon_widget_test.dart' as favorite_icon_widget_test;
import 'widget/main_app_test.dart' as main_app_test;

void main() {
  group('Restaurant App Test Suite', () {
    group('Unit Tests', () {
      restaurant_model_test.main();
      restaurant_list_provider_test.main();
    });

    group('Widget Tests', () {
      restaurant_card_widget_test.main();
      favorite_icon_widget_test.main();
      main_app_test.main();
    });
  });
}
