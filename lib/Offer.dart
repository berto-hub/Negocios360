import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Opportunity.dart';
import 'editMyProfile.dart';
import 'createOffer.dart';

class DetailOfferPage extends StatefulWidget{

  Map offer;
  List profileData;
  DetailOfferPage(this.offer, this.profileData);

  @override
  Offer createState() => Offer();
}

class Offer extends State<DetailOfferPage>{

  Map offer = {};
  String id = "";
  List opportunities = [];
  List idProfiles = [];
  List profiles = [];

  getOffer() async {
    Map o = widget.offer;
    setState(() {
      offer = o;
    });
    print(offer);
  }

  getOpportunities() async {
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunityOffer/${offer["id"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    print(data);
    setState(() {
      opportunities = data["opportunity"];
      for(int i=0; i<opportunities.length; i++){
        idProfiles.add(opportunities[i]["idUser"]);
      }
    });
    print(opportunities);
    getProfile(idProfiles);
  }

  int count = 0;

  getMoreOpportunities() async {
    count = count + 5;
    
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/moreOpportunitiesOffer/${offer["id"]}/${count}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      idProfiles = [];
      opportunities = data["opportunity"];
      /*for(int i=0; i<data["opportunity"].length; i++){
        setState(() {
          opportunities.add(data["opportunity"][i]);
        });
      }*/
      for(int i=0; i<opportunities.length; i++){
        idProfiles.add(opportunities[i]["idUser"]);
      }
    });
    
    print(opportunities);
    getProfile(idProfiles);
  }

  getProfile(List id) async {
    profiles = [];
    for(int i=0; i<id.length; i++){
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
  }

  Map m = {};
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
  }

  @override
  void initState(){
    super.initState();
    getOffer();
    getOpportunities();
  }

  @override
  Widget build(BuildContext context) {
    //print(opportunity);
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de la oferta"),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          key: Key("Back"),
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image(
                  image: NetworkImage(
                    offer["image"]!=""?"${offer["image"]}" : ""),
                  height: 200,
                  width: 200,
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(20),
                child: 
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "${offer["title"]}",
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        )
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            "${offer["date"]}".substring(0, 10),
                            style:TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                          )
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                "${offer["description"]}",
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              )
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                "Recompensa: " + "${offer["reward"]}" + "${offer["typeReward"]}",
                                style: TextStyle(
                                  color: Color(0xff1B2434),
                                   fontFamily: 'roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ),
                          ),
                        ],
                      )
                    ),
                      
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: block.length == 0 ? 
                          Text(
                            "De momento no hay oportunidades generadas",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ) :
                          Text(
                            "Oportunidades generadas: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          )
                        ),
                      ),

                      block.length == 0 ? 
                      Text("") :
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: block == null ? 0 : block.length,
                        //scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index){
                          return Card(child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 2, 0, 2),
                              child: Text("${block[index]["user"]}",
                                style: TextStyle(
                                  color: Color(0xff1B2434),
                                  fontFamily: 'roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 2, 0, 2),
                                    child: Text("${block[index]["description"]}".length >= 30 ?
                                      "${block[index]["description"]}".substring(0, 30) + "..." : "${block[index]["description"]}",
                                      style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child:Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 2, 0, 2),
                                    child: Text("${block[index]["name"]}",
                                      style: TextStyle(
                                        color: Color(0xff1B2434), 
                                        fontSize: 15, 
                                        fontFamily: 'roboto',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context){
                                    return DetailOpporPage(0, widget.profileData, getOppors(index), offer["title"]);
                                  }
                                )
                              );
                            },
                          ),
                          );
                        }
                      ),

                      TextButton(
                        onPressed: (){
                          getMoreOpportunities();
                        },
                        child: Text("Mas oportunidades"))
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