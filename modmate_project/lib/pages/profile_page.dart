import 'package:flutter/material.dart';
import 'login_page.dart';
import '../services/firestore_auth_service.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color kBg = Colors.black;
  static const Color kCard = Color(0xFF1A1B20);
  static const Color kAccent = Color(0xFFFF7A1A);
  static const Color kTextDim = Color(0xFFB7B7B7);
  static const Color kBorder = Color(0xFF2A2B30);
  String? coverUrl;

  // Profile data (โหลดจาก assessment)
  String genderText = "-";
  int? age;
  double? weightKg;
  double? heightCm;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await FirestoreAuthService.instance.getUserDoc(widget.username);
    if (!mounted || data == null) return;

    final assessment = (data['assessment'] as Map?)?.cast<String, dynamic>();
    final g = (assessment?['gender'] ?? '').toString();

    final profile = (data['profile'] as Map?)?.cast<String, dynamic>();
    final cUrl = (profile?['coverUrl'] ?? '').toString().trim();

    setState(() {
      genderText = _genderToText(g);
      age = (assessment?['age'] as num?)?.toInt();
      weightKg = (assessment?['weightKg'] as num?)?.toDouble();
      heightCm = (assessment?['heightCm'] as num?)?.toDouble();

      coverUrl = cUrl.isEmpty ? null : cUrl; // ✅ รูปปก
    });
  }

  String _genderToText(String g) {
    switch (g) {
      case 'male':
        return '♂';
      case 'female':
        return '♀';
      case 'other':
        return '⚧';
      case 'preferNot':
      default:
        return '–';
    }
  }

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => const _LogoutDialog(),
    ).then((result) {
      if (result == true) _logout();
    });
  }

  void _logout() {
    // ถ้ามีระบบ keep signed in / token ให้ clear ตรงนี้ด้วย
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage(username: AutofillHints.username)),
      (route) => false,
    );
  }

  Widget _coverImage() {
    if (coverUrl != null) {
      return Image.network(
        coverUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          "assets/onboarding_bg_1.png",
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      "assets/onboarding_bg_1.png", // ✅ default cover
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(color: const Color(0xFF121318)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // ===== Cover image =====
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                        ),
                        child: SizedBox(
                          height: 210,
                          width: double.infinity,
                          child: _coverImage(),
                        ),
                      ),

                      // back button
                      Positioned(
                        left: 8,
                        top: 6,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 34),
                        ),
                      ),

                      // avatar (ซ้อนลงมา)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF1E1F24),
                                  border: Border.all(color: kAccent, width: 3),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 44,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ===== Name & gender =====
                  Text(
                    widget.username,
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    genderText,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                  ),

                  const SizedBox(height: 22),

                  // ===== Stats row =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatTile(
                          icon: Icons.person_outline,
                          value: age?.toString() ?? "-",
                          unit: "ปี",
                        ),
                        _StatTile(
                          icon: Icons.monitor_weight_outlined,
                          value: weightKg == null ? "-" : weightKg!.toStringAsFixed(0),
                          unit: "กิโลกรัม",
                        ),
                        _StatTile(
                          icon: Icons.height,
                          value: heightCm == null ? "-" : heightCm!.toStringAsFixed(0),
                          unit: "เซนติเมตร",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== Logout button =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: InkWell(
                      onTap: _showLogoutDialog,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B1208),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: kAccent),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                "ออกจากระบบ",
                                style: TextStyle(color: kAccent, fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            ),
                            Icon(Icons.logout, color: kAccent),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),

                  // ===== bottom logo =====
                  Column(
                    children: [
                      Image.asset(
                        "assets/logo_small.png",
                        width: 54,
                        height: 34,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox(height: 34),
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        "assets/logo.png", // ใส่รูปจริงทีหลัง
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "ModMate",
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String unit;

  const _StatTile({
    required this.icon,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(unit, style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "คุณต้องการออกจากระบบ\nใช่หรือไม่",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "ออกจากระบบ",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B5C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF3B5C)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  foregroundColor: const Color(0xFFFF3B5C),
                ),
                child: const Text(
                  "ยังไม่ต้องการออกจากระบบ",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
