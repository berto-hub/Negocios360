import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'dart:math';

class RewardPage extends StatefulWidget{

  Map opportunity;
  List profileData;
  RewardPage(this.opportunity, this.profileData);

  @override
  RewardOpportunity createState() => RewardOpportunity();
}

class RewardOpportunity extends State<RewardPage>{

  Map opportunity = {};
  String id = "";
  String state = "";
  bool pendiente = false;

  double reward = 0;
  var import = TextEditingController();
  var comment = TextEditingController();
  int stars = 0;

  Map profileData = {};
  String idUser = "";

  List<MaterialColor> star = [];
  var star1 = Colors.grey;
  var star2 = Colors.grey;
  var star3 = Colors.grey;
  var star4 = Colors.grey;
  var star5 = Colors.grey;

  Map offer = {};

  String idReward = "";

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String team = "";
  List teams = [];
  bool coincidence = false;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  getProfile() async {
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${widget.opportunity["idUser"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      profileData = data['profile'];
    });

    List myTeams = widget.profileData[0]["idTeam"].split("/");
    List otherTeams = profileData["idTeam"].split("/");
    int repeat = 0;

    print(profileData);
    print(myTeams);
    print(otherTeams);

    if(widget.profileData[0]["idTeam"] == ""){
      print("holi1");
      for(int i=0; i<otherTeams.length; i++){
        setState(() {
            repeat++;
            team = otherTeams[i];
            teams.add(otherTeams[i]);
          });
          
          print(repeat);
          print(team);
      }

      if(repeat > 1){
        setState(() {
          team = "";
          coincidence = true;
        });
      }

      print(data);
    }
    if(profileData["idTeam"] == ""){
      print("holi2");
      for(int i=0; i<myTeams.length; i++){
        setState(() {
            repeat++;
            team = myTeams[i];
            teams.add(myTeams[i]);
          });
          
          print(repeat);
          print(team);
      }

      if(repeat > 1){
        setState(() {
          team = "";
          coincidence = true;
        });
      }

      print(data);
    }else{
      print("holi3");
      for(int i=0; i<myTeams.length; i++){
        for(int j=0; j<otherTeams.length; j++){
          if(myTeams[i] == otherTeams[j]){
            setState(() {
              repeat++;
              team = myTeams[i];
              teams.add(myTeams[i]);
            });
            
            print(repeat);
            print(team);
          }
        }
      }

      if(repeat > 1){
        setState(() {
          team = "";
          coincidence = true;
        });
      }

      print(data);
    }
  }

  sendReward(String rewardUser) async {
    idUser = widget.opportunity["idUser"];
    String rew = "";
    //print(usersName['opportunities']);

    if(profileData['reward'] == ""){
      rew = rewardUser;
    }else{
      rew = profileData['reward'];
      rew = rew + "/" + rewardUser;
    }

    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/sendRewardUser/${idUser}'), 
      body: ({
        'reward': rew,
      }),
    );
    print(rewardUser);
    print(idUser);

    if(response.statusCode==204){
        debugPrint("Inserted correctly.");
        //updateEmailOpor(emailCont.text);

        //ScaffoldMessenger.of(context)
        //.showSnackBar(SnackBar(content: Text("Oportunity Sended.")));
        //Navigator.push(
          //context, MaterialPageRoute(builder: (context) => Second()));
      }else{
        debugPrint("Invalid Credentials");
        //ScaffoldMessenger.of(context)
        //.showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
  }

  int getStars(){
    int s = 0;
    for(int i=0; i<star.length; i++){
      if(star[i] == Colors.yellow){
        s++;
      }
    }

    return s;
  }

  createReward() async {
    reward = getImport(import.text);
    stars = getStars();
    //idUser = widget.opportunity["idUser"];
    print(stars);
    print(idReward);
    print(widget.profileData[0]["id"]);

    var response = await http.post(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createReward'), 
      body: ({
        'idReward': idReward,
        'idSender': widget.profileData[0]["id"],
        'idReceiver': widget.opportunity["idUser"],
        'reward': reward.toString(),
        'comment': comment.text,
        'stars': stars.toString(),
      }),
    );
    print(reward);
    print(idUser);

    sendReward(idReward);

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //updateEmailOpor(emailCont.text);

      //ScaffoldMessenger.of(context)
      //.showSnackBar(SnackBar(content: Text("Oportunity Sended.")));
      //Navigator.push(
        //context, MaterialPageRoute(builder: (context) => Second()));
    }else{
      debugPrint("Invalid Credentials");
      //ScaffoldMessenger.of(context)
      //.showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  setWall(String t) async {
    setState(() {
      coincidence = false;
    });
    var response = await http.post(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/setWall'), 
      body: ({
        'id': idReward,
        'idTeam': t,
        'type': 'reward',
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //updateEmailOpor(emailCont.text);

      //ScaffoldMessenger.of(context)
      //.showSnackBar(SnackBar(content: Text("Oportunity Sended.")));
      //Navigator.push(
        //context, MaterialPageRoute(builder: (context) => Second()));
    }else{
      debugPrint("Invalid Credentials");
      //ScaffoldMessenger.of(context)
      //.showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  @override
  void initState(){
    super.initState();
    idReward = getRandomString(10);
    getProfile();
    getOffer();

    star.add(star1);
    star.add(star2);
    star.add(star3);
    star.add(star4);
    star.add(star5);
  }

  @override
  Widget build(BuildContext context) {
    //print(opportunity);
    return Scaffold(
      appBar: AppBar(
        title: Text("Recompensar"),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
          child: SingleChildScrollView(
              child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Valora la experiencia con este usuario:",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 350,
                    height: 60,
                    child: TextField(
                      style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                      controller: import,
                      decoration: InputDecoration(
                        hintText: "Importe",
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  Text("Valora la experiencia con este usuario:",
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: (){
                            setState(() {
                              star[0] = Colors.yellow;
                              star[1] = Colors.grey;
                              star[2] = Colors.grey;
                              star[3] = Colors.grey;
                              star[4] = Colors.grey;
                            });
                          }, 
                          icon: Icon(Icons.star),
                          color: star[0],
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              star[0] = Colors.yellow;
                              star[1] = Colors.yellow;
                              star[2] = Colors.grey;
                              star[3] = Colors.grey;
                              star[4] = Colors.grey;
                            });
                          }, 
                          icon: Icon(Icons.star),
                          color: star[1],
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              star[0] = Colors.yellow;
                              star[1] = Colors.yellow;
                              star[2] = Colors.yellow;
                              star[3] = Colors.grey;
                              star[4] = Colors.grey;
                            });
                          }, 
                          icon: Icon(Icons.star),
                          color: star[2],
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              star[0] = Colors.yellow;
                              star[1] = Colors.yellow;
                              star[2] = Colors.yellow;
                              star[3] = Colors.yellow;
                              star[4] = Colors.grey;
                            });
                          }, 
                          icon: Icon(Icons.star),
                          color: star[3],
                        ),
                        IconButton(
                          onPressed: (){
                            setState(() {
                              star[0] = Colors.yellow;
                              star[1] = Colors.yellow;
                              star[2] = Colors.yellow;
                              star[3] = Colors.yellow;
                              star[4] = Colors.yellow;
                            });
                          }, 
                          icon: Icon(Icons.star),
                          color: star[4],
                        )
                      ],
                    ),
                  ),
                  
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Text("Comenta la experiencia:",
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15),
                          width: 350,
                          height: 60,
                          child: TextField(
                            style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                            controller: comment,
                            decoration: InputDecoration(
                              hintText: "Comentario de la valoración",
                              hintStyle: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: TextButton(
                      onPressed: (){
                        createReward();
                        if(coincidence == true){
                          for(int i=0;i<teams.length;i++){
                            setWall(teams[i]);
                          }
                        }else{
                          setWall(team);
                        }
                        Navigator.pop(context);
                      }, 
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text("Guardar",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(100, 40)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),
                      ),
                    ),
                  ),
                ],
              )
              )
            ),
          )
        ),
      )
    );
  }

  Future<void> getOffer() async{
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOffer/${widget.opportunity["idOffer"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      offer = data['offer'];
    });

    print(offer);
    print(data);
  }

  getImport(String rew){
    
    double writeReward = double.parse(rew);
    double initialReward = double.parse(offer["reward"]);
    double finalReward = 0;
    print(import.text);
    
    if(profileData["typeReward"] == "%"){
      finalReward = writeReward * (initialReward / 100);
    }else{
      if(writeReward >= initialReward){
        finalReward = initialReward;
      }else{
        finalReward = writeReward;
      }
    }

    print(finalReward);
    return finalReward;
  }
}