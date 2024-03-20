import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:say_the_line/dataClass.dart';
import 'finalPage.dart';

class GamePage extends StatefulWidget {
  String category;
  String type;
  late dynamic citation = JsonData().Citation(category, type);

  GamePage({required this.category, required this.type});

  @override
  State<GamePage> createState() => GamePageState();
}

class GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _opacityTween = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  dynamic fonds = {
    "Films" : Colors.orange[300],
    "Séries" : Colors.green[300],
    "Animés" : Colors.red[300],
    "Jeux" : Colors.blue[300]
  };

  dynamic contours = {
    "Films" : Colors.orange[900],
    "Séries" : Colors.green[900],
    "Animés" : Colors.red[900],
    "Jeux" : Colors.blue[900]
  };

  int indice = 0;
  bool showRep = false;

  double height(String text) {
    int h = text.length~/30+3;
    return h*20;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle myStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: contours[widget.category]
    );

    double h = height(widget.citation['citation']);

    Container episode = Container(
      width: 300,
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 15),

          Container(
              width: 300,
              height: 20,
              child: Visibility(
                  visible: indice >= 3,
                  child: Text("Saison/ep : ${widget.citation['épisode']}", style: myStyle)
              )
          ),

          SizedBox(height: 15),
        ],
      )
    );

    Container personnage = Container(
        width: 300,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 15),

            Container(
                width: 300,
                height: 50,
                child: Visibility(
                    visible: indice >= (widget.category == "Animés" || widget.category == "Séries" ? 4 : 3),
                    child: Text("Personnage : ${widget.citation['personnages']}", style: myStyle)
                )
            ),

            SizedBox(height: 15),
          ],
        )
    );

    double rect = widget.category == "Animés" || widget.category == "Séries"
        ? widget.type == "Complete" ? 250 : 185
        : widget.type == "Complete" ? 205 : 140;

    rect += 40+20*(widget.citation['réponse'].length + widget.citation['titre'].length)~/36;
    rect += 20 + 20*widget.citation['titre'].length~/36;

    int rep = widget.category == "Animés" || widget.category == "Séries"
        ? widget.type == "Complete" ? 5 : 4
        : widget.type == "Complete" ? 4 : 3;

    bool end = JsonData().films_com.isEmpty && JsonData().films_qad.isEmpty &&
        JsonData().series_com.isEmpty && JsonData().series_qad.isEmpty &&
        JsonData().animes_com.isEmpty && JsonData().animes_qad.isEmpty &&
        JsonData().jeux_qad.isEmpty && JsonData().jeux_com.isEmpty;

    Widget hintButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: contours[widget.category],
                width: 2.0,
              ),
            ),
            child: InkWell(
                onTap: () {
                  setState(() {
                    indice++;
                    indice > rep ? indice = rep : indice = indice;
                    if (indice >= rep) {
                      _controller.forward();
                    }
                  });
                },
                child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: fonds[widget.category],
                    child: SvgPicture.asset("assets/help_circle.svg", fit: BoxFit.cover,)
                )
            )
        ),

        SizedBox(width: 250, height: 70,),

        Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                color: contours[widget.category],
                width: 2.0,
              ),
            ),
            child: InkWell(
                onTap: () {
                  setState(() {
                    showRep = !showRep;

                    if (indice >= rep || showRep) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  });
                },
                child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: fonds[widget.category],
                    child: SvgPicture.asset(indice >= rep || showRep
                        ? "assets/lightbulb_off.svg"
                        : "assets/lightbulb.svg",
                      fit: BoxFit.cover,)
                )
            )
        ),
      ],
    );

    Widget validButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(
                color: Color.fromARGB(255, 255, 0, 0),
                width: 5.0,
              ),
            ),
            child: InkWell(
                onTap: () {
                  JsonData().addScore(0);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScorePage(end: JsonData().end),
                    ),
                  );
                },
                child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Color.fromARGB(150, 255, 0, 0),
                    child: SvgPicture.asset("assets/x.svg",
                      fit: BoxFit.cover,)
                )
            )
        ),

        SizedBox(width: 190),

        Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(
                color: Color.fromARGB(255, 0, 255, 0),
                width: 5.0,
              ),
            ),
            child: InkWell(
                onTap: () {
                  JsonData().addScore(15-3*indice);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScorePage(end: JsonData().end),
                    ),
                  );
                },
                child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Color.fromARGB(150, 0, 255, 0),
                    child: SvgPicture.asset("assets/check.svg",
                      fit: BoxFit.cover,)
                )
            )
        ),
      ],
    );

    Widget portraitView = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          hintButton,

          SizedBox(height: 30),

          Container(
              width: 350,
              height: h <= 225 ? h+rect : 225+rect,
              decoration: BoxDecoration(
                color: fonds[widget.category],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: contours[widget.category],
                  width: 3.0,
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),

                    Container(
                      width: 300,
                      height: h <= 225 ? h : 225,
                      child: h <= 215 ? Text("Citation :\n${widget.citation['citation']}", style: myStyle)
                          : ListView.builder(
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Text("Citation :\n${widget.citation['citation']}", style: myStyle);
                        },

                      ),
                    ),

                    SizedBox(height: 15),

                    Container(
                        width: 300,
                        height: 20,
                        child: Visibility(
                            visible: indice >= 1,
                            child: Text("Date : ${widget.citation['date'].toString()}", style: myStyle)
                        )
                    ),

                    SizedBox(height: 15),

                    Container(
                        width: 300,
                        height: 20 + 20*widget.citation['titre'].length/36,
                        child: Visibility(
                            visible: indice >= 2,
                            child: Text("Titre : ${widget.citation['titre']}", style: myStyle)
                        )
                    ),

                    widget.category == "Animés" || widget.category == "Séries"
                        ? episode
                        : SizedBox(height: 15),

                    widget.type == "Complete"
                        ? personnage
                        : SizedBox(height: 15),

                    Opacity(
                      opacity: _opacityTween.value,
                      child: Container(
                          width: 300,
                          height: 40+20*(widget.citation['réponse'].length + widget.citation['titre'].length)/36,
                          color: fonds[widget.category],
                          child: Text("Réponse : \n${widget.citation['réponse']}, ${widget.citation['titre']} (${widget.citation['date']})",
                            style: myStyle,)
                      ),
                    )
                  ]
              )
          ),

          SizedBox(height: 30),

          validButton
        ],
      ),
    );

    Widget landscapeView = Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 350,
                  height: h <= 125 ? h+50 : 175,
                  decoration: BoxDecoration(
                    color: fonds[widget.category],
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: contours[widget.category],
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 25),

                        Container(
                          width: 300,
                          height: h <= 125 ? h : 125,
                          child: h <= 215 ? Text("Citation :\n${widget.citation['citation']}", style: myStyle)
                              : ListView.builder(
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return Text("Citation :\n${widget.citation['citation']}", style: myStyle);
                            },

                          ),
                        ),
                      ]
                  )
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                          color: Color.fromARGB(255, 255, 0, 0),
                          width: 5.0,
                        ),
                      ),
                      child: InkWell(
                          onTap: () {
                            JsonData().addScore(0);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ScorePage(end: JsonData().end),
                              ),
                            );
                          },
                          child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Color.fromARGB(150, 255, 0, 0),
                              child: SvgPicture.asset("assets/x.svg",
                                fit: BoxFit.cover,)
                          )
                      )
                  ),

                  SizedBox(width: 15),

                  Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                          color: Color.fromARGB(255, 0, 255, 0),
                          width: 5.0,
                        ),
                      ),
                      child: InkWell(
                          onTap: () {
                            JsonData().addScore(15-3*indice);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ScorePage(end: JsonData().end),
                              ),
                            );
                          },
                          child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Color.fromARGB(150, 0, 255, 0),
                              child: SvgPicture.asset("assets/check.svg",
                                fit: BoxFit.cover,)
                          )
                      )
                  ),

                  SizedBox(width: 60,),

                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: contours[widget.category],
                          width: 2.0,
                        ),
                      ),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              indice++;
                              indice > rep ? indice = rep : indice = indice;
                              if (indice >= rep) {
                                _controller.forward();
                              }
                            });
                          },
                          child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: fonds[widget.category],
                              child: SvgPicture.asset("assets/help_circle.svg", fit: BoxFit.cover,)
                          )
                      )
                  ),

                  SizedBox(width: 15),

                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: contours[widget.category],
                          width: 2.0,
                        ),
                      ),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              showRep = !showRep;

                              if (indice >= rep || showRep) {
                                _controller.forward();
                              } else {
                                _controller.reverse();
                              }
                            });
                          },
                          child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: fonds[widget.category],
                              child: SvgPicture.asset(indice >= rep || showRep
                                  ? "assets/lightbulb_off.svg"
                                  : "assets/lightbulb.svg",
                                fit: BoxFit.cover,)
                          )
                      )
                  ),
                ],
              )
            ],
          ),

          SizedBox(width: 20,),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350,
                height: rect <= 225 ? rect : 225,
                decoration: BoxDecoration(
                    color: fonds[widget.category],
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: contours[widget.category],
                      width: 3.0,
                    ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),

                    Container(
                        width: 300,
                        height: 20,
                        child: Visibility(
                            visible: indice >= 1,
                            child: Text("Date : ${widget.citation['date'].toString()}", style: myStyle)
                        )
                    ),

                    SizedBox(height: 15),

                    Container(
                        width: 300,
                        height: 20 + 20*widget.citation['titre'].length/36,
                        child: Visibility(
                            visible: indice >= 2,
                            child: Text("Titre : ${widget.citation['titre']}", style: myStyle)
                        )
                    ),

                    widget.category == "Animés" || widget.category == "Séries"
                        ? episode
                        : SizedBox(height: 15),

                    widget.type == "Complete"
                        ? personnage
                        : SizedBox(height: 15),

                    Opacity(
                      opacity: _opacityTween.value,
                      child: Container(
                          width: 300,
                          height: 40+20*(widget.citation['réponse'].length + widget.citation['titre'].length)/36,
                          color: fonds[widget.category],
                          child: Text("Réponse : \n${widget.citation['réponse']}, ${widget.citation['titre']} (${widget.citation['date']})",
                            style: myStyle,)
                      ),
                    )
                  ],

                )
              )
            ],
          )
        ],
      ),
    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.type == "Complete" ? "Complète la citation": "Qui a dit cette citation ?"),
        automaticallyImplyLeading: false,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? portraitView
              : landscapeView;
        },
      )
    );
  }

}