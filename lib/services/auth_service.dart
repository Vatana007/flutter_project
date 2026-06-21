import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:project_flutter/models/student.dart';

class AuthService {
  static List<File> get _accountFileCandidates {
    if (kIsWeb) {
      return [];
    }

    final files = <String, File>{};
    Directory? directory = Directory.current;

    while (directory != null) {
      final accountFile = File('${directory.path}/accounts/accounts.json');
      files[accountFile.path] = accountFile;

      final parent = directory.parent;
      if (parent.path == directory.path) {
        directory = null;
      } else {
        directory = parent;
      }
    }

    final tempFile = File(
      '${Directory.systemTemp.path}/project_flutter/accounts.json',
    );
    files[tempFile.path] = tempFile;

    return files.values.toList();
  }

  Future<Student> login(String emailOrId, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final email = emailOrId.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (email.isEmpty || cleanPassword.isEmpty) {
      throw Exception('email_empty');
    }

    for (final account in await _readAccounts()) {
      final savedEmail = account['email']?.toString().toLowerCase() ?? '';
      final savedPassword = account['password']?.toString() ?? '';
      if (savedEmail == email && savedPassword == cleanPassword) {
        final studentJson = account['student'];
        if (studentJson is Map<String, dynamic>) {
          return Student.fromJson(studentJson);
        }
      }
    }

    throw Exception('invalid_login');
  }

  Future<Student> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanName.isEmpty ||
        cleanEmail.isEmpty ||
        cleanPassword.isEmpty ||
        confirmPassword.trim().isEmpty) {
      throw Exception('fields_empty');
    }

    if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      throw Exception('invalid_email');
    }

    if (cleanPassword != confirmPassword.trim()) {
      throw Exception('passwords_dont_match');
    }

    final accounts = await _readAccounts();
    final emailExists = accounts.any((account) {
      final savedEmail = account['email']?.toString().toLowerCase() ?? '';
      return savedEmail == cleanEmail;
    });

    if (emailExists) {
      throw Exception('email_exists');
    }

    final student = Student(
      id: 'ST-${DateTime.now().millisecondsSinceEpoch}',
      name: cleanName,
      email: cleanEmail,
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      major: 'Software Development',
      academicYear: 'Year 3, Semester 2',
      phoneNumber: '+855 12 345 678',
      gpa: 4.00,
      attendanceRate: 1.0,
    );

    accounts.add({
      'email': cleanEmail,
      'password': cleanPassword,
      'student': student.toJson(),
    });

    await _writeAccounts(accounts);
    return student;
  }

  Future<List<Map<String, dynamic>>> _readAccounts() async {
    final accountsByEmail = <String, Map<String, dynamic>>{};

    try {
      final content = await rootBundle.loadString('accounts/accounts.json');
      _mergeAccountsFromJson(content, accountsByEmail);
    } catch (_) {}

    if (kIsWeb) {
      return accountsByEmail.values.toList();
    }

    for (final file in _accountFileCandidates) {
      try {
        if (!await file.exists()) {
          continue;
        }

        final content = await file.readAsString();
        if (content.trim().isEmpty) {
          continue;
        }

        _mergeAccountsFromJson(content, accountsByEmail);
      } catch (_) {
        continue;
      }
    }

    return accountsByEmail.values.toList();
  }

  void _mergeAccountsFromJson(
    String content,
    Map<String, Map<String, dynamic>> accountsByEmail,
  ) {
    if (content.trim().isEmpty) {
      return;
    }

    final data = jsonDecode(content);
    if (data is Map<String, dynamic>) {
      final accounts = data['accounts'];
      if (accounts is List) {
        final parsedAccounts = accounts
            .whereType<Map>()
            .map((account) => Map<String, dynamic>.from(account))
            .toList();

        for (final account in parsedAccounts) {
          final email = account['email']?.toString().toLowerCase() ?? '';
          if (email.isNotEmpty) {
            accountsByEmail.putIfAbsent(email, () => account);
          }
        }
      }
    }
  }

  Future<void> _writeAccounts(List<Map<String, dynamic>> accounts) async {
    if (kIsWeb) {
      throw Exception(
        'account_storage_failed: Flutter Web cannot write to project JSON files.',
      );
    }

    Object? lastError;

    for (final file in _accountFileCandidates) {
      try {
        final parent = file.parent;
        if (!await parent.exists()) {
          await parent.create(recursive: true);
        }

        const encoder = JsonEncoder.withIndent('  ');
        await file.writeAsString(encoder.convert({'accounts': accounts}));
        return;
      } catch (error) {
        lastError = error;
      }
    }

    throw Exception('account_storage_failed: $lastError');
  }
}
