import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/dummy_data.dart';
import '../providers/wardrobe_provider.dart';
import '../utils/theme.dart';
import 'archive_detail_screen.dart';
import 'inspiration_detail_screen.dart';
import '../services/search_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  String _currentTag = '';
  
  bool _isLoading = false;
  String _errorMessage = '';
  List<String> _pinterestImages = [];
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _hasSearched = false;
        _pinterestImages.clear();
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _hasSearched = true;
    });

    try {
      final searchQuery = query.toLowerCase().contains('vintage') ? query : '$query vintage outfit';
      final results = await _searchService.searchPinterestImages(searchQuery);
      setState(() {
        _pinterestImages = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat gambar: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wardrobe = context.watch<WardrobeProvider>();
    final query = _searchController.text;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _searchController,
            onSubmitted: (value) => _performSearch(value),
            decoration: InputDecoration(
              hintText: 'Search inspiration...',
              hintStyle: GoogleFonts.inter(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: AppTheme.secondaryCharcoal),
              suffixIcon: query.isNotEmpty || _currentTag.isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.clear), 
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _currentTag = '';
                        _hasSearched = false;
                        _pinterestImages.clear();
                      });
                    }
                  ) 
                : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Tags
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTag('#Oversized'),
              _buildTag('#EarthTones'),
              _buildTag('#90sDenim'),
              _buildTag('#Leather'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          Text(
            _hasSearched ? 'Inspirations (${_pinterestImages.length})' : 'Curated Archives',
            style: GoogleFonts.epilogue(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryCharcoal,
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: GoogleFonts.inter(color: Colors.red)))
                : _hasSearched 
                  ? _pinterestImages.isEmpty
                    ? Center(child: Text('Tidak ada inspirasi ditemukan.', style: GoogleFonts.inter()))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _pinterestImages.length,
                        itemBuilder: (context, index) {
                          final imageUrl = _pinterestImages[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InspirationDetailScreen(imageUrl: imageUrl),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.2)),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Icon(Icons.broken_image, color: Colors.grey.shade400, size: 40),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      )
                  : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: DummyData.categories.length - 1, // Skip 'All'
                  itemBuilder: (context, index) {
                    final category = DummyData.categories[index + 1];
                    return GestureDetector(
                      onTap: () {
                        final item = DummyData.wardrobeItems.firstWhere(
                          (i) => i.category == category,
                          orElse: () => DummyData.wardrobeItems.first,
                        );
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => ArchiveDetailScreen(item: item),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
                        ),
                        child: Center(
                          child: Text(
                            category.toUpperCase(),
                            style: GoogleFonts.epilogue(
                              color: AppTheme.primaryOlive,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
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
    );
  }

  Widget _buildTag(String text) {
    final isSelected = _currentTag == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _currentTag = '';
            _searchController.clear();
            _hasSearched = false;
            _pinterestImages.clear();
          } else {
            _currentTag = text;
            _searchController.text = text;
            _performSearch(text);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryOlive : AppTheme.tertiaryMutedOlive.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : AppTheme.primaryOlive,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
