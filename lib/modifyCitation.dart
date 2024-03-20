import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:say_the_line/dataClass.dart';

class ModifyQuotePage extends StatefulWidget {
  @override
  State<ModifyQuotePage> createState() => ModifyQuotePageState();
}

class ModifyQuotePageState extends State<ModifyQuotePage> {
  String category = "Films";
  List<dynamic> quotes = [];
  int currentID = 0;
  TextEditingController quote = TextEditingController();
  TextEditingController rest = TextEditingController();

  Future<bool?> _showChoiceDialog(BuildContext context, bool delete) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(delete ? 'Vous allez supprimer une citation' : 'Vous allez modifier une citation'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // L'utilisateur a choisi "Cancel"
              },
              child: Text('Retour'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // L'utilisateur a choisi "OK"
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  String info(dynamic data) {
    String res = "";
    res += "Type : ${data['type']}\n";
    res += "Réponse : ${data['réponse']}\n";
    res += "Date : ${data['date']}\n";
    res += "Titre : ${data['titre']}\n";
    if(category == "Animés" || category == "Séries") {
      res += "Épisode : ${data['épisode']}\n";
    }
    if(data['type'] == "Complete") {
      res += "Personnages : ${data['personnages']}\n";
    }
    return res;
  }

  dynamic parseInfoString(String citation, String infoString) {
    List<String> lines = infoString.split('\n');

    Map<String, dynamic> result = {
      "citation": citation,
      "type": "",
      "réponse": "",
      "date": 0,
      "titre": ""
    };

    for (String line in lines) {
      if (line.isNotEmpty) {
        List<String> parts = line.split(':');
        String key = parts[0].trim();
        String value = parts[1].trim();

        if (key == "Date") {
          result[key.toLowerCase()] = int.parse(value);
        } else {
          result[key.toLowerCase()] = value;
        }
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Widget saveButton = FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          bool? temp = await _showChoiceDialog(context, false);
          bool res = temp ?? false;
          if (res) {
            dynamic temp = parseInfoString(quote.text, rest.text);
            quotes[currentID] = temp;
            await JsonData().modifyFile(quotes, category);
            await JsonData().reset();
            Navigator.of(context).pop();
          }
        },
        child: SvgPicture.asset("assets/penline.svg")
    );

    Widget delButton = FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          bool? temp = await _showChoiceDialog(context, true);
          bool res = temp ?? false;
          if (res) {
            quotes.removeAt(currentID);
            await JsonData().modifyFile(quotes, category);
            await JsonData().reset();
            Navigator.of(context).pop();
          }
        },
        child: SvgPicture.asset("assets/trash.svg")
    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Modification"),
        actions: [saveButton, SizedBox(width: 5), delButton, SizedBox(width: 10),],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (currentID > 0) {
                        setState(() {
                          currentID -= 1;
                          quote.value = quote.value.copyWith(
                            text: quotes[currentID]['citation'],
                            selection: TextSelection.collapsed(offset: quotes[currentID]['citation'].length)
                          );

                          rest.value = rest.value.copyWith(
                              text: info(quotes[currentID]),
                              selection: TextSelection.collapsed(offset: info(quotes[currentID]).length)
                          );
                        });
                      }
                    },
                    backgroundColor: quotes.length != 0  && currentID != 0
                        ? Colors.deepPurple
                        : Theme.of(context).colorScheme.background,
                    child: SvgPicture.asset("assets/arrow_left.svg", fit: BoxFit.cover,)
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width/3,
                  height: 50,
                  child: DropdownButton<String>(
                      hint: const Text("Catégorie"),
                      value: category,
                      onChanged: (String? value) async {
                        List<dynamic>? temp = await JsonData().readFile(value ?? "Films");
                        setState(() {
                          category = value ?? "Films";
                          quotes = temp ?? [];
                        });
                      },
                      items: ["Films", "Séries", "Animés", "Jeux"].map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList()
                  ),
                ),

                Container(
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                      onPressed: () {
                        if (currentID < quotes.length - 1) {
                          setState(() {
                            currentID += 1;
                            quote.value = quote.value.copyWith(
                                text: quotes[currentID]['citation'],
                                selection: TextSelection.collapsed(offset: quotes[currentID]['citation'].length)
                            );

                            rest.value = rest.value.copyWith(
                                text: info(quotes[currentID]),
                                selection: TextSelection.collapsed(offset: info(quotes[currentID]).length)
                            );
                          });
                        }
                      },
                      backgroundColor: quotes.length != 0 && currentID != quotes.length-1
                          ? Colors.deepPurple
                          : Theme.of(context).colorScheme.background,
                      child: SvgPicture.asset("assets/arrow_right.svg", fit: BoxFit.cover,)
                  ),
                ),
              ],
            ),

            Container(
                width: 4*MediaQuery.of(context).size.width/5,
                height: 200,
                child: TextFormField(
                  controller: quote,
                  maxLines: 15,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Citation',
                  ),
                )
            ),

            Container(
                width: 4*MediaQuery.of(context).size.width/5,
                height: 200,
                child: TextFormField(
                  controller: rest,
                  maxLines: 15,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Autres',
                  ),
                )
            ),
          ],
        )
      ),
    );
  }
  
}