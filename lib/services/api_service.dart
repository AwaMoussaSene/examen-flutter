import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'https://api-exam-flutter-l3.smartek.sn';
  static const String tokenKey = 'auth_token';
  
  late Dio _dio;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Intercepteur pour ajouter le token automatiquement
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Si token expiré (401), supprimer le token
        if (error.response?.statusCode == 401) {
          await removeToken();
        }
        handler.next(error);
      },
    ));
  }

  // Gestion du token
  Future<void> saveToken(String token) async {
    await _storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: tokenKey);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Authentification
  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      if (token != null) {
        await saveToken(token);
        return token;
      } else {
        throw Exception('Token non reçu dans la réponse');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Email ou mot de passe incorrect');
      } else if (e.response?.statusCode == 422) {
        throw Exception('Données invalides');
      } else {
        throw Exception('Erreur de connexion: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }

  Future<void> logout() async {
    await removeToken();
  }

  // CRUD Produits
  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await _dio.get('/api/products');
      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getProduct(int id) async {
    try {
      final response = await _dio.get('/api/products/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _dio.post('/api/products', data: productData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      final response = await _dio.put('/api/products/$id', data: productData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/api/products/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Upload d'image avec multipart/form-data
  Future<Map<String, dynamic>> uploadProductWithImage({
    required Map<String, dynamic> productData,
    required String imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        ...productData,
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post('/api/products', data: formData);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Gestion des erreurs
  Exception _handleError(DioException e) {
    switch (e.response?.statusCode) {
      case 400:
        return Exception('Requête invalide');
      case 401:
        return Exception('Non autorisé - Veuillez vous reconnecter');
      case 403:
        return Exception('Accès refusé');
      case 404:
        return Exception('Ressource non trouvée');
      case 422:
        return Exception('Données invalides: ${e.response?.data}');
      case 500:
        return Exception('Erreur serveur');
      default:
        return Exception('Erreur de connexion: ${e.message}');
    }
  }
}