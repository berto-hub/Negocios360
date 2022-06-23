import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Drawer.dart';
import 'dart:async';
import 'dart:convert';
import 'Event.dart';
import 'Offer.dart';
import 'myChats.dart';
import 'myOffers.dart';
import 'myOpportunities.dart';
import 'myTeams.dart';
import 'searchUsers.dart';
import 'sendOportunity.dart';
import 'main.dart';
import 'myProfile.dart';
import 'myTeam.dart';
import 'package:intl/intl.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_storage/firebase_storage.dart';
//import 'dart:html';

class HomePage extends StatefulWidget{

  List profileData;
  HomePage(this.profileData);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  //Map data ;
  List usersData = [];
  List eventsData = [];
  List idEvents = [];
  List pData = [];
  List usersName = [];
  List idUsers = [];

  List rewards = [];

  List wall = [];
  List wallData = [];
  List walldata = [];

  var imCont = TextEditingController();
  var titCont = TextEditingController();
  var desCont = TextEditingController();
  var dSCont = TextEditingController();
  var dECont = TextEditingController();
  var addCont = TextEditingController();
  var coCont = TextEditingController();
  var telCont = TextEditingController();

  String imgNotFound = "https://comnplayscience.eu/app/images/notfound.png";
  ScrollController scroll = ScrollController();

  int countMoreOffers = 10;

  List<String> opportunities = [];
  List opportunityData = [];
  //List pData = [];
  
  List idOffers = [];
  List idRewards = [];
  List offers = [];
  
  List idSender = [];
  List idReceiver = [];
  List senders = [];
  List receivers = [];

  Map m = {};
  List block = [];
  List rew = [];

  int assistants = 0;

  nameUsers() async {
    for(int i=0;i<idUsers.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idUsers[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        data['profile']['id'] = idUsers[i];
        usersName.add(data['profile']);
      });

      print(data);
    }

    print(usersName);
  }

  Future<void> getWallAdmin() async {
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getWall'));
    Map data = json.decode(response.body);

    setState(() {
      wall = data['wall'];
      for(int i=0; i<wall.length; i++){
        if(wall[i]["type"] == "offer"){
          idOffers.add(wall[i]["idElement"]);
        }
        if(wall[i]["type"] == "reward"){
          idRewards.add(wall[i]["idElement"]);
        }
        if(wall[i]["type"] == "event"){
          idEvents.add(wall[i]["idElement"]);
        }//Arreglar lo del nombre de los eventos**************
        //Hacer clickable tanto las ofertas como los eventos****** 
      }
    });
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List idTeams = [];
  Future<void> getWall() async{
    idTeams = widget.profileData[0]["idTeam"].split("/");
    /*http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getWall/${idTeams}'));
    Map data = json.decode(response.body);*/
    //coger solo unos datos determinados:
    firestore
      .collection("wall")
      .where("idTeam", whereIn: idTeams)
      .orderBy("date", descending: true)
      .limit(10)
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            Map data = user.data()!;
            wall.add(user.data());
            print("Data" + "${data}");
            print("Data" + "${wall}");

            //for(int i=0; i<wall.length; i++){
              if(data["type"] == "offer"){
                idOffers.add(data["id"]);
              }
              if(data["type"] == "reward"){
                idRewards.add(data["id"]);
              }
              if(data["type"] == "event"){
                idEvents.add(data["id"]);
              }
              print(idOffers);
            //}
          });
        }
      }).then((value) => {
      getEvents().then((value) =>
      getOffers().then((value) => {
        nameUsers(),
        getRewards().then((value) => {
          getProfileSender(),
          getProfileReceiver(),
        })
        }
      )
      )
    });//dani@gmail.com hello123
    /*setState(() {
      wall = data['wall'];
      for(int i=0; i<wall.length; i++){
        if(wall[i]["type"] == "offer"){
          idOffers.add(wall[i]["idElement"]);
        }
        if(wall[i]["type"] == "reward"){
          idRewards.add(wall[i]["idElement"]);
        }
        if(wall[i]["type"] == "event"){
          idEvents.add(wall[i]["idElement"]);
        }//Arreglar lo del nombre de los eventos**************
        //Hacer clickable tanto las ofertas como los eventos****** 
      }
    });*/

    print("Id de los Elements y wall\n");
    print(idOffers);
    //getOffers(idOffers);
    print(idRewards);
    //getRewards(idRewards);
    print(idEvents);
    print(wall);
  }

  Future<void> getOffers() async {
    print(idOffers);
    usersData = [];
    //idUsers = [];
    for(int i=0; i<idOffers.length; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOfferId/${idOffers[i]}'));
      var data = json.decode(response.body);
      
      //coger solo unos datos determinados:
      setState(() {
        usersData.add(data['offer']);
        idUsers.add(usersData[i]["user"]);
      });
      print(data);
    }
    /*usersData.sort(
      (a, b) => b["date"].toString().compareTo(a["date"].toString())
    );*/
    print("Ofertas:");
    print(usersData);

    pData = widget.profileData;
    print(pData);
  }

  Future<void> getEvents() async {
    //print(idOffers);
    eventsData = [];
    idUsers = [];
    for(int i=0; i<idEvents.length; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getEventId/${idEvents[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        eventsData.add(data['event']);
        print(eventsData);
        idUsers.add(eventsData[i]["user"]);
      });
      print(data);
    }
    /*usersData.sort(
      (a, b) => b["date"].toString().compareTo(a["date"].toString())
    );*/
    print("Eventos:");
    print(eventsData);
  }

  /*getOpportunities() async {
    opportunities = pData[0]['opportunities'].split('/');
    print(opportunities);
    
    for(int i=0;i<opportunities.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunity/${opportunities[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        opportunityData.add(data['opportunity']);

        idOffers.add(opportunityData[i]["idOffer"]);
        idProfiles.add(opportunityData[i]["idUser"]);
      });

      print(data);
    }

    print(opportunityData);
    print(idOffers);
    getOffer(idOffers);
    getProfile(idProfiles);
  }*/

  /*getOffer(List id) async {
    for(int i=0;i<idOffers.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOffer/${id[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        offers.add(data['offer']);
      });

      print(data);
    }

    print(offers);
  }*/

  Future<void> getProfileSender() async {
    //senders = [];
    for(int i=0;i<idSender.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idSender[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        data['profile']['id'] = idSender[i];
        senders.add(data['profile']);
      });

      print(data);
    }

    print(senders);
  }

  Future<void> getProfileReceiver() async {
    //receivers = [];
    for(int i=0;i<idReceiver.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idReceiver[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        data['profile']['id'] = idReceiver[i];
        receivers.add(data['profile']);
      });

      print(data);
    }

    print(receivers);
  }

  Future<void> getRewards() async {
    rewards = [];
    idSender = [];
    idReceiver = [];
    print(idRewards);
    for(int i=0; i<idRewards.length; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getReward/${idRewards[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      print(data);
      setState(() {
        rewards.add(data['rewards']);
        idSender.add(rewards[i]["idSender"]);
        idReceiver.add(rewards[i]["idReceiver"]);
      });
    }

    //mery@gmail.com
    //hello345

    print("Rewards\n");
    print(rewards);
    //Future.delayed(Duration(microseconds: 100));
    walldata.addAll(usersData);
    walldata.addAll(rewards);
    walldata.addAll(eventsData);

    print(walldata);
    
    walldata.sort((a,b) {
      return a["date"].compareTo(b["date"]);
    });
    print("WallData\n");
    wallData = List.from(walldata.reversed);

    print("Walllllllllll");
    print(wallData);
  }

  /*Future<void> getBlock() async{
    //print("Madreee          ${widget.user}");
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      for(int i=0; i<usersData.length; i++){
        m = {
          'imageUser': usersName[i]["image"],
          'nameUser': usersName[i]["name"],
          'name': usersData[i]["title"],
          'image': usersData[i]["image"],
        };
        print(m);
        block.add(m);
      }
    });
    print(block);
  }*/

  bool update = false;
  bool morePos = false;

  @override
  void initState(){
    super.initState();
    if(widget.profileData[0]["role"] == "administrator"){
      getWallAdmin().then((value) => {
        getEvents().then((value) =>
        getOffers().then((value) => {
          nameUsers(),
          getRewards().then((value) => {
            getProfileSender(),
            getProfileReceiver(),
          })
          }
        )
        )
      }
      );
      scroll.addListener(() {
      if(scroll.position.pixels==scroll.position.maxScrollExtent && morePos == false){
        setState(() {
          morePos = true;
        });
        getMoreDataAdmin().then((value) => 
          getEvents().then((value) =>
          getOffers().then((value) => {
            nameUsers(),
            getRewards().then((value) => {
              getProfileSender(),
              getProfileReceiver(),
            })
          }
          )
          )
        );
        print("more data");
      }
      if(scroll.position.pixels==scroll.position.minScrollExtent){
        print("update data");
        setState(){
          update = true;
        };
      }
    });
    }else{
      getWall();

      scroll.addListener(() {
      if(scroll.position.pixels==scroll.position.maxScrollExtent && morePos == false){
        setState(() {
          morePos = true;
        });
        print("more data");
        getMoreData();/*.then((value) => 
          getEvents().then((value) =>
          getOffers().then((value) => {
            nameUsers(),
            getRewards().then((value) => {
              getProfileSender(),
              getProfileReceiver(),
            })
          }
          )
          )
        );*/
        
      }
      if(scroll.position.pixels==scroll.position.minScrollExtent){
        print("update data");
        setState(){
          update = true;
        };
      }
    });
    }
    /*.then((value) => {
      getEvents().then((value) =>
      getOffers().then((value) => {
        nameUsers(),
        getRewards().then((value) => {
          getProfileSender(),
          getProfileReceiver(),
        })
        }
      )
      )
    }
    );*/
    //nameUsers();
    //getBlock();
    /*scroll.addListener(() {
      if(scroll.position.pixels==scroll.position.maxScrollExtent && morePos == false){
        setState(() {
          morePos = true;
        });
        getMoreData().then((value) => 
          getEvents().then((value) =>
          getOffers().then((value) => {
            nameUsers(),
            getRewards().then((value) => {
              getProfileSender(),
              getProfileReceiver(),
            })
          }
          )
          )
        );
        print("more data");
      }
      if(scroll.position.pixels==scroll.position.minScrollExtent){
        print("update data");
        setState(){
          update = true;
        };
      }
    });*/
  }

  bool more = true;
  List moreData = [];
  List updateData = [];
  int indexMore = 1;

  Future<void> getMoreDataAdmin() async {
    int count = countMoreOffers * indexMore;

    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/showMoreWall/${count}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    idOffers = [];
    idRewards = [];
    idEvents = [];
    setState(() {
      moreData = data['wall'];
      //usersData.addAll(moreOffers);
      for(int i=0; i<moreData.length; i++){
        if(moreData[i]["type"] == "offer"){
          idOffers.add(moreData[i]["idElement"]);
        }
        if(moreData[i]["type"] == "reward"){
          idRewards.add(moreData[i]["idElement"]);
        }
        if(moreData[i]["type"] == "event"){
          idEvents.add(moreData[i]["idElement"]);
        }
      }
    });

    if(data == null){print("Nullllllllllllllllll");}
    print(moreData);
    print(idOffers);
    print(idRewards);
    //print(usersData);
    indexMore++;

    setState((){
      morePos = false;
    });
    
    /*setState(() {
      more = false;
    });*/
  }

  Future<void> getMoreData() async {
    int count = countMoreOffers * indexMore;
    
    var query = await firestore.collection('wall')
      .where("idTeam", whereIn: idTeams)
      .orderBy("date", descending: true);
    var documentSnapshot = await query.get();
    var lastDocument = documentSnapshot.docs[count-1];

    setState(() {
      idOffers = [];
      idRewards = [];
      idEvents = [];
      wall = [];
      indexMore++;
      morePos = false;
    });

    await query
      .startAfterDocument(lastDocument)
      .limit(10)
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            Map data = user.data()!;
            wall.add(user.data());
            print("Data" + "${data}");
            print("Data" + "${wall}");

            //for(int i=0; i<wall.length; i++){
              if(data["type"] == "offer"){
                idOffers.add(data["id"]);
              }
              if(data["type"] == "reward"){
                idRewards.add(data["id"]);
              }
              if(data["type"] == "event"){
                idEvents.add(data["id"]);
              }
              print(idOffers);
            //}
          });
        }
      }).then((value) => 
          getEvents().then((value) =>
          getOffers().then((value) => {
            nameUsers(),
            getRewards().then((value) => {
              getProfileSender(),
              getProfileReceiver(),
            })
          }
          )
          )
        );
    /*http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/showMoreWall/${masOfertas}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    idOffers = [];
    idRewards = [];
    idEvents = [];
    setState(() {
      moreData = data['wall'];
      //usersData.addAll(moreOffers);
      for(int i=0; i<moreData.length; i++){
        if(moreData[i]["type"] == "offer"){
          idOffers.add(moreData[i]["idElement"]);
        }
        if(moreData[i]["type"] == "reward"){
          idRewards.add(moreData[i]["idElement"]);
        }
        if(moreData[i]["type"] == "event"){
          idEvents.add(moreData[i]["idElement"]);
        }
      }
    });

    if(data == null){print("Nullllllllllllllllll");}
    print(moreData);
    print(idOffers);
    print(idRewards);
    //print(usersData);
    indexMore++;

    setState((){
      morePos = false;
    });*/
    
    /*setState(() {
      more = false;
    });*/
  }

  Future<void> getUpdateWallAdmin() async {
    print(wall[0]["id"] + ", " + wall[0]["idElement"]);
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/showUpdateWall/${wall[0]["id"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    updateData = [];
    idOffers = [];
    idRewards = [];
    idEvents = [];
    setState(() {
      updateData = data['wall'];
      for(int i=0; i<updateData.length; i++){
        if(updateData[i]["type"] == "offer"){
          idOffers.add(updateData[i]["idElement"]);
        }
        if(updateData[i]["type"] == "reward"){
          idRewards.add(updateData[i]["idElement"]);
        }
        if(updateData[i]["type"] == "event"){
          idEvents.add(updateData[i]["idElement"]);
        }
      }
      //usersData.addAll(moreOffers);
      for(int i=updateData.length-1; i>=0; i--){
        wall.insertAll(i, updateData);
      }
    });

    if(updateData == []){print("No hay datos nuevos.");}
    print(wall);
    
    /*setState(() {
      more = false;
    });*/
  }

  Future<void> getUpdateWall() async {
    var query = await firestore.collection('wall')
      .where("idTeam", whereIn: idTeams)
      .orderBy("date", descending: true);

    var idDoc;
    var firstDocument;

    setState(() {
      idOffers = [];
      idRewards = [];
      idEvents = [];
      wall = [];
    });

    var documentSnapshot = await query.get();
    Map data = {};
    documentSnapshot.docs.forEach((doc) => {
      data = doc.data(),
      print(doc.data()),
      print(doc.id),
      if(data["id"] == wallData[0]["idOffer"]){
          idDoc = data["id"],
          firstDocument = doc,
      }
    });
    print(wallData[0]["id"]);
    print(documentSnapshot);
    print(idDoc);
    print(firstDocument);//dani@gmail.com hello123
    
    await query
      .endBeforeDocument(firstDocument)
      .get()
      .then((result) {
        print("holi");
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            Map newData = user.data()!;
            //updateData.add(user.data());
            print(newData);
            wall.insert(0, user.data());

            print("Data" + "${newData}");
            print("Data" + "${wall}");

            //for(int i=0; i<wall.length; i++){
              if(newData["type"] == "offer"){
                idOffers.add(newData["id"]);
              }
              if(newData["type"] == "reward"){
                idRewards.add(newData["id"]);
              }
              if(newData["type"] == "event"){
                idEvents.add(newData["id"]);
              }
              print(idOffers);
            //}
            //for(int i=updateData.length-1; i>=0; i--){
            //wall.insert(0, updateData);
            //}
          });
        }
      }).then((value) => 
          getEvents().then((value) =>
          getOffers().then((value) => {
            nameUsers(),
            getRewards().then((value) => {
              getProfileSender(),
              getProfileReceiver(),
            })
          }
          )
          )
        );

    //int masOfertas = countMoreOffers * indexMore;
    /*print(wall[0]["id"] + ", " + wall[0]["idElement"]);
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/showUpdateWall/${wall[0]["id"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    updateData = [];
    idOffers = [];
    idRewards = [];
    idEvents = [];
    setState(() {
      updateData = data['wall'];
      for(int i=0; i<updateData.length; i++){
        if(updateData[i]["type"] == "offer"){
          idOffers.add(updateData[i]["idElement"]);
        }
        if(updateData[i]["type"] == "reward"){
          idRewards.add(updateData[i]["idElement"]);
        }
        if(updateData[i]["type"] == "event"){
          idEvents.add(updateData[i]["idElement"]);
        }
      }
      //usersData.addAll(moreOffers);
      for(int i=updateData.length-1; i>=0; i--){
        wall.insertAll(i, updateData);
      }
    });

    if(updateData == []){print("No hay datos nuevos.");}
    print(wall);*/
    
    /*setState(() {
      more = false;
    });*/
  }

  Future<void> updateFun() async{
    print("update data");

    if(widget.profileData[0]["role"] == "administrator"){
      getUpdateWallAdmin().then((value) => 
        getEvents().then((value) => {
          getOffers().then((value) => {
            nameUsers(),
            getRewards().then((value) => {
              getProfileSender(),
              getProfileReceiver(),
            })
          }
          )
        }
        )
      );
    }else{
      getUpdateWall()/*.then((value) => 
        getEvents().then((value) => {
          getOffers().then((value) => {
            nameUsers(),
            getRewards().then((value) => {
              getProfileSender(),
              getProfileReceiver(),
            })
          }
          )
        }
        )
      )*/;
    }
  }

  Stream<DocumentSnapshot> streamSnapshot(String conver) { 
    return FirebaseFirestore.instance.collection("users")
      .doc(widget.profileData[0]["id"])
      .snapshots();
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Muro'),
        backgroundColor: Colors.blue.shade800,
      ), 
      drawer: DrawerBlock(),
      body: Container(
        child: Column(
          children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade800
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text("QUÉ HAY DE NUEVO HOY", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold ,fontFamily: 'comfortaa',),),
          ),
        
          Flexible(
            child: RefreshIndicator(
              onRefresh: updateFun,
              child: ListView.builder(
                controller: scroll,
                itemCount: wallData == null ? 0 : wallData.length + 1,
                itemBuilder: (BuildContext context, int index){
                  if((index == wallData.length || update == true) && more == true){
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if(moreData == []){
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 50,
                        height: 50,
                        child: Text("No existen más elementos en el muro."),
                      ),
                    );
                  }
                  return 
                    Card(
                      child: 
                      wallData[index]["idEvent"] != null ?
                      listEvents(index) :
                      wallData[index]["idReward"] != null ?
                      listRewards(index) :
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor: const Color(0xFF778899),
                                  backgroundImage: NetworkImage(getImageUser(wallData[index]["user"])), // for Network image
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                                      child:Text(getNameUser(wallData[index]["user"]), style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold ,fontFamily: 'roboto',),),),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                                      child: Text(getDataUser(wallData[index]["user"]), style: TextStyle(color: Color(0xff303C50), fontSize: 12,fontFamily: 'roboto',),),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ),

  //**********************Crear ofertas, falta el date, melon****************************
                          
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Image.network(wallData[index]["image"]!=""?"${wallData[index]["image"]}" : imgNotFound),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: ListTile(
                              onTap: (){
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (BuildContext context){
                                      return DetailOfferPage(wallData[index], widget.profileData);
                                    }
                                  ),
                                );
                              },
                              title: Text("${wallData[index]["title"]}", style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontWeight: FontWeight.bold ,fontFamily: 'comfortaa',),),
                              subtitle: Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "${DateTime.parse(wallData[index]["date"]).day}"+"/"+"${DateTime.parse(wallData[index]["date"]).month}"+"/"+"${DateTime.parse(wallData[index]["date"]).year}",
                                  style: TextStyle(color: Color(0xff1B2434), fontSize: 14,fontFamily: 'roboto',),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                            child: Text(wallData[index]["description"].length <= 1000 ?
                              "${wallData[index]["description"]}" :
                              "${wallData[index]["description"]}".substring(0, 1000) + "...",
                              style: TextStyle(color: Color(0xff1B2434), fontSize: 13,fontFamily: 'roboto',),),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text("${wallData[index]["reward"]} ${wallData[index]["typeReward"]}", style: TextStyle(color: Color(0xff1B2434), fontSize: 12, fontWeight: FontWeight.bold , fontFamily: 'comfortaa',),),
                                MaterialButton(
                                  child: Container(
                                    child: Text("Enviar Oportunidad", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'roboto',),
                                    )
                                  ),
                                  color: Color(0xff1B2434),
                                  splashColor: Color(0xff303C50),
                                  onPressed: (){
                                    //print(getUser(wallData[index]["id"]));
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder: (BuildContext context){
                                          //getOfferId(wallData[index]["id"]);
                                          //print(getId(wallData[index]["idElement"]));
                                          print(wallData[index]);
                                          return SecondPage(
                                            getUser(wallData[index]["idOffer"]), 
                                            getId(wallData[index]["idOffer"]),
                                            pData,
                                          );
                                        }
                                      ),
                                    );
                                    //getOfferId(wallData[index]["id"]);
                                  },
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
            /*if(more == true)...[
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              ),
            )],*/
          ],
        ),
      ),
    );
  }

  String getUser(String id){
    String idUser = "";
    for(int i=0; i<usersData.length; i++){
      if(usersData[i]["idOffer"] == id){
        idUser = usersData[i]["user"];
      }
    }

    return idUser;
  }

  String getId(String id){
    String trueId = "";
    for(int i=0; i<usersData.length; i++){
      if(usersData[i]["idOffer"] == id){
        trueId = usersData[i]["id"];
      }
    }

    return trueId;
  }

  int getAssistants(String id){
    int assistants = 0;

    for(int i=0; i<eventsData.length; i++){
      if(eventsData[i]["idEvent"] == id){
        List assis = eventsData[i]["assistants"].split("/");
        assistants = assis.length - 1;
        print(assis);
      }
    }

    return assistants; 
  }

  Widget listRewards(int index) {
    return Container(
      padding: EdgeInsets.only(right: 20, bottom: 20, left: 20),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Text("¡Negocio cerrado con éxito!", style: TextStyle(color: Color(0xff1B2434), fontSize: 20, fontWeight: FontWeight.bold ,fontFamily: 'comfortaa',),),
          ),

          ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF778899),
              backgroundImage: NetworkImage(getImageSender(wallData[index]["idSender"])),
              radius: 25.0,
            ),
            title: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(getNameSender(wallData[index]["idSender"]),
                style: TextStyle(
                  color: Color(0xff1B2434),
                  fontFamily: 'comfortaa',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(2.0),
                  child: Text("Negocio cerrado",
                    style: TextStyle(
                      color: Color(0xff1B2434),
                      fontFamily: 'comfortaa',
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(2.0),
                  child: Text(getRewardSender(wallData[index]["idReward"]),
                    style: TextStyle(
                      color: Color(0xff1B2434),
                      fontFamily: 'comfortaa',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF778899),
              backgroundImage: NetworkImage(getImageReceiver(wallData[index]["idReceiver"])),
              radius: 25.0,
            ),
            title: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(getNameReceiver(wallData[index]["idReceiver"]),
                style: TextStyle(
                  color: Color(0xff1B2434),
                  fontFamily: 'comfortaa',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(2.0),
                  child: Text("Recompensa recibida",
                    style: TextStyle(
                      color: Color(0xff1B2434),
                      fontFamily: 'comfortaa',
                      fontSize: 12,
                    ),
                  ),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(2.0),
                  child: Text(getRewardReceiver(wallData[index]["idReward"]),
                    style: TextStyle(
                      color: Color(0xff1B2434),
                      fontFamily: 'comfortaa',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listEvents(int index){
    return Column(
      children: <Widget>[
        /*Container(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundColor: const Color(0xFF778899),
                backgroundImage: NetworkImage(getImageUser(wallData[index]["user"])), // for Network image
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                    child:Text(getNameUser(wallData[index]["user"]), style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold ,fontFamily: 'roboto',),),),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                    child: Text(getDataUser(wallData[index]["user"]), style: TextStyle(color: Color(0xff303C50), fontSize: 12,fontFamily: 'roboto',),),
                  ),
                ],
              )
            ],
          )
        ),*/
          
        Container(
          padding: EdgeInsets.all(20.0),
          child: Image.network(wallData[index]["image"]!=""?"${wallData[index]["image"]}" : imgNotFound),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: ListTile(
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return DetailEventPage(wallData[index], widget.profileData);
                  }
                ),
              );
            },
            title: Text("${wallData[index]["title"]}", style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontWeight: FontWeight.bold ,fontFamily: 'comfortaa',),),
            subtitle: Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "${wallData[index]["dateStart"]}"+" - "+"${wallData[index]["dateEnd"]}",
                style: TextStyle(color: Color(0xff1B2434), fontSize: 14,fontFamily: 'roboto',),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
          child: Text(
            wallData[index]["description"].length <= 1000 ?
            "${wallData[index]["description"]}" :
            "${wallData[index]["description"]}".substring(0, 1000) + "...",
            style: TextStyle(color: Color(0xff1B2434), fontSize: 12,fontFamily: 'roboto',),),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
          child: 
            Text("Asistentes al evento: ${getAssistants(wallData[index]["idEvent"])}",
              style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold , fontFamily: 'comfortaa',),),
        ),
      ],
    );
  }

  Future<void> sendOportunityUser(String id) async{
    print(id);
    //widget.profileData[]
    //usersData[id]["user"];
  }

  String getNameUser(String id){
    String name = "";
    for(int i=0; i<usersName.length; i++){
      if(usersName[i]["id"] == id){
        name = usersName[i]["name"];
      } 
    }
    return name;
  }
  String getNameSender(String id){
    String name = "";
    for(int i=0; i<senders.length; i++){
      if(senders[i]["id"] == id){
        name = senders[i]["name"];
      } 
    }
    return name;
  }
  String getNameReceiver(String id){
    String name = "";
    for(int i=0; i<receivers.length; i++){
      if(receivers[i]["id"] == id){
        name = receivers[i]["name"];
      } 
    }
    return name;
  }
  String getRewardSender(String id){
    String reward = "";
    for(int i=0; i<rew.length; i++){
      if(rew[i]["idReward"] == id){
        reward = rew[i]["reward"];
      } 
    }
    return reward;
  }
  String getRewardReceiver(String id){
    String reward = "";
    for(int i=0; i<rew.length; i++){
      if(rew[i]["idReward"] == id){
        reward = rew[i]["reward"];
      } 
    }
    return reward;
  }
  String getImageUser(String id){
    String image = "";
    for(int i=0; i<usersName.length; i++){
      if(usersName[i]["id"] == id){
        image = usersName[i]["image"];
      } 
    }
    return image;
  }
  String getImageSender(String id){
    String image = "";
    for(int i=0; i<senders.length; i++){
      if(senders[i]["id"] == id){
        image = senders[i]["image"];
      } 
    }
    return image;
  }
  String getImageReceiver(String id){
    String image = "";
    for(int i=0; i<receivers.length; i++){
      if(receivers[i]["id"] == id){
        image = receivers[i]["image"];
      } 
    }
    return image;
  }
  String getDataUser(String id){
    String data = "";
    for(int i=0; i<usersName.length; i++){
      if(usersName[i]["id"] == id){
        data = usersName[i]["businessName"];
      } 
    }
    return data;
  }

  var offer;
  Future<void> getOfferId(String id) async{
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOfferId/${id}'));
    var data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      offer = data['offer'];
    });
    //debugPrint(response.body);
    print(offer);
  }

  /*Future<String> getName(int index)async{
    http.Response response = await http.get(Uri.parse('http://localhost:5000/networking-360-5d7b7/us-central1/app/getProfile/${usersData[index]["id"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersName = data['profile'];
    });
    debugPrint(response.body);

    return usersName[0]["name"];
  }*/

  /*Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.blue,
      ), 
      body: Container(
        child: ListView.builder(
          itemCount: usersData == null ? 0 : usersData.length,
          itemBuilder: (BuildContext context, int index){
            return Card(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("${usersData[index]["title"]} ${usersData[index]["description"]}")
                  ),
                ],
              ),
            );
          }
        ),
      )
    );
  }*/

  /*Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: imCont,
                  decoration: InputDecoration(
                    labelText: "Image",
                    border: OutlineInputBorder(),
                  )
                ),
                TextFormField(
                  controller: titCont,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  )
                ),
                TextFormField(
                  controller: desCont,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  )
                ),
                TextFormField(
                  controller: dSCont,
                  decoration: InputDecoration(
                    labelText: "DateStart",
                    border: OutlineInputBorder(),
                  )
                ),
                TextFormField(
                  controller: dECont,
                  decoration: InputDecoration(
                    labelText: "DateEnd",
                    border: OutlineInputBorder(),
                  )
                ),
                TextFormField(
                  controller: addCont,
                  decoration: InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                  )
                ),
                TextFormField(
                  controller: coCont,
                  decoration: InputDecoration(
                    labelText: "Contact name",
                    border: OutlineInputBorder(),
                  )
                ),
                TextFormField(
                  controller: telCont,
                  decoration: InputDecoration(
                    labelText: "Telephone",
                    border: OutlineInputBorder(),
                  )
                ),
                OutlinedButton.icon(
                  onPressed: (){
                    createEvent();
                  }, 
                  icon: Icon(Icons.event, size: 18), 
                  label: Text("Create Event")
                ),
              ],))))
    );
  }*/

  Future<void> createEvent() async{
    if(coCont.text.isNotEmpty && desCont.text.isNotEmpty && imCont.text.isNotEmpty 
    && titCont.text.isNotEmpty && dSCont.text.isNotEmpty && dECont.text.isNotEmpty 
    && addCont.text.isNotEmpty && telCont.text.isNotEmpty){
      var response = await http.post(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createEvent'), 
        body: ({
          'image': imCont.text, 
          'title': titCont.text, 
          'description': desCont.text, 
          'dateStart': dSCont.text, 
          'dateEnd': dECont.text, 
          'address': addCont.text, 
          'contactName': coCont.text,
          'telephone': telCont.text,
        }),
      );

      if(response.statusCode==204){
        debugPrint("Inserted correctly.");
        debugPrint(titCont.text);
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Event Created.")));
        //Navigator.push(
          //context, MaterialPageRoute(builder: (context) => Second()));
      }else{
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    }else{
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Not Allowed")));
    }
  }

  Widget DrawerBlock(){
    return Drawer(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          color: Colors.blue.shade800,
          padding: EdgeInsets.all(40),
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage("${widget.profileData[0]["image"]}"),
                radius: 45.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 12, left: 10), 
                    child: Text("${widget.profileData[0]["name"]}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12, left: 10), 
                    child: Text("${widget.profileData[0]["email"]}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //Text("Menú"),
          
          /*decoration: BoxDecoration(
            color: Colors.blue.shade800,
          ),*/
        ),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.person),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Perfil"),
              ),
            ],
          ),
          
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context){
                  return ProfilePage(pData);
                }
              )
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        Ink(
          color: Colors.blue.shade200,
          child: ListTile(
            title: Row(
              children: [
                Icon(Icons.event),
                Padding(
                  padding: EdgeInsets.only(left: 11.0),
                  child: Text("Muro"),
                ),
              ],
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        ),

        widget.profileData[0]["role"] == "manager" || 
        widget.profileData[0]["role"] == "responsable" ||
        widget.profileData[0]["role"] == "administrator" ?
        ListTile(
          title: Row(
            children: [
              Icon(Icons.group),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Mis equipos"),
              ),
            ],
          ),
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context){
                  return TeamsPage(pData, );
                }
              )
            ).then(((value) => Navigator.pop(context)));
          },
        ) :
        ListTile(
          title: Row(
            children: [
              Icon(Icons.group),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Mi equipo"),
              ),
            ],
          ),
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context){
                  return TeamPage(pData, pData[0]["idTeam"]);
                }
              )
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.euro),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Mis ofertas"),
              ),
            ],
          ),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context){
                  return OfferPage(pData);
                }
              )
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.work),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Mis oportunidades"),
              ),
            ],
          ),
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context){
                  //getOpportunities();
                  //print("holiiiiii" + "${opportunityData}");
                  return OpportunityPage(pData);
                }
              )
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.person_search),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Buscar usuarios"),
              ),
            ],
          ),
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context){
                  //getOpportunities();
                  //print("holiiiiii" + "${opportunityData}");
                  return UserSearchPage(pData);
                }
              )
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.message),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Mensajes"),
              ),
            ],
          ),
          onTap: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context){
                  return ChatPage(pData);
                }
              )
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.door_front_door),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Cerrar sesión"),
              ),
            ],
          ),
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context){
                  return SignInPage();
                }
              ),
              (route) => false,
            );
          },
        ),
      ],
    ),
    );
  }
}

