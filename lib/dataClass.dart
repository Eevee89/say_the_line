import 'dart:math';
import 'dart:io';
import 'dart:convert';

class JsonData {
  static JsonData? _instance;
  List<dynamic> films_qad = [];
  List<dynamic> films_com = [];
  List<dynamic> series_qad = [];
  List<dynamic> series_com = [];
  List<dynamic> animes_qad = [];
  List<dynamic> animes_com = [];
  List<dynamic> jeux_qad = [];
  List<dynamic> jeux_com = [];
  List<String> players = [];
  List<int> scores = [];
  int current = 0;
  String updScore = "";
  int nbCitations = 0;
  dynamic game = {
    "Type": "Jusqu'à l'épuisement",
    "Nombre": -1
  };

  String path = "/storage/emulated/0/Download/SayTheLineDatas";

  bool end = false;

  JsonData._internal();

  factory JsonData() {
    return _instance ??= JsonData._internal();
  }

  Future<void> addQuote(dynamic data, String category) async {
    try {
      File file = category == "Films"
          ? File("${path}/films.json")
          : category == "Séries"
          ? File("${path}/series.json")
          : category == "Animés"
          ? File("${path}/animes.json")
          : File("${path}/jeux.json");
      String jsonString = await file.readAsString();
      List<dynamic> temp = json.decode(jsonString);
      temp.add(data);
      jsonString = jsonEncode(temp);
      await file.writeAsString(jsonString);
      print("Citation ajoutée");
    } catch (e) {
      print("Erreur lors de l'écriture dans le fichier JSON : $e");
    }
  }

  Future<List<dynamic>?> readFile(String category) async {
    try {
      File file = category == "Films"
          ? File("${path}/films.json")
          : category == "Séries"
          ? File("${path}/series.json")
          : category == "Animés"
          ? File("${path}/animes.json")
          : File("${path}/jeux.json");
      String jsonString = await file.readAsString();
      List<dynamic> temp = json.decode(jsonString);
      return temp;
    } catch (e) {
      print("Erreur lors de la lecture du fichier JSON : $e");
    }
  }

  Future<void> modifyFile(List<dynamic> newDatas, String category) async {
    try {
      File file = category == "Films"
          ? File("${path}/films.json")
          : category == "Séries"
          ? File("${path}/series.json")
          : category == "Animés"
          ? File("${path}/animes.json")
          : File("${path}/jeux.json");

      String jsonString = jsonEncode(newDatas);
      await file.writeAsString(jsonString);
      print("Fichier modifié");
    } catch (e) {
      print("Erreur lors de l'écriture dans le fichier JSON : $e");
    }
  }


  Future<void> initialize() async {
    String jsonString = await File("${path}/films.json").readAsString();
    List<dynamic> temp = json.decode(jsonString);
    for (dynamic film in temp) {
        if (film['type'] == "Complete") {
          films_com.add(film);
        }
        else {
          films_qad.add(film);
        }
        nbCitations++;
    }

    jsonString = await File("${path}/series.json").readAsString();
    temp = json.decode(jsonString);
    for (dynamic serie in temp) {
      if (serie['type'] == "Complete") {
        series_com.add(serie);
      }
      else {
        series_qad.add(serie);
      }
      nbCitations++;
    }

    jsonString = await File("${path}/animes.json").readAsString();
    temp = json.decode(jsonString);
    for (dynamic anime in temp) {
      if (anime['type'] == "Complete") {
        animes_com.add(anime);
      }
      else {
        animes_qad.add(anime);
      }
      nbCitations++;
    }

    jsonString = await File("${path}/jeux.json").readAsString();
    temp = json.decode(jsonString);
    for (dynamic jeu in temp) {
      if (jeu['type'] == "Complete") {
        jeux_com.add(jeu);
      }
      else {
        jeux_qad.add(jeu);
      }
      nbCitations++;
    }
  }

  void addScore(int gain) {
    updScore = "${players[current]} : ${scores[current]} +$gain";
    scores[current] += gain;
    end = ((game["Type"] == "Premier à") && (scores[current] >= game["Nombre"])) || (nbCitations == 0);
    current = (current+1)%players.length;
    if (current == 0 && game["Type"] == "En ?? tours") {
      game["Nombre"]--;
      end = (game["Nombre"] == 0) || (nbCitations == 0);
    }
  }

  String getScore(int i) {
    return "${players[i]} : ${scores[i]}";
  }

  String getCurrentPlayer() {
    return players[current];
  }

  bool addPlayer(String player) {
    bool toAdd = !players.contains(player);
    if (toAdd)
    {
      players.add(player);
      scores.add(0);
    }
    return toAdd;
  }

  void removePlayer(String player) {
    players.remove(player);
    scores.removeLast();
  }

  dynamic Citation(String category, String type)
  {
    Random random = Random();
    int r;

    if (category == "Films")
      {
        if (type == "Complete")
        {
          r = random.nextInt(films_com.length);
          dynamic film = films_com[r];
          films_com.remove(film);
          nbCitations--;
          return film;
        }
        else
        {
          r = random.nextInt(films_qad.length);
          dynamic film = films_qad[r];
          films_qad.remove(film);
          nbCitations--;
          return film;
        }
      }

    else if (category == "Séries")
    {
      if (type == "Complete")
      {
        r = random.nextInt(series_com.length);
        dynamic serie = series_com[r];
        series_com.remove(serie);
        nbCitations--;
        return serie;
      }
      else
      {
        r = random.nextInt(series_qad.length);
        dynamic serie = series_qad[r];
        series_qad.remove(serie);
        nbCitations--;
        return serie;
      }
    }

    else if (category == "Animés")
    {
      if (type == "Complete")
      {
        r = random.nextInt(animes_com.length);
        dynamic anime = animes_com[r];
        animes_com.remove(anime);
        nbCitations--;
        return anime;
      }
      else
      {
        r = random.nextInt(animes_qad.length);
        dynamic anime = animes_qad[r];
        animes_qad.remove(anime);
        nbCitations--;
        return anime;
      }
    }

    else
    {
      if (type == "Complete")
      {
        r = random.nextInt(jeux_com.length);
        dynamic jeu = jeux_com[r];
        jeux_com.remove(jeu);
        nbCitations--;
        return jeu;
      }
      else
      {
        r = random.nextInt(jeux_qad.length);
        dynamic jeu = jeux_qad[r];
        jeux_qad.remove(jeu);
        nbCitations--;
        return jeu;
      }
    }
  }

  Future<void> reset() async {
    films_qad = []; films_com = [];
    series_qad = []; series_com = [];
    animes_qad = []; animes_com = [];
    jeux_qad = []; jeux_com = [];
    players = []; List<int> scores = [];
    current = 0; updScore = "";
    await initialize();
  }
}
