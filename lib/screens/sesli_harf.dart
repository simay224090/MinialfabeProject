import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SesliHarf extends StatelessWidget {
  final AudioPlayer audioPlayer = AudioPlayer();

  SesliHarf({super.key});

  // Ses çalmak için metot
  void _playSound(String letter) {
    String soundPath = 'sounds/$letter.wav'; // Harfe göre ses dosyası yolu
    audioPlayer.play(AssetSource(soundPath)).catchError((error) {
      if (kDebugMode) {
        print("Ses çalarken hata oluştu: $error");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Türk alfabesi
    final List<String> turkishLetters = [
      'A',
      'E',
      'I',
      'İ',
      'O',
      'Ö',
      'U',
      'Ü',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Harf Dinleme'),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Kids',
        fontSize: 24,
        color:Colors.black
      ),),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/image/background.png'), // Arka plan resmi yolu
            fit: BoxFit.cover, // Resmin ekranı kaplaması için
          ),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, // 5 sütunlu ızgara
            childAspectRatio: 1.0,
          ),
          itemCount: turkishLetters.length, // Türk harf sayısı
          itemBuilder: (context, index) {
            final letter = turkishLetters[index]; // Türk harflerini al
            return GestureDetector(
              onTap: () =>
                  _playSound(letter), // Harfe tıklandığında ilgili sesi çal
              child: Card(
                color: Colors.indigo[100],
                child: Center(
                  child: Text(
                    letter,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'MyFont',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
