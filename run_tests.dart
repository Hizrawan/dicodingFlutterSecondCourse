// Test runner script for the restaurant app
// Run this with: dart run run_tests.dart

import 'dart:io';

void main() async {
  print('🧪 Running Restaurant App Tests...\n');

  // Run unit tests
  print('📋 Running Unit Tests...');
  final unitResult = await Process.run('flutter', ['test', 'test/unit/']);
  print('Unit Tests Result: ${unitResult.exitCode == 0 ? '✅ PASSED' : '❌ FAILED'}');
  if (unitResult.exitCode != 0) {
    print('Unit Test Errors:\n${unitResult.stderr}');
  }
  print('');

  // Run widget tests
  print('🎨 Running Widget Tests...');
  final widgetResult = await Process.run('flutter', ['test', 'test/widget/']);
  print('Widget Tests Result: ${widgetResult.exitCode == 0 ? '✅ PASSED' : '❌ FAILED'}');
  if (widgetResult.exitCode != 0) {
    print('Widget Test Errors:\n${widgetResult.stderr}');
  }
  print('');

  // Run integration tests (optional - requires device/emulator)
  print('🔄 Integration Tests (requires device/emulator)...');
  print('To run integration tests, use: flutter test integration_test/');
  print('');

  // Summary
  final allPassed = unitResult.exitCode == 0 && widgetResult.exitCode == 0;
  print('📊 Test Summary:');
  print('Unit Tests: ${unitResult.exitCode == 0 ? '✅ PASSED' : '❌ FAILED'}');
  print('Widget Tests: ${widgetResult.exitCode == 0 ? '✅ PASSED' : '❌ FAILED'}');
  print('Overall: ${allPassed ? '✅ ALL TESTS PASSED' : '❌ SOME TESTS FAILED'}');
  
  exit(allPassed ? 0 : 1);
}
