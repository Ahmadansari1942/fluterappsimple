import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import 'article_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  List<Article> _articles = [];
  List<Article> _filtered = [];
  bool _loading = true;
  String _error = '';
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Technology', 'Creativity', 'Lifestyle', 'Health', 'Business'
  ];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    try {
      setState(() { _loading = true; _error = ''; });
      final articles = await _apiService.getArticles();
      setState(() {
        _articles = articles;
        _filtered = articles;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not load articles. Please try again.';
        _loading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filtered = _articles.where((a) {
        final matchSearch = a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            a.content.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchCategory = _selectedCategory == 'All' || a.category == _selectedCategory;
        return matchSearch && matchCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        children: [
          // TOP BAR
          Container(
            color: const Color(0xFF0A0A0A),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AhmadBlog',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: _loadArticles,
                      icon: const Icon(Icons.refresh, color: Colors.deepPurpleAccent),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Search Bar
                TextField(
                  onChanged: (val) {
                    _searchQuery = val;
                    _applyFilters();
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search articles...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: const Icon(Icons.search, color: Colors.deepPurpleAccent),
                    filled: true,
                    fillColor: const Color(0xFF1E1E2E),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Category chips
                SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final selected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() { _selectedCategory = cat; });
                            _applyFilters();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected ? Colors.deepPurple : const Color(0xFF1E1E2E),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? Colors.deepPurple : Colors.grey[800]!,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.grey[400],
                                fontSize: 13,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // CONTENT
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
                  )
                : _error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off, color: Colors.grey, size: 60),
                            const SizedBox(height: 16),
                            Text(_error, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadArticles,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'No articles found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadArticles,
                            color: Colors.deepPurpleAccent,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                              itemCount: _filtered.length,
                              itemBuilder: (context, index) {
                                return _ArticleCard(
                                  article: _filtered[index],
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ArticleDetailPage(
                                        article: _filtered[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const _ArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                  ? Image.network(
                      article.imageUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + Date Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.category,
                          style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        article.createdAt?.substring(0, 10) ?? '',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Title
                  Text(
                    article.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Content preview
                  Text(
                    article.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Author + Read More Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              (article.author ?? 'A')[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            article.author ?? 'Ahmad',
                            style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Read More',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFF2A2A3E),
      child: const Icon(Icons.article_outlined, color: Colors.deepPurpleAccent, size: 50),
    );
  }
}
