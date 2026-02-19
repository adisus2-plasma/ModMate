import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class FirestoreAuthService {
  FirestoreAuthService._();
  static final instance = FirestoreAuthService._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');

  String _docIdFromUsername(String username) => username.trim().toLowerCase();

  // ===== Register (แก้ให้ hash/salt ทำใน service) =====
  Future<void> register({
    required String username,
    required String password,
  }) async {
    final docId = _docIdFromUsername(username);
    final ref = _users.doc(docId);

    final exists = await ref.get();
    if (exists.exists) {
      throw Exception("username already exists");
    }

    final salt = _randomSalt();
    final passwordHash = _hashPassword(password: password, salt: salt);

    await ref.set({
      'username': username.trim(),
      'usernameLower': docId,
      'salt': salt,
      'passwordHash': passwordHash,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ===== Login (รองรับ legacy/plaintext + migrate) =====
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final u = username.trim();
    if (u.isEmpty || password.isEmpty) return false;

    final docId = _docIdFromUsername(u);
    final ref = _users.doc(docId);
    final snap = await ref.get();

    if (!snap.exists) return false;

    final data = snap.data()!;
    final salt = (data['salt'] ?? '').toString();
    final savedHash = (data['passwordHash'] ?? '').toString();
    if (savedHash.isEmpty) return false;

    // ✅ CASE 1: ข้อมูลถูกต้อง (มี salt) -> เทียบ hash ปกติ
    if (salt.isNotEmpty) {
      final inputHash = _hashPassword(password: password, salt: salt);
      return inputHash == savedHash;
    }

    // ✅ CASE 2: legacy ที่เคยเก็บ plaintext ไว้ใน passwordHash (เหมือนรูป)
    final legacyOk = (password == savedHash);
    if (!legacyOk) return false;

    // ✅ migrate: สร้าง salt+hash แล้วอัปเดตให้ถูกต้อง (ครั้งต่อไปจะปลอดภัย)
    final newSalt = _randomSalt();
    final newHash = _hashPassword(password: password, salt: newSalt);

    await ref.set({
      'salt': newSalt,
      'passwordHash': newHash,
      'migratedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return true;
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

  // ===== ของเดิมที่เหลือใช้ต่อได้ =====
  Future<void> updateAssessment({
    required String username,
    required String gender,
    required int age,
    required double weightKg,
    required double heightCm,
    required double dailyKcal,
  }) async {
    final docId = _docIdFromUsername(username);
    final ref = _users.doc(docId);

    await ref.set({
      'assessment': {
        'gender': gender,
        'age': age,
        'weightKg': weightKg,
        'heightCm': heightCm,
        'dailyKcal': dailyKcal,
        'updatedAt': FieldValue.serverTimestamp(),
      }
    }, SetOptions(merge: true));
  }

  Future<void> updateMetrics({
    required String username,
    double? bmi,
    double? bmr,
    double? tdee,
  }) async {
    final docId = _docIdFromUsername(username);
    final ref = _users.doc(docId);

    debugPrint('[updateMetrics] ref.path=${ref.path} bmi=$bmi bmr=$bmr tdee=$tdee');

    final data = <String, dynamic>{
      'metrics': {
        if (bmi != null) 'bmi': bmi,
        if (bmr != null) 'bmr': bmr,
        if (tdee != null) 'tdee': tdee,
        'updatedAt': FieldValue.serverTimestamp(),
      }
    };

    await ref.set(data, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getMetrics(String username) async {
    final docId = _docIdFromUsername(username);
    final snap = await _users.doc(docId).get();
    if (!snap.exists) return null;
    final data = snap.data() as Map<String, dynamic>;
    return (data['metrics'] as Map?)?.cast<String, dynamic>();
  }

  Future<Map<String, dynamic>?> getUserDoc(String username) async {
    final docId = _docIdFromUsername(username);
    final snap = await _users.doc(docId).get();
    if (!snap.exists) return null;
    return snap.data();
  }

  Future<void> updateProfileAndMetrics({
    required String username,

    // profile
    String? gender,   // "male" | "female" | ...
    int? age,
    double? weightKg,
    double? heightCm,
    double? dailyKcal, // ถ้ามี

    // metrics
    double? bmi,
    double? bmr,
    double? tdee,

    // optional
    int? activityIndex,
    int? goalIndex,
  }) async {
    final docId = _docIdFromUsername(username);
    final ref = _users.doc(docId);

    debugPrint(
      '[updateProfileAndMetrics] ref.path=${ref.path} '
      'gender=$gender age=$age weightKg=$weightKg heightCm=$heightCm dailyKcal=$dailyKcal '
      'bmi=$bmi bmr=$bmr tdee=$tdee activityIndex=$activityIndex goalIndex=$goalIndex'
    );

    final Map<String, dynamic> data = {};

    // ✅ update profile -> เก็บใน assessment (เหมือนเดิม)
    if (gender != null || age != null || weightKg != null || heightCm != null || dailyKcal != null) {
      data['assessment'] = {
        if (gender != null) 'gender': gender,
        if (age != null) 'age': age,
        if (weightKg != null) 'weightKg': double.parse(weightKg.toStringAsFixed(2)),
        if (heightCm != null) 'heightCm': double.parse(heightCm.toStringAsFixed(2)),
        if (dailyKcal != null) 'dailyKcal': double.parse(dailyKcal.toStringAsFixed(0)),
        'updatedAt': FieldValue.serverTimestamp(),
      };
    }

    // ✅ update metrics -> เก็บใน metrics (ให้ Home/getMetrics อ่านเจอแน่นอน)
    if (bmi != null || bmr != null || tdee != null) {
      data['metrics'] = {
        if (bmi != null) 'bmi': double.parse(bmi.toStringAsFixed(2)),
        if (bmr != null) 'bmr': double.parse(bmr.toStringAsFixed(0)),
        if (tdee != null) 'tdee': double.parse(tdee.toStringAsFixed(0)),
        'updatedAt': FieldValue.serverTimestamp(),
      };
    }

    // ✅ optional: เก็บ preference เพิ่มเติม (จะไว้ที่ root ก็ได้)
    if (activityIndex != null) data['activityIndex'] = activityIndex;
    if (goalIndex != null) data['goalIndex'] = goalIndex;

    // กันกรณีเรียกมาแต่ไม่มี field จะอัปเดต
    if (data.isEmpty) return;

    await ref.set(data, SetOptions(merge: true));
  }

}
