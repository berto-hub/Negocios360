import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Opportunity.dart';
import 'OpportunitySended.dart';
import 'sendOportunity.dart';
import 'main.dart';
import 'myProfile.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class SendedOpporPage extends StatefulWidget{

  //List name;
  //List offer;
  //List user;
  List profileData;
  SendedOpporPage(this.profileData);

  @override
  OpporPageState createState() => OpporPageState();
}

class OpporPageState extends State<SendedOpporPage>{
  //Map data ;
  String idUser = "";
  List usersData = [];
  //List pData = [];
  
  List idOffers = [];
  List offers = [];
  
  List idProfiles = [];
  List profiles = [];
  
  String empty = "No existen oportunidades";
  String a = "Aceptada";
  String b = "No aceptada";

  Map m = {};
  List block = [];

  var searchView = TextEditingController();
  String query = "";
  bool firstSearch = true;

  int count = 0;
  String res = "";

  bool loading = false;

  Future<void> getOpportunities() async {
    idUser = widget.profileData[0]["id"];
    print(idUser);
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunityUser/${idUser}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersData = data['opportunity'];

      for(int i=0; i<usersData.length;i++){
        idOffers.add(usersData[i]["idOffer"]);
      //idProfiles.add(usersData[i]["idUser"]);
      }
    });

    /*setState(() {
      count = count + 3;
    });*/

    print(data);

    print(usersData);
    print(idOffers);
    //getOffer(idOffers);
  }

  Future<void>getMoreOpportunities() async {
    int c = 0;
    //block = [];
    usersData = [];
    count = count + 10;

    /*if((count + 3) >= usersData.length){
      c = usersData.length;
    }else{
      c = count + 3;
    }*/

    print("holi " + "${count}");

    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/moreOpportunitiesUser/${idUser}/${count}'));
    var data = json.decode(response.body);
    print(data);
    //coger solo unos datos determinados:
    setState(() {
      for(int i=0; i<data["opportunity"].length; i++){
        usersData.add(data['opportunity'][i]);
      }
      print(usersData);
      
      for(int i=0; i<usersData.length;i++){
        idOffers.add(usersData[i]["idOffer"]);
      //idProfiles.add(usersData[i]["idUser"]);
      }
    });

    print(data);

    /*setState(() {
      count = count + 3;
    });*/

    print(usersData);
    print(idOffers);
    print(idProfiles);
  }

  Future<void> getOffer() async {
    offers = [];
    for(int i=0;i<idOffers.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOffer/${idOffers[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        offers.add(data['offer']);
      });

      print(data);
    }

    idOffers = [];

    print(offers);
    //getBlock();
  }

  /*getProfile(List id) async {
    print(id);
    for(int i=0;i<idProfiles.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${id[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        profiles.add(data['profile']);
      });

      print(data);
    }

    print(profiles);
    if(profiles != [] && usersData != [] && offers != []){
      getBlock();
    }
  }*/

  Future<void> getBlock() async{
    //print("Madreee          ${widget.user}");
    //await Future.delayed(const Duration(seconds: 1));
    //block = [];
    setState(() {
      for(int i=0; i<usersData.length; i++){
        m = {
          'idOpor': usersData[i]["idOpor"],
          'name': usersData[i]["name"],
          'offer': offers[i]["title"],
          'state': usersData[i]["state"],
        };
        print(m);
        block.add(m);
      }
      loading = false;
    });
    print(block);
  }

  Map opportunity = {};

  Future<Map> getOpportunity(String id) async {
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunity/${id}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      opportunity = data['opportunity'];
    });
    print(data);
    print(response.body);
    //print(data['opportunity']);
    //print(opportunity);
    return opportunity;
  }

  List off = [];
  Future getOff(String id) async {
    off = [];
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOffer/${id}'));
    var data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      off.add(data['offer']);
    });

    print(data);
    print(off);
  }

  List bl = [];
  Future<void> Block() async{
    //await Future.delayed(const Duration(seconds: 1));
    setState(() {
      for(int i=0; i<filterOppors.length; i++){
        m = {
          'idOpor': filterOppors[i]["idOpor"],
          'name': filterOppors[i]["name"],
          'offer': off[i]["title"],
          'state': filterOppors[i]["state"],
        };
        print(m);
        bl.add(m);
      }
    });
    //block = [];
    //usersData = [];
    print(b);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List filterOppors = [];

  Future searchStateMayus(String state) {
    // code to convert the first character to uppercase
    String searchKey = ""; //state[0].toUpperCase() + state.substring(1);
    if(state[0] != state[0].toUpperCase()){
      searchKey = state[0].toUpperCase() + state.substring(1);
    }else{
      searchKey = state[0] + state.substring(1);
    }
    print(widget.profileData[0]["id"]);
    
    return firestore
      .collection("opportunities")
      .where("idUser", isEqualTo: widget.profileData[0]["id"])
      .orderBy("state")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> oppor in result.docs) {
          setState(() {
            filterOppors.add(oppor.data());
            print(oppor.data()!["idUser"]);
            print(oppor);
          });
          getOff(oppor.data()!["idOffer"]);
          //getProf(oppor.data()!["idUser"]);
        }

        print(filterOppors);
        return filterOppors;
      });
  }

Future searchStateMinus(String state) {
    // code to convert the first character to uppercase
    String searchKey = ""; //state[0].toUpperCase() + state.substring(1);
    if(state[0] != state[0].toLowerCase()){
      searchKey = state[0].toLowerCase() + state.substring(1);
    }else{
      searchKey = state[0] + state.substring(1);
    }
    
    return firestore
      .collection("opportunities")
      .where("idUser", isEqualTo: widget.profileData[0]["id"])
      .orderBy("state")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> oppor in result.docs) {
          setState(() {
            filterOppors.add(oppor.data());
            print(oppor.data()!["idUser"]);
            print(oppor);
          });
          getOff(oppor.data()!["idOffer"]);
          //getProf(oppor.data()!["idUser"]);
        }

        print(filterOppors);
        return filterOppors;
      });
  }

  OpporPageState(){
    searchView.addListener(() {
      if(searchView.text.length != res.length){
        setState(() {
          firstSearch = false;
          filterOppors = [];
        });
      }
      if(searchView.text.isEmpty){
        setState(() {
          firstSearch = true;
          filterOppors = [];
          //query = "";
        });
      }/*else{
        setState(() {
          firstSearch = false;
          query = searchView.text;
        });
      }*/
      if(searchView.text.isNotEmpty){
        setState(() {
          firstSearch = false;
          filterOppors = [];
        });
        //List oppors = widget.profileData[0]["opportunities"].split("/");
        //for(int i=0; i<oppors.length; i++){
        if(searchView.text == "Recompensada"){
          searchStateMayus("Ya recompensada");
          searchStateMinus("Ya recompensada");
        }
        searchStateMayus(searchView.text);
        searchStateMinus(searchView.text);
        //}
      }
      if(searchView.text == "Todos"){
        setState(() {
          firstSearch = true;
          filterOppors = [];
        });
      }
    });
  }
  
  void moreData() {
    getMoreOpportunities().then((value) => 
      getOffer().then((value) =>  
        getBlock()
      )
    );
  }

  ScrollController scroll = ScrollController();

  @override
  void initState(){
    super.initState();
    setState(() {
      loading = true;
    });
    getOpportunities().then((value) => 
      getOffer().then((value) => 
        getBlock()));
    
    scroll.addListener(() {
      if(scroll.position.pixels >= scroll.position.maxScrollExtent){
        moreData();
        print("more data");
      }
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Oportunidades enviadas'),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        /*actions: <Widget>[
          /*IconButton(
            onPressed: (){
              searchBar(context);
            }, 
            icon: Icon(Icons.search)
          ),
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.settings)
          ),*/

          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ],*/
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            CreateSearchView(),
            loading == true ? 
            Center(
              child: Container(
                padding: EdgeInsets.all(5),
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ) : 
            firstSearch ? CreateListView() : performSearch(),

            /*TextButton(
              onPressed: (){
                moreData();
              },
              child: Text("More data")
            ),*/

            loading == false ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonTheme(
                  height: 200,
                  child: OutlinedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_left,
                      size: 20,
                      color: Colors.white,
                    ), 
                    label: Text("Recibidos",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                ButtonTheme(
                  height: 200,
                  child: OutlinedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),
                    ),
                    onPressed: (){
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return SendedOpporPage(
                              widget.profileData
                            );
                          }
                        )
                      );*/
                    }, 
                    icon: Icon(
                      Icons.arrow_right,
                      size: 20,
                      color: Colors.white,
                    ), 
                    label: Text("Enviados",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ) : Text(""),

            /*Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: OutlinedButton.icon(
                    onPressed: (){

                    }, 
                    icon: Icon(Icons.arrow_right, size: 18), 
                    label: Text("Recibidos")
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: OutlinedButton.icon(
                    onPressed: (){

                    }, 
                    icon: Icon(Icons.arrow_left, size: 18), 
                    label: Text("Enviados")
                  ),
                ),
              ],
            )*/
          ]
        )
      ),
      /*bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ButtonTheme(
            height: 200,
            child: OutlinedButton.icon(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_left, size: 20), 
              label: Text("Recibidos",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          ButtonTheme(
            height: 200,
            child: OutlinedButton.icon(
              onPressed: (){}, 
              icon: Icon(Icons.arrow_right, size: 20), 
              label: Text("Enviados",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),*/
    );
  }

  Widget ButtonPopUp(){
    return Container(
      //decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: PopupMenuButton<String>(
        color: Colors.lightBlue.shade50,
        icon: Icon(Icons.arrow_drop_down),
        onSelected: (String result){
          setState(() {
            res = result;
            searchView.text = result;
            filterOppors = [];
          });
          //searchState(result);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'Todos',
            child: Text('Todos'),
          ),
          PopupMenuItem<String>(
            value: 'Pendiente',
            child: Text('Pendiente'),
          ),
          PopupMenuItem<String>(
            value: 'En proceso',
            child: Text('En proceso'),
          ),
          PopupMenuItem<String>(
            value: 'No aceptada',
            child: Text('No aceptada'),
          ),
          PopupMenuItem<String>(
            value: 'Contratada',
            child: Text('Contratada'),
          ),
          PopupMenuItem<String>(
            value: 'Cancelada',
            child: Text('Cancelada'),
          ),
          PopupMenuItem<String>(
            value: 'Recompensada',
            child: Text('Recompensada'),
          ),
        ]
      ),
    );
  }

  Widget CreateSearchView(){
    return new Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Material(
              elevation: 2,
              shape: StadiumBorder(),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextField(
                  style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                  controller: searchView,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Buscar por estado",
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    suffixIcon: ButtonPopUp(),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),

          /*IconButton(
            onPressed: (){
              showPopup();
            },
            icon: Icon(Icons.arrow_drop_down),
          ),*/
        ],
      ),
    );
    /*return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 360,
            decoration: BoxDecoration(border: Border.all(width: 1.0)),
            child: TextField(
              controller: searchView,
              decoration: InputDecoration(
                hintText: "Buscar por estado",
                hintStyle: TextStyle(
                  color: Colors.grey
                ),
              ),
              textAlign: TextAlign.left,
            ),
          ),

          /*IconButton(
            onPressed: (){
              showPopup();
            },
            icon: Icon(Icons.arrow_drop_down),
          ),*/
          Container(
            decoration: BoxDecoration(border: Border.all(width: 1.0)),
            child: PopupMenuButton<String>(
              color: Colors.lightBlue.shade50,
              icon: Icon(Icons.arrow_drop_down),
              onSelected: (String result){
                setState(() {
                  searchView.text = result;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Todos',
                  child: Text('Todos'),
                ),
                PopupMenuItem<String>(
                  value: 'Pendiente',
                  child: Text('Pendiente'),
                ),
                PopupMenuItem<String>(
                  value: 'En proceso',
                  child: Text('En proceso'),
                ),
                PopupMenuItem<String>(
                  value: 'No aceptada',
                  child: Text('No aceptada'),
                ),
                PopupMenuItem<String>(
                  value: 'Contratada',
                  child: Text('Contratada'),
                ),
                PopupMenuItem<String>(
                  value: 'Cancelada',
                  child: Text('Cancelada'),
                ),
                PopupMenuItem<String>(
                  value: 'Recompensada',
                  child: Text('Recompensada'),
                ),
              ]
            ),
          )
        ],
      ),
    );*/
  }

  Widget CreateListView(){
    if(block == null){
      return CircularProgressIndicator();
    }
    return Flexible(
      child: ListView.builder(
      controller: scroll,
      itemCount: block == null ? 0 : block.length,
      itemBuilder: (BuildContext context, int index){
        if(index == block.length){
          return Center(
            child: Container(
              padding: EdgeInsets.all(5),
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        /*if (index == _photos.length - _nextPageThreshold) {
            fetchPhotos();
          }
          if (index == _photos.length) {
            if (_error) {
              return Center(
                  child: InkWell(
                onTap: () {
                  setState(() {
                    _loading = true;
                    _error = false;
                    fetchPhotos();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Error while loading photos, tap to try agin"),
                ),
              ));
            } else {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ));
            }
          }*/
        return Card(
          child: SingleChildScrollView(
            child: 
              Column(
                children: <Widget>[
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(6.0),
                        child: ListTile(
                        title: Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(bottom: 5.0),
                              alignment: Alignment.centerLeft,
                              child: Text("Facilitada por ${widget.profileData[0]["name"]}".length <= 20 ?
                                "Facilitada por ${widget.profileData[0]["name"]}" : "Facilitada por ${widget.profileData[0]["name"]}".substring(0, 20) + "...",
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 5.0),
                              alignment: Alignment.centerLeft,
                              child:Text(
                                "${block[index]["name"]}".length <= 20 ?
                                "${block[index]["name"]}" : "${block[index]["name"]}".substring(0, 20) + "...",
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 17, fontFamily: 'roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 5.0),
                              alignment: Alignment.centerLeft,
                              child:Text(
                                "${block[index]["offer"]}".length <= 20 ?
                                "${block[index]["offer"]}" : "${block[index]["offer"]}".substring(0, 20) + "...",
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          "${block[index]["state"]}".toUpperCase(),
                          style: TextStyle(color: Color(0xff1B2434), fontSize: 16, fontFamily: 'roboto',),
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context){
                                Future<Map> oppor = getOpportunity(block[index]["idOpor"]);
                                return DetailOpporSendedPage(
                                  index,
                                  oppor,
                                  block[index]["offer"],
                                );
                              }
                            )
                          ).then((value) => {
                            if(value[1] != ""){ //Pasando el indice al ir a la pagina Oportunity.dart
                              print(value),
                              setState((){
                                block[value[0]]["state"] = value[1];
                              })
                              /*for(int i=0; i<block.length; i++){
                                print(value),
                                if(block[i]["idOpor"] == value[1]){
                                  print("holi"),
                                  setState((){
                                    block[i]["state"] = value[0];
                                  })
                                }
                              }*/
                            /*setState(() => {
                                
                              opportunities = [],
                              usersData = [],
                              //List pData = [];
                              
                              idOffers = [],
                              offers = [],
                              
                              idProfiles = [],
                              profiles = [],

                              m = {},
                              block = [],
                              getOpportunities().then((value) => 
                                getOffer().then((value) => 
                                  getProfile().then((value) => 
                                    getBlock()
                                  )
                                )
                              ),
                              //CreateListView(),
                              
                              })*/
                          }});
                        },
                      ),
                    ),
                  ),
                ],
              )
            ),
          );
        }
      )
    );
  }

  /*Widget CreateListView(){
    return Flexible(child: ListView.builder(
      itemCount: block == null ? 0 : block.length,
      itemBuilder: (BuildContext context, int index){
        if(index == block.length){
          return Center(
            child: Container(
              padding: EdgeInsets.all(5),
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Card(
          child: SingleChildScrollView(
            child: 
              Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${widget.profileData[0]["name"]}",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Text(
                              "${block[index]["name"]}",
                              style: TextStyle(fontSize: 20)
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Text(
                              "${block[index]["offer"]}",
                              style: TextStyle(fontSize: 20)
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                      "${block[index]["state"]}",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              Future<Map> oppor = getOpportunity(block[index]["idOpor"]);
                              return DetailOpporPage(
                                index,
                                oppor,
                                block[index]["offer"],
                              );
                            }
                          )
                        );
                      },
                    ),
                  ),
                ],
              )
            ),
          );
        }
      )
    );
  }*/

  /*Widget performSearch() {
    Map filter = {};
    List filterList = [];
    for(int i=0; i<block.length; i++){
      String item = block[i]["state"];
      if(item.toLowerCase().contains(query.toLowerCase())){
        filter = {
          "idOpor": block[i]["idOpor"],
          "name": block[i]["name"],
          "offer": block[i]["offer"],
          "state": block[i]["state"],
        };
        filterList.add(filter);
      }
    }

    return Flexible(
      child: ListView.builder(
        itemCount: filterList == null ? 0 : filterList.length,
        itemBuilder: (BuildContext context, int index){
          if(index == filterList.length){
            return Center(
              child: Container(
                padding: EdgeInsets.all(5),
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Card(
            child: SingleChildScrollView(
              child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${widget.profileData[0]["name"]}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:Text(
                            "${filterList[index]["name"]}",
                            style: TextStyle(fontSize: 20)
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:Text(
                            "${filterList[index]["offer"]}",
                            style: TextStyle(fontSize: 20)
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                    "${filterList[index]["state"]}",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            Future<Map> oppor = getOpportunity(filterList[index]["idOpor"]);
                            return DetailOpporPage(
                              index,
                              oppor,
                              block[index]["offer"],
                            );
                          }
                        )
                      );
                    },
                  ),
                ),
              ],
            ),
            ),
          );
        }
      )
    );
  }*/

  Widget performSearch() {
    Map filter = {};
    List filterList = [];
    
    /*if(res == "Todos"){
      setState(() {
        firstSearch = true;
      });
    }else{
      /*for(int i=0; i<filterOppors.length; i++){
        
      }*/
      filterList = filterOppors;
    }*/

    /*for(int i=0; i<filterOppors.length; i++){
      else{
        filter = {
          "idOpor": filterOppors[i]["idOpor"],
          "user": block[i]["user"],
          "name": block[i]["name"],
          "offer": block[i]["offer"],
          "state": block[i]["state"],
        };
        filterList.add(filter);
      }
    }*/

    if(filterOppors == []){
      return Container(
        child: Text("No existen oportunidades con el estado ${res}")
      );
    }

    if(filterOppors.length != off.length){
      return Center(
        child: Container(
          padding: EdgeInsets.all(5),
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      );
    }

    int length = 0;

    /*if(off.length <= prof.length){
      length = off.length;
    }else{
      length = prof.length;
    }*/


    return Flexible(
      child: ListView.builder(
        //controller: scroll,
        itemCount: filterOppors.length,
        itemBuilder: (BuildContext context, int index){
          return Card(
            child: SingleChildScrollView(
              child: Column(
              children: <Widget>[
                Card( 
                  child: Container(
                    padding: EdgeInsets.all(6.0),
                    child: ListTile(
                      title: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Facilitada por ${widget.profileData[0]["name"]}".length <= 20 ?
                              "Facilitada por ${widget.profileData[0]["name"]}" : "Facilitada por ${widget.profileData[0]["name"]}".substring(0, 20) + "...",
                              style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            alignment: Alignment.centerLeft,
                            child:Text(
                              "${filterOppors[index]["name"]}".length <= 20 ?
                              "${filterOppors[index]["name"]}" : "${filterOppors[index]["name"]}".substring(0, 20) + "...",
                              style: TextStyle(color: Color(0xff1B2434), fontSize: 17, fontFamily: 'roboto',
                                fontWeight: FontWeight.bold,
                              )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            alignment: Alignment.centerLeft,
                            child:Text(
                              "${off[index]["title"]}".length <= 20 ?
                              "${off[index]["title"]}" : "${off[index]["title"]}".substring(0, 20) + "...",
                              style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                      "${filterOppors[index]["state"]}".toUpperCase(),
                        style: TextStyle(color: Color(0xff1B2434), fontSize: 16, fontFamily: 'roboto',),
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              Future<Map> oppor = getOpportunity(filterOppors[index]["idOpor"]);
                              return DetailOpporSendedPage(
                                index,
                                oppor,
                                off[index]["title"]
                              );
                            }
                          )
                        ).then((value) => {
                            if(value[1] != ""){ //Pasando el indice al ir a la pagina Oportunity.dart
                              print(value),
                              setState((){
                                block[value[0]]["state"] = value[1];
                              })
                            }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            ),
          );
        }
      )
    );
  }
}