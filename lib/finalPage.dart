import 'package:flutter/material.dart';
import 'package:say_the_line/dataClass.dart';
import 'package:say_the_line/main.dart';
import 'selectCat.dart';

class ScorePage extends StatefulWidget {
  bool end;
  ScorePage({required this.end});

  @override
  State<StatefulWidget> createState() => ScorePageState();
}

class ScorePageState extends State<ScorePage> {
  List<String> oldTexts = [];
  List<String> newTexts = [];
  int n = JsonData().players.length;
  bool tap = false;

  void updText() {
    for (int i=0; i<n; i++)
    {
      String text = JsonData().getScore(i);
      newTexts.add(text);
      if (i == (JsonData().current-1)%n) {
        oldTexts.add(JsonData().updScore);
      }
      else {
        oldTexts.add(text);
      }
    }
  }


  void changeText() async {
    if (!tap)
      {
        setState(() {
          oldTexts = newTexts;
          tap = true;
        });
      }
    else {
      if (!widget.end)
        {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Selection(),
            ),
          );
        }
      else
      {
        await JsonData().reset();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyHomePage(newGame: true),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    updText();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.end ? "Partie finie, résultats finaux" : "Rappel des scores"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 350,
              height: n<10 ? n*50 : 500,
              child: ListView.builder(
                itemCount: n,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      width: 350,
                      height: 40,
                      margin: const EdgeInsets.all(5.0),
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: Text(
                          oldTexts[index],
                          key: ValueKey<String>(oldTexts[index]),
                          style: TextStyle(fontSize: 24),
                        ),
                      )
                  );
                },
              ),
            ),


            SizedBox(height: 80),

            Container(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: changeText,
                child: Text(widget.end ? "Fin de partie" : "Suivant",
                    style: TextStyle(fontSize: 20, color: Colors.pink, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
