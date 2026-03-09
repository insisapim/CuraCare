import 'package:curacare/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("register", () {
    testWidgets("Empty input", (tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage()));

      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.byType(ElevatedButton), findsNWidgets(1));

      expect(find.text("ชื่อผู้ใช้"), findsOneWidget);
      expect(find.text("อีเมล"), findsOneWidget);
      expect(find.text("รหัสผ่าน"), findsOneWidget);
      expect(find.text("ยืนยันรหัสผ่าน"), findsOneWidget);

      await tester.tap(find.text("ลงทะเบียน"));
      await tester.pump();
    });
  });
}
