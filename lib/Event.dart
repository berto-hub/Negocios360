import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Opportunity.dart';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'wall.dart';
//import 'package:address_search_field/address_search_field.dart';

class DetailEventPage extends StatefulWidget{

  Map event;
  List myProfile;
  DetailEventPage(this.event, this.myProfile);

  @override
  Event createState() => Event();
}

class Event extends State<DetailEventPage>{

  Map event = {};
  String id = "";
  //List opportunities = [];
  List idProfiles = [];
  List profiles = [];

  bool exist = false;
  String assist = "Asistir";

  getEvent() async {
    Map e = widget.event;
    setState(() {
      event = e;
    });
    print(event);
  }

  updateAssistants1(String id) async {
    var response = await http.put(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/assistantsUpdate/${event["id"]}'), 
      body: ({
        'assistants': widget.event["assistants"] + id + "/",
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      Navigator.pop(context, true);
    }else{
      debugPrint("Invalid Credentials");
    }
  }

  updateAssistants2() async {
    List assis = event["assistants"].split("/");
    bool res = assis.remove(widget.myProfile[0]["id"]);
    print(assis);

    String newAssis = "";
    for(int i=0; i<assis.length; i++){
      newAssis += "${assis[i]}/";
    }
    if(newAssis == "/"){
      newAssis = "";
    }
    print(newAssis);

    var response = await http.put(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/assistantsUpdate/${event["id"]}'), 
      body: ({
        'assistants': newAssis,
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      Navigator.pop(context, true);
    }else{
      debugPrint("Invalid Credentials");
    }
  }

  int getAssistants(){
    int assistants = 0;

    List assis = event["assistants"].split("/");
    assistants = assis.length - 1;
    print(assis);

    return assistants; 
  }

  /*getOpportunities() async {
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunityOffer/${offer["id"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      opportunities = data["opportunity"];
      for(int i=0; i<opportunities.length; i++){
        idProfiles.add(opportunities[i]["idUser"]);
      }
    });
    print(opportunities);
    getProfile(idProfiles);
  }*/

  /*getProfile(List id) async {
    for(int i=0; i<opportunities.length; i++){
      //idProfiles.add(opportunities[i]["idUser"]);
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${id[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        profiles.add(data["profile"]);
      });
    }
    print(profiles);

    getBlock();
  }*/

  /*Map m = {};
  List block = [];

  Future<Map> getOppors(int index) async{
    return opportunities[index];
  }

  Future<void> getBlock() async{
    //print("Madreee          ${widget.user}");
    setState(() {
      for(int i=0; i<opportunities.length; i++){
        m = {
          'user': profiles[i]["name"],
          'name': opportunities[i]["name"],
          'description': opportunities[i]["description"],
        };
        print(m);
        block.add(m);
      }
    });
    print(block);
  }*/

  assistButton(){
    List assis = event["assistants"].split("/");

    for(int i=0; i<assis.length; i++){
      if(assis[i] == widget.myProfile[0]["id"]){
        exist = true;
      }
    }
    print(assis);
    print(exist);

    if(exist == true){
      setState((){
        assist = "No asistir";
      });
    }
  }

  getAssist(){
    if(assist == "Asistir"){
      setState(() {
        assist = "No asistir";
      });
    }else{
      setState(() {
        assist = "Asistir";
      });
    }
  }

  @override
  void initState(){
    super.initState();
    getEvent();
    assistButton();
    //getOpportunities();
  }

  @override
  Widget build(BuildContext context) {
    //print(opportunity);
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle del evento"),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: (){
            if(exist == false){
              if(assist == "No asistir"){
                updateAssistants1(widget.myProfile[0]["id"]);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return HomePage(widget.myProfile);
                    }
                  ),
                  (Route<dynamic> route) => false
                );
              }else{
                Navigator.pop(context);
              }
            }else{
              if(assist == "Asistir"){
                updateAssistants2();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return HomePage(widget.myProfile);
                    }
                  ),
                  (Route<dynamic> route) => false
                );
              }else{
                Navigator.pop(context);
              }
            }
          },
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Image(
                  image: NetworkImage(
                    event["image"]!=""?"${event["image"]}" : ""),
                  height: 200,
                  width: 200,
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(30),
                child: 
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        //padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "${event["title"]}",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        )
                      ),
                    ),
                    Container(//padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "${event["dateStart"]} - ${event["dateEnd"]}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          )
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "${event["description"]}"*10,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(3, 20, 5, 5),
                              child: Text(
                                exist == false ?
                                assist == "Asistir" ? 
                                "Asistentes:  " + "${getAssistants()}" :
                                "Asistentes:  " + "${getAssistants() + 1}" :
                                assist == "No asistir" ? 
                                "Asistentes:  " + "${getAssistants()}" :
                                "Asistentes:  " + "${getAssistants() - 1}",

                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ),
                          ),
                        ],
                      )
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            iconSize: 50,
                            icon: Icon(Icons.map_sharp),
                            onPressed: (){

                            },
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 120,
                            height: 50,
                            child: MaterialButton(
                              textColor: Colors.white,
                              color: Colors.blue.shade800,
                              child: Text(
                                "${assist}",
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: (){
                                getAssist();
                              },
                            ),
                          ),
                        ),
                      ]  
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}