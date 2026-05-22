import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  final List<String> _allFaqs = [
    'How does the OOTD generator work?',
    'Can I export my wardrobe data?',
    'How do I manage my privacy settings?',
    'How do I add a new item?',
    'How do I connect my Instagram account?',
  ];
  
  List<String> _filteredFaqs = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqs = _allFaqs;
    _searchController.addListener(_filterFaqs);
  }

  void _filterFaqs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFaqs = _allFaqs.where((faq) => faq.toLowerCase().contains(query)).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _contactSupport() async {
    final Uri url = Uri.parse('https://wa.me/6285121080310');
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HELP & SUPPORT')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text('How can we help you?', style: GoogleFonts.epilogue(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.secondaryCharcoal)),
          const SizedBox(height: 24),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for articles...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.tertiaryMutedOlive),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3))),
            ),
          ),
          const SizedBox(height: 32),
          Text('FAQ', style: GoogleFonts.epilogue(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryOlive)),
          const SizedBox(height: 16),
          ..._filteredFaqs.map((faq) => _buildFaqItem(faq)),
          
          const SizedBox(height: 48),
          OutlinedButton.icon(
            onPressed: _contactSupport,
            icon: const Icon(Icons.email_outlined, color: AppTheme.primaryOlive),
            label: const Text('CONTACT SUPPORT'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppTheme.primaryOlive),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.tertiaryMutedOlive.withOpacity(0.3)),
      ),
      child: ExpansionTile(
        title: Text(question, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('This is a dummy answer for the FAQ item. The support logic will be implemented later.', style: GoogleFonts.inter(color: Colors.grey.shade600)),
          )
        ],
      ),
    );
  }
}
