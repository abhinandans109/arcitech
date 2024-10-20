import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/item_model.dart';

class ItemProvider with ChangeNotifier {
  List<dynamic> _items = [];
  bool _isLoading = true;
  String? _error;

  List<dynamic> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch items from the API
  Future<void> fetchItems() async {
    const apiKey = 'P1PSjj7JD37q2r0hj2JumPF2d2Bedmv1f0V3dC2HrfcgS59XHCCDksA0';
    const url = 'https://api.pexels.com/v1/curated'; // Your API URL here

    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(
          Uri.parse(url),
        headers: {
          'Authorization': apiKey
        }
      );
      if (response.statusCode == 200) {

        Map<String,dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> itemsList = jsonResponse['photos'].map((item) => Item.fromJson(item)).toList() ;

        _items = itemsList;
        _error = null;
      } else {
        _error = 'Failed to load items';
      }
    } catch (e) {
      _error = 'Error loading data: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
