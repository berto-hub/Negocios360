import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/Offer.dart';
import 'package:negocios360app/main.dart';
import 'dart:async';
import 'dart:convert';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'Offer.dart';
import 'myOffers.dart';
import 'myOpportunities.dart';
import 'myProfile.dart';
import 'myTeam.dart';
import 'myTeams.dart';
import 'otherProfile.dart';
import 'message.dart';
import 'searchUsers.dart';
import 'wall.dart';

class ChatPage extends StatefulWidget{

  List myProfile;
  ChatPage(this.myProfile);

  @override
  Chat createState() => Chat();
}

class Chat extends State<ChatPage>{

  List profileData = [];
  Map teamData = {};

  var searchView = TextEditingController();
  String query = "";
  bool firstSearch = true;
  String result = "";

  List<String> idTeams = [];
  List<String> idConvers = [];
  List<String> idUsers = [];
  List usersData = [];

  List lastMessages = [];
  String lastMessage = "";
  String dateLastMessage = "";

  List conversations = [];
  bool change = false;

  /*getLastMessage() async {
    for(int i=0; i<idUsers.length; i++){
      http.Response response = await http.get(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getMessages/${idUsers[i]}/${widget.myProfile[0]["id"]}')
      );
      var data = json.decode(response.body);
      setState(() {
        lastMessages = data['messages'];
      });
    }

    print(lastMessages);
  }*/

  /*getProfile() async {
    //http.Response response = await http.get(Uri.parse('http://localhost:5000/networking-360-5d7b7/us-central1/app/myProfile'));
    //Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersData = widget.profileData;
    });
    print(usersData);
  }*/
  
  /*getChats() async{
    profileData = widget.myProfile[0]["conversations"].split("/");
    print(profileData);
    
    for(int i=0; i<profileData.length; i++){
      http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${profileData[i]}'));
      var data = json.decode(response.body);
      //coger solo unos datos determinados:
      setState(() {
        usersData.add(data["profile"]);
      });
    }
    //getUsers();
    print(usersData);
    //print(idUsers);
  }*/

  Future<void>getProfile() async{
    usersData = [];
    try{
      for(int i=0; i<idUsers.length; i++){
        http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idUsers[i]}'));
        var data = json.decode(response.body);
        //coger solo unos datos determinados:
        print("user");
        print(data);
        setState(() {
          usersData.add(data['profile']);
        });
      }
    }catch(e){
      print(e);
    }

    //getConversations(idUsers);
    //blockConver();
    
    //ids = [];
    //idUsers = [];
    print(usersData);
    //print(usersData[1]["id"]);
    //blockConver();
  }

  int count = 0;
  int c = 0;

  Future<void>getConversations() async{
    idConvers = widget.myProfile[0]["conversations"].split("/");
    print(idConvers[0]);
    print("holi");
    print(idConvers);

    if(idConvers.length <= 10){
      count = idConvers.length;
    }else{
      count = 10;
    }

    try{
      for(int i=0; i<count; i++){
        print("ID CONVER::::::::: " + idConvers[i]);
        http.Response response = await http.get(
          Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getConversConver/${idConvers[i]}')
        );
        var data = json.decode(response.body);
        //data["conversations"][i]["id"] = idConvers[i];
        print(data);
        print("aqui");

        setState(() {
          conversations.add(data['conversations'][0]);
          if(conversations[i]["user1"] == widget.myProfile[0]["id"]){
            idUsers.add(conversations[i]["user2"]);
          }else{
            idUsers.add(conversations[i]["user1"]);
          }
        });
        print(data);
      }
    }catch(e){
      print(e);
    }

    //getProfile(idUsers);
    
    print(conversations);
  }

  //Hacer que al hablar con un usuario se cree un chat.

  bool ok = false;
  bool isLoading = false;

  Future<void>getMoreConversations() async{
    print("holi");
    print(idConvers);
    print(idConvers.length);
    
    
    if(count < idConvers.length){
      setState(() {
        ok = true;
      });
    }

    /*if(idConvers.length <= (count + 10)){
      c = idConvers.length;
    }else{
      c = count + 10;
    }*/

    print("Antes");
    print(idConvers);
    setState(() {
      idConvers.removeRange(0, count);
    });
    print("Despues");
    print(idConvers);

    if(idConvers.length <= 10){
      count = idConvers.length;
    }else{
      count =  10;
    }

    print("holi" + "${count}");

    try{
      for(int i=0; i<count; i++){
        http.Response response = await http.get(
          Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getConversConver/${idConvers[i]}')
        );
        var data = json.decode(response.body);
        //data["conversations"][i]["id"] = idConvers[i];
        print(data);
        idUsers = [];

        setState(() {
          conversations = data['conversations'];
        });
      }

      for(int i=0; i<conversations.length; i++){
        print(conversations[i]["user2"]);
        if(conversations[i]["user1"] == widget.myProfile[0]["id"]){
          idUsers.add(conversations[i]["user2"]);
        }else{
          idUsers.add(conversations[i]["user1"]);
        }
      }

    }catch(e){
      print(e);
    }

    count = count + 10;

    print(count); 
    
    //getProfile(idUsers);
    
    print("Conversaciones");
    print(conversations);
    print(idUsers);
  }

  /*lastMess(DocumentSnapshot lastMessage) async {
    String idConver = "";
    idConver = widget.conver["id"];

    /*for(int i=0; i<conversations.length; i++){
      if(conver["user"]==idUser){
        idConver = conversations[i]["id"];
      }
    }*/

    var response = await http.put(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/lastMessageUpdate/${idConver}'), 
      body: ({
        'lastMessage': lastMessage["text"],
      }),
    );

    if(response.statusCode == 204){
      debugPrint("Inserted correctly.");
    
    }else{
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }*/

  List block = [];
  Future<void>blockConver() async {
    Map m = {};
    //await Future.delayed(const Duration(seconds: 1));
    print("Conversations: ");
    print(conversations);

    setState(() {
      for(int i=0; i<conversations.length; i++){
        m = {
          'id': conversations[i]["idConver"],
          'ID': conversations[i]["id"],
          'idUser': idUsers[i],
          'name': usersData[i]["name"],
          'lastMessage': conversations[i]["lastMessage"],
          'messageDate': conversations[i]["messageDate"],
          'image': usersData[i]["image"],
        };
        print(m);
        block.add(m);
      }

      block.sort(((a, b) => b["messageDate"].compareTo(a["messageDate"])));
      isLoading = false;
    });

    conversations = [];
    print(block);
  }

  String getTime(int blockId){
    String phraseTime = "";

    String date = block[blockId]["messageDate"];
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);

    phraseTime = day + "/" + month + "/" + year;

    return phraseTime;
  }

  ScrollController scroll = new ScrollController();

  @override
  void initState(){
    super.initState();
    setState(() {
      isLoading = true;
    });
    getConversations().then((value) => 
      getProfile().then((value) => 
        blockConver()));

    scroll.addListener((){
      if(scroll.position.pixels >= scroll.position.maxScrollExtent){
        getMoreConversations().then((value) => 
          getProfile().then((value) => 
            blockConver()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis chats"),
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
      body: isLoading == true ?
      Center(
        child: Container(
          padding: EdgeInsets.all(5),
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ) :
      ListView.builder(
        itemCount: block == null ? 0 : block.length,
        controller: scroll,
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
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage("${block[index]["image"]}"),
                          radius: 30.0,
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("${block[index]["name"]}",
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
                                child: /*change == true ?
                                  Text(lastMessage.length >= 25 ?
                                  lastMessage.substring(0, 25) + "..." : lastMessage,/*.length >= 30 ?
                                  conversations[index]["lastMessage"].substring(0, 30) + "..." : conversations[index]["lastMessage"],*/
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ) :*/
                                  Text(block[index]["lastMessage"].length >= 25 ?
                                  "${block[index]["lastMessage"].substring(0, 25)}" + "..." : "${block[index]["lastMessage"]}",/*.length >= 30 ?
                                  conversations[index]["lastMessage"].substring(0, 30) + "..." : conversations[index]["lastMessage"],*/
                                  style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: change == true ?
                                  Text(dateLastMessage.substring(0, 10),/*.length >= 30 ?
                                  conversations[index]["messageDate"].substring(0, 30) + "..." : conversations[index]["messageDate"],*/
                                  style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                                ) :
                                  Text(getTime(index),/*.length >= 30 ?
                                  conversations[index]["messageDate"].substring(0, 30) + "..." : conversations[index]["messageDate"],*/
                                  style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                                ),
                              ),
                            ],
                          )
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context){
                                return MessagePage(index, block[index]["idUser"], widget.myProfile, block[index]);
                              }
                            )
                          ).then((value) => {
                            if(value != []){
                              setState((){
                                print(value);
                                block[value[0]]["lastMessage"] = value[1]["text"];
                                block[value[0]]["messageDate"] = value[1]["date"].toDate().toString();
                                
                                //block.insert(0, block[value[0]]);
                                //block.removeAt(value[0]);
                                //change = true;
                              })
                            }
                          });
                        },
                      ),
                    ),
                  ],
                )
              ),
            );
          }
        ),
      /*bottomNavigationBar: TextButton(
          onPressed: (){
            //if(ok == true){
              getMoreConversations().then((value) => 
                getProfile().then((value) => 
                  blockConver()));
            //}
          },
          child: Text("More data"),
        ),*/
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
                backgroundImage: NetworkImage("${widget.myProfile[0]["image"]}"),
                radius: 45.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 12, left: 10), 
                    child:    Text("${widget.myProfile[0]["name"]}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12, left: 10), 
                    child: Text("${widget.myProfile[0]["email"]}",
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
                  return ProfilePage(widget.myProfile);
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
                  return HomePage(widget.myProfile);
                }
              ),
              (Route<dynamic> route) => false
            ).then(((value) => Navigator.pop(context)));
          },
        ),

        widget.myProfile[0]["role"] == "manager" || 
        widget.myProfile[0]["role"] == "responsable"||
        widget.myProfile[0]["role"] == "administrator"?
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
                  return TeamsPage(widget.myProfile, );
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
                  return TeamPage(widget.myProfile, widget.myProfile[0]["idTeam"]);
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
                  return OfferPage(widget.myProfile);
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
                  return OpportunityPage(widget.myProfile);
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
                  return UserSearchPage(widget.myProfile);
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
                Icon(Icons.message),
                Padding(
                  padding: EdgeInsets.only(left: 11.0),
                  child: Text("Mensajes"),
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