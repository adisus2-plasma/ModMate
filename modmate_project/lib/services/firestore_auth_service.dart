import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class FirestoreAuthService {
  FirestoreAuthService._();
  static final instance = FirestoreAuthService._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  String _docIdFromUsername(String username) => username.trim().toLowerCase();

  // ===== Register =====
  Future<void> register({
    required String username,
    required String password,
  }) async {
    final u = username.trim();
    if (u.isEmpty) throw AuthException('กรุณากรอก username');
    if (u.contains(' ')) throw AuthException('username ห้ามมีช่องว่าง');
    if (u.length < 4) throw AuthException('username ต้องยาวอย่างน้อย 4 ตัว');

    if (password.length < 8) {
      throw AuthException('รหัสผ่านต้องอย่างน้อย 8 ตัวอักษร');
    }

    final docId = _docIdFromUsername(u);
    final ref = _users.doc(docId);
    final snap = await ref.get();

    if (snap.exists) {
      throw AuthException('มี username นี้อยู่แล้ว');
    }

    final salt = _randomSalt();
    final hash = _hashPassword(password: password, salt: salt);

    await ref.set({
      'username': u,
      'usernameLower': docId,
      'salt': salt,
      'passwordHash': hash,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ===== Login =====
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final u = username.trim();
    if (u.isEmpty || password.isEmpty) return false;

    final docId = _docIdFromUsername(u);
    final snap = await _users.doc(docId).get();

    if (!snap.exists) return false;

    final data = snap.data()!;
    final salt = (data['salt'] ?? '').toString();
    final savedHash = (data['passwordHash'] ?? '').toString();
    if (salt.isEmpty || savedHash.isEmpty) return false;

    final inputHash = _hashPassword(password: password, salt: salt);
    return inputHash == savedHash;
  }

  // ===== Helpers =====
  String _randomSalt({int length = 16}) {
    final rnd = Random.secure();
    final bytes = List<int>.generate(length, (_) => rnd.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _hashPassword({required String password, required String salt}) {
    final bytes = utf8.encode('$salt:$password');
    return sha256.convert(bytes).toString();
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
