import '../../../core/network/api_client.dart';
import '../../../core/network/api_config.dart';
import '../../../core/storage/token_storage.dart';
import '../models/auth_response.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;

  AuthRepository({ApiClient? apiClient, TokenStorage? tokenStorage})
    : _apiClient = apiClient ?? ApiClient(),
      _tokenStorage = tokenStorage ?? TokenStorage();

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/register',
        body: {'name': name, 'email': email, 'password': password},
      );

      final data = response['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid registration response.');
      }

      final authResponse = AuthResponse.fromJson(data);

      // SAVE ACCESS TOKEN HERE
      await _tokenStorage.saveAccessToken(authResponse.accessToken);

      return authResponse;
    } on ApiException catch (error) {
      throw Exception(error.message);
    } catch (error) {
      throw Exception(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/login',
        body: {'email': email, 'password': password},
      );

      final data = response['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid login response.');
      }

      final authResponse = AuthResponse.fromJson(data);

      // SAVE ACCESS TOKEN HERE
      await _tokenStorage.saveAccessToken(authResponse.accessToken);

      return authResponse;
    } on ApiException catch (error) {
      throw Exception(error.message);
    } catch (error) {
      throw Exception(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearAccessToken();
  }
}
