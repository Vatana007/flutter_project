import 'dart:async';
import 'package:project_flutter/models/student.dart';

class AuthService {
  // Simulates login api call.
  Future<Student> login(String emailOrId, String password) async {
    await Future.delayed(const Duration(milliseconds: 1200)); // Simulate networking lag
    
    if (emailOrId.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('email_empty');
    }
    
    // Create a mock logged-in student profile
    return Student(
      id: 'ST-20240982',
      name: 'Rithy Seng',
      email: emailOrId.contains('@') ? emailOrId : 'rithy.seng@edutrack.edu.kh',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150', // Female/Male neutral profile photo
      major: 'Computer Science & Engineering',
      academicYear: 'Year 3, Semester 2',
      phoneNumber: '+855 89 777 666',
      gpa: 3.82,
    );
  }

  // Simulates register api call.
  Future<Student> register(String name, String email, String password, String confirmPassword) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (name.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty || confirmPassword.trim().isEmpty) {
      throw Exception('fields_empty');
    }
    
    if (!email.contains('@') || !email.contains('.')) {
      throw Exception('invalid_email');
    }
    
    if (password != confirmPassword) {
      throw Exception('passwords_dont_match');
    }
    
    // Return the newly registered student
    return Student(
      id: 'ST-2024${1000 + (name.length * 7) % 900}',
      name: name,
      email: email,
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      major: 'Computer Science & Engineering',
      academicYear: 'Year 1, Semester 1',
      phoneNumber: '+855 12 345 678',
      gpa: 4.00, // Starts fresh!
    );
  }
}
