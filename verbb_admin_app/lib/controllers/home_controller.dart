import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/school_model.dart';
import '../services/api_service.dart';

class HomeController with ChangeNotifier {
  List<SchoolModel> _schools = [];
  List<SchoolModel> get schools => _schools;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  // Add school via API
  Future<void> addSchool(String name, String email, String tname) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.post('/add_school', {
        "school_name": name,
        "teacher_name": tname,
        "email": email,
        "is_active": true,
      });

      if (response.statusCode == 200) {
        // Add school to the list locally after successful API call
        _schools.add(SchoolModel(name: name, email: email, tname: tname));
      } else {
        print(response.body);
        print(response.statusCode);
        throw Exception('Failed to add school');
      }
    } catch (e) {
      print('Error adding school: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch schools via API on HomeView initialization
  Future<void> fetchSchools() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/get_schools');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        _schools = data.map((school) {
          return SchoolModel(
            name: school['school_name'],
            email: school['email'],
            tname: school['teacher_name'],
          );
        }).toList();
      } else {
        throw Exception('Failed to fetch schools');
      }
    } catch (e) {
      print('Error fetching schools: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
