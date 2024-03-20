import 'package:flutter/material.dart';
import 'package:say_the_line/dataClass.dart';

class NewQuotePage extends StatefulWidget {
  @override
  State<NewQuotePage> createState() => NewQuotePageState();
}

class NewQuotePageState extends State<NewQuotePage> {
  String categorie = "Films";
  String type = "Qui a dit";
  TextEditingController quote = TextEditingController();
  TextEditingController answer = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController episode = TextEditingController();
  TextEditingController characters = TextEditingController();

  dynamic newQuote = {};

  @override
  Widget build(BuildContext context) {
    Widget dropButtonRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width/3,
          height: 50,
          child: DropdownButton<String>(
              hint: const Text("Catégorie"),
              value: categorie,
              onChanged: (String? value) {
                setState(() {
                  categorie = value ?? "Films";
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
          width: MediaQuery.of(context).size.width/3,
          height: 50,
          child: DropdownButton<String>(
              hint: const Text("Type"),
              value: type,
              onChanged: (String? value) {
                setState(() {
                  type = value ?? "Qui a dit";
                });
              },
              items: ["Qui a dit", "Complete"].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList()
          ),
        ),
      ],
    );

    Widget portraitView = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        dropButtonRow,

        Container(
          width: 4*MediaQuery.of(context).size.width/5,
          height: 110,
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
            width: 2*MediaQuery.of(context).size.width/3,
            height: 70,
            child: TextFormField(
              controller: answer,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Réponse',
              ),
            )
        ),

        Container(
            width: 2*MediaQuery.of(context).size.width/3,
            height: 70,
            child: TextFormField(
              controller: title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Titre',
              ),
            )
        ),

        Container(
            width: MediaQuery.of(context).size.width/2,
            height: 50,
            child: TextFormField(
              controller: date,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date de sortie',
              ),
            )
        ),

        Visibility(
            visible: categorie == "Animés" || categorie == "Séries",
            child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                child: TextFormField(
                  controller: episode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Saison et épisode',
                  ),
                )
            ),
        ),

        Visibility(
          visible: type == "Complete",
          child: Container(
              width: 2*MediaQuery.of(context).size.width/3,
              height: 70,
              child: TextFormField(
                controller: characters,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Personnages',
                ),
              )
          ),
        ),
      ],
    );

    Widget landscapeView = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            dropButtonRow,

            Container(
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                child: TextFormField(
                  controller: quote,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Citation',
                  ),
                )
            ),
          ],
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                child: TextFormField(
                  controller: answer,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Réponse',
                  ),
                )
            ),

            Container(
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                child: TextFormField(
                  controller: title,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Titre',
                  ),
                )
            ),

            Container(
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                child: TextFormField(
                  controller: date,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date de sortie',
                  ),
                )
            ),

            Visibility(
              visible: categorie == "Animés" || categorie == "Séries",
              child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: 50,
                  child: TextFormField(
                    controller: episode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Saison et épisode',
                    ),
                  )
              ),
            ),

            Visibility(
              visible: type == "Complete",
              child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: 50,
                  child: TextFormField(
                    controller: characters,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Personnages',
                    ),
                  )
              ),
            ),
          ],
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Say the line - ajout de citation"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? portraitView
              : landscapeView;
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Center(
          child: Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  newQuote["citation"] = quote.text;
                  quote.text = "";
                  newQuote["type"] = type;
                  newQuote["réponse"] = answer.text;
                  answer.text = "";
                  newQuote["titre"] = title.text;
                  title.text = "";
                  newQuote["date"] = int.parse(date.text);
                  date.text = "";
                  if (type == "Complete") {
                    newQuote["personnages"] = characters.text;
                    characters.text = "";
                  }
                  if (categorie == "Animés" || categorie == "Séries") {
                    newQuote["épisode"] = episode.text;
                    episode.text = "";
                  }
                });
                print(newQuote["citation"]);
                print(newQuote["réponse"]);
                print(newQuote["titre"]);
                print(newQuote["date"]);
                await JsonData().addQuote(newQuote, categorie);
                await JsonData().reset();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background
              ),
              child: const Text("Ajouter",
                  style: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            ),
          ),
        )
      ),
    );

  }

}