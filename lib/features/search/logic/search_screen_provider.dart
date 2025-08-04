import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organicplants/core/services/all_plants_global_data.dart';
import 'package:organicplants/models/all_plants_model.dart';

class SearchScreenProvider extends ChangeNotifier {
  final List<String> _recentSearchHistory = [];
  final List<String> _recentViewedPlants = [];
  final List<AllPlantsModel> _searchResult = [];
  String _searchText = '';
  bool noResultsFound = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Real-time listeners
  StreamSubscription<DocumentSnapshot>? _searchHistoryListener;
  StreamSubscription<DocumentSnapshot>? _viewedPlantsListener;

  List<String> get recentSearchHistory => _recentSearchHistory;
  List<String> get recentViewedPlants => _recentViewedPlants;
  List<AllPlantsModel> get searchResult => _searchResult;
  String get searchText => _searchText;
  String get _uid => _auth.currentUser?.uid ?? '';

  SearchScreenProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadSearchHistoryFromFirestore();
      } else {
        _disposeListeners();
        _clearAllData();
      }
    });
  }

  void _clearAllData() {
    _recentSearchHistory.clear();
    _recentViewedPlants.clear();
    _searchResult.clear();
    _searchText = '';
    noResultsFound = false;
    notifyListeners();
  }

  void _disposeListeners() {
    _searchHistoryListener?.cancel();
    _searchHistoryListener = null;
    _viewedPlantsListener?.cancel();
    _viewedPlantsListener = null;
  }

  Future<void> _loadSearchHistoryFromFirestore() async {
    if (_uid.isEmpty) return;
    // Listen to search history changes
    _searchHistoryListener = _firestore
        .collection('users')
        .doc(_uid)
        .collection('search_history')
        .doc('recent_searches')
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.exists) {
              final data = snapshot.data();
              final List<dynamic> searches = data?['searches'] ?? [];
              _recentSearchHistory.clear();
              _recentSearchHistory.addAll(searches.cast<String>());
              notifyListeners();
            }
          },
          onError: (error) {
            debugPrint('Error listening to search history: $error');
          },
        );

    // Listen to viewed plants changes
    _viewedPlantsListener = _firestore
        .collection('users')
        .doc(_uid)
        .collection('search_history')
        .doc('recent_viewed_history')
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.exists) {
              final data = snapshot.data();
              final List<dynamic> viewedPlants = data?['viewedPlants'] ?? [];
              _recentViewedPlants.clear();
              for (String plantId in viewedPlants) {
                _recentViewedPlants.add(plantId);
              }
              notifyListeners();
            }
          },
          onError: (error) {
            debugPrint('Error listening to viewed plants: $error');
          },
        );
  }

  @override
  void dispose() {
    _disposeListeners();
    super.dispose();
  }

  Future<void> _saveSearchHistoryToFirestore() async {
    if (_uid.isEmpty) return;
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('search_history')
          .doc('recent_searches')
          .set({
            'searches': _recentSearchHistory,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving search history: $e');
      rethrow; // Re-throw to allow rollback
    }
  }

  Future<void> _saveViewedPlantsToFirestore() async {
    if (_uid.isEmpty) return;
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('search_history')
          .doc('recent_viewed_history')
          .set({
            'viewedPlants': _recentViewedPlants,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving viewed plants: $e');
      rethrow; // Re-throw to allow rollback
    }
  }

  void updateSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  void setNoResultsFound(bool value) {
    noResultsFound = value;
    notifyListeners();
  }

  Future<void> addRecentSearchHistory(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    // Store original state for rollback
    final originalHistory = List<String>.from(_recentSearchHistory);

    try {
      _recentSearchHistory.removeWhere((h) => h == cleanQuery);
      _recentSearchHistory.insert(0, cleanQuery);
      if (_recentSearchHistory.length > 20) {
        _recentSearchHistory.removeRange(0, _recentSearchHistory.length - 20);
      }

      if (_uid.isNotEmpty) {
        await _saveSearchHistoryToFirestore();
      }
      notifyListeners();
    } catch (e) {
      // Rollback on failure
      _recentSearchHistory.clear();
      _recentSearchHistory.addAll(originalHistory);
      notifyListeners();
      debugPrint('Error adding search history, rolled back: $e');
    }
  }

  Future<void> addRecentlyViewedPlant(String plantId) async {
    if (plantId.isEmpty) return;

    // Store original state for rollback
    final originalViewed = List<String>.from(_recentViewedPlants);

    try {
      _recentViewedPlants.removeWhere((p) => p == plantId);
      _recentViewedPlants.insert(0, plantId);
      if (_recentViewedPlants.length > 10) {
        _recentViewedPlants.removeRange(0, _recentViewedPlants.length - 10);
      }

      if (_uid.isNotEmpty) {
        await _saveViewedPlantsToFirestore();
      }
      notifyListeners();
    } catch (e) {
      // Rollback on failure
      _recentViewedPlants.clear();
      _recentViewedPlants.addAll(originalViewed);
      notifyListeners();
      debugPrint('Error adding viewed plant, rolled back: $e');
    }
  }

  Future<void> removeRecentViewPlant(String plantId) async {
    if (plantId.isEmpty) return;

    // Store original state for rollback
    final originalViewed = List<String>.from(_recentViewedPlants);

    try {
      _recentViewedPlants.removeWhere((p) => p == plantId);

      if (_uid.isNotEmpty) {
        await _saveViewedPlantsToFirestore();
      }
      notifyListeners();
    } catch (e) {
      // Rollback on failure
      _recentViewedPlants.clear();
      _recentViewedPlants.addAll(originalViewed);
      notifyListeners();
      debugPrint('Error removing viewed plant, rolled back: $e');
    }
  }

  Future<void> removeSearchHistory(String query) async {
    if (query.isEmpty) return;

    // Store original state for rollback
    final originalHistory = List<String>.from(_recentSearchHistory);

    try {
      _recentSearchHistory.remove(query);

      if (_uid.isNotEmpty) {
        await _saveSearchHistoryToFirestore();
      }
      notifyListeners();
    } catch (e) {
      // Rollback on failure
      _recentSearchHistory.clear();
      _recentSearchHistory.addAll(originalHistory);
      notifyListeners();
      debugPrint('Error removing search history, rolled back: $e');
    }
  }

  Future<void> clearSearchHistory() async {
    // Store original state for rollback
    final originalHistory = List<String>.from(_recentSearchHistory);

    try {
      _recentSearchHistory.clear();

      if (_uid.isNotEmpty) {
        await _saveSearchHistoryToFirestore();
      }
      notifyListeners();
    } catch (e) {
      // Rollback on failure
      _recentSearchHistory.clear();
      _recentSearchHistory.addAll(originalHistory);
      notifyListeners();
      debugPrint('Error clearing search history, rolled back: $e');
    }
  }

  Future<void> clearRecentlyViewed() async {
    // Store original state for rollback
    final originalViewed = List<String>.from(_recentViewedPlants);

    try {
      _recentViewedPlants.clear();

      if (_uid.isNotEmpty) {
        await _saveViewedPlantsToFirestore();
      }
      notifyListeners();
    } catch (e) {
      // Rollback on failure
      _recentViewedPlants.clear();
      _recentViewedPlants.addAll(originalViewed);
      notifyListeners();
      debugPrint('Error clearing viewed plants, rolled back: $e');
    }
  }

  List<AllPlantsModel> search(String query) {
    final keywords = query.toLowerCase().trim();
    final allPlantTerms = ['plant', 'plants', 'all plants', 'all plant'];

    if (keywords.isEmpty) {
      _searchResult.clear();
      notifyListeners();
      return _searchResult;
    }

    if (allPlantTerms.contains(keywords)) {
      _searchResult.clear();
      _searchResult.addAll(allPlantsGlobal);
      notifyListeners();
      return _searchResult;
    }

    final knownTags = [
      'pet friendly',
      'low maintenance',
      'air purifying',
      'edible',
      'foliage',
      'flowering',
      'beginner friendly',
      'sun loving',
      'shadow loving',
    ];

    final knownCategories = [
      'indoor',
      'outdoor',
      'bonsai',
      'flowering',
      'succulent',
      'medicinal',
      'cacti',
      'herbs',
    ];

    final matchedTags =
        knownTags.where((tag) => keywords.contains(tag)).toList();
    final matchedCategories =
        knownCategories.where((cat) => keywords.contains(cat)).toList();

    String remainingQuery = keywords;
    for (var tag in matchedTags) {
      remainingQuery = remainingQuery.replaceAll(tag, '');
    }
    for (var cat in matchedCategories) {
      remainingQuery = remainingQuery.replaceAll(cat, '');
    }

    remainingQuery =
        remainingQuery
            .replaceAll(
              RegExp(r'\b(plants?|trees?)\b', caseSensitive: false),
              '',
            )
            .trim();

    final searchTerms =
        remainingQuery
            .split(RegExp(r'\s+'))
            .where((term) => term.isNotEmpty)
            .toList();

    String normalizeScientificName(String name) {
      return name.toLowerCase().trim().replaceAll('.', '');
    }

    _searchResult.clear();
    _searchResult.addAll(
      allPlantsGlobal.where((plant) {
        final commonName = plant.commonName?.toLowerCase() ?? '';
        final sciName = normalizeScientificName(plant.scientificName ?? '');
        final tags =
            plant.tags?.map((t) => t.replaceAll('_', ' ').toLowerCase()) ?? [];
        final category = plant.category?.toLowerCase() ?? '';

        final matchesAllTags = matchedTags.every((tag) => tags.contains(tag));
        final matchesCategory =
            matchedCategories.isEmpty ||
            matchedCategories.any((cat) => category.contains(cat));
        final matchesKeyword =
            searchTerms.isEmpty ||
            searchTerms.any(
              (term) => commonName.contains(term) || sciName.contains(term),
            );

        return matchesAllTags && matchesCategory && matchesKeyword;
      }),
    );

    if (_searchResult.isEmpty) {
      _searchResult.addAll(
        allPlantsGlobal.where((plant) {
          final commonName = plant.commonName?.toLowerCase() ?? '';
          final sciName = normalizeScientificName(plant.scientificName ?? '');
          return searchTerms.any(
            (term) => commonName.contains(term) || sciName.contains(term),
          );
        }),
      );
    }

    notifyListeners();
    return _searchResult;
  }

  List<AllPlantsModel> getSuggestions(String query) {
    final keywords = query.toLowerCase().trim();
    if (keywords.isEmpty) return [];

    return allPlantsGlobal
        .where((plant) {
          final name = plant.commonName?.toLowerCase() ?? '';
          final sci = plant.scientificName?.toLowerCase() ?? '';
          final tags =
              plant.tags?.map((t) => t.replaceAll('_', ' ').toLowerCase()) ??
              [];
          final category = plant.category?.toLowerCase() ?? '';

          return name.contains(keywords) ||
              sci.contains(keywords) ||
              category.contains(keywords) ||
              tags.any((t) => t.contains(keywords));
        })
        .take(8)
        .toList();
  }
}
