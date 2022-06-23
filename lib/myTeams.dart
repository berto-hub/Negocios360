import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/Offer.dart';
import 'dart:async';
import 'dart:convert';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'Offer.dart';
import 'main.dart';
import 'myChats.dart';
import 'myOffers.dart';
import 'myOpportunities.dart';
import 'myProfile.dart';
import 'myTeam.dart';
import 'myTeamAdmin.dart';
import 'myTeamResponsable.dart';
import 'otherProfile.dart';
import 'searchUsers.dart';
import 'wall.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'dart:convert';

class TeamsPage extends StatefulWidget{

  List profileData;
  TeamsPage(this.profileData);

  @override
  Teams createState() => Teams();
}

class Teams extends State<TeamsPage>{

  List profileData = [];
  List teamData = [];

  var searchView = TextEditingController();
  String query = "";
  bool firstSearch = true;
  String result = "";

  List<String> idTeams = [];
  List<String> idUsers = [];
  List usersData = [];
  bool search = false;

  bool isLoading = false;
  bool duration = false;
  final ScrollController scroll = ScrollController(); 

  /*getProfile() async {
    //http.Response response = await http.get(Uri.parse('http://localhost:5000/networking-360-5d7b7/us-central1/app/myProfile'));
    //Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersData = widget.profileData;
    });
    print(usersData);
  }*/
  
  int count = 0;
  getTeam() async{
    Map user = widget.profileData[0];
    //Hacer un nuevo elemento que introduzca al igual que los idUsers los nombres de los usuarios

    print(user);
    idTeams = widget.profileData[0]["idTeam"].split('/');
    print(idTeams);

    if(idTeams.length <= 10){
      count = idTeams.length;
    }else{
      count = 10;
    }

    for(int i=0; i<count; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getTeam/${idTeams[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        Map d = data["team"];
        d["id"] = idTeams[i];
        teamData.add(d);
      });
    }
    //getUsers();
    setState(() {
      isLoading = false;
    });

    print(teamData);
    //print(idUsers);
  }

  //////////////// Hacer moreTeams() //////////////////////

  /*int numUsers = 1;

  getUsers() async{
    //usersData = widget.profileData;
    //await Future.delayed(const Duration(milliseconds: 100));
    idUsers = teamData["users"].split("/");
    print(idUsers);
    setState(() {
      isLoading = true;
    });
    for(int i=0; i<numUsers; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idUsers[i]}'));
      Map data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        usersData.add(data["profile"]);
      });
    }
    setState(() {
      isLoading = false;
    });
    
    print(usersData);
    //print(usersData[1]);
  }*/

  getMoreTeams() async{
    Map user = widget.profileData[0];
    //Hacer un nuevo elemento que introduzca al igual que los idUsers los nombres de los usuarios

    print(user);
    //idTeams = widget.profileData[0]["idTeam"].split('/');
    print(idTeams);

    /*if(count <= idTeams.length){
      count = count;
    }else{
      count = idTeams.length;
    }*/

    int c = count;

    /*if(idTeams.length <= (count + 10)){
      count = idTeams.length;
    }else{
      count = count + 10;
    }*/

    print("Antes");
    print(idTeams);
    setState(() {
      idTeams.removeRange(0, count);
    });
    print("Despues");
    print(idTeams);

    if(idTeams.length <= 10){
      count = idTeams.length;
    }else{
      count =  10;
    }

    print("holi" + "${count}");

    for(int i=0; i<count; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getTeam/${idTeams[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        Map d = data["team"];
        d["id"] = idTeams[i];
        teamData.add(d);
        //count = count + 1;
        print(count);
      });
    }
    //getUsers();

    print(teamData);
  }

  getTeamAdmin() async{
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getTeams'));
    var data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      teamData = data["team"];
    });
    //getUsers();

    setState(() {
      isLoading = false;
    });

    print(data);
    print(teamData);
    //print(idUsers);
  }

  int countAdmin = 0;

  getMoreTeamsAdmin() async{
    countAdmin = countAdmin + 10;
    print(countAdmin);
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getMoreTeams/${countAdmin}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    print(data);
    setState(() {
      for(int i=0; i<data["team"].length; i++){
        teamData.add(data["team"][i]);
      }
    });
    //getUsers();

    print(teamData);
    //print(idUsers);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List filterTeams = [];
  Map t = {};
  bool change = false;

  Future<List> searchUsersMayus(String name) {
    // code to convert the first character to uppercase
    String searchKey;
    if(name[0] != name[0].toUpperCase()){
      searchKey = name[0].toUpperCase() + name.substring(1);
    }else{
      searchKey = name[0] + name.substring(1);
    }
    
    return firestore
      .collection("teams")
      .orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> team in result.docs) {
          setState(() {
            t = team.data()!;
            t["id"] = team.id;
            filterTeams.add(t);
            print(t);
          });
        }

        return filterTeams;
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
      .collection("teams")
      .orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> team in result.docs) {
          setState(() {
            t = team.data()!;
            t["id"] = team.id;
            filterTeams.add(t);
            print(t);
          });
        }

        return filterTeams;
      });
  }

  @override
  void initState(){
    super.initState();
    setState(() {
      isLoading = true;
    });
    if(widget.profileData[0]["role"] == "administrator"){
      getTeamAdmin();
      scroll.addListener(() {
        if(scroll.position.pixels >= scroll.position.maxScrollExtent){
          getMoreTeamsAdmin();
          print("more data");
        }
      });
    }else{
      getTeam();
      scroll.addListener(() {
        if(scroll.position.pixels >= scroll.position.maxScrollExtent){
          getMoreTeams();
        }
      });
    }
  }

  void dispose(){
    super.dispose();
    scroll.dispose();
  }

  Teams(){
    searchView.addListener(() {
      if(searchView.text.length != result.length){
        setState(() {
          firstSearch = true;
          filterTeams = [];
        });
      }
      if(searchView.text.isEmpty){
        setState(() {
          firstSearch = true;
          filterTeams = [];
          //query = "";
        });
      }/*else{
        setState(() {
          //firstSearch = false;
          //query = searchView.text;
        });
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis equipos"),
        backgroundColor: Colors.blue.shade800,
        actions: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ],
      ),
      drawer: DrawerBlock(),
      body: Container(
        child: Column(
          children: <Widget>[
            CreateSearchView(),
            isLoading == true ? 
            Container(
              padding: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
            ) :
            firstSearch ? getListTeam() : performSearch(),
            /*TextButton(
              onPressed: (){
                getMoreTeams();
              },
              child: Text("More teams"),
            ),*/
          ],
        ),
      ),
    );
  }

  Widget CreateSearchView(){
    Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
      ),
      child: Expanded(
        child: Material(
          elevation: 2,
          shape: StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: TextField(
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
      ),
    );
    new Container(
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
                  controller: searchView,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Buscar por estado",
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    //suffixIcon: ButtonPopUp(),
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
    return new Container(
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
                hintText: "Buscar por equipo",
                hintStyle: TextStyle(
                  color: Colors.grey
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search), 
                  onPressed: (){
                    /*const time = Duration(milliseconds: 5000);
                    Timer timer = new Timer(time, () {
                      setState(() {
                        duration = true;
                      });
                    });*/
                    setState(() {
                      result = searchView.text;
                      if(firstSearch == true){
                        searchUsersMayus(result);//Tengo que hacer que solo busque una vez.
                        searchUsersMinus(result);
                      }
                      firstSearch = false;
                    });
                  },
                ),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      //),

          /*IconButton(
            onPressed: (){
              showPopup();
            },
            icon: Icon(Icons.arrow_drop_down),
          ),*/
          /*Container(
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
          )*/
    );
  }

  Widget getListTeam(){
    return Flexible(child: ListView.builder(
      controller: scroll,
      itemCount: teamData == null ? 0 : teamData.length,
      itemBuilder: (BuildContext context, int index){
        if(index == teamData.length){
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
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(teamData[index]["image"]),
                        radius: 30.0,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("${teamData[index]["name"]}",
                          style: TextStyle(
                            color: Color(0xff1B2434),
                            fontSize: 17,
                            fontFamily: 'roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Número de usuarios: ${teamData[index]["numUsers"]}", 
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              ),
                            ),
                          ],
                        )
                        
                      ),
                      onTap: (){
                        widget.profileData[0]["role"] == "administrator" ?
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return TeamAdminPage(widget.profileData, teamData[index]["id"]);
                            }
                          )
                        ).then((value) => {
                          print(value),
                          if(value != ""){
                            setState((){
                              teamData[index]["numUsers"] = value;
                            })
                          }
                          }
                        ) :
                        widget.profileData[0]["role"] == "responsable" ?
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return TeamResponsablePage(widget.profileData, teamData[index]["id"]);
                            }
                          )
                        ).then((value) => {
                          print(value),
                          if(value != ""){
                            setState((){
                              teamData[index]["numUsers"] = value;
                            })
                          }
                          }
                        ) :
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return TeamPage(widget.profileData, teamData[index]["id"]);
                            }
                          )
                        ).then((value) => {
                          print(value),
                          if(value != ""){
                            setState((){
                              teamData[index]["numUsers"] = value;
                            })
                          }
                          }
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
  }

  Widget performSearch() {
    Map filter = {};
    List filterList = filterTeams;

    //filterUsers = [];

    //print("data: " + filterUsers[0].data());
    /*if(firstSearch == false){
      filterList = usersData;
    }*/
    
    /*for(int i=0; i<filterUsers.length; i++){
      String name = filterUsers[i]["name"];
      String profCategory = filterUsers[i]["profCategory"];
      /*if(name.toLowerCase().contains(result.toLowerCase())
        || profCategory.toLowerCase().contains(result.toLowerCase())
      ){*/
        filter = filterUsers[i];
        filterList.add(filter);
      //}
    }*/
    
    return Flexible(
      child: filterList.length == 0 ? 
      Center(
        child: Container(
          padding: EdgeInsets.all(5),
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ) /*: duration == false ? 
      Container(
        child: Text("No existe usuario"),
      )*/ :
      ListView.builder(
        itemCount: filterList == null ? 0 : filterList.length,
        itemBuilder: (BuildContext context, int index){
          /*if(index == filterList.length){
            return Center(
              child: Container(
                child: Text("No existe usuario"),
              ),
            );
          }*/
          return Card(
            child: SingleChildScrollView(
              child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(filterList[index]["image"]),
                      radius: 30.0,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "${filterList[index]["name"]}",
                        style: TextStyle(
                          color: Color(0xff1B2434),
                          fontSize: 15,
                          fontFamily: 'roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child:Text(
                            "Número de usuarios: ${filterList[index]["numUsers"]}",
                            style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                          ),
                        ),
                      ],
                    ), 
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return TeamPage(widget.profileData, filterList[index]["id"]);
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

        Ink(
          color: Colors.blue.shade200,
          child: ListTile(
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
              Navigator.pop(context);
            },
          ),
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