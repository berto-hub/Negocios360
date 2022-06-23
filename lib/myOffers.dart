import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/myTeam.dart';
//import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'Offer.dart';
import 'createOffer.dart';
import 'myChats.dart';
import 'myOpportunities.dart';
import 'mySendedOpportunities.dart';
import 'dart:async';
import 'dart:convert';
import 'Opportunity.dart';
import 'myTeams.dart';
import 'searchUsers.dart';
import 'sendOportunity.dart';
import 'main.dart';
import 'myProfile.dart';
import 'wall.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class OfferPage extends StatefulWidget{

  //List name;
  //List offer;
  //List user;
  List profileData;
  OfferPage(this.profileData);

  @override
  OfferPageState createState() => OfferPageState();
}

class OfferPageState extends State<OfferPage>{
  //Map data ;
  List<String> opportunities = [];
  List usersData = [];
  //List pData = [];
  
  List idOffers = [];
  List offersData = [];
  
  List idProfiles = [];
  List profiles = [];

  Map m = {};
  List block = [];

  var searchView = TextEditingController();
  String query = "";
  bool firstSearch = true;
  String result = "";
  bool isLoading = false;
  ScrollController scroll = new ScrollController();

  int count = 0;

  getOffers() async{
    usersData = widget.profileData;
    setState(() {
      isLoading = true;
    });

    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOfferUser/${usersData[0]["id"]}'));
    var data = json.decode(response.body);
    print(data);
    //coger solo unos datos determinados:
    setState(() {
      offersData = data["offer"];
      isLoading = false;
    });
    print(offersData);
  }

  getMoreOffers() async{
    count = count + 10;
    
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/showMoreOffers/${usersData[0]["id"]}/${count}'));
    var data = json.decode(response.body);
    //coger solo unos datos determinados:
    for(int i=0; i<data["offer"].length; i++){
      setState(() {
        offersData.add(data["offer"][i]);
      });
    }
    
    //count = count + 10;
    print(offersData);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List filterOffers = [];

  Future<List> searchUsersMayus(String name) {
    // code to convert the first character to uppercase
    String searchKey;
    if(name[0] != name[0].toUpperCase()){
      searchKey = name[0].toUpperCase() + name.substring(1);
    }else{
      searchKey = name[0] + name.substring(1);
    }
    
    return firestore
      .collection("offers")
      .where("user", isEqualTo: usersData[0]["id"])
      .orderBy("title")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> offer in result.docs) {
          setState(() {
            filterOffers.add(offer.data());
            print(offer);
          });
        }

        return filterOffers;
      });
  }

  Future<List> searchUsersMinus(String name) {
    // code to convert the first character to uppercase
    String searchKey;
    if(name[0] != name[0].toLowerCase()){
      searchKey = name[0].toLowerCase() + name.substring(1);
    }else{
      searchKey = name[0] + name.substring(1);
    }
    
    return firestore
      .collection("offers")
      .where("user", isEqualTo: usersData[0]["id"])
      .orderBy("title")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> offer in result.docs) {
          setState(() {
            filterOffers.add(offer.data());
            print(offer.data());
          });
        }

        return filterOffers;
      });
  }

  OfferPageState(){
    searchView.addListener(() {
      /*if(searchView.text.isEmpty){
        setState(() {
          firstSearch = true;
          query = "";
        });
      }else{
        setState(() {
          firstSearch = false;
          query = searchView.text;
        });
      }*/
      if(searchView.text.length != result.length){
        setState(() {
          firstSearch = false;
          filterOffers = [];
        });
      }
      if(searchView.text.isEmpty){
        setState(() {
          firstSearch = true;
          filterOffers = [];
          //query = "";
        });
      }
      if(searchView.text.isNotEmpty){
        setState(() {
          firstSearch = false;
        });
        searchUsersMayus(searchView.text);
        searchUsersMinus(searchView.text);
      }
    });
  }

  @override
  void initState(){
    super.initState();
    getOffers();
    //getBlock();
    scroll.addListener((){
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        getMoreOffers();
      }
    });
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis ofertas'),
        //elevation: 0,
        //backgroundColor: Colors.transparent,
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
          ),
        ],
      ),
      drawer: DrawerBlock(),
      body: Column(
        children: <Widget>[
          CreateSearchView(),

          isLoading == false ?
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Mis ofertas publicadas",
                  style: TextStyle(color: Color(0xff1B2434), fontFamily: 'roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ) :
          Container(),

          isLoading == true ? 
          Container(
            padding: EdgeInsets.only(top: 20),
            alignment: Alignment.center,
            child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          ) :
          firstSearch ? CreateListView() : performSearch(),
          
          isLoading == false ?
          Align(
            alignment: Alignment.bottomCenter, 
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: MaterialButton(
                  height: 50,
                  color: Colors.blue.shade800,
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context){
                          return CreateOfferPage(usersData);
                        }
                      )
                    ).then((value) => {
                      print(value),
                      if(value != null){
                        setState(() {
                          offersData.insert(0, value);
                        }),
                      }
                    }
                  );
                  },
                  child: Text(
                    "Crear oferta",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ) :
          Container(),

          /*TextButton(
            child: Text("Mostrar mas ofertas"),
            onPressed: (){
              getMoreOffers();
            },
          ),*/
        ]
      ),
    );
  }

  Widget CreateSearchView(){
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
      ),
      //child: Expanded(
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
                hintText: "Buscar en mis ofertas",
                hintStyle: TextStyle(
                  color: Colors.grey
                ),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      //),
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
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(left: 25),
        child: ListView.builder(
          itemCount: offersData == null ? 0 : offersData.length,
          //scrollDirection: Axis.horizontal,
          controller: scroll,
          itemBuilder: (BuildContext context, int index){
            if(index == offersData.length){
              return Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ListTile(
              contentPadding: EdgeInsets.all(10.0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(offersData[index]["image"]),
                radius: 30.0,
              ),
              title: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("${offersData[index]["title"]}",
                  style: TextStyle(color: Color(0xff1B2434), fontSize: 17, fontFamily: 'roboto',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("${offersData[index]["description"]}".length >= 30 ?
                  "${offersData[index]["description"]}".substring(0, 30) + "..." : "${offersData[index]["description"]}",
                  style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return DetailOfferPage(offersData[index], widget.profileData);
                    }
                  )
                );
              },
            );
          }
        ),
      ),
    );
  }

  Widget performSearch() {
    Map filter = {};
    List filterList = filterOffers;
    
    /*for(int i=0; i<offersData.length; i++){
      String item = offersData[i]["title"];
      if(item.toLowerCase().contains(query.toLowerCase())){
        filter = {
          "id": offersData[i]["id"],
          "user": offersData[i]["user"],
          "image": offersData[i]["image"],
          "video": offersData[i]["video"],
          "title": offersData[i]["title"],
          "description": offersData[i]["description"],
          "date": offersData[i]["date"],
          "reward": offersData[i]["reward"],
          "typeReward": offersData[i]["typeReward"],
        };
        filterList.add(filter);
      }
    }*/

    return Flexible(
      child: ListView.builder(
        itemCount: filterList == null ? 0 : filterList.length,
        controller: scroll,
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
          return ListTile(
            contentPadding: EdgeInsets.all(10.0),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(filterList[index]["image"]),
              radius: 30.0,
            ),
            title: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("${filterList[index]["title"]}",
                style: TextStyle(color: Color(0xff1B2434), fontSize: 17, fontFamily: 'roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("${filterList[index]["description"]}".length >= 30 ?
                "${filterList[index]["description"]}".substring(0, 30) + "..." : "${filterList[index]["description"]}",
                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
              ),
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return DetailOfferPage(filterList[index], widget.profileData);
                  }
                )
              );
            },
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

        Ink(
          color: Colors.blue.shade200,
          child: ListTile(
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
              Navigator.pop(context);
            },
          ),
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
                  return OpportunityPage(widget.profileData);
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