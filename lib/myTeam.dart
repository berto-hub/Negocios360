import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/Offer.dart';
import 'dart:async';
import 'dart:convert';
import 'addUserTeam.dart';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'Offer.dart';
import 'main.dart';
import 'myChats.dart';
import 'myOffers.dart';
import 'myOpportunities.dart';
import 'myProfile.dart';
import 'otherProfile.dart';
import 'searchUsers.dart';
import 'wall.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'dart:convert';

class TeamPage extends StatefulWidget{

  List profileData;
  String idTeam;
  TeamPage(this.profileData, this.idTeam);

  @override
  Team createState() => Team();
}

class Team extends State<TeamPage>{

  List profileData = [];
  Map teamData = {};

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

  bool change = false;

  /*getProfile() async {
    //http.Response response = await http.get(Uri.parse('http://localhost:5000/networking-360-5d7b7/us-central1/app/myProfile'));
    //Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersData = widget.profileData;
    });
    print(usersData);
  }*/
  
  getTeam() async{
    Map user = widget.profileData[0];
    //Hacer un nuevo elemento que introduzca al igual que los idUsers los nombres de los usuarios

    print(user);
    //idTeams = widget.profileData[0]["idTeam"].split('/');
    print(idTeams);
    //for(int i=0; i<idTeams.length; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getTeam/${widget.idTeam}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        teamData = data["team"];
      });
    //}
    getUsers();
    print(teamData);
    //print(idUsers);
  }

  int numUsers = 1;
  int count = 0;

  getUsers() async{
    //usersData = widget.profileData;
    //await Future.delayed(const Duration(milliseconds: 100));
    idUsers = teamData["users"].split("/");
    print(idUsers);
    setState(() {
      isLoading = true;
    });

    if(idUsers.length <= 10){
      count = idUsers.length;
    }else{
      count = 10;
    }

    for(int i=0; i<count; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idUsers[i]}'));
      Map data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        data["profile"]["id"] = idUsers[i];
        usersData.add(data["profile"]);
      });
    }
    setState(() {
      isLoading = false;
    });
    
    print(usersData);
    //print(usersData[1]);
  }

  getMoreUsers() async{
    //usersData = widget.profileData;
    //await Future.delayed(const Duration(milliseconds: 100));
    //idUsers = teamData["users"].split("/");
    int c = count;

    /*if(idUsers.length <= (count + 10)){
      count = idUsers.length;
    }else{
      count = count + 10;
    }*/

    print("Antes");
    print(idUsers);
    setState(() {
      idUsers.removeRange(0, count);
    });
    print("Despues");
    print(idUsers);

    if(idUsers.length <= 10){
      count = idUsers.length;
    }else{
      count =  10;
    }

    print("holi" + "${count}");

    print(idUsers);
    for(int i=0; i<count; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idUsers[i]}'));
      Map data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        data["profile"]["id"] = idUsers[i];
        usersData.add(data["profile"]);
      });
    }
    setState(() {
      numUsers = numUsers + 1;
    });
    
    print(numUsers);
    print(usersData);
    //print(usersData[1]);
  }

  unsubscribeUser(String idUser, int index) async {
    setState(() {
      usersData.removeAt(index);
      change = true;
    });

    String teams = "";
    List t = usersData[index]["idTeam"].split("/");
    print(usersData);
    print(t);

    for(int i=0; i<t.length; i++){
      if(t[i] != widget.idTeam){
        if(teams == ""){
          teams = t[i];
        }else{
          teams = teams + "/" + t[i];
        }
      }
    }

    print(teams);

    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/editTeamUser/${idUser}'), 
      body: ({
        'idTeam': teams,
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  String numUs = "";
  unsubscribeUserTeam(String idUser) async {
    List usersTeam = teamData["users"].split("/");
    String users = "";

    print(usersTeam);
    for(int i=0; i<usersTeam.length; i++){
      if(usersTeam[i] != idUser){
        if(users == ""){
          users = usersTeam[i];
        }else{
          users = users + "/" + usersTeam[i];
        }
      }
    }

    print(users);
    numUs = (usersTeam.length - 1).toString();
    print(numUs);

    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/editUserTeam/${widget.idTeam}'), 
      body: ({
        'users': users,
        'numUsers': numUs,
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  subscribeUser(String idUser) async {
    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/editTeamUser/${idUser}'), 
      body: ({
        'idTeam': widget.idTeam,
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  subscribeManager(Map user) async {
    //List teamsUser = user["idTeam"].split("/");
    //print(teamsUser);
    //teamsUser.add(user);

    String teams = "";
    teams = user["idTeam"] + "/" + widget.idTeam;

    /*for(int i=0; i<teamsUser.length; i++){
      if(teams == ""){
        teams = teamsUser[i];
      }else{
        teams = teams + "/" + teamsUser[i];
      }
    }*/

    print(teams);

    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/editTeamUser/${user["id"]}'), 
      body: ({
        'idTeam': teams,
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  subscribeUserTeam(List idUsers) async {
    List usersTeam = teamData["users"].split("/");
    print(usersTeam);
    for(int i=0; i<idUsers.length; i++){
      usersTeam.add(idUsers[i]);
    }
    String users = "";

    print(usersTeam);
    for(int i=0; i<usersTeam.length; i++){
      if(users == ""){
        users = usersTeam[i];
      }else{
        users = users + "/" + usersTeam[i];
      }
    }

    print(users);
    numUs = (usersTeam.length).toString();
    print(numUs);

    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/editUserTeam/${widget.idTeam}'), 
      body: ({
        'users': users,
        'numUsers': numUs,
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  addUserTeam(List user){
    print(user);
    setState((){
      usersData.addAll(user);
    });
    List idUsers = [];
    for(int i=0; i<user.length; i++){
      if(user[i]["role"] == "manager"){
        subscribeManager(user[i]);
      }
      if(user[i]["role"] == "user"){
        subscribeUser(user[i]["id"]);
      }
      
      idUsers.add(user[i]["id"]);
    }
    subscribeUserTeam(idUsers);
  }

  String selection = "";
  void popup(String idUser, String nameUser, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Opciones'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*ListTile(
                title: Text("Dar de baja"),
                onTap: (){
                  Navigator.pop(context);
                  showMyDialog(idUser, nameUser, index);
                },
              ),*/
              widget.profileData[0]["role"] == "responsable" ||
              widget.profileData[0]["role"] == "administrator" ? 
              ListTile(
                title: Text("Añadir a un equipo"),
                onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return addUserPage(widget.profileData);
                      }
                    )
                  ).then((value) => {
                    Navigator.pop(context),
                    //print(value),
                    addUserTeam(value),
                  });
                },
              ) :
              Text(""),
            ],
          ),
        );
      }
    );
  }

  Future<void> showMyDialog(String idUser, String nameUser, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dar de baja'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("¿Desea dar de baja a " + "${nameUser}" + "?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                unsubscribeUser(idUser, index);
                unsubscribeUserTeam(idUser);
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
      },
    );
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List filterUsers = [];

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
      .where("idTeam", isEqualTo: widget.idTeam)
      .orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            filterUsers.add(user.data());
            print(user);
          });
        }

        return filterUsers;
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
      .where("idTeam", isEqualTo: widget.idTeam)
      .orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])
      .get()
      .then((result) {
        for (DocumentSnapshot<Map<dynamic, dynamic>> user in result.docs) {
          setState(() {
            filterUsers.add(user.data());
            print(user);
          });
        }

        return filterUsers;
      });
  }

  @override
  void initState(){
    super.initState();
    getTeam();
    scroll.addListener(() {
      if(scroll.position.pixels >= scroll.position.maxScrollExtent){
        getMoreUsers();
      }
    });
  }

  void dispose(){
    super.dispose();
    scroll.dispose();
  }

  Team(){
    searchView.addListener(() {
      if(searchView.text.length != result.length){
        setState(() {
          firstSearch = true;
          filterUsers = [];
        });
      }
      if(searchView.text.isEmpty){
        setState(() {
          firstSearch = true;
          filterUsers = [];
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
        title: Text("Mi equipo"),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context, numUs);
          }, 
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        actions: 
        widget.profileData[0]["role"] == "manager"|| 
        widget.profileData[0]["role"] == "responsable"||
        widget.profileData[0]["role"] == "administrator" ?
        null :
        <Widget>[
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ],
      ),
      drawer: widget.profileData[0]["role"] == "manager" || 
      widget.profileData[0]["role"] == "responsable" ? 
      null :
      DrawerBlock(),
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
                getMoreUsers();
              },
              child: Text("More users"),
            ),*/

            widget.profileData[0]["role"] == "responsable"||
            widget.profileData[0]["role"] == "administrator" ? 
            TextButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return addUserPage(widget.profileData);
                    }
                  )
                ).then((value) => {
                  addUserTeam(value),
                });
              },
              child: Text("Añadir usuarios"),
            ) :
            Text(""),
          ],
        ),
      ),
    );
  }

  Widget CreateSearchView(){
    /*Container(
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
    );*/
    /*return new Container(
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
          )*/*/
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
    );
  }

  Widget getListTeam(){
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

                      trailing: widget.profileData[0]["role"] == "manager" ? 
                      usersData[index]["role"] == "manager" ?
                        Text("Manager",
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 15,
                          ),
                        ) :
                      usersData[index]["role"] == "responsable" ?
                        Text("Responsable",
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 15,
                          ),
                        ) :
                        IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: (){
                            showMyDialog(usersData[index]["id"], usersData[index]["name"], index);
                            //popup(usersData[index]["id"], usersData[index]["name"], index);
                          },
                        ) : 
                      Text(""),

                      /*trailing: widget.profileData[0]["role"] == "manager" ? 
                      usersData[index]["role"] != "manager"?
                        IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: (){
                            showMyDialog(usersData[index]["id"], usersData[index]["name"], index);
                          },
                        ) : 
                        Text("Manager",
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 15,
                          ),
                        )
                        :
                      Text(""),*/

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
                                return OtherProfilePage(usersData[index], idUsers[index], widget.profileData);
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

                    trailing: widget.profileData[0]["role"] == "manager" ? 
                      filterList[index]["role"] == "manager" ?
                        Text("Manager",
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 15,
                          ),
                        ) :
                      filterList[index]["role"] == "responsable" ?
                        Text("Responsable",
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 15,
                          ),
                        ) :
                        IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: (){
                            showMyDialog(usersData[index]["id"], usersData[index]["name"], index);
                            //popup(usersData[index]["id"], usersData[index]["name"], index);
                          },
                        ) : 
                      Text(""),

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
                  child: Text("Mi equipo"),
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