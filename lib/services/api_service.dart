import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiService {
  late String baseUrl;
  late int timeout;

  ApiService() {
    baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://localhost:5000';
    timeout = int.parse(dotenv.env['API_TIMEOUT'] ?? '30');
  }

  // Get all articles
  Future<List<dynamic>> getArticles() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/articles'))
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Get single article
  Future<dynamic> getArticleById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/articles/$id'))
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Article not found');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Add new article
  Future<dynamic> addArticle(Map<String, dynamic> articleData) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/articles'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(articleData),
          )
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 201) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to add article');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Update article
  Future<dynamic> updateArticle(
      int id, Map<String, dynamic> articleData) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/api/articles/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(articleData),
          )
          .timeout(Duration(seconds: timeout));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to update article');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Delete article
  Future<void> deleteArticle(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/api/articles/$id'))
          .timeout(Duration(seconds: timeout));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete article');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
