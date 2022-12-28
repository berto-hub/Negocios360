import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/Offer.dart';
import 'package:negocios360app/wall.dart';
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
import 'myTeams.dart';
import 'otherProfile.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class addUserPage extends StatefulWidget{

  List profileData;
  addUserPage(this.profileData);

  @override
  UserTeamState createState() => UserTeamState();
}

class UserTeamState extends State<addUserPage>{

  List profileData = [];
  Map teamData = {};
  ScrollController scroll = ScrollController();

  var searchView = TextEditingController();
  String query = "";
  bool firstSearch = true;
  String result = "";

  List<String> idTeams = [];
  List<String> idUsers = [];
  List usersData = [];
  bool isLoading = false;

  List<bool> isChecked = [false];
  List checkedUsers = [];

  int count = 2;

  /*getProfile() async {
    //http.Response response = await http.get(Uri.parse('http://localhost:5000/networking-360-5d7b7/us-central1/app/myProfile'));
    //Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersData = widget.profileData;
    });
    print(usersData);
  }*/

  /*getUsers() async{
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getUsers'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    print(data);
    setState(() {
      usersData = data["profile"];
    });
    
    print(usersData);
  }

  getMoreUsers() async{
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/showMoreUsers/${count}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    print(data);
    setState(() {
      for(int i=0; i<data["profile"].length; i++){
        usersData.add(data["profile"][i]);
        isChecked.add(false);
      }
      count = count + 1;
    });
    
    print(usersData);
    print(usersData[1]);
  }

  String selection = "";
  void popup() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Opciones'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Dar de baja"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Añadir a un equipo"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }*/

    /*return PopupMenuButton<String>(
      onSelected: (String result) {
        setState(() { 
          selection = result; 
        }); 
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "Añadir",
          child: Text('Añadir usuario al equipo.'),
        ),
        const PopupMenuItem<String>(
          value: "Dar de baja",
          child: Text('Dar de baja al usuaio en este equipo.'),
        ),
      ],
    );*/

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List filterUsers = [];
  Map u = {};

  Future<List> getUsers() {
    return firestore
      .collection("users")
      .where("idTeam", isEqualTo: "")
      .limit(2)
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            u = user.data()!;
            u["id"] = user.id;
            usersData.add(u);
            isChecked.add(false);
          });
          
          print(usersData);
        }

        return usersData;
      });
  }

  Future<List> getManagers() {
    return firestore
      .collection("users")
      .where("role", isEqualTo: "manager")
      .limit(2)
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            u = user.data()!;
            u["id"] = user.id;
            usersData.add(u);
            isChecked.add(false);
          });
          
          print(usersData);
        }

        return usersData;
      });
  }

  Future<List> getMoreUsers() async{
    var query = await firestore.collection('users');
    var documentSnapshot = await query.get();
    var lastDocument = documentSnapshot.docs[count-1];

    for(int i=0; i<count; i++){
      setState((){
        isChecked.add(false);
      });
    }

    setState(() {
      count = count + 2;
    });
    
    return await query
      .startAfterDocument(lastDocument)
      .where("idTeam", isEqualTo: "")
      .limit(2)
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            u = user.data()!;
            u["id"] = user.id;
            usersData.add(user.data());
          });
            
          print(user.data());
        }

        return usersData;
      });
  }

  Future<List> getMoreManagers() async{
    var query = await firestore.collection('users');
    var documentSnapshot = await query.get();
    var lastDocument = documentSnapshot.docs[count-1];

    for(int i=0; i<count; i++){
      setState((){
        isChecked.add(false);
      });
    }

    setState(() {
      count = count + 2;
    });
    
    return await query
      .startAfterDocument(lastDocument)
      .where("role", isEqualTo: "manager")
      .limit(2)
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            u = user.data()!;
            u["id"] = user.id;
            usersData.add(user.data());
          });
            
          print(user.data());
        }

        return usersData;
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
      .collection("users")
      .where("idTeam", isEqualTo: "")
      .orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            idUsers.add(user.id);
            filterUsers.add(user.data());
            print(user.data());
          });
        }

        return filterUsers;
      });
  }

  Future<List> searchUsersMayus(String name) {
    // code to convert the first character to uppercase
    String searchKey;
    if(name[0] != name[0].toUpperCase()){
      searchKey = name[0].toUpperCase() + name.substring(1);
    }else{
      searchKey = name[0] + name.substring(1);
    }
    
    return firestore
      .collection("users")
      .where("idTeam", isEqualTo: "")
      .orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            idUsers.add(user.id);
            filterUsers.add(user.data());
            print(user.data());
          });
        }

        return filterUsers;
      });
  }

  Future<List> searchManagersMayus(String name) {
    // code to convert the first character to uppercase
    String searchKey;
    if(name[0] != name[0].toUpperCase()){
      searchKey = name[0].toUpperCase() + name.substring(1);
    }else{
      searchKey = name[0] + name.substring(1);
    }
    
    return firestore
      .collection("users")
      .where("role", isEqualTo: "manager")
      .orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            idUsers.add(user.id);
            filterUsers.add(user.data());
            print(user.data());
          });
        }

        return filterUsers;
      });
  }

  Future<List> searchManagersMinus(String name) {
    // code to convert the first character to uppercase
    String searchKey;
    if(name[0] != name[0].toLowerCase()){
      searchKey = name[0].toLowerCase() + name.substring(1);
    }else{
      searchKey = name[0] + name.substring(1);
    }
    
    return firestore
      .collection("users")
      .where("role", isEqualTo: "manager")
      .orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            idUsers.add(user.id);
            filterUsers.add(user.data());
            print(user.data());
          });
        }

        return filterUsers;
      });
  }

  @override
  void initState(){
    super.initState();
    getUsers();
    getManagers();

    scroll.addListener(() {
      if(scroll.position.pixels==scroll.position.maxScrollExtent){
        getMoreUsers();
        getMoreManagers();
        print("more data");
      }
    });
  }

  /*@override
  void dispose(){
    searchView.dispose();
    super.dispose();
  }*/

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.blue.shade800;
  }

  UserTeamState(){
    searchView.addListener(() {
      if(searchView.text.length != result.length){
        setState(() {
          firstSearch = true;
          filterUsers = [];
          for(int i=0; i<usersData.length; i++){
            isChecked.add(false);
          }
        });
      }
      if(searchView.text.isEmpty){
        setState(() {
          firstSearch = true;
          filterUsers = [];
          for(int i=0; i<usersData.length; i++){
            isChecked.add(false);
          }
          //query = "";
        });
      }/*else{
        setState(() {
          firstSearch = false;
          //searchUsers(query);
        });
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir usuarios"),
        backgroundColor: Colors.blue.shade800,
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],*/
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: (){
            Navigator.pop(context, false);
          },
        )
      ),
      //drawer: DrawerBlock(),
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
            firstSearch ? getListUsers() : performSearch(),
            Container(
              child: Column(
                children: [
                  TextButton(
                    onPressed: (){
                      getMoreUsers();
                    },
                    child: Text("More data"),
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context, checkedUsers);
                    },
                    child: Text("Añadir usuarios"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CreateSearchView(){
    /*return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 300,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Material(
                elevation: 2,
                shape: StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    controller: searchView,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Buscar por usuario o empleo",
                      hintStyle: TextStyle(
                        color: Colors.grey
                      ),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            Container(
              child: Material(
                elevation: 2,
                shape: StadiumBorder(),
                child: TextButton.icon(
                  icon: Icon(Icons.search), 
                  label: Text("Buscar"),
                  onPressed: (){
                    setState(() {
                      result = searchView.text;
                      if(firstSearch == true){
                        searchUsers(result);
                      }
                      firstSearch = false;
                    });
                  },
                ),
              ), 
            ),


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
          ],*/

    return new Container(
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
              style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
              controller: searchView,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Buscar por usuario",
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
                        searchUsersMinus(result);
                        searchUsersMayus(result);
                        searchManagersMayus(result);
                        searchManagersMinus(result);
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
        ),
    );
  }

  Widget getListUsers(){
    return Flexible(child: ListView.builder(
      controller: scroll,
      itemCount: usersData == null ? 0 : usersData.length,
      itemBuilder: (BuildContext context, int index){
        if(index == usersData.length){
          return Center(
            child: Container(
              padding: EdgeInsets.all(5),
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        if(usersData == []){
          return Center(
            child: Text("No existen usuarios sin grupo."),
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
                        backgroundImage: NetworkImage(usersData[index]["image"]),
                        radius: 30.0,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text("${usersData[index]["name"]}",
                          style: TextStyle(color: Color(0xff1B2434), fontSize: 17, fontFamily: 'roboto',
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
                              child: Text("${usersData[index]["businessName"]}".length >= 30 ?
                                "${usersData[index]["businessName"]}".substring(0, 30).toUpperCase() + "..." : "${usersData[index]["businessName"]}".toUpperCase(),
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("${usersData[index]["profCategory"]}".length >= 30 ?
                                "${usersData[index]["profCategory"]}".substring(0, 30) + "..." : "${usersData[index]["profCategory"]}",
                                style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              ),
                            ),
                          ],
                        )
                      ),

                      trailing: Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: isChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[index] = value!;
                            if(value == true){
                              checkedUsers.add(usersData[index]);
                            }else{
                              checkedUsers.remove(usersData[index]);
                            }
                          });
                          //print(checkedUsers);
                        },
                      ),

                      onTap: (){
                        usersData[index]["email"] == widget.profileData[0]["email"] ? 
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return ProfilePage(widget.profileData);
                            }
                          )
                        ) :
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return OtherProfilePage(usersData[index], usersData[index]["id"], widget.profileData);
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
  }

  Widget performSearch() {
    Map filter = {};
    List filterList = filterUsers;
    /*if(firstSearch == false){
      filterList = usersData;
    }*/
    /*for(int i=0; i<usersData.length; i++){
      String name = usersData[i]["name"];
      String profCategory = usersData[i]["profCategory"];
      if(name.toLowerCase().contains(result.toLowerCase())
        || profCategory.toLowerCase().contains(result.toLowerCase())
      ){
        filter = {
          "name": usersData[i]["name"],
          "businessName": usersData[i]["businessName"],
          "profCategory": usersData[i]["profCategory"],
        };
        filterList.add(filter);
      }
    }*/
    
    return Flexible(
      child: filterList.length == 0 ? 
      Center(
        child: Container(
          padding: EdgeInsets.all(5),
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      ) /*: duration == false ? 
      Container(
        child: Text("No existe usuario"),
      )*/ : ListView.builder(
        itemCount: filterList == null ? 0 : filterList.length,
        itemBuilder: (BuildContext context, int index){
          /*if(index == filterList.length){
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
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(filterList[index]["image"]),
                      radius: 30.0,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "${filterList[index]["name"]}",
                        style: TextStyle(color: Color(0xff1B2434), fontSize: 17, fontFamily: 'roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child:Text(
                            "${filterList[index]["businessName"]}".length >= 30 ?
                                "${filterList[index]["businessName"]}".substring(0, 30).toUpperCase() + "..." : "${filterList[index]["businessName"]}".toUpperCase(),
                            style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child:Text(
                            "${filterList[index]["profCategory"]}".length >= 30 ?
                                "${filterList[index]["profCategory"]}".substring(0, 30) + "..." : "${filterList[index]["profCategory"]}",
                            style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                          ),
                        ),
                      ],
                    ), 
                    trailing: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked[index] = value!;
                          if(value == true){
                            checkedUsers.add(filterList[index]);
                          }else{
                            checkedUsers.remove(filterList[index]);
                          }
                        });
                        //print(checkedUsers);
                      },
                    ),
                    onTap: (){
                      filterList[index]["email"] == widget.profileData[0]["email"] ? 
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return ProfilePage(widget.profileData);
                            }
                          )
                        ) :
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context){
                              return OtherProfilePage(filterList[index], idUsers[index], widget.profileData);
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
    child: ListView(
      padding: EdgeInsets.all(1.0),
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage("${widget.profileData[0]["image"]}"),
                radius: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12), 
                child: Text("${widget.profileData[0]["email"]}"),
              ),
            ],
          ),
          //Text("Menú"),
          
          decoration: BoxDecoration(
            color: Colors.blue.shade800,
          ),
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
              )
            );
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
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (BuildContext context){
                  //getOpportunities();
                  //print("holiiiiii" + "${opportunityData}");
                  return HomePage(widget.profileData);
                }
              )
            );;
          },
        ),

        widget.profileData[0]["role"] == "manager"|| 
        widget.profileData[0]["role"] == "responsable" ?
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
            );
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
            );
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
              )
            );
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
            );
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
            Navigator.pop(context);
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
            );
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