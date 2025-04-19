import 'package:flutter/material.dart';
import 'package:xyz/screens/Game.dart';
import 'package:xyz/screens/Harfleri_Soyle_Page.dart';
import 'package:xyz/screens/giris.dart';
import 'package:xyz/screens/harf_testi_page.dart';
import 'package:xyz/screens/letter_button_page.dart';
import 'package:xyz/screens/sessiz_harf.dart';
import 'package:xyz/screens/Harfli_Resim_Oyunu.dart'; // Resim sayfası
import 'package:xyz/screens/sesli_harf.dart';

class HomeScren extends StatelessWidget {
  const HomeScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/anasayfa.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Butonlar
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildButton(context, "Harfleri Dinleyelim", Colors.blueAccent,LettersButtonPage(),), 
                  _buildButton(context, "Harfleri Söyleyelim",const Color.fromARGB(255, 23, 133, 36),HarfUygulamasi()), 
                  _buildButton(context,"Harf Testi",  Colors.green[300],const HarfTestiPage(),),
                  _buildButton(context,"Sessiz Harfleri Öğrenelim",  Colors.orange[400],  SessizHarf(), ),
                  _buildButton( context,"Sesli Harfleri Öğrenelim", Colors.purple, SesliHarf(), ), _buildButton( context,"Resimli Harfler", Colors.pinkAccent,HarfliResimOyunu(), ),
                  _buildButton( context,"Sürükle Bırak Oyunu",Colors.teal, HarfleriSurukleBirak(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GirisEkrani()),
                );
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.arrow_back_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildButton(BuildContext context, String text,Color? color, Widget page,) {
    return SizedBox(
      width: 150,
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => page),
       );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: color,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
