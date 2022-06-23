import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/myOpportunities.dart';
import 'dart:async';
import 'dart:convert';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'rewardOpportunity.dart';

class DetailOpporSendedPage extends StatefulWidget{

  Future<Map> opportunity;
  String titleOffer;
  int index;
  DetailOpporSendedPage(this.index, this.opportunity, this.titleOffer);

  @override
  OpportunitySended createState() => OpportunitySended();
}

class OpportunitySended extends State<DetailOpporSendedPage>{

  Map opportunity = {};
  String id = "";
  String state = "";
  bool pendiente = false;
  bool changeState = false;

  getOpportunity() async {
    Map oppor = await widget.opportunity;
    setState(() {
      opportunity = oppor;
    });
    print(opportunity);
  }

  /*getOffer() async {
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOffer/${opportunity["idOffer"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      offer = (data['offer']);
    });

    print(data);
    print("offer..........................................");
    print(offer);
  }*/

  updateState(String s) async {
    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/updateOpportunityState/${opportunity["id"]}'), 
      body: ({
        'state': s,
      }),
    );

    setState(() {
      state = s;
    });

    print(state);
    print(opportunity["id"]);
    //changeState = false;

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
    getOpportunity();
    //getOffer();
  }

  @override
  Widget build(BuildContext context) {
    //print(opportunity);
    return Listener(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detalle de la oportunidad"),
          backgroundColor: Colors.blue.shade800,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(
                context,
                [
                  widget.index,
                  state,
                  opportunity["id"]
                ]
              );
            },
            icon: Icon(Icons.arrow_back_ios)),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          alignment: Alignment.topCenter,
          child: Container(
            child: SingleChildScrollView(
              child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                        ),
                        width: MediaQuery.of(context).size.width * 0.37,
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(bottom: 3),
                              child: Text("De:",
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              ),
                            //Nombre del creador de la oportunidad:
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                opportunity["name"] == null?"":
                                "${opportunity["name"]}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(bottom: 3),
                              child: Text(
                                opportunity["date"] == null?"":
                                "${DateTime.parse(opportunity["date"].toString()).day}"+"/"+"${DateTime.parse(opportunity["date"]).month}"+"/"+"${DateTime.parse(opportunity["date"]).year}"
                              )
                            ),
                          ],
                        )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100
                        ),
                        width: MediaQuery.of(context).size.width * 0.37,
                        height: MediaQuery.of(context).size.width * 0.20,
                        child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Text(
                                  "Contacto:",
                                  style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Text(
                                  opportunity["telephone"] == null?"":
                                  "${opportunity["telephone"]}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              /*Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Text(
                                  opportunity["telephone"] == null?"":
                                  "${opportunity["telephone"]}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),*/
                            ],
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Icon(
                          Icons.message,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: 
                            Text(
                              opportunity["description"] == null?"":
                              "${opportunity["description"]}",
                              style: TextStyle(
                                color: Color(0xff1B2434), 
                                fontSize: 15,
                                fontFamily: 'roboto',
                              ),
                            )
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                        ),
                        width: MediaQuery.of(context).size.width * 0.37,
                        height: MediaQuery.of(context).size.width * 0.20,
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Text("Oferta:",
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Text(
                                widget.titleOffer == null?"":
                                "${widget.titleOffer}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ]
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                        ),
                        width: MediaQuery.of(context).size.width * 0.37,
                        height: MediaQuery.of(context).size.width * 0.20,
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: 
                                Text(
                                  "Estado:",
                                  style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                                )
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child:
                                  Text(
                                    changeState == true? "${state}":
                                    opportunity["state"] == null?"":
                                    "${opportunity["state"]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ),
                          ],
                        )
                      ),
                    ],
                  ),
                  //getButtonState(),
                ],
              )
              )
            ),
          )
        )
      ),
    );
  }

  Widget buttonState(){
    i = j;
    return Row(
      children: [
        TextButton(
          onPressed: (){
            changeState = true;
            //getInProcess();
            i++;
            j++;
            state = states[j];
          }, 
          child: changeState == true ? 
            Text("${nameButtonState1[i]}") : nameState(),
        ),
      ],
    );
  }

  Widget nameState(){
    if(opportunity["state"] == "Pendiente"){
      return Text("Aceptar",
        style: TextStyle(
          color: Colors.white
        ),
      );
    }
    if(opportunity["state"] == "En proceso"){
      return Text("Contratar",
        style: TextStyle(
          color: Colors.white
        ),
      );
    }
    if(opportunity["state"] == "Contratada"){
      return Text("Recompensar",
        style: TextStyle(
          color: Colors.white
        ),
      );
    }
    return Text("");
  }

  List<String> nameButtonState1 = 
    ["Aceptar", "Contratar", "Recompensar", "Archivar", "Desarchivar"];
  
  List<String> states = 
    ["Pendiente", "En proceso", "Contratada", "Recompensada", "Archivada", "Desarchivada", "Cancelada"];
  int i = 0, j = 0;
  String nameButton = "";

  int getIndex(){
    int index = 0;
    setState(() {
      
    
    if(opportunity["state"] == "Pendiente"){
      //setState((){
        index = 0;
      //});
    }
    if(opportunity["state"] == "En proceso"){
      //setState((){
        index = 1;
      //});
    }
    if(opportunity["state"] == "Contratada"){
      //setState(() {
        index = 2;
      //});
    }
    });
    return index;
  }

  int pulsed = 0;
  int index = 0;

  Widget getButtonState(){

    /*if(opportunity["state"] == "Recompensada"){
      setState(() {
        i = 3;
        j = 3;
      });
    }
    if(opportunity["state"] == "Archivada"){
      setState(() {
        i = 4;
        j = 4;
      });
    }
    /*if(opportunity["state"] == states[5]){
      setState(() {
        i = 3;
      });
    }
    if(opportunity["state"] == states[6]){
      setState(() {
        i = 3;
      });
    }*/*/
    //String nameButton = nameButtonState1[i];
    index = getIndex();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextButton(
          onPressed:(){
            setState(() {
              changeState = true;
              //getInProcess();
              i++;
              j++;
              state = states[j + index];
              //nameButton = nameButtonState1[i];
            });
            
            print(getIndex());
            print("i: " "${i}" + " j: " + "${j}");
            /*if(state == "Recompensada"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return RewardPage(opportunity);
                  }
                )
              );
            }*/
            updateState(state);
          }, 
          child: Text("${nameButtonState1[i + index]}",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
        ),

        TextButton(
          onPressed: (){
            setState(() {
              changeState = true;
              state = "Cancelada";
            });
            getButtonState();
            updateState(state);
          }, 
          child: Text("Cancelar"),
        ),
      ],
    );
    /*if(opportunity["state"] == "Contratada" || state == "Contratada"){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextButton(
            onPressed: (){
              setState(() {
                changeState = true;
                state = "Recompensada";
              });
              
              updateState(state);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return RewardPage(opportunity["idUser"]);
                  }
                )
              );
            }, 
            child: Text("Recompensar",
              style: TextStyle(
                color: Colors.white
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
          ),
          TextButton(
            onPressed: (){
              state = "Cancelada";
              updateState(state);
            }, 
            child: Text("Cancelar"),
          ),
        ],
      );
    }
    if(opportunity["state"] == "Recompensada" || opportunity["state"] == "Cancelada" 
    || state == "Recompensada" || state == "Cancelada"){
      return TextButton(
        onPressed: (){
          setState(() {
            changeState = true;
            state = "Archivada";
          });
          
          updateState(state);
        }, 
        child: Text("Archivar",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
      );
    }
    if(opportunity["state"] == "Archivada" || state == "Archivada"){
      return TextButton(
        onPressed: (){
          setState(() {
            changeState = true;
            state = "Recompensada";
          });
          
          updateState(state);
        }, 
        child: Text("Desarchivar",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
        ),
      );
    }*/
    //return Text("");
  }
}