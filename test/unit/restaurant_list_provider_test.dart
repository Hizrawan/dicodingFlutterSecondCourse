import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/services/api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

// Mock ApiServices for testing
class MockApiServices extends ApiServices {
  Result<RestaurantListResponse>? mockGetRestaurantListResult;
  Result<RestaurantListResponse>? mockSearchRestaurantResult;

  @override
  Future<Result<RestaurantListResponse>> getRestaurantList() async {
    return mockGetRestaurantListResult ?? Failure('Mock error');
  }

  @override
  Future<Result<RestaurantListResponse>> searchRestaurant(String query) async {
    return mockSearchRestaurantResult ?? Failure('Mock error');
  }
}

void main() {
  group('RestaurantListProvider', () {
    late RestaurantListProvider provider;
    late MockApiServices mockApiServices;

    setUp(() {
      mockApiServices = MockApiServices();
      provider = RestaurantListProvider(mockApiServices);
    });

    test('should initialize with none state', () {
      // Assert
      expect(provider.resultState, isA<RestaurantListNoneState>());
    });

    group('fetchRestaurantList', () {
      test('should update state to loading then loaded when API call succeeds', () async {
        // Arrange
        final mockRestaurants = [
          Restaurant(
            id: '1',
            name: 'Test Restaurant 1',
            description: 'Test description 1',
            pictureId: 'pic1',
            city: 'Test City 1',
            rating: 4.0,
            categories: [],
            menus: Menus(foods: [], drinks: []),
            customerReviews: [],
          ),
          Restaurant(
            id: '2',
            name: 'Test Restaurant 2',
            description: 'Test description 2',
            pictureId: 'pic2',
            city: 'Test City 2',
            rating: 4.5,
            categories: [],
            menus: Menus(foods: [], drinks: []),
            customerReviews: [],
          ),
        ];

        final mockResponse = RestaurantListResponse(
          error: false,
          message: 'success',
          count: 2,
          restaurants: mockRestaurants,
        );

        mockApiServices.mockGetRestaurantListResult = Success(mockResponse);

        // Act
        await provider.fetchRestaurantList();

        // Assert
        expect(provider.resultState, isA<RestaurantListLoadedState>());
        if (provider.resultState is RestaurantListLoadedState) {
          final loadedState = provider.resultState as RestaurantListLoadedState;
          expect(loadedState.data.length, 2);
          expect(loadedState.data.first.name, 'Test Restaurant 1');
          expect(loadedState.data.last.name, 'Test Restaurant 2');
        }
      });

      test('should update state to loading then error when API call fails', () async {
        // Arrange
        mockApiServices.mockGetRestaurantListResult = Failure('Network error');

        // Act
        await provider.fetchRestaurantList();

        // Assert
        expect(provider.resultState, isA<RestaurantListErrorState>());
        if (provider.resultState is RestaurantListErrorState) {
          final errorState = provider.resultState as RestaurantListErrorState;
          expect(errorState.error, 'Network error');
        }
      });

      test('should handle exceptions during API call', () async {
        // Arrange
        mockApiServices.mockGetRestaurantListResult = null; // This will cause an exception

        // Act
        await provider.fetchRestaurantList();

        // Assert
        expect(provider.resultState, isA<RestaurantListErrorState>());
        if (provider.resultState is RestaurantListErrorState) {
          final errorState = provider.resultState as RestaurantListErrorState;
          expect(errorState.error, contains('Mock error'));
        }
      });
    });

    group('searchRestaurant', () {
      test('should call fetchRestaurantList when query is empty', () async {
        // Arrange
        final mockRestaurants = [
          Restaurant(
            id: '1',
            name: 'Test Restaurant',
            description: 'Test description',
            pictureId: 'pic1',
            city: 'Test City',
            rating: 4.0,
            categories: [],
            menus: Menus(foods: [], drinks: []),
            customerReviews: [],
          ),
        ];

        final mockResponse = RestaurantListResponse(
          error: false,
          message: 'success',
          count: 1,
          restaurants: mockRestaurants,
        );

        mockApiServices.mockGetRestaurantListResult = Success(mockResponse);

        // Act
        await provider.searchRestaurant('');

        // Assert
        expect(provider.resultState, isA<RestaurantListLoadedState>());
        if (provider.resultState is RestaurantListLoadedState) {
          final loadedState = provider.resultState as RestaurantListLoadedState;
          expect(loadedState.data.length, 1);
          expect(loadedState.data.first.name, 'Test Restaurant');
        }
      });

      test('should call fetchRestaurantList when query is whitespace only', () async {
        // Arrange
        final mockRestaurants = [
          Restaurant(
            id: '1',
            name: 'Test Restaurant',
            description: 'Test description',
            pictureId: 'pic1',
            city: 'Test City',
            rating: 4.0,
            categories: [],
            menus: Menus(foods: [], drinks: []),
            customerReviews: [],
          ),
        ];

        final mockResponse = RestaurantListResponse(
          error: false,
          message: 'success',
          count: 1,
          restaurants: mockRestaurants,
        );

        mockApiServices.mockGetRestaurantListResult = Success(mockResponse);

        // Act
        await provider.searchRestaurant('   ');

        // Assert
        expect(provider.resultState, isA<RestaurantListLoadedState>());
      });

      test('should update state to loading then loaded when search succeeds', () async {
        // Arrange
        final mockRestaurants = [
          Restaurant(
            id: '1',
            name: 'Melting Pot',
            description: 'Test description',
            pictureId: 'pic1',
            city: 'Test City',
            rating: 4.0,
            categories: [],
            menus: Menus(foods: [], drinks: []),
            customerReviews: [],
          ),
        ];

        final mockResponse = RestaurantListResponse(
          error: false,
          message: 'success',
          count: 1,
          restaurants: mockRestaurants,
        );

        mockApiServices.mockSearchRestaurantResult = Success(mockResponse);

        // Act
        await provider.searchRestaurant('melting');

        // Assert
        expect(provider.resultState, isA<RestaurantListLoadedState>());
        if (provider.resultState is RestaurantListLoadedState) {
          final loadedState = provider.resultState as RestaurantListLoadedState;
          expect(loadedState.data.length, 1);
          expect(loadedState.data.first.name, 'Melting Pot');
        }
      });

      test('should update state to loading then error when search fails', () async {
        // Arrange
        mockApiServices.mockSearchRestaurantResult = Failure('Search failed');

        // Act
        await provider.searchRestaurant('nonexistent');

        // Assert
        expect(provider.resultState, isA<RestaurantListErrorState>());
        if (provider.resultState is RestaurantListErrorState) {
          final errorState = provider.resultState as RestaurantListErrorState;
          expect(errorState.error, 'Search failed');
        }
      });

      test('should handle exceptions during search', () async {
        // Arrange
        mockApiServices.mockSearchRestaurantResult = null; // This will cause an exception

        // Act
        await provider.searchRestaurant('test');

        // Assert
        expect(provider.resultState, isA<RestaurantListErrorState>());
        if (provider.resultState is RestaurantListErrorState) {
          final errorState = provider.resultState as RestaurantListErrorState;
          expect(errorState.error, contains('Mock error'));
        }
      });
    });
  });
}
