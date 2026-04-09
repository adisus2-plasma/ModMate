import 'package:flutter/material.dart';
import 'tip_data.dart'; // อย่าลืม import ไฟล์ข้อมูลของคุณ

class TipDetailPage extends StatelessWidget {
  final TipItem item;

  const TipDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังสีดำตามรูป
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ส่วนบน: รูปภาพ + ปุ่มย้อนกลับ + Tag + Card ชื่อเรื่อง
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Hero(
                  tag: 'tip_image_${item.id}', 
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // 1. รูปภาพด้านหลัง
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(item.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // เพิ่ม Gradient ทับรูปเพื่อให้เห็น Text สีขาวชัดขึ้น
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. ปุ่มย้อนกลับ และ Tag ด้านบน
                Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.white, size: 35),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        item.tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48), // เพื่อให้ตัวหนังสือ Tag อยู่กลางพอดี
                    ],
                  ),
                ),

                // 3. Card สีดำที่ลอยทับรูปภาพ
                Positioned(
                  bottom: -60, // ให้เยื้องลงมาข้างล่างรูป
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A), // สีเทาเข้มเกือบดำ
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          item.tag,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ระยะห่างหลัง Card ลอย
            const SizedBox(height: 80),

            // ส่วนที่ 4: เนื้อหา (Content)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    item.content ?? "",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.6, // ระยะห่างระหว่างบรรทัด
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}