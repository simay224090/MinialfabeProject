import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() => runApp(HarfUygulamasi());

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
    'A', 'B', 'C', 'Ç', 'D', 'E', 'F', 'G', 'Ğ', 'H',
    'I', 'İ', 'J', 'K', 'L', 'M', 'N', 'O', 'Ö', 'P',
    'R', 'S', 'Ş', 'T', 'U', 'Ü', 'V', 'Y', 'Z'
  ];

  Future<void> startListening() async {
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
            String filtered = val.recognizedWords.toUpperCase().replaceAll(RegExp(r'[^A-ZÇĞİÖŞÜ]'), '');
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
        resultMessage = "❌ Yanlış söyledin! '$selectedLetter' demeliydin, sen '$spokenText' dedin.";
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: const Text("Harf Eşleştirici", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 149, 162, 184),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.png'), // Add your background image path here
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Bir harfe dokun ve söyle!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Expanded(
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
                            boxShadow: [
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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: stopListeningAndCheck,
                icon: Icon(Icons.stop_circle_outlined),
                label: Text("Konuşmayı Bitir"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  backgroundColor: Colors.pink[100],
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder( // Rectangular shape instead of rounded
                    borderRadius: BorderRadius.zero, // Set to zero to make the button rectangular
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("Seçilen Harf: $selectedLetter", style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Text("Söylediğin Harf: $spokenText", style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      Text(resultMessage, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
),
);
}
}
