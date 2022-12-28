import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'myChats.dart';
import 'myOffers.dart';
import 'mySendedOpportunities.dart';
import 'dart:async';
import 'dart:convert';
import 'Opportunity.dart';
import 'myTeam.dart';
import 'myTeams.dart';
import 'searchUsers.dart';
import 'sendOportunity.dart';
import 'main.dart';
import 'myProfile.dart';
import 'wall.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class OpportunityPage extends StatefulWidget{

  //List name;
  //List offer;
  //List user;
  List profileData;
  OpportunityPage(this.profileData);

  @override
  OpporPageState createState() => OpporPageState();
}

class OpporPageState extends State<OpportunityPage>{
  //Map data ;
  List<String> opportunities = [];
  List usersData = [];
  //List pData = [];
  
  List idOffers = [];
  List offers = [];
  
  List idProfiles = [];
  List profiles = [];

  Map m = {};
  List block = [];

  var searchView = TextEditingController();
  String query = "";
  bool firstSearch = true;

  bool loading = false;

  int count = 0;
  int countFin = 0;
  String res = "";

  Future<void> getOpportunities() async {
    opportunities = widget.profileData[0]['opportunities'].split('/');
    print(opportunities);
    print("holi: ${widget.profileData[0]}");
    
    List opporsReversed = opportunities.reversed.toList();
    print("Reversed: ${opporsReversed}");
    

    if(opportunities.length <= 10){
      count = opportunities.length;
    }else{
      count = 10;
    }
    
    for(int i=0;i<count;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunity/${opporsReversed[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        usersData.add(data['opportunity']);

        idOffers.add(usersData[i]["idOffer"]);
        idProfiles.add(usersData[i]["idUser"]);
      });

      print(data);
    }

    print(usersData);
    print(idOffers);
    //getOffer(idOffers);
    //getProfile(idProfiles);
  }

  Future<void>getMoreOpportunities() async {
    //int c = 0;
    //block = [];

    /*if((count + 3) >= opportunities.length){
      c = opportunities.length;
    }else{
      c = count + 3;
    }*/
    print(count);
    //int c = 2;//count

//Estooooooooooooooooooooooooooooooo********************************

    print("Antes");
    print(opportunities);
    /*setState(() {
      opportunities.removeRange(0, count);
    });*/
    /*print("Despues");
    print(opportunities);*/

    print("holi " + "${count}");
    print("holi " + "${countFin}");

    List opporsReversed = opportunities.reversed.toList();
    print("Reversed: ${opporsReversed}");

    if(opportunities.length > count){
      if(opportunities.length <= (count + 10)){
        countFin = opportunities.length;
      }else{
        countFin = count + 10;
      }
      print(usersData);
      print(opporsReversed[count]);
      for(int i=count; i<countFin; i++){
        print(opporsReversed[count]);
        http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunity/${opporsReversed[i]}'));
        var data = json.decode(response.body);
        
        setState(() {
          usersData.add(data['opportunity']);

          idOffers.add(usersData[i-count]["idOffer"]);
          idProfiles.add(usersData[i-count]["idUser"]);
        });
        print("Data of more data");
        print(usersData);
        print(idOffers);
        print(idProfiles);

        print(data);
      }

      if(opportunities.length <= (count + 10)){
        count = opportunities.length;
      }else{
        count = count + 10;
      }
    }else{
      usersData = [];
      idOffers = [];
      idProfiles = [];
    }

    print("Data of more data");
    print(usersData);
    print(idOffers);
    print(idProfiles);
  }

  Future<void>getOffer() async {
    offers = [];
    /*if(idOffers.length == 0){
      return;
    }*/
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
  }

  Future<void>getProfile() async {
    profiles = [];
    for(int i=0;i<idProfiles.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idProfiles[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        profiles.add(data['profile']);
      });

      print(data);
    }
    
    idProfiles = [];
    print(profiles);
    /*if(profiles != [] && usersData != [] && offers != []){
      getBlock();
    }*/
  }

  Future<void> getBlock() async{
    //await Future.delayed(const Duration(seconds: 1));
    print("Block");
    print(usersData.length);
    setState(() {
      for(int i=0; i<usersData.length; i++){
        m = {
          'idOpor': usersData[i]["idOpor"],
          'user': profiles[i]["name"],
          'name': usersData[i]["name"],
          'offer': offers[i]["title"],
          'state': usersData[i]["state"],
        };
        print(m);
        block.add(m);
      }
    });
    //block = [];
    usersData = [];
    loading = false;
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

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List prof = [];
  List idProf = [];
  Future getProf() async {
    prof = [];
    for(int i=0;i<idProf.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idProf[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        prof.add(data['profile']);
      });
    }

    //print(data);
    print(prof);

    //return data['profile'];
    /*return firestore
      .collection("users")
      .where("idUser", isEqualTo: id)
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            prof.add(user.data());
            print(user.data());
            print(user);
          });
        }
        return prof;
      });*/
  }

  List off = [];
  List idOff = [];
  Future getOff() async {
    off = [];
    for(int i=0;i<idOff.length;i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOffer/${idOff[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        off.add(data['offer']);
      });
    }

    //print(data);
    print(off);

    /*return firestore
      .collection("offers")
      .where("idOffer", isEqualTo: id)
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> offer in result.docs) {
          setState(() {
            off.add(offer.data());
            print(offer.data());
            print(offer);
          });
        }
        return off;
      });*/

    //return data['offer'];
  }

  List blockFilter = [];
  Future<void> Block() async{
    //await Future.delayed(const Duration(seconds: 1));
    setState(() {
      for(int i=0; i<filterOppors.length; i++){
        m = {
          'idOpor': filterOppors[i]["idOpor"],
          'user': prof[i]["name"],
          'name': filterOppors[i]["name"],
          'offer': off[i]["title"],
          'state': filterOppors[i]["state"],
        };
        print(m);
        blockFilter.add(m);
      }
    });
    //block = [];
    filterOppors = [];
    prof = [];
    off = [];
    idProf = [];
    idOff = [];
    loading = false;
    print(blockFilter);
  }

  /*Widget searchBar(BuildContext context) {
    return Autocomplete(
      //displayStringForOption: ,
      optionsBuilder: (TextEditingValue textEditingValue){
        if (textEditingValue.text == '') {
          return const Iterable.empty();
        }
        return block.where((option) {
          return option.toString().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (selection) {
        print('You just selected');
      },
    );
  }*/

  List filterOppors = [];
  int countSearch = 0;
  int countSea = 0;
  late Future<dynamic> search;

  Future searchState(String state) {
    // code to convert the first character to uppercase
    String searchKey = state[0].toUpperCase() + state.substring(1);
    /*if(state[0] != state[0].toUpperCase()){
      searchKey = state[0].toUpperCase() + state.substring(1);
    }else{
      searchKey = state[0] + state.substring(1);
    }*/
    List opporsReversed = opportunities.reversed.toList();
    print("Reversed: ${opporsReversed}");
    List oppors = [];
    
    if(opporsReversed.length <= 10){
      countSearch = 1;
      countSea = opporsReversed.length;
    }else{
      countSearch = 2;
      countSea = 10;
    }

    for(int i=0; i<countSea; i++){
      oppors.add(opporsReversed[i]);
    }

    int numOppors = 0;
    int num10 = 10;
    for(int i=0; i<opporsReversed.length; i++){
      if((i+1) == num10){
        numOppors++;
        num10 = num10 + 10;
      }
    }

    for(int i=0; i<numOppors; i++){
      //oppors.add(opporsReversed[i]);
      search = firestore
        .collection("opportunities")
        .where("idOpor", whereIn: oppors)
        .orderBy("state")
        .startAt([searchKey])
        .endAt([searchKey + "\uf8ff"])
        .get()
        .then((result) {
          for (DocumentSnapshot<Map<dynamic, dynamic>> oppor in result.docs) {
            setState(() {
              /*Map m = {
                'idOpor': oppor.data()!["idOpor"],
                'user': getProf(oppor.data()!["idUser"]),
                'name': oppor.data()!["name"],
                'offer': getOff(oppor.data()!["idOffer"]),
                'state': oppor.data()!["state"],
              };*/
              //print(m);
              filterOppors.add(oppor.data());
              idOff.add(oppor.data()!["idOffer"]);
              idProf.add(oppor.data()!["idUser"]);
              print(oppor.data());
              print(oppor);
            });
          //getOff(oppor.data()!["idOffer"]);
          //getProf(oppor.data()!["idUser"]);
          //getOff(oppor.data()!["idOffer"]);
          //getProf(oppor.data()!["idUser"]);
          }

          //print(filterOppors);
          return filterOppors;
        });
    }

    return search;
  }

  /*Future<List> searchStateMinus(String state) {
    // code to convert the first character to uppercase
    String searchKey;
    if(state[0] != state[0].toLowerCase()){
      searchKey = state[0].toLowerCase() + state.substring(1);
    }else{
      searchKey = state[0] + state.substring(1);
    }
    
    return firestore
      .collection("opportunities")
      .where("idOpor", whereIn: opportunities)
      .orderBy("state")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> oppor in result.docs) {
          setState(() {
            filterOppors.add(oppor.data());
            print(oppor);
          });
        }

        return filterOppors;
      });
  }*/

  OpporPageState(){
    searchView.addListener(() {
      if(searchView.text.length != res.length){
        setState(() {
          firstSearch = false;
          filterOppors = [];
          blockFilter = [];
        });
      }
      if(searchView.text.isEmpty){
        setState(() {
          firstSearch = true;
          filterOppors = [];
          blockFilter = [];
          //query = "";
        });
      }
      if(searchView.text.isNotEmpty){
        setState(() {
          firstSearch = false;
          filterOppors = [];
          blockFilter = [];
        });
        if(searchView.text == "Recompensada"){
          searchState("Ya recompensada").then((value) => 
            getProf().then((value) => 
              getOff().then((value) => 
                Block()
              )
            )
          );
        }
        searchState(searchView.text).then((value) => 
          getProf().then((value) => 
            getOff().then((value) => 
              Block()
            )
          )
        );
      }
      if(searchView.text == "Todos"){
        setState(() {
          firstSearch = true;
          filterOppors = [];
          blockFilter = [];
        });
      }/*else{
        setState(() {
          firstSearch = false;
          query = searchView.text;
        });
      }*/
    });
  }

  void moreData() {
    getMoreOpportunities().then((value) => 
      getOffer().then((value) => 
        getProfile().then((value) => 
          getBlock()
        )
      )
    );
  }

  ScrollController scroll = ScrollController();

  @override
  void initState(){
    super.initState();
    loading = true;
    getOpportunities().then((value) => 
      getOffer().then((value) => 
        getProfile().then((value) => 
          getBlock()
        )
      )
    );

    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        moreData();
        print("more data");
      }
    });
    //getBlock();
  }

  Stream<QuerySnapshot<Map>> streamSnapshot(String oppor) { 
    return FirebaseFirestore.instance.collection("opportunities")
      .where("idOpor", isEqualTo: oppor)
      .snapshots();
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis oportunidades'),
        backgroundColor: Colors.blue.shade800,
        actions: <Widget>[
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
          )
        ],
      ),
      drawer: DrawerBlock(),
      body: Container(
        child: Column(
          children: <Widget>[
            CreateSearchView(),
            
            loading == true ? 
            Container(
              padding: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(5),
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ) : 
            firstSearch ? CreateListView() : performSearch(),

            loading==false ?
            /*TextButton(
              onPressed: (){
                moreData();
              }, 
              child: Text("More data"),
            ) : Text(""),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ButtonTheme(
                  height: 200,
                  child: OutlinedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),
                    ),
                    onPressed: (){},
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return SendedOpporPage(
                              widget.profileData
                            );
                          }
                        )
                      );
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
              //]
            //)

            /*Container(
              child: 
            ),*/
          ]
        ),
      ),

      /*bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ButtonTheme(
            height: 200,
            child: OutlinedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),
              ),
              onPressed: (){},
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return SendedOpporPage(
                        widget.profileData
                      );
                    }
                  )
                );
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
      ),*/
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
          PopupMenuItem<String>(
            value: 'Archivada',
            child: Text('Archivada'),
          ),
        ]
      ),
    );
  }

  Future<void> showPopup() async {
    String? result = "";
    int? selectedRadio;
    int? value = 0;

    return showDialog<void>(
      context: context, 
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: const Text('Todos'),
                  leading: Radio(
                    groupValue: value,
                    value: 1,
                    activeColor: Colors.blue,
                    onChanged: (int? val) {
                      setState(() {
                        value = val;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('En proceso'),
                  leading: Radio(
                    groupValue: value,
                    value: 2,
                    activeColor: Colors.blue,
                    onChanged: (int? val) {
                      setState(() {
                        value = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                setState(() {
                  searchView.text = result.toString();
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ); 
      }
    );
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
                              child: Text("Facilitada por ${block[index]["user"]}".length <= 20 ?
                                "Facilitada por ${block[index]["user"]}" : "Facilitada por ${block[index]["user"]}".substring(0, 20) + "...",
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
                                return DetailOpporPage(
                                  index,
                                  widget.profileData,
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

  Widget performSearch() {
    //Map filter = {};
    //List filterList = [];
    
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

    /*if(filterOppors == []){
      return Container(
        child: Text("No existen oportunidades con el estado ${res}")
      );
    }

    if(filterOppors.length != off.length && 
    filterOppors.length != prof.length){
      return Center(
        child: Container(
          padding: EdgeInsets.all(5),
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      );
    }

    if(blockFilter.length != 0){
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

    if(off.length <= prof.length){
      length = off.length;
    }else{
      length = prof.length;
    }*/

    if(blockFilter == null){
      return CircularProgressIndicator();
    }
    return Flexible(
      child: ListView.builder(
        controller: scroll,
        itemCount: blockFilter == null ? 0 : blockFilter.length,
        itemBuilder: (BuildContext context, int index){
          /*if(index == blockFilter.length){
            return Center(
              child: Container(
                padding: EdgeInsets.all(5),
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );
          }*/
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
                              "Facilitada por ${blockFilter[index]["user"]}".length <= 20 ?
                              "Facilitada por ${blockFilter[index]["user"]}" : "Facilitada por ${blockFilter[index]["user"]}".substring(0, 20) + "...",
                              style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            alignment: Alignment.centerLeft,
                            child:Text(
                              "${blockFilter[index]["name"]}".length <= 20 ?
                              "${blockFilter[index]["name"]}" : "${blockFilter[index]["name"]}".substring(0, 20) + "...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1B2434), fontSize: 17, fontFamily: 'roboto',
                              )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            alignment: Alignment.centerLeft,
                            child:Text(
                              "${blockFilter[index]["offer"]}".length <= 20 ?
                              "${blockFilter[index]["offer"]}" : "${blockFilter[index]["offer"]}".substring(0, 20) + "...",
                              style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                      "${blockFilter[index]["state"]}".toUpperCase(),
                        style: TextStyle(color: Color(0xff1B2434), fontSize: 16, fontFamily: 'roboto',),
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              Future<Map> oppor = getOpportunity(blockFilter[index]["idOpor"]);
                              return DetailOpporPage(
                                index,
                                widget.profileData,
                                oppor,
                                blockFilter[index]["offer"]
                              );
                            }
                          )
                        ).then((value) => {
                            if(value[1] != ""){ //Pasando el indice al ir a la pagina Oportunity.dart
                              print(value),
                              setState((){
                                blockFilter[value[0]]["state"] = value[1];
                                searchView.text = value[1];
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
                    child:    Text("${widget.profileData[0]["name"]}",
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
                  return ProfilePage(widget.profileData);
                }
              ),
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        ListTile(
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
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context){
                  return HomePage(widget.profileData);
                }
              ),
              (Route<dynamic> route) => false
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        widget.profileData[0]["role"] == "manager"|| 
        widget.profileData[0]["role"] == "responsable"||
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
                  return TeamsPage(widget.profileData, );
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
                  return TeamPage(widget.profileData, widget.profileData[0]["idTeam"]);
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
                  return OfferPage(widget.profileData);
                }
              ),
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        Ink(
          color: Colors.blue.shade200,
          child: ListTile(
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
              Navigator.pop(context);
            },
          ),
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
                  return UserSearchPage(widget.profileData);
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
                  return ChatPage(widget.profileData);
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