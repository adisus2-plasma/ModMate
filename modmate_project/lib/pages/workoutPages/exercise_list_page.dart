import 'package:flutter/material.dart';
import 'exercise_detail_page.dart';
import 'exercise_model.dart';
import 'exercise_action_page.dart';

class ExerciseListPage extends StatelessWidget {
  final String bodyPartLabel;
  final String bodyPartKey;

  const ExerciseListPage({
    super.key,
    required this.bodyPartLabel,
    required this.bodyPartKey,
  });

  static const Color bgColor = Color(0xFF070B16);
  static const Color cardColor = Color(0xFF44454F);
  static const Color activeColor = Color(0xFFFF7A12);

  List<ExerciseModel> get allExercises => const [
        ExerciseModel(
          id: 'chest_1',
          bodyPartKey: 'chest',
          title: 'Dumbbell Bench Presses',
          subtitle: 'ท่านอนยกดัมเบลล์',
          imagePath: 'assets/workout_img/chest/chest_1.png',
          description:
              'ท่านี้ช่วยเสริมสร้างกล้ามเนื้อหน้าอก โดยเน้นแรงดันจากหน้าอกและต้นแขน เหมาะสำหรับผู้เริ่มต้นและผู้ที่ต้องการเพิ่มความแข็งแรงของร่างกายส่วนบน',
          steps: [
            'นอนหงายบนม้านั่งราบ วางเท้าแนบบนพื้นเพื่อความมั่นคง',
            'งอข้อศอกแล้วถือดัมเบลล์ในมือทั้งสองข้าง โดยหงายฝ่ามือขึ้นตรงด้านหน้าอก',
            'หายใจเข้าและดันแขนขึ้นในแนวตั้งพร้อมหมุนปลายแขนให้ดัมเบลล์ขึ้นจากน้ำหนัก',
            'หายใจออกเมื่อทำการควบคุมการเคลื่อนไหว',
          ],
          shortDescription:
              'ท่านี้คล้ายท่านอนยกน้ำหนัก\nแต่มีช่วงการเคลื่อนไหวกว้างกว่า\nเน้นยืดกล้ามเนื้อเพคทรอรัลลิส (Pectoralis)',
          muscleImagePath: 'assets/workout_img/chest/detail_chest_1.png',
          targetMuscles: [
            'Pectoralis Major',
            'Triceps brachii',
            'Anterior Deltoids',
            'Anconeus',
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
            'Bench (ม้านั่ง)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png',
            'assets/workout_img/bench.png',
          ],
          videoUrl: 'https://www.youtube.com/watch?v=VmB1G1K7v94',
          arModelPath: '',

        ),
        ExerciseModel(
          id: 'chest_2',
          bodyPartKey: 'chest',
          title: 'Dumbbell Flys',
          subtitle: 'ท่านอนกางแขนยกดัมเบลล์',
          imagePath: 'assets/workout_img/chest/chest_2.png',
          description:
              'ท่านี้ช่วยเสริมสร้างกล้ามเนื้อหน้าอก โดยเน้นแรงดันจากหน้าอกและต้นแขน เหมาะสำหรับผู้เริ่มต้นและผู้ที่ต้องการเพิ่มความแข็งแรงของร่างกายส่วนบน',
          steps: [
            'นอนหงายบนม้านั่งที่เรียบและแคบเพื่อให้หัวไหล่ขยับได้ขณะฝึก',
            'ถือดัมเบลล์ในมือทั้งสองข้างโดยหงายฝ่ามือ ยืดแขนขึ้นตรง หรืออาจงอข้อศอกเล็กน้อยเพื่อบรรเทาความตึงที่ข้อศอก',
            'หายใจเข้าและกางแขนออกจนอยู่ในแนวขนานกับพื้น',
            'จากนั้นยกแขนกลับขึ้นมาในตำแหน่งเดิมขณะที่หายใจออก',
          ],
          shortDescription:
              'ท่านี้เน้นกล้ามเนื้อเพคทอราลิส เมเจอร์\n(Pectoralis Major) ช่วยเพิ่มความจุปอดและเสริมความยืดหยุ่นของกล้ามเนื้อ',
          muscleImagePath: 'assets/workout_img/chest/detail_chest_2.png',
          targetMuscles: [
            'Pectoralis Major',
            'Biceps brachii',
            'Anterior Deltoids',
            'Anconeus',
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
            'Bench (ม้านั่ง)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png',
            'assets/workout_img/bench.png',
          ],
          videoUrl: 'https://www.youtube.com/watch?v=eozdVDA78K0',
          arModelPath: '',
        ),
        ExerciseModel(
          id: 'shoulder_1',
          bodyPartKey: 'shoulder',
          title: 'Dumbbell Shoulder Press',
          subtitle: 'ท่านนั่งยกดัมเบลล์',
          imagePath: 'assets/workout_img/shoulder/shoulder_1.png',
          description:
              'การฝึกกล้ามเนื้อไหล่ช่วยเพิ่มความแข็งแกร่งและความสมดุลให้กับไหล่ส่วนต่าง ๆ ช่วยให้การเคลื่อนไหวราบรื่น',
          steps: [
            'นั่งบนม้านั่งโดยรักษาหลังให้ตรง',
            'ถือดัมเบลล์ในมือทั้งสองข้างด้วยท่าหงายมือที่ระดับไหล่ (หัวแม่มือหันเข้าหากัน)',
            'หายใจเข้าแล้วดันแขนขึ้นตรง ๆ',
            'หายใจออกเมื่อดันแขนขึ้นสุด สามารถทำท่านี้ได้ในขณะยืนด้วย',
          ],
          shortDescription:
              'ท่านี้เน้นกล้ามเนื้อเดลทอยด์ (Deltoid)\n สามารถทำได้ทั้งท่านั่ง ยืน หรือสลับยกทีละข้าง\n โดยหากมีพนักพิงจะช่วยป้องกันการโค้งงอของหลัง',
          muscleImagePath: 'assets/workout_img/shoulder/detail_shoulder_1.png',
          targetMuscles: [
            'Deltoids',
            'Triceps brachii',
            'Serratus anterior',
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
            'Bench (ม้านั่ง)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png',
            'assets/workout_img/bench.png',
          ],
          videoUrl: 'assets/workout_vdo/shoulder_press.mp4',
          arModelPath: 'assets/workout_ar_model/shoulder_press.usdz',

        ),
        ExerciseModel(
          id: 'back_1',
          bodyPartKey: 'back',
          title: 'Dumbbell Rows',
          subtitle: 'ท่าโน้มตัวยกดัมเบลล์',
          imagePath: 'assets/workout_img/back/back_1.png',
          description:
              'การฝึกกล้ามเนื้อหลังช่วยเสริมความแข็งแกร่งให้กับร่างกายส่วนบนและช่วยปรับท่าทางในการยกของหนักและการเคลื่อนไหว',
          steps: [
            'ยืนโดยงอเข่าเล็กน้อยและโน้มตัวไปข้างหน้า 45 องศา',
            'รักษาหลังให้ตรงและปล่อยแขนห้อยลงข้างลำตัว',
            'ถือดัมเบลล์ในมือทั้งสองข้างโดยฝ่ามือหันเข้าหากัน',
            'หายใจเข้าแล้วดึงดัมเบลล์ขึ้นให้สูงที่สุด พร้อมกับดึงข้อศอกเข้าหาลำตัวและกระดูกสะบักให้เข้าหากัน ',
            'เมื่อถึงจุดสูงสุดให้ลดแขนลงกลับสู่ตำแหน่งเริ่มต้นและหายใจออก'
          ],
          shortDescription:
              'โน้มตัวเล็กน้อย ลำตัวตั้งตรง จะเน้นทราพีเซียสส่วนบน (Upper Trapezius) แต่ถ้าโน้มตัวมาก ลำตัวขนานพื้นจะเน้นทราพีเซียสส่วนกลางและล่าง(Middle & Lower Trapezius)',
          muscleImagePath: 'assets/workout_img/back/detail_back_1.png',
          targetMuscles: [
            'Latissimus Dorsi',
            'Teres major',
            'Posterior deltoid',
            'Biceps brachii',
            'Trapezius',
            'Brachioradialis'
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
            'Bench (ม้านั่ง)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png',
            'assets/workout_img/bench.png',
          ],
          videoUrl: 'https://www.youtube.com/watch?v=pYcpY20QaE8',
          arModelPath: '',
        ),
        ExerciseModel(
          id: 'back_2',
          bodyPartKey: 'back',
          title: 'Lat Pull-downs',
          subtitle: 'ท่าดึงลงด้านหน้าแบบกางแขน',
          imagePath: 'assets/workout_img/back/back_2.png',
          description:
              'การฝึกกล้ามเนื้อหลังช่วยเสริมความแข็งแกร่งให้กับร่างกายส่วนบนและช่วยปรับท่าทางในการยกของหนักและการเคลื่อนไหว',
          steps: [
            'นั่งหันหน้าเข้าหาอุปกรณ์และสอดขาไว้ใต้ล็อก',
            'จับบาร์ด้วยท่าคว่ำมือ โดยให้มือสองข้างห่างกันพอประมาณ',
            'หายใจเข้าแล้วดึงบาร์ลงโดยยืดอกและดึงข้อศอกไปด้านหลังพร้อมกัน',
            'เมื่อทำท่าครบให้หายใจออก',
          ],
          shortDescription:
              'ท่านี้ช่วยเสริมความหนาของแผ่นหลัง โดยเน้นกล้ามเนื้อแลทิสซิมัสดอร์ไซส่วนบนและกลาง(Latissimus Dorsi) ',
          muscleImagePath: 'assets/workout_img/back/detail_back_2.png',
          targetMuscles: [
            'Latissimus Dorsi',
            'Trapezius',
            'Rhomboid',
            'Biceps brachii',
            'Brachialis',
            'Pectorals'
          ],
          equipments: [
            'Lat pulldown Machine (เครื่องดึงหลัง)',
          ],
          equipmentImages: [
            'assets/workout_img/latpulldown_machine.png'
          ],
          videoUrl: 'https://www.youtube.com/watch?v=eozdVDA78K0',
          arModelPath: '',
        ),
        ExerciseModel(
          id: 'leg_1',
          bodyPartKey: 'leg',
          title: 'Dumbbell Squat',
          subtitle: 'ท่าสควอทกับดัมเบลล์',
          imagePath: 'assets/workout_img/leg/leg_1.png',
          description:
              'การฝึกกล้ามเนื้อขาช่วยเสริมสร้างความแข็งแกร่งของขาและสะโพก รวมถึงช่วยพัฒนาความสมดุลและความยืดหยุ่น',
          steps: [
            'ยืนวางขาห่างกันเล็กน้อยถือดัมเบลล์ในมือข้างละอัน',
            'ผ่อนคลายกล้ามเนื้อเเขน มองตรงข้างหน้า',
            'หายใจเข้าโก่งหลังเล็กน้อย ย่อเข่าลง',
            'เมื่อต้นขาอยู่เเนวระนาบขนานกับพื้นให้ยืดขา กลับไปสู่ตำเเหน่งเริ่มต้น',
            'หายใจออกเมื่อสิ้นสุดการเคลื่อนไหว'
          ],
          shortDescription:
              'ท่านี้ช่วยเสริมความหนาของแผ่นหลัง โดยเน้นกล้ามเนื้อแลทิสซิมัสดอร์ไซส่วนบนและกลาง(Latissimus Dorsi) ',
          muscleImagePath: 'assets/workout_img/leg/detail_leg_1.png',
          targetMuscles: [
            'Quadriceps',
            'Glutes medius',
            'Glutes maximus',
            'Fascia lata'
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png'
          ],
          videoUrl: 'https://www.youtube.com/watch?v=aclHkVaku9U',
          arModelPath: '',
        ),
        ExerciseModel(
          id: 'leg_2',
          bodyPartKey: 'leg',
          title: 'Dumbbell Lunges',
          subtitle: 'ท่าเเทงขาลุกนั่งกับดัมเบลล์',
          imagePath: 'assets/workout_img/leg/leg_2.png',
          description:
              'การฝึกกล้ามเนื้อขาช่วยเสริมสร้างความแข็งแกร่งของขาและสะโพก รวมถึงช่วยพัฒนาความสมดุลและความยืดหยุ่น',
          steps: [
            'ยืนเท้าห่างกันเล็กน้อย ถือดัมเบลล์ไว้ที่มือคนละข้าง',
            'หายใจเข้าเเละก้าวเท้าไปข้างหน้า 1 ก้าวใหญ่ พยายามตั้งตัวให้ตรงที่สุดเท่าที่ทำได้',
            'เมื่อต้นขาของขาที่ก้าวไปข้างหน้าอยู่ในเเนวระนาบขนานกับพื้นหรือต่ำกว่าเล็กน้อยให้กลับสู่ตำเเหน่งเริ่มต้น'
          ],
          shortDescription:
              'ท่าแทงขา (Lunge) ต้องใช้ขาหน้ารับน้ำหนักและอาศัยสมดุล ควรใช้ดัมเบลล์น้ำหนักเบาเพื่อป้องกันการบาดเจ็บที่เข่า ',
          muscleImagePath: 'assets/workout_img/leg/detail_leg_2.png',
          targetMuscles: [
            'Quadriceps',
            'Glutes maximus',
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png'
          ],
          videoUrl: 'https://www.youtube.com/watch?v=QOVaHwm-Q6U',
          arModelPath: '',
        ),
        ExerciseModel(
          id: 'core_1',
          bodyPartKey: 'core',
          title: 'Dumbbell Side Bends',
          subtitle: 'ท่าเอียงลำตัวกับดัมเบลล์',
          imagePath: 'assets/workout_img/core/core_1.png',
          description:
              'เสริมความแข็งแกร่งให้กับกล้ามเนื้อแกนกลางลำตัวเพื่อการเคลื่อนไหวที่มั่นคง',
          steps: [
            'ยืนกางขาเล็กน้อย มือข้างหนึ่งอยู่หลังใบหู อีกข้างถือดัมเบลล์',
            'เอียงตัวไปด้านข้างตรงข้ามกับข้างที่ถือดัมเบลล์',
            'กลับสู่ตำเเหน่งเริ่มต้นหรือเลยไปตำเเหน่งเริ่มต้นไปอีกด้านด้วยการงอตามธรรมชาติของลำตัว',
            'ทำซ้ำเป็นชุดโดยสลับข้างที่ถือดัมเบลล์เมื่อขึ้นชุดใหม่ โดยไม่มีการหยุดพัก'
          ],
          shortDescription:
              'ท่านี้ช่วยเน้นการบริหารกล้ามเนื้อออบลีก (Obliques) บริเวณด้านข้างลำตัว พร้อมทั้งเสริมการทำงานของกล้ามเนื้อเร็กตัส แอบโดมินิส (Rectus abdominis)',
          muscleImagePath: 'assets/workout_img/core/detail_core_1.png',
          targetMuscles: [
            'External Obliques',
            'Internal Obliques',
            'Retus abdominis',
            'Pyramidalis'
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png'
          ],
          videoUrl: 'https://www.youtube.com/watch?v=ZJXj8tqQGgk',
          arModelPath: '',
        ),
        ExerciseModel(
          id: 'arm_1',
          bodyPartKey: 'arm',
          title: 'Dumbbell Curl',
          subtitle: 'ท่าม้วนข้อด้วยดัมเบลล์',
          imagePath: 'assets/workout_img/arm/arm_1.png',
          description:
              'การฝึกกล้ามเนื้อแขนช่วยเสริมสร้างความแข็งแกร่งของแขนทั้งสองข้าง และพัฒนาความสมดุลในการเคลื่อนไหว',
          steps: [
            'นั่งบนเก้าอี้ ถือดัมเบลล์ในมือทั้งสองข้าง ปล่อยแขนลงตรง ๆ โดยหันฝ่ามือเข้าหาลำตัว',
            'หายใจเข้าและงอข้อศอกเพื่อยกท่อนแขนขึ้น พร้อมกับหมุนข้อมือให้ฝ่ามือพลิกหงายจนท่อนแขนยกถึงแนวราบ',
            'เมื่อข้อศอกงอจนสุดแล้ว ให้กลับมาตำแหน่งเดิม',
          ],
          shortDescription:
              'ท่านี้ช่วยบริหารกล้ามเนื้อไบเซ็ปส์ (Biceps) ครบทุกช่วงการทำงานทั้งงอ เหยียด และบิดหงายมือ',
          muscleImagePath: 'assets/workout_img/arm/detail_arm_1.png',
          targetMuscles: [
            'Biceps Brachii',
            'Brachialis',
            'Anterior Deltoids',
            'Brachioradialis'
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png'
          ],
          videoUrl: 'https://www.youtube.com/watch?v=ykJmrZ5v0Oo',
          arModelPath: '',
        ),
        ExerciseModel(
          id: 'arm_2',
          bodyPartKey: 'arm',
          title: 'Hammer Curl',
          subtitle: 'ท่าม้วนข้อด้วยวิธีจับแบบถือค้อน',
          imagePath: 'assets/workout_img/arm/arm_2.png',
          description:
              'การฝึกกล้ามเนื้อแขนช่วยเสริมสร้างความแข็งแกร่งของแขนทั้งสองข้าง และพัฒนาความสมดุลในการเคลื่อนไหว',
          steps: [
            'อยู่ในท่านั่งหรือยืน มือทั้งสองข้างถือดัมเบลล์ โดยหันฝ่ามือเข้าหากัน',
            'หายใจเข้าและงอข้อศอกเพื่อยกท่อนแขนขึ้นพร้อมกันทั้งสองข้าง หรือจะยกทีละข้างก็ได้',
            'หายใจออกเมื่อยกท่อนแขนขึ้นสุด'
          ],
          shortDescription:
              'ท่านี้เป็นการออกกำลังกายที่เหมาะที่สุดสำหรับการพัฒนากล้ามเนื้อเบรคิโอเรเดียลิส (Brachioradialis) และไบเซ็ปส์เบรคิไอ (Biceps Brachii)',
          muscleImagePath: 'assets/workout_img/arm/detail_arm_2.png',
          targetMuscles: [
            'Brachioradialis',
            'Biceps brachii',
            'Brachilais'
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png'
          ],
          videoUrl: 'https://www.youtube.com/watch?v=zC3nLlEvin4',
          arModelPath: '',
        ),
        ExerciseModel(
          id: 'arm_3',
          bodyPartKey: 'arm',
          title: 'Seated Dumbbell Triceps Extensions',
          subtitle: 'ท่ายืดกล้ามเนื้อหลังแขนด้วยดัมเบลล์ขณะนั่ง',
          imagePath: 'assets/workout_img/arm/arm_3.png',
          description:
              'การฝึกกล้ามเนื้อแขนช่วยเสริมสร้างความแข็งแกร่งของแขนทั้งสองข้าง และพัฒนาความสมดุลในการเคลื่อนไหว',
          steps: [
            'นั่งบนเก้าอี้ ใช้มือทั้งสองข้างประคองดัมเบลล์ไว้ที่ด้านหลังศีรษะ',
            'หายใจเข้าแล้วเหยียดแขนขึ้นให้ตรง',
            'หายใจออกเมื่อแขนเหยียดเต็มที่'
          ],
          shortDescription:
              'เส้นใยกล้ามเนื้อไตรเซ็ปส์ (Triceps) ทั้งสามมัดยึดกับเอ็นร่วมที่ต่อกับโอเลครานอน (Olecranon) เมื่อหดตัว เอ็นจะดึงกล้ามเนื้อทั้งสามมัดให้โป่งนูนเห็นเด่นชัดเป็นรูปคล้ายเกือกม้า',
          muscleImagePath: 'assets/workout_img/arm/detail_arm_3.png',
          targetMuscles: [
            'Triceps Brachii',
            'Anconeus'
          ],
          equipments: [
            'Dumbbell (ดัมเบล)',
          ],
          equipmentImages: [
            'assets/workout_img/dumbell.png'
          ],
          videoUrl: 'https://www.youtube.com/watch?v=YbX7Wd8jQ-Q',
          arModelPath: '',
        ),
      ];

  List<ExerciseModel> get filteredExercises =>
      allExercises.where((e) => e.bodyPartKey == bodyPartKey).toList();

  String get descriptionText {
    switch (bodyPartKey) {
      case 'chest':
        return 'การฝึกกล้ามเนื้อหน้าอก\nจะช่วยเสริมสร้างความแข็งแรงในส่วนบนของร่างกาย\nรวมถึงยังช่วยเพิ่มขนาดและการกระชับของอก';
      case 'shoulder':
        return 'การฝึกกล้ามเนื้อไหล่\nช่วยเพิ่มความแข็งแรงและความมั่นคงของหัวไหล่\nเหมาะสำหรับการเคลื่อนไหวในชีวิตประจำวัน';
      case 'arm':
        return 'การฝึกกล้ามเนื้อแขน\nช่วยให้แขนแข็งแรง กระชับ และใช้งานได้ดีขึ้น\nทั้งการผลัก การดึง และการยกของ';
      case 'back':
        return 'การฝึกกล้ามเนื้อหลัง\nช่วยเสริมบุคลิกภาพและความแข็งแรงของร่างกาย\nพร้อมลดความเสี่ยงจากอาการปวดหลัง';
      case 'leg':
        return 'การฝึกกล้ามเนื้อขา\nช่วยเพิ่มกำลังในการเดิน ยืน และทรงตัว\nรวมถึงช่วยเสริมความแข็งแรงของร่างกายส่วนล่าง';
      case 'core':
        return 'การฝึกแกนกลางลำตัว\nช่วยให้ร่างกายมั่นคงมากขึ้น\nและช่วยพยุงการเคลื่อนไหวของทุกส่วน';
      default:
        return '';
    }
  }

  String get titleText {
    switch (bodyPartKey) {
      case 'chest':
        return 'Chest (อก)';
      case 'shoulder':
        return 'Shoulder (ไหล่)';
      case 'arm':
        return 'Arm (แขน)';
      case 'back':
        return 'Back (หลัง)';
      case 'leg':
        return 'Leg (ขา)';
      case 'core':
        return 'Core (แกนกลางลำตัว)';
      default:
        return bodyPartLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercises = filteredExercises;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                titleText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                descriptionText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.separated(
                  itemCount: exercises.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return _ExerciseCard(
                      index: index,
                      exercise: exercise,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExerciseActionPage(
                              exercise: exercise,
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
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final int index;
  final ExerciseModel exercise;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.index,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF44454F),
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  exercise.imagePath,
                  width: 108,
                  height: 108,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ท่าที่ ${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFFFF7A12),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      exercise.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      exercise.subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white70,
                size: 38,
              ),
            ],
          ),
        ),
      ),
    );
  }
}