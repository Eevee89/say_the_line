import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:say_the_line/newCitation.dart';
import 'dataClass.dart';
import 'modifyCitation.dart';
import 'selectCat.dart';

Future<void> requestPermissions() async {
  await Permission.manageExternalStorage.request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestPermissions();
  await JsonData().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: MyHomePage(newGame: false,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  bool newGame;

  MyHomePage({super.key, required this.newGame});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> players = [];
  String player = '';
  String? gameType;
  String? maxTour;
  List<String> points = List.generate(JsonData().nbCitations~/5, (index) => (75*(index+1)).toString());
  List<String> tours = ["Error"];
  bool first = true;

  void addPlayer() {
    setState(() {
      if (JsonData().addPlayer(player)) {
        players.add(player);
      }
      _controller.text = "";
      tours = List.generate(JsonData().nbCitations~/JsonData().players.length, (index) => (index+1).toString());
      maxTour = gameType == "En ?? tours" ? tours[0] : points[0];
    });
  }

  void removePlayer(String player) {
    setState(() {
      players.remove(player);
      JsonData().removePlayer(player);
    });
  }

  void showRules(BuildContext context) async {
    String text1 = "A chaque tour vous devrez dire qui a dit la citation (un ou plusieurs personnages), ou la compléter, selon votre choix initial.\n"
        "Vous avez droit à des indices : date, titre, saison/épisode (si série ou animé), personnage (si mode 'Complete'), puis la réponse. Chaque indice utilisé retire 3 points.\n"
        "Une bonne réponse sans indice rapporte 15 points.";

    String text2 = "Modes : \n - Jusqu'à épuisement : le jeu continue tant que des citations sont disponibles.\n"
        "- En ?? tours : chaque joueur aura un certain nombre d'essais.\n"
        "- Premier à : le jeu s'arrête dès qu'un des joueurs a un score supérieur ou égal au score spécifié.\n\n"
        "Couleurs : \n"
        "- Orange : Films\n- Vert : Séries\n- Rouge : Animés/Dessins animés\n- Bleu : Jeux vidéos";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Règles"),
          content: Container(
            width: 300,
            height: first ? 200 : 300,
            child: Text(first ? text1 : text2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (!first) {
                  setState(() {
                    first = true;
                    Navigator.of(context).pop();
                  });
                }
                else {
                  setState(() {
                    first = false;
                    Navigator.of(context).pop();
                    showRules(context);
                  });
                }
              },
              child: Text(first ? 'Suivant' : "Ok"),
            ),
          ],
        );
      },
    );
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget portraitView = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 200,
                  height: 50,
                  child: TextFormField(
                    controller: _controller,
                    onChanged: (text) {
                      setState(() {
                        player = text;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nouveau joueur',
                    ),
                  )
              ),

              SizedBox(width: 10),

              Container(
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: addPlayer,
                    tooltip: 'Ajouter joueur',
                    child: const Icon(Icons.add),
                  )
              )
            ],
          ),


          Container(
            width: 255,
            height: 250,
            child: ListView.builder(
                padding: const EdgeInsets.all(5.0),
                itemCount: players.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 30,
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(200, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: const Color.fromARGB(50, 0, 0, 0),
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                            child: Text(players[index],
                                style: TextStyle(fontSize: 20, color: Colors.deepPurple)
                            )
                        ),
                      ),

                      SizedBox(width: 5),

                      Container(
                          width: 30,
                          height: 30,
                          child: CircleAvatar(
                              radius: 25.0,
                              child: InkWell(
                                  onTap: () {removePlayer(players[index]); },
                                  child: SvgPicture.asset("assets/x.svg")
                              )
                          )

                      )
                    ],
                  );
                }
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                height: 40,
                child: DropdownButton<String>(
                  hint: const Text('Type de jeu'),
                  value: gameType,
                  onChanged: (String? value) {
                    setState(() {
                      gameType = value;
                      JsonData().game["Type"] = value;
                      maxTour = gameType == "En ?? tours" ? tours[0] : points[0];
                    });
                  },
                  items: ["Jusqu'à épuisement", "Premier à", "En ?? tours"].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
              ),

              Visibility(
                visible: gameType != "Jusqu'à épuisement",
                child: SizedBox(width: 10),
              ),

              Visibility(
                visible: gameType != "Jusqu'à épuisement",
                child: Container(
                  width: 75,
                  height: 40,
                  child: DropdownButton<String>(
                    hint: Text(gameType == "En ?? tours" ? 'Tours' : "Points"),
                    value: maxTour,
                    onChanged: (String? value) {
                      setState(() {
                        maxTour = value;
                        JsonData().game["Nombre"] = int.parse(value ?? "-1");
                      });
                    },
                    items: gameType == "En ?? tours"
                        ? tours.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList()
                        : points.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 15),

          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (players.length < 2) showRules(context);
                else{
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Selection(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: players.length < 2
                      ? Colors.red : Colors.green
              ),
              child: Text(players.length < 2 ? "Règles" : "Démarrer",
                  style: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );

    Widget landscapeView = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 200,
                      height: 50,
                      child: TextFormField(
                        controller: _controller,
                        onChanged: (text) {
                          setState(() {
                            player = text;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nouveau joueur',
                        ),
                      )
                  ),

                  SizedBox(width: 10),

                  Container(
                      width: 50,
                      height: 50,
                      child: FloatingActionButton(
                        onPressed: addPlayer,
                        tooltip: 'Ajouter joueur',
                        child: const Icon(Icons.add),
                      )
                  )
                ],
              ),

              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 180,
                    height: 40,
                    child: DropdownButton<String>(
                      hint: const Text('Type de jeu'),
                      value: gameType,
                      onChanged: (String? value) {
                        setState(() {
                          gameType = value;
                          JsonData().game["Type"] = value;
                          maxTour = gameType == "En ?? tours" ? tours[0] : points[0];
                        });
                      },
                      items: ["Jusqu'à épuisement", "Premier à", "En ?? tours"].map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                    ),
                  ),

                  Visibility(
                    visible: gameType != "Jusqu'à épuisement",
                    child: SizedBox(width: 10),
                  ),

                  Visibility(
                    visible: gameType != "Jusqu'à épuisement",
                    child: Container(
                      width: 75,
                      height: 40,
                      child: DropdownButton<String>(
                        hint: Text(gameType == "En ?? tours" ? 'Tours' : "Points"),
                        value: maxTour,
                        onChanged: (String? value) {
                          setState(() {
                            maxTour = value;
                            JsonData().game["Nombre"] = int.parse(value ?? "-1");
                          });
                        },
                        items: gameType == "En ?? tours"
                            ? tours.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList()
                            : points.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 15),

              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (players.length < 2) showRules(context);
                    else{
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Selection(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: players.length < 2
                          ? Colors.red : Colors.green
                  ),
                  child: const Text("Démarrer",
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),

          SizedBox(width: 50),

          Container(
            width: 255,
            height: 250,
            child: ListView.builder(
                padding: const EdgeInsets.all(5.0),
                itemCount: players.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 30,
                        margin: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(200, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: const Color.fromARGB(50, 0, 0, 0),
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                            child: Text(players[index],
                                style: TextStyle(fontSize: 20, color: Colors.deepPurple)
                            )
                        ),
                      ),

                      SizedBox(width: 5),

                      Container(
                          width: 30,
                          height: 30,
                          child: CircleAvatar(
                              radius: 25.0,
                              child: InkWell(
                                  onTap: () {removePlayer(players[index]); },
                                  child: SvgPicture.asset("assets/x.svg")
                              )
                          )

                      )
                    ],
                  );
                }
            ),
          ),
        ],
      )
    );

    Widget addButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewQuotePage(),
            ),
          );
        },
        child: const Text("Ajouter")
    );

    Widget modifyButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ModifyQuotePage(),
            ),
          );
        },
        child: const Text("Modifier")
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Say the line"),
        automaticallyImplyLeading: false,
        actions: [addButton, SizedBox(width: 5), modifyButton, SizedBox(width: 10),],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? portraitView
              : landscapeView;
        },
      ),
    );
  }
}
