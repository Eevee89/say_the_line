import 'package:flutter/material.dart';
import 'package:say_the_line/dataClass.dart';
import 'gamePage.dart';

class Selection extends StatefulWidget {

  Selection();

  @override
  State<Selection> createState() => SelectionState();
}

class SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("A ${JsonData().getCurrentPlayer()} de jouer"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: JsonData().films_qad.isNotEmpty,
                  child: Container(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GamePage(category: "Films", type: "Qad"),
                            ),
                          );
                        },
                        child: Text("Qui a dit ? : ${JsonData().films_qad.length}",
                            style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold, fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[300],
                        )
                    ),
                  ),
                ),

                Visibility(
                  visible: JsonData().films_com.isNotEmpty && JsonData().films_qad.isNotEmpty,
                  child: SizedBox(width: 20),),

                Visibility(
                  visible: JsonData().films_com.isNotEmpty,
                  child: Container(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GamePage(category: "Films", type: "Complete"),
                            ),
                          );
                        },
                        child: Text("Complète : ${JsonData().films_com.length}",
                            style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold, fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[300],
                        )
                    ),
                  ),
                )
              ],
            ),

            Visibility(
              visible: JsonData().films_com.isNotEmpty || JsonData().films_qad.isNotEmpty,
              child: SizedBox(height: 30),),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: JsonData().series_qad.isNotEmpty,
                  child: Container(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GamePage(category: "Séries", type: "Qad"),
                            ),
                          );
                        },
                        child: Text("Qui a dit ? : ${JsonData().series_qad.length}",
                            style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                        )
                    ),
                  )
                ),

                Visibility(
                  visible: JsonData().series_com.isNotEmpty && JsonData().series_qad.isNotEmpty,
                  child: SizedBox(width: 20),),

                Visibility(
                  visible: JsonData().series_com.isNotEmpty,
                  child: Container(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => GamePage(category: "Séries", type: "Complete"),
                            ),
                          );
                        },
                        child: Text("Complète : ${JsonData().series_com.length}",
                            style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold, fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[300],
                        )
                    ),
                  )
                ),
              ],
            ),

            Visibility(
              visible: JsonData().series_com.isNotEmpty || JsonData().series_qad.isNotEmpty,
              child: SizedBox(height: 30),),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: JsonData().animes_qad.isNotEmpty,
                    child: Container(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GamePage(category: "Animés", type: "Qad"),
                              ),
                            );
                          },
                          child: Text("Qui a dit ? : ${JsonData().animes_qad.length}",
                              style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300],
                          )
                      ),
                    )
                ),

                Visibility(
                  visible: JsonData().animes_com.isNotEmpty && JsonData().animes_qad.isNotEmpty,
                  child: SizedBox(width: 20),),

                Visibility(
                    visible: JsonData().animes_com.isNotEmpty,
                    child: Container(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                          MaterialPageRoute(
                          builder: (context) => GamePage(category: "Animés", type: "Complete"),
                          ),
                          );
                        },
                        child: Text("Complète : ${JsonData().animes_com.length}",
                            style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold, fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[300],
                            )
                      ),
                    )
                ),
              ],
            ),

            Visibility(
              visible: JsonData().animes_qad.isNotEmpty || JsonData().animes_com.isNotEmpty,
              child: SizedBox(height: 30),),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: JsonData().jeux_qad.isNotEmpty,
                    child: Container(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GamePage(category: "Jeux", type: "Qad"),
                              ),
                            );
                          },
                          child: Text("Qui a dit ? : ${JsonData().jeux_qad.length}",
                              style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                          )
                      ),
                    )
                ),

                Visibility(
                  visible: JsonData().jeux_qad.isNotEmpty && JsonData().jeux_com.isNotEmpty,
                  child: SizedBox(width: 20),),

                Visibility(
                    visible: JsonData().jeux_com.isNotEmpty,
                    child: Container(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GamePage(category: "Jeux", type: "Complete"),
                              ),
                            );
                          },
                          child: Text("Complète : ${JsonData().jeux_com.length}",
                              style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[300],
                          )
                      ),
                    )
                ),
              ],
            )
          ],
        )
      )
    );
  }

}