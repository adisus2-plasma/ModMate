import 'package:flutter/material.dart';
import 'tip_data.dart';
import 'tip_detail_page.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  // ===== Theme (ตามภาพ) =====
  static const Color kBg = Colors.black;
  static const Color kCard = Color(0xFF23242A);
  static const Color kBorder = Color(0xFF3A3B40);
  static const Color kTextDim = Color(0xFFB7B7B7);

  @override
  Widget build(BuildContext context) {
    final items = kTips;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Top bar (back only) =====
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),

            // ===== Header =====
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Text(
                "Tips",
                style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Text(
                "เทคนิคเล็ก ๆ ที่จะทำให้คุณพัฒนาการรับประทานอาหาร\nและการออกกำลังกายให้มีประสิทธิภาพมากขึ้น",
                style: TextStyle(color: kTextDim, fontWeight: FontWeight.w700, height: 1.35),
              ),
            ),

            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: Text(
                "Tips ทั้งหมด",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),

            // ===== List =====
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final t = items[index];
                  return _TipListTile(
                    tag: t.tag,
                    title: t.title,
                    imagePath: t.imagePath,
                    onTap: () {
                      // TODO: ถ้าต้องการเปิดรายละเอียด tip ให้ทำหน้า detail แล้ว navigate ตรงนี้
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TipDetailPage(
                            item: t
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== Models =====================

class _TipItem {
  final String tag;
  final String title;
  final String imagePath;
  const _TipItem({required this.tag, required this.title, required this.imagePath});
}

// ===================== Tile =====================

class _TipListTile extends StatelessWidget {
  final String tag;
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _TipListTile({
    required this.tag,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  static const Color kCard = Color(0xFF23242A);
  static const Color kBorder = Color(0xFF3A3B40);
  static const Color kTextDim = Color(0xFFB7B7B7);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 96,
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: kBorder),
          boxShadow: const [
            BoxShadow(color: Color(0x24000000), blurRadius: 18, offset: Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            // Left text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tag,
                    style: const TextStyle(color: kTextDim, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Right image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 86,
                height: 68,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.white10,
                    child: const Center(
                      child: Icon(Icons.image_outlined, color: Colors.white24),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
