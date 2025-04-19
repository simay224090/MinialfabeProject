import 'dart:math';
import 'package:flutter/material.dart';

class HarfleriSurukleBirak extends StatefulWidget {
  const HarfleriSurukleBirak({super.key});

  @override
  _HarfleriSurukleBirakState createState() => _HarfleriSurukleBirakState();
}

class _HarfleriSurukleBirakState extends State<HarfleriSurukleBirak> {
  List<String> letters = ['A', 'B', 'C','Ç', 'D', 'E', 'F', 'G','Ğ','H', 'I','İ', 'J', 'K', 'L', 'M', 'N', 'O','Ö','P', 'Q', 'R', 'S','Ş' ,'T', 'U','Ü','V','Y','Z'];
  List<String> vowels = ['A', 'E', 'I','İ' 'O','Ö', 'U','Ü'];
  String draggedLetter = '';
  int correctCount = 0;
  int wrongCount = 0;

  void _getRandomLetter() {
    final random = Random();
    setState(() {
      draggedLetter = letters[random.nextInt(letters.length)];
    });
  }

  void _checkDrop(String letterType) {
    setState(() {
      if ((vowels.contains(draggedLetter) && letterType == 'Vowels') || (!vowels.contains(draggedLetter) && letterType == 'Consonants')) {
        correctCount++;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Doğru!")));
      } else {
        wrongCount++;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Yanlış!")));
      }
      _getRandomLetter();
    });
  }

  @override
  void initState() {
    super.initState();
    _getRandomLetter();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Harfleri Sürükle ve Bırak")),
    body: Container(
      decoration: BoxDecoration(
        // Renkli arka plan (dilersen değiştirebilirsin)
        color: Colors.white,

        // Veya buraya resim ekleyebilirsin (aşağıdaki satırı yorumdan çıkar)
         image: DecorationImage(
         image: AssetImage("assets/image/background.png"), // görseli assets klasörüne eklemeyi unutma
         fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sürükle: $draggedLetter", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text("Doğru: $correctCount", style: TextStyle(fontSize: 20, color: Colors.green)),
                    Text("Yanlış: $wrongCount", style: TextStyle(fontSize: 20, color: Colors.red)),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            DragTarget<String>(
              onAcceptWithDetails: (data) => _checkDrop('Vowels'),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 200,
                  height: 100,
                  color: Colors.blue[100],
                  child: Center(child: Text('Ünlü Harfler', style: TextStyle(fontSize: 20))),
                );
              },
            ),
            SizedBox(height: 20),
            DragTarget<String>(
              onAcceptWithDetails: (data) => _checkDrop('Consonants'),
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: 200,
                  height: 100,
                  color: Colors.green[100],
                  child: Center(child: Text('Ünsüz Harfler', style: TextStyle(fontSize: 20))),
                );
              },
            ),
            SizedBox(height: 20),
            Draggable<String>(
              data: draggedLetter,
              feedback: Material(
                color: Colors.transparent,
                child: Text(draggedLetter, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              childWhenDragging: Container(),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.yellow[200],
                child: Center(
                  child: Text(
                    draggedLetter,
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getRandomLetter,
              child: Text("Yeni Harf Al"),
            ),
          ],
        ),
      ),
    ),
  );
}
}