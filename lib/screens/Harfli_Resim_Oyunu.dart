// ignore: file_names
import 'dart:math';
import 'package:flutter/material.dart';

class HarfliResimOyunu extends StatefulWidget {
  const HarfliResimOyunu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HarfliResimOyunuState createState() => _HarfliResimOyunuState();
}

class _HarfliResimOyunuState extends State<HarfliResimOyunu>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> imageList = [
    {"image": "assets/images/apple.png", "letter": "E"},
    {"image": "assets/images/car.png", "letter": "A"},
    {"image": "assets/images/karpuz.png", "letter": "K"},
    {"image": "assets/images/zürafa.png", "letter": "Z"},
    {"image": "assets/images/cilek.png", "letter": "Ç"},
    {"image": "assets/images/rainbow.png", "letter": "G"},
    {"image": "assets/images/fish.png", "letter": "B"},
    {"image": "assets/images/dog.png", "letter": "K"},
  ];

  Map<String, dynamic>? _currentImage;
  String _userGuess = "";
  String _message = "";
  bool _isCorrect = false;
  bool _showFeedback = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _getRandomImage();

    // Animasyon başlat
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getRandomImage() {
    final random = Random();
    setState(() {
      _currentImage = imageList[random.nextInt(imageList.length)];
    });
  }

  void _checkGuess() {
    if (_currentImage == null) return;

    setState(() {
      if (_userGuess.toUpperCase() == _currentImage!['letter']) {
        _message = "🎉 Tebrikler! Dogru bildiniz.";
        _isCorrect = true;
        _showFeedback = true;
        _controller.forward().then((_) {
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _showFeedback = false;
              _controller.reset();
              _getRandomImage(); // Doğruysa yeni resim
            });
          });
        });
      } else {
        _message = "❌ Yanlis, tekrar deneyin.";
        _isCorrect = false;
        _showFeedback = true;
        _controller.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              _showFeedback = false;
              _controller.reset();
            });
          });
        });
      }
      _userGuess = ""; // Tahmin kutusunu sıfırla
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Resimli Harf Oyunu"),
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily:'Kids',
      fontSize: 24,
      color:Colors.black

    ),),
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/background.png'), // Arka plan görseli
          fit: BoxFit.cover, // Resmin ekranı kaplamasını sağlar
        ),
      ),
      child: Center(
        child: _currentImage == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    _currentImage!['image'],
                    width: 200,
                    height: 200,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("⚠️ Resim yüklenemedi!");
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Bas Harfini Tahmin Et?",
                    style: TextStyle(fontFamily:'Kids',fontSize:  20,),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) => setState(() => _userGuess = value),
                      maxLength: 1,
                      decoration: const InputDecoration(
                        hintText: "A-Z",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkGuess,
                    child: const Text("Tahmin Et"),
                  ),
                  const SizedBox(height: 20),

                  // Animasyonlu Geri Bildirim Kutusu
                  _showFeedback
                      ? Opacity(
                          opacity: _animation.value,
                          child: Container(
                            width: 150,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _isCorrect ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _isCorrect
                                ? const Icon(Icons.check, color: Colors.white, size: 30)
                                : const Icon(Icons.close, color: Colors.white, size: 30),
                          ),
                        )
                      : const SizedBox(),

                  const SizedBox(height: 10),
                  Text(
                    _message,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              )
      ),
    ),
  );
}
    }