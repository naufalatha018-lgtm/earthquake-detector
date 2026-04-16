import 'package:flutter/material.dart';

class AppStyle {

  // ✅ BACKGROUND COLOR (dipakai settings)
  static Color bg(BuildContext context) {
    return const Color(0xFFF5F7FA);
  }

  // ✅ BACKGROUND DECORATION (dipakai login & layout)
  static BoxDecoration background() {
    return const BoxDecoration(
      color: Color(0xFFF5F7FA),
    );
  }

  // ✅ CARD
  static BoxDecoration card() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ✅ TEXT STYLE
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static const TextStyle subtle = TextStyle(
    fontSize: 13,
    color: Colors.grey,
  );

  static const TextStyle value = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // ✅ BUTTON (dipakai login)
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
