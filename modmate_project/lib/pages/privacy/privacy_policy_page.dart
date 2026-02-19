import 'package:flutter/material.dart';
import '../assessment/assessment_flow_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final String username; // รับ username จากหน้าก่อน
  const PrivacyPolicyPage({super.key, required this.username});

  static const Color kAccent = Color(0xFFFF7A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ส่วนหัวโค้งตามภาพ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(26),
                  bottomRight: Radius.circular(26),
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                    ),
                  ),

                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, 10)),
                      ],
                    ),
                    child: const Center(
                      child: Image(image: AssetImage("assets/logo.png"), width: 50, height: 50, fit: BoxFit.contain
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    "ความยินยอมเรื่องข้อมูลส่วนบุคคล",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "ModMate ให้ความสำคัญกับข้อมูลส่วนบุคคลของคุณ\nโปรดอ่านรายละเอียดเกี่ยวกับเงื่อนไขการใช้งาน\nและนโยบายด้านความเป็นส่วนตัว",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            // เนื้อหาเลื่อนอ่าน
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                  child: _PolicyBody(),
                ),
              ),
            ),

            // ปุ่มยืนยัน
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AssessmentFlowPage(username: username),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "ฉันได้อ่านและทำความเข้าใจแล้ว",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ],
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

class _PolicyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle h = const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16);
    TextStyle p = TextStyle(color: Colors.white.withOpacity(0.80), fontWeight: FontWeight.w600, height: 1.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("แอปพลิเคชัน ModMate อยู่ภายใต้งานวิจัย", style: p),
        const SizedBox(height: 8),
        Text(
          "“การพัฒนาแอปพลิเคชันให้ความรู้เกี่ยวกับการออกกำลังกายในรูปแบบเวทเทรนนิ่งด้วยตนเอง โดยใช้ร่วมกับเทคโนโลยีความเป็นจริงเสริม (AR)”",
          style: p,
        ),
        const SizedBox(height: 14),
        Text("มีความจำเป็นต้องเก็บ ใช้ และประมวลผลข้อมูลส่วนบุคคลของท่าน", style: p),
        const SizedBox(height: 14),

        Text("วัตถุประสงค์ต่อไปนี้", style: h),
        const SizedBox(height: 10),
        Text("ข้อมูลที่เก็บรวบรวม", style: h),
        const SizedBox(height: 6),
        Text("1. ข้อมูลทั่วไป เช่น เพศ อายุ ส่วนสูง น้ำหนัก", style: p),

        const SizedBox(height: 14),
        Text("วัตถุประสงค์ในการใช้ข้อมูล", style: h),
        const SizedBox(height: 6),
        Text("1. เพื่อให้บริการและแนะนำการออกกำลังกายที่เหมาะสมกับผู้ใช้งาน", style: p),
        Text("2. เพื่อการวิเคราะห์และพัฒนาแอปพลิเคชันให้มีประสิทธิภาพยิ่งขึ้น", style: p),
        Text("3. เพื่อประกอบการทำวิจัยเชิงวิชาการ", style: p),
        const SizedBox(height: 8),
        Text("โดยข้อมูลจะถูกนำเสนอในภาพรวมเชิงสถิติเท่านั้น", style: p),
        Text("โดยไม่เปิดเผยข้อมูลส่วนบุคคลที่สามารถระบุตัวตนได้", style: p),

        const SizedBox(height: 14),
        Text("การเปิดเผยข้อมูล", style: h),
        const SizedBox(height: 6),
        Text("ข้อมูลของท่านอาจถูกเปิดเผย ต่อผู้วิจัยเพื่อการวิเคราะห์ข้อมูล", style: p),

        const SizedBox(height: 14),
        Text("สิทธิของท่าน", style: h),
        const SizedBox(height: 6),
        Text("ท่านมีสิทธิในการ", style: p),
        Text("1. ขอเข้าถึงหรือรับสำเนาข้อมูลของตนเอง", style: p),
        Text("2. ขอแก้ไขข้อมูลให้ถูกต้องและเป็นปัจจุบัน", style: p),
        Text("3. ถอนความยินยอมเมื่อใดก็ได้ (ซึ่งอาจส่งผลต่อการใช้งานของแอปพลิเคชัน)", style: p),

        const SizedBox(height: 18),
        Text("หากมีข้อสงสัย สามารถติดต่อผู้วิจัยได้ที่", style: p),
        const SizedBox(height: 6),
        Text("นางสาว ธมิดา พาหูถิตย์", style: p),
        Text("p.thamida25@gmail.com", style: p),

        const SizedBox(height: 18),
        Divider(color: Colors.white.withOpacity(0.12)),
        const SizedBox(height: 6),
      ],
    );
  }
}
