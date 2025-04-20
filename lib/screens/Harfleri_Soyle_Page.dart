import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:xyz/screens/home_screen.dart'; // HomeScreen dosyanda sınıf adı gerçekten "HomeScreen" olmalı

void main() => runApp(const HarfUygulamasi());

class HarfUygulamasi extends StatefulWidget {
  const HarfUygulamasi({super.key});

  @override
  _HarfUygulamasiState createState() => _HarfUygulamasiState();
}

class _HarfUygulamasiState extends State<HarfUygulamasi> {
  String selectedLetter = "";
  String resultMessage = "";
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  String spokenText = "";

  List<String> turkceHarfler = [
    'A','B','C','Ç','D','E','F','G','Ğ','H','I','İ','J','K','L','M',
    'N','O','Ö','P','R','S','Ş','T','U','Ü','V','Y','Z'
  ];

  Future<void> startListening() async {
    if (speech.isListening) {
      await speech.stop(); // önceki konuşmayı durdur
    }

    bool available = await speech.initialize();
    if (available) {
      setState(() {
        isListening = true;
        spokenText = "";
        resultMessage = "";
      });
      speech.listen(
        localeId: "tr_TR",
        onResult: (val) {
          setState(() {
            String filtered = val.recognizedWords.toUpperCase().replaceAll(
              RegExp(r'[^A-ZÇĞİÖŞÜ]'),
              '',
            );
            spokenText = filtered.isNotEmpty ? filtered[0] : '';
          });
        },
      );
    }
  }

  Future<void> stopListeningAndCheck() async {
    await speech.stop();
    setState(() => isListening = false);

    if (spokenText == selectedLetter) {
      setState(() {
        resultMessage = "✅ Doğru söyledin!";
      });
    } else {
      setState(() {
        resultMessage =
            "❌ Yanlış söyledin! '$selectedLetter' demeliydin, sen '$spokenText' dedin.";
      });
    }
  }

 @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "Harf Eşleştirici",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 149, 162, 184),
      ),
      body: Stack(
        children: [
          // Arka plan görseli tüm ekranı kaplar
          SizedBox.expand(
            child: Image.asset(
              'assets/image/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "Bir Harfe Dokun ve Söyle !",
                    style: TextStyle(fontFamily: 'Kids',fontSize:22, fontWeight: FontWeight.bold),
            
                  ),
                  const SizedBox(height: 15),
                  
                  // 🔽 Harflerin ortalanması
                  Expanded(
                    child: Align(
                      alignment: Alignment.center, // Harfleri yatay ve dikey ortala
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: turkceHarfler.map((harf) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLetter = harf;
                                  spokenText = "";
                                  resultMessage = "";
                                });
                                startListening();
                              },
                              child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 52, 76, 87),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    harf,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: stopListeningAndCheck,
                    icon: const Icon(Icons.stop_circle_outlined),
                    label: const Text("Konuşmayı Bitir"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      backgroundColor: Colors.pink[100],
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔽 Doğru/yanlış sonucu her zaman görünür
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Seçilen Harf: $selectedLetter",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Söylediğin Harf: $spokenText",
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            resultMessage,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScren()),
          );
        },
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
      ),
    ),
  );
}
}