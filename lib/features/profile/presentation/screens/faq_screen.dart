import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organicplants/core/services/app_sizes.dart';
import 'package:organicplants/features/profile/presentation/widgets/profile_custom_icon.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I care for my new plant?',
      'answer':
          'Most plants need bright, indirect light, regular watering when the top soil feels dry, and well-draining soil. Check the care guide that comes with your plant for specific instructions.',
      'category': 'Plant Care',
      'icon': Icons.eco_outlined,
    },
    {
      'question': 'What is your return policy?',
      'answer':
          'We offer a 30-day return window for all plants. If your plant arrives damaged or dies within 30 days, we\'ll replace it or provide a full refund.',
      'category': 'Returns',
      'icon': Icons.assignment_return_outlined,
    },
    {
      'question': 'How long does shipping take?',
      'answer':
          'Standard shipping takes 3-5 business days. Express shipping (1-2 days) is available for an additional fee. We ship plants carefully packaged to ensure they arrive healthy.',
      'category': 'Shipping',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'question': 'Do you ship internationally?',
      'answer':
          'Currently, we only ship within India. We\'re working on expanding our shipping to other countries soon.',
      'category': 'Shipping',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'question': 'Are your plants pet-safe?',
      'answer':
          'We offer a selection of pet-safe plants. Look for the "Pet Safe" badge on plant listings. However, we recommend keeping all plants out of reach of pets.',
      'category': 'Plant Care',
      'icon': Icons.eco_outlined,
    },
    {
      'question': 'What payment methods do you accept?',
      'answer':
          'We accept all major credit/debit cards, UPI, net banking, and digital wallets like Paytm, PhonePe, and Google Pay.',
      'category': 'Payment',
      'icon': Icons.payment_outlined,
    },
    {
      'question': 'Can I cancel my order?',
      'answer':
          'You can cancel your order within 2 hours of placing it. After that, the order will be processed and shipped. Contact our support team for assistance.',
      'category': 'Orders',
      'icon': Icons.shopping_bag_outlined,
    },
    {
      'question': 'Do you offer plant care advice?',
      'answer':
          'Yes! We provide detailed care guides with each plant, and our plant care experts are available via chat, email, or phone to help you with any questions.',
      'category': 'Support',
      'icon': Icons.support_agent_outlined,
    },
  ];

  // Refactor to use ValueNotifier
  final ValueNotifier<String> _selectedCategory = ValueNotifier('All');
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<List<Map<String, dynamic>>> _filteredFaqs = ValueNotifier(
    [],
  );

  @override
  void initState() {
    super.initState();
    _filterFaqs(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ", style: textTheme.headlineMedium),

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
            size: AppSizes.iconMd,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: AppSizes.paddingAllSm,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: _filterFaqs,
                  decoration: InputDecoration(
                    contentPadding: AppSizes.paddingAllSm,
                    hintText: 'Search FAQs...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: colorScheme.onSurface,
                      size: AppSizes.iconMd,
                    ),
                    suffixIcon:
                        _searchController.text.isEmpty
                            ? null
                            : IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: colorScheme.onSurface,
                              ),
                              iconSize: AppSizes.iconMd,
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppSizes.radiusXxl),
                      ),
                      borderSide: BorderSide(color: colorScheme.surface),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppSizes.radiusXxl),
                      ),
                      borderSide: BorderSide(color: colorScheme.surface),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppSizes.radiusXxl),
                      ),
                      borderSide: BorderSide(color: colorScheme.surface),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Category Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('All'),
                      SizedBox(width: 8.w),
                      _buildCategoryChip('Plant Care'),
                      SizedBox(width: 8.w),
                      _buildCategoryChip('Shipping'),
                      SizedBox(width: 8.w),
                      _buildCategoryChip('Returns'),
                      SizedBox(width: 8.w),
                      _buildCategoryChip('Payment'),
                      SizedBox(width: 8.w),
                      _buildCategoryChip('Orders'),
                      SizedBox(width: 8.w),
                      _buildCategoryChip('Support'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FAQ List
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: _filteredFaqs,
              builder: (context, filteredFaqs, _) {
                return filteredFaqs.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: filteredFaqs.length,
                      itemBuilder: (context, index) {
                        return _buildFAQCard(filteredFaqs[index]);
                      },
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ValueListenableBuilder<String>(
      valueListenable: _selectedCategory,
      builder: (context, selectedCategory, _) {
        final isSelected = selectedCategory == category;
        return FilterChip(
          label: Text(category, style: textTheme.bodyMedium),

          selected: isSelected,
          onSelected: (selected) {
            _selectedCategory.value = category;
            _filterFaqs(_searchController.text);
          },
          backgroundColor: colorScheme.surface,
          selectedColor: colorScheme.primary,
          checkmarkColor: colorScheme.onSurface,

          side: BorderSide(color: colorScheme.surface),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppSizes.paddingAllSm,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_outlined,
              size: AppSizes.iconXl,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 24.h),
          Text("No FAQs Found", style: textTheme.headlineLarge),
          SizedBox(height: 8.h),
          Text(
            "Try adjusting your search or filter",
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(Map<String, dynamic> faq) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),

      //  elevation: 1,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),

      child: ExpansionTile(
        leading: ProfileCustomIcon(
          icon: faq['icon'],
          iconColor: _getCategoryColor(faq['category']),
        ),
        title: Text(faq['question'], style: textTheme.titleMedium),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            faq['category'],
            style: textTheme.bodySmall?.copyWith(
              color: _getCategoryColor(faq['category']),
            ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
            child: Text(
              faq['answer'],
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Plant Care':
        return Colors.green;
      case 'Shipping':
        return Colors.blue;
      case 'Returns':
        return Colors.orange;
      case 'Payment':
        return Colors.purple;
      case 'Orders':
        return Colors.indigo;
      case 'Support':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _filterFaqs(String query) {
    _filteredFaqs.value =
        _faqs.where((faq) {
          final matchesSearch =
              faq['question'].toLowerCase().contains(query.toLowerCase()) ||
              faq['answer'].toLowerCase().contains(query.toLowerCase());
          final matchesCategory =
              _selectedCategory.value == 'All' ||
              faq['category'] == _selectedCategory.value;
          return matchesSearch && matchesCategory;
        }).toList();
  }
}
