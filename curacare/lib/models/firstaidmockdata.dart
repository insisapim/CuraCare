import 'package:curacare/models/firstaiddata.dart';

final List<FirstaidData> mockFirstaidList = [
  /// ===================== CPR =====================
  FirstaidData(
    title: "การกู้ชีพ (CPR)",
    description: "การกู้ชีพสำหรับภาวะหัวใจหยุดเต้น",
    sections: [
      FirstaidSection(
        title: "ขั้นตอนการปฏิบัติ",
        type: FirstaidSectionType.step,
        items: [
          FirstaidStep(order: 1, text: "โทรเรียกบริการฉุกเฉิน (1669) ทันที"),
          FirstaidStep(order: 2, text: "วางผู้ป่วยนอนหงายบนพื้นแข็ง"),
          FirstaidStep(order: 3, text: "คุกเข่าข้างหน้าอกผู้ป่วย"),
          FirstaidStep(
            order: 4,
            text: "วางส้นมือข้างหนึ่งตรงกลางหน้าอก วางมืออีกข้างซ้อนทับ",
          ),
          FirstaidStep(
            order: 5,
            text: "กดหน้าอกลึกประมาณ 5 ซม. ความเร็ว 100–120 ครั้ง/นาที",
          ),
          FirstaidStep(
            order: 6,
            text: "กดหน้าอก 30 ครั้ง แล้วช่วยหายใจ 2 ครั้ง",
          ),
          FirstaidStep(order: 7, text: "เงยหน้าผู้ป่วย บีบจมูก เป่าลมเข้าปาก"),
          FirstaidStep(order: 8, text: "ทำซ้ำจนกว่าความช่วยเหลือจะมาถึง"),
        ],
      ),
      FirstaidSection(
        title: "คำเตือนสำคัญ",
        type: FirstaidSectionType.warning,
        items: [
          FirstaidWarn(text: "ทำเฉพาะเมื่อผู้ป่วยหมดสติและไม่หายใจ"),
          FirstaidWarn(text: "อย่าหยุดกดหน้าอกนานเกิน 10 วินาที"),
        ],
      ),
    ],
  ),

  /// ===================== แผลไฟไหม้ =====================
  FirstaidData(
    title: "แผลไฟไหม้",
    description: "การรักษาแผลไฟไหม้และน้ำร้อนลวก",
    sections: [
      FirstaidSection(
        title: "ขั้นตอนการปฏิบัติ",
        type: FirstaidSectionType.step,
        items: [
          FirstaidStep(order: 1, text: "นำผู้ป่วยออกจากแหล่งความร้อน"),
          FirstaidStep(
            order: 2,
            text: "ล้างแผลด้วยน้ำเย็นไหลผ่านอย่างน้อย 20 นาที",
          ),
          FirstaidStep(
            order: 3,
            text: "ถอดเครื่องประดับหรือเสื้อผ้าที่รัดใกล้แผล",
          ),
          FirstaidStep(order: 4, text: "ปิดแผลด้วยผ้าสะอาดที่ไม่ติดแผล"),
          FirstaidStep(order: 5, text: "ทายาแก้ปวดถ้าจำเป็น"),
          FirstaidStep(order: 6, text: "พบแพทย์หากแผลไฟไหม้รุนแรง"),
        ],
      ),
      FirstaidSection(
        title: "คำเตือนสำคัญ",
        type: FirstaidSectionType.warning,
        items: [
          FirstaidWarn(text: "อย่าทาน้ำมัน เนย หรือครีมทาแผลไฟไหม้"),
          FirstaidWarn(text: "อย่าเจาะตุ่มพอง"),
          FirstaidWarn(text: "หากแผลใหญ่กว่า 3 นิ้ว ให้พบแพทย์"),
        ],
      ),
    ],
  ),

  /// ===================== สำลัก =====================
  FirstaidData(
    title: "สำลัก",
    description: "วิธี Heimlich สำหรับทางเดินหายใจอุดตัน",
    sections: [
      FirstaidSection(
        title: "ขั้นตอนการปฏิบัติ",
        type: FirstaidSectionType.step,
        items: [
          FirstaidStep(
            order: 1,
            text:
                "ถามว่าผู้ป่วยสำลักหรือไม่ ถ้าตอบไม่ได้ โทรขอความช่วยเหลือทันที",
          ),
          FirstaidStep(order: 2, text: "ยืนด้านหลังผู้ป่วย โอบแขนรอบเอว"),
          FirstaidStep(
            order: 3,
            text: "กำมือข้างหนึ่ง วางเหนือสะดือใต้ลิ้นปี่",
          ),
          FirstaidStep(order: 4, text: "จับกำปั้นด้วยมืออีกข้าง"),
          FirstaidStep(order: 5, text: "ดันเข้าด้านในและขึ้นอย่างรวดเร็ว"),
          FirstaidStep(
            order: 6,
            text: "ทำซ้ำจนสิ่งแปลกปลอมหลุดหรือผู้ป่วยหมดสติ",
          ),
          FirstaidStep(order: 7, text: "ถ้าผู้ป่วยหมดสติ ให้ทำ CPR"),
        ],
      ),
      FirstaidSection(
        title: "คำเตือนสำคัญ",
        type: FirstaidSectionType.warning,
        items: [
          FirstaidWarn(text: "สำหรับทารก ใช้วิธีตบหลังและกดหน้าอกแทน"),
          FirstaidWarn(text: "โทร 1669 หากไม่สามารถเอาสิ่งแปลกปลอมออกได้"),
        ],
      ),
    ],
  ),

  /// ===================== เลือดออกฉุกเฉิน =====================
  FirstaidData(
    title: "เลือดออกฉุกเฉิน",
    description: "การควบคุมเลือดที่ออกมาก",
    sections: [
      FirstaidSection(
        title: "ขั้นตอนการปฏิบัติ",
        type: FirstaidSectionType.step,
        items: [
          FirstaidStep(order: 1, text: "โทรเรียกบริการฉุกเฉิน"),
          FirstaidStep(order: 2, text: "ล้างมือหรือสวมถุงมือ"),
          FirstaidStep(order: 3, text: "กดแผลโดยตรงด้วยผ้าสะอาด"),
          FirstaidStep(order: 4, text: "กดอย่างสม่ำเสมออย่างน้อย 15 นาที"),
          FirstaidStep(order: 5, text: "ถ้าเลือดไม่หยุด ให้เพิ่มผ้ากดทับ"),
          FirstaidStep(order: 6, text: "ยกแผลให้สูงกว่าหัวใจถ้าเป็นไปได้"),
          FirstaidStep(
            order: 7,
            text: "ใช้สายรัดเฉพาะเมื่อเลือดออกมากและควบคุมไม่ได้",
          ),
        ],
      ),
      FirstaidSection(
        title: "คำเตือนสำคัญ",
        type: FirstaidSectionType.warning,
        items: [
          FirstaidWarn(text: "อย่านำสิ่งแปลกปลอมที่ฝังอยู่ออก"),
          FirstaidWarn(text: "อย่าปล่อยแผลจนกว่าเลือดจะหยุด"),
        ],
      ),
    ],
  ),

  /// ===================== ช็อก =====================
  FirstaidData(
    title: "ช็อก",
    description: "การรับรู้และรักษาอาการช็อก",
    sections: [
      FirstaidSection(
        title: "ขั้นตอนการปฏิบัติ",
        type: FirstaidSectionType.step,
        items: [
          FirstaidStep(order: 1, text: "โทรเรียกบริการฉุกเฉินทันที"),
          FirstaidStep(order: 2, text: "ให้ผู้ป่วยนอนหงาย"),
          FirstaidStep(
            order: 3,
            text: "ยกขาสูงประมาณ 30 ซม. ถ้าไม่มีการบาดเจ็บ",
          ),
          FirstaidStep(order: 4, text: "คลุมผ้าห่มเพื่อรักษาอุณหภูมิร่างกาย"),
          FirstaidStep(order: 5, text: "ห้ามให้อาหารหรือเครื่องดื่ม"),
          FirstaidStep(order: 6, text: "สังเกตการหายใจและความรู้สึกตัว"),
          FirstaidStep(order: 7, text: "ทำ CPR หากผู้ป่วยหยุดหายใจ"),
        ],
      ),
      FirstaidSection(
        title: "คำเตือนสำคัญ",
        type: FirstaidSectionType.warning,
        items: [
          FirstaidWarn(text: "สัญญาณช็อก: ตัวซีด หายใจเร็ว อ่อนแรง"),
          FirstaidWarn(text: "แม้ผู้ป่วยดูดีขึ้น ควรพบแพทย์"),
        ],
      ),
    ],
  ),

  /// ===================== พิษ =====================
  FirstaidData(
    title: "พิษ",
    description: "การตอบสนองต่อเหตุฉุกเฉินจากสารพิษ",
    sections: [
      FirstaidSection(
        title: "ขั้นตอนการปฏิบัติ",
        type: FirstaidSectionType.step,
        items: [
          FirstaidStep(order: 1, text: "โทรศูนย์พิษวิทยาทันที (1367)"),
          FirstaidStep(order: 2, text: "พยายามระบุชนิดและปริมาณสารพิษ"),
          FirstaidStep(order: 3, text: "อย่าทำให้อาเจียนเว้นแต่แพทย์สั่ง"),
          FirstaidStep(
            order: 4,
            text: "ถ้าสารพิษสัมผัสผิวหนัง ให้ถอดเสื้อผ้าและล้างด้วยน้ำ",
          ),
          FirstaidStep(
            order: 5,
            text: "ถ้าสารพิษเข้าตา ล้างด้วยน้ำ 15–20 นาที",
          ),
          FirstaidStep(order: 6, text: "ถ้าผู้ป่วยหมดสติ โทร 1669"),
          FirstaidStep(order: 7, text: "เก็บภาชนะสารพิษไว้เพื่อระบุชนิด"),
        ],
      ),
      FirstaidSection(
        title: "คำเตือนสำคัญ",
        type: FirstaidSectionType.warning,
        items: [
          FirstaidWarn(text: "อย่าให้อาเจียนสำหรับสารกัดกร่อน"),
          FirstaidWarn(text: "อย่าทำตามคำแนะนำที่ไม่ใช่จากผู้เชี่ยวชาญ"),
        ],
      ),
    ],
  ),
];
