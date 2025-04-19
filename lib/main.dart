import 'package:flutter/material.dart';
import 'screens/giris.dart';

void main() async {
  // Firebase başlatılıyor
  runApp(const Proje());
}

class Proje extends StatelessWidget {
  const Proje({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GirisEkrani(),
    );
  }
}





