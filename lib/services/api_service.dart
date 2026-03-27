import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article_model.dart';

class ApiService {
  static const String baseUrl = "https://ahmadansari.site";
  static const int timeout = 30;

  // Get all articles
  Future<List<Article>> getArticles() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/articles'))
          .timeout(const Duration(seconds: timeout));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];

        return data.map((item) => Article.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching articles: $e');
      rethrow;
    }
  }

  // Get article by ID
  Future<Article> getArticleById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/articles/$id'))
          .timeout(const Duration(seconds: timeout));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Article.fromJson(jsonData['data']);
      } else {
        throw Exception('Article not found');
      }
    } catch (e) {
      print('Error fetching article: $e');
      rethrow;
    }
  }

  // Add new article
  Future<Article> addArticle({
    required String title,
    required String category,
    required String content,
    required String author,
    String? imageUrl,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/articles'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'title': title,
              'category': category,
              'content': content,
              'author': author,
              'image_url': imageUrl,
            }),
          )
          .timeout(const Duration(seconds: timeout));

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return Article.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to add article');
      }
    } catch (e) {
      print('Error adding article: $e');
      rethrow;
    }
  }

  // Update article
  Future<Article> updateArticle({
    required int id,
    required String title,
    required String category,
    required String content,
    required String author,
    String? imageUrl,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl/api/articles/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'title': title,
              'category': category,
              'content': content,
              'author': author,
              'image_url': imageUrl,
            }),
          )
          .timeout(const Duration(seconds: timeout));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Article.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to update article');
      }
    } catch (e) {
      print('Error updating article: $e');
      rethrow;
    }
  }

  // Delete article
  Future<void> deleteArticle(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/api/articles/$id'))
          .timeout(const Duration(seconds: timeout));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete article');
      }
    } catch (e) {
      print('Error deleting article: $e');
      rethrow;
    }
  }
}
