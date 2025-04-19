import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:xyz/screens/home_screen.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> with TickerProviderStateMixin {
  late final AudioPlayer _player;
  late final AnimationController _flyController;
  final List<String> harfler = ['A', 'B', 'C', 'Ç', 'D', 'E', 'F'];
  List<Offset> hedefKonumlar = [];
  bool harflerHazir = false;
  bool harflerUcusuyor = false;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _baslatMuzik();

    _flyController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // Yazı animasyonu bittikten sonra harfler uçamaya başlasın
    Future.delayed(Duration(seconds: 6), () {
      _generateRandomOffsets();
      setState(() {
        harflerHazir = true;
        harflerUcusuyor = true;
      });
      _flyController.forward();
    });

    // 50 saniye sonra ana menüye geç
    Future.delayed(Duration(seconds: 50), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScren()),
      );
    });
  }

  Future<void> _baslatMuzik() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('music/music.mp3'));
  }

  void _generateRandomOffsets() {
    final random = Random();
    hedefKonumlar = List.generate(harfler.length, (index) {
      double dx = random.nextDouble() * 800 - 400;
      double dy = random.nextDouble() * 1000 - 500;
      return Offset(dx, dy);
    });
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    _flyController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/anasayfa.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Harf uçuş animasyonu
                if (harflerHazir && harflerUcusuyor)
                  ...List.generate(harfler.length, (index) {
                    return AnimatedBuilder(
                      animation: _flyController,
                      builder: (context, child) {
                        final offset = Offset.lerp(
                          Offset.zero,
                          hedefKonumlar[index],
                          _flyController.value,
                        )!;
                        return Transform.translate(
                          offset: offset,
                          child: Opacity(
                            opacity: 1 - _flyController.value,
                            child: Text(
                              harfler[index],
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors.purpleAccent,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),

                // Metin animasyonları
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText(
                          'Mini Alfabem',
                          textStyle: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                            shadows: [
                              Shadow(
                                blurRadius: 8.0,
                                color: Colors.purpleAccent,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          speed: Duration(milliseconds: 100),
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                    SizedBox(height: 100),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Minİ Alfabene Hoşgeldin',
                          textStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.purple[700],
                            fontStyle: FontStyle.italic,
                          ),
                          speed: Duration(milliseconds: 150),
                        ),
                      ],
                      isRepeatingAnimation: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 🟣 Alta yerleştirilmiş geçiş butonu
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScren()),
                );
              },
              icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
              label: Text(
                'Ana Sayfaya Geç',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}