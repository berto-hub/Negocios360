import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
//import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:js/js_util.dart';
import 'package:negocios360app/createOffer.dart';
import 'package:negocios360app/myChats.dart';
import 'dart:async';
import 'dart:convert';
import 'myProfile.dart';
import 'wall.dart';
import 'sendOportunity.dart';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

/*import 'package:flutter_chat/Models/UserModel.dart';
import 'package:flutter_chat/chatDB.dart';
import 'package:flutter_chat/chatData.dart';
import 'package:flutter_chat/chatWidget.dart';
import 'package:flutter_chat/constants.dart';
import 'package:flutter_chat/hexColor.dart';
import 'package:flutter_chat/screens/chat.dart';
import 'package:flutter_chat/screens/dashboard_screen.dart';
import 'package:flutter_chat/screens/login_screen.dart';
import 'package:flutter_chat/screens/zoomImage.dart';*/
//import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MessagePage extends StatefulWidget{
  String idUser;
  List myProfile;
  Map conver;
  int index;
  MessagePage(this.index, this.idUser, this.myProfile, this.conver);

  @override
  Message createState() => Message();
}

class Message extends State<MessagePage>{

  var message = TextEditingController();
  //var passCont = TextEditingController();

  Map usersData = {};
  String idUser = "";

  List messagesList = [];
  List messages = [];
  var now = DateTime.now();
  String dateNow = "";
  String hourNow = "";
  //String date = "";
  //String hour = "";
  String messageHour = "";

  List conversations = [];
  List lastMessages = [];

  ScrollController scroll = ScrollController();

  StreamController<QuerySnapshot<Map>> controller = StreamController<QuerySnapshot<Map>>();
  Stream<QuerySnapshot<Map>> get streamController => controller.stream;

  List<DocumentSnapshot> docs = [];
  List<QuerySnapshot<Map>> queries = [];

  getProfile() async {
    idUser = widget.idUser;
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${idUser}'));
    var data = json.decode(response.body);
    setState(() {
      usersData = data['profile'];
    });

    print(data);
    print(usersData);
  }

  createMessage() async {
    if(message.text.isNotEmpty){
      CollectionReference messages = FirebaseFirestore.instance.collection("messages");
      messages.add({
        'date': Timestamp.now(),
        'idConversation': widget.conver["id"],
        'sender': widget.myProfile[0]["id"],
        'receiver': widget.idUser,
        'text': message.text,
      });

      message.clear();

      /*print("okei");
      print("Converrrrrrrrrrrrrrrrrrrrrrr");
      print(widget.conver);
      var response = await http.post(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createMessage'), 
        body: ({
          'idConversation': widget.conver["id"],
          'sender': widget.myProfile[0]["id"],
          'receiver': widget.idUser,
          'text': message.text,
        }),
      );*/

      /*Map newMessage = {
        'sender': widget.myProfile[0]["id"],
        'receiver': widget.idUser,
        'text': message.text,
      };*/

      /*setState(() {
        messages.insert(0, newMessage);
      });*/

      /*if(response.statusCode==204){
        debugPrint("Inserted correctly.");
        print(messages);
        print("Recarga");
        //updateEmailOpor(emailCont.text);

        //ScaffoldMessenger.of(context)
        //.showSnackBar(SnackBar(content: Text("Oportunity Sended.")));
        //Navigator.push(
          //context, MaterialPageRoute(builder: (context) => Second()));
      }else{
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }*/
    }
  }

  void addMessage(){
    Map newMessage = {
      'date': DateTime.now().toIso8601String(),
      'sender': widget.myProfile[0]["id"],
      'receiver': widget.idUser,
      'text': message.text,
    };

    setState(() {
      messages.insert(0, newMessage);
      //messages.add(newMessage);
    });
    message.clear();
  }

  getMessages() async {
    try{
      Query<Map> query = FirebaseFirestore.instance.collection("messages")
        .where("idConversation", isEqualTo: widget.conver["id"])
        .orderBy("date", descending: true)
        .limit(11);

      print("Query.................." + "${query}");
      QuerySnapshot<Map> qS = await query.get();
      print("QuerySnapshot.........." + "${qS}");
      print("Docs antiguos......" + "${docs}");
      
      //List<DocumentSnapshot> d = [];
      //d.addAll();

      docs.addAll(qS.docs);
      controller.sink.add(qS);

      print("Docs nuevos......" + "${docs}");

    }catch(e){
      controller.sink.addError(e);
    }
    /*http.Response response = await http.get(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getMessConver/${widget.conver["id"]}')
    );
    var data = json.decode(response.body);
    setState(() {
      messagesList = data['messages'];
    });

    print(messagesList);
    /*messagesList.sort(
      (a, b) => a["date"].toString().compareTo(b["date"].toString())
    );*/

    /*messagesList.sort(
      (a, b) => a["date"].toString().compareTo(b["date"].toString())
    );*/

    messages = messagesList;
    print(messagesList);
    print(messages);
    conversation(messages);

    return messages;*/
  }

  /*getMessagesSended() async {
    http.Response response = await http.get(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getMessages/${idUser}/${widget.myProfile[0]["id"]}')
    );
    var data = json.decode(response.body);
    setState(() {
      messagesList = data['messages'];
    });

    print(messagesList);
    /*messagesList.sort(
      (a, b) => a["date"].toString().compareTo(b["date"].toString())
    );*/
    
    getMessagesReceived();
  }

  getMessagesReceived() async {
    List list = [];
    
    http.Response response = await http.get(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getMessages/${widget.myProfile[0]["id"]}/${idUser}')
    );
    var data = json.decode(response.body);
    setState(() {
      list = data['messages'];
    });

    print(list);
    messagesList.addAll(list);

    messagesList.sort(
      (a, b) => a["date"].toString().compareTo(b["date"].toString())
    );

    messages = List.from(messagesList.reversed);
    print(messagesList);
    print(messages);
    conversation(messages);
  }*/

  /*getConversations(List idUsersConvers) async{
    for(int i=0; i<idUsersConvers.length; i++){
      http.Response response = await http.get(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getConversUser/${idUsersConvers[i]}')
      );
      var data = json.decode(response.body);
      
      setState(() {
        conversations = data['conversations'];
      });
    }

    print(conversations);
  }*/

  conversation(List mes) async {
    List idUsersConvers = widget.myProfile[0]["conversations"].split("/");
    bool coincidence = false;

    //getConversations(idUsersConvers);

    if(mes != []){
      if(widget.myProfile[0]["conversations"] == ""){
        coincidence = true;
      }else{
        for(int i=0; i<idUsersConvers.length; i++){
          if(idUsersConvers[i] == idUser){
            coincidence = true;
          }
        }
      }

      if(coincidence == true){
        var response = await http.put(
          Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/profileConver/${widget.myProfile[0]["id"]}'), 
          body: ({
            'conversations': idUser + "/",
          }),
        );

        if(response.statusCode == 204){
          debugPrint("Inserted correctly.");
        
        }else{
          ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
        }
      }
    }
  }

  lastMessage(DocumentSnapshot lastMessage) async {
    String idConver = "";
    print("Conver: " + "${widget.conver}");
    idConver = widget.conver["ID"];

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
  }

  String getTime(DocumentSnapshot doc){
    String phraseTime = "";
    print(widget.conver);
    print(widget.idUser);
    print(widget.myProfile);

    DateTime date = doc["date"].toDate();
    //phraseTime = "${date.year}";
    DateTime now = DateTime.now();
    int difference = now.difference(date).inDays;
    difference == 1 ? phraseTime = "Hace ${difference} día" : phraseTime = "Hace ${difference} días";
    
    if(difference == 0){
      difference = now.difference(date).inHours;
      difference == 1 ? phraseTime = "Hace ${difference} hora" : phraseTime = "Hace ${difference} horas";
      if(difference == 0){
        difference = now.difference(date).inMinutes;
        difference == 1 ? phraseTime = "Hace ${difference} minuto" : phraseTime = "Hace ${difference} minutos";
        if(difference == 0){
          difference = now.difference(date).inSeconds;
          difference == 1 ? phraseTime = "Hace ${difference} segundo" : phraseTime = "Hace ${difference} segundos";
        }
      }
    }

    return phraseTime;
  }

  int countMore = 11;
  int indexMore = 1;
  List moreMessages = [];
  bool streamMore = false;
  List<QuerySnapshot> q = [];
  //late QuerySnapshot collectionState;

  getMoreMessages() async{
    var lastVisible = docs[docs.length-1];
    //print('listDocument legnth: ${collectionState.size} last: $lastVisible');

    QuerySnapshot<Map> moreMess = await FirebaseFirestore.instance.collection("messages")
      .where("idConversation", isEqualTo: widget.conver["id"])
      .orderBy("date", descending: true)
      .startAfterDocument(lastVisible)
      .limit(11)
      .get();
    
    queries.add(moreMess);
    docs.addAll(moreMess.docs);
    
    List<QuerySnapshot<Map>> moreMessages = [];
    //moreMessages.add(moreMess);
    for(int i=0; i<queries.length; i++){
      controller.sink.add(queries[i]);
    }
  }

  /*getMoreMessages(QuerySnapshot oldMessages) async {
    print("loading more info.......");

    //print("docsMore..............." + "${docs[docs.length - 1]}");
    
    try{
      Query<Map> query = FirebaseFirestore.instance.collection("messages")
        .where("idConversation", isEqualTo: widget.conver["id"])
        .orderBy("date", descending: true)
        .startAfterDocument(docs[docs.length - 1])
        .limit(11);

      print("Query.................." + "${query}");
      QuerySnapshot<Map> qS = await query.get();
      print("QuerySnapshot.........." + "${qS}");
      print("Docs antiguos......" + "${oldMessages.docs[0]["text"]}");
      
      //List<DocumentSnapshot> d = [];
      //d.addAll();

      docs.addAll(oldMessages.docs);
      controller.sink.add(qS);

      print("Docs nuevos......" + "${docs}");
      print("Controller sink.." + "${controller.sink}");

      streamMore = false;
      indexMore++;
    }catch(e){
      controller.sink.addError(e);
    }

    /*http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getMoreMessages/${widget.conver["id"]}/${moreMes}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:

    setState(() {
      moreMessages = data['messages'];
    });

    print("MoreMessages: ");
    print(moreMessages);

    messages.addAll(moreMessages);*/
  }*/

  void scrollToBottom() {
    final bottomOffset = scroll.position.maxScrollExtent;
    scroll.animateTo(
      bottomOffset,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  bool more = false;
  void initState(){
    super.initState();
    //connect();
    getProfile();
    //getMessages();
    //getMessagesReceived();
    //streamChat();
    //scroll.animateTo(scroll.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    scroll.addListener(() {
      /*setState(() {
        scroll.animateTo(scroll.position.maxScrollExtent, duration: Duration(milliseconds: 100), curve: Curves.easeOut);
      });*/

      if(scroll.position.pixels==scroll.position.maxScrollExtent){
        /*setState(() {
          more = true;
        });*/
        print("more data");
        setState(() {
          count = count + 11;
          streamMore = true;
        });
        
        /*getMoreMessages();
        print("more data");*/
      }
    });
  }

  int count = 11;

  Stream<QuerySnapshot<Map>> streamSnapshot(String conver) { 
    return FirebaseFirestore.instance.collection("messages")
      .where("idConversation", isEqualTo: conver)
      .orderBy("date", descending: true)
      .limit(count)
      .snapshots();
  }
  
  Widget build(BuildContext context){
    /*return Column(
      children: [
        /*AppBar(
          title: Text("Mensajes con ${usersData["name"]}"),
          backgroundColor: Colors.blue.shade800,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){
              if(docs[0].exists){
                Navigator.pop(context, [widget.index, docs[0]]);
                lastMessage(docs[0]);
              }else{
                Navigator.pop(context, []);
              }
            },
          ),
        ),*/
        listMessages(),
      ],
    );*/
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Mensajes con ${usersData["name"]}"),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            if(docs[0].exists){
              Navigator.pop(context, [widget.index, docs[0]]);
              lastMessage(docs[0]);
            }else{
              Navigator.pop(context, []);
            }
          },
        ),
      ),

      body: SafeArea(
        child: Column(
          children: <Widget>[
            /*TextButton(
              onPressed: (){
                //QuerySnapshot oldMessages = queries;
                //getMoreMessages();
                setState(() {
                  count = count + 11;
                  streamMore = true;
                });
              }, 
              child: Text("Mostrar mas mensajes"),
            ),*/

            //Expanded(
            //Container(
            listMessages(),
              //),
            //),
            inputMessage(),
            /*Expanded(
              child: Container(
                child: 
            StreamBuilder<QuerySnapshot<Map>>(
      stream: /*streamMore == false ?*/ 
      streamSnapshot(widget.conver["id"]),// : streamController,

      builder: (context, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
        if(!snapshot.hasData){
          print("Docsssssss");
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        print("Docsssssss1");
        print(snapshot);

        /*if(snapshot.data != null){
          docs = snapshot.data!.docs;
        }else{
          docs = [];
        }*/
        
        queries.add(snapshot.data!);
        docs = snapshot.data!.docs;
        List<DocumentSnapshot> reverseDocs = List.from(docs.reversed);

        print("Print docsssssssssssssss:\n" + "${docs}");

        return ListView.builder(
          reverse: true,
          controller: scroll,
          itemCount: docs == null ? 0 : docs.length,//.first + 10, //messages.length - 4
          itemBuilder: (BuildContext context, int index){
            //if(messages.length > 10){
            /*if(scroll.hasClients){
              scroll.jumpTo(scroll.position.maxScrollExtent);
            }*/
            /*if(index == docs.length && more == true){
              return Center(
                child: Container(
                  /*padding: EdgeInsets.all(5),
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),*/
                  child: TextButton(
                    child: Text("Cargar mensajes"),
                    onPressed: (){
                      getMoreMessages();
                    },
                  ),
                ),
              );
            }*/
            /*if(index == messages.length && more == false){
              return Container(
                child: Text(""),
              );
            }*/
            //}
            
            return 
            /*Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(width: 1.0),
              ),
              child:ListTile(
                title: Text("${messagesList[index]["text"]}"),
                subtitle: Text("${messagesList[index]["hour"]}"),
              ),
            );*/
            SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: docs[index]["sender"] == widget.myProfile[0]["id"] ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: docs[index]["sender"] != widget.myProfile[0]["id"] ? 
                      CircleAvatar(
                        backgroundImage: NetworkImage("${usersData["image"]}"),
                        radius: 20.0,
                      ) : Text(""),
                  ),
                  
                  Container(
                    //constraints: BoxConstraints(maxWidth: 300),
                    margin: EdgeInsets.all(12),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomRight: docs[index]["sender"] != widget.myProfile[0]["id"] ? Radius.circular(20) : Radius.zero,
                        bottomLeft: docs[index]["sender"] == widget.myProfile[0]["id"] ? Radius.circular(20) : Radius.zero,
                      ),
                      color: Colors.blue.shade100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(maxWidth: 170),
                          child: //Row(
                            //children: [
                              Text(
                                "${docs[index]["text"]}",
                                maxLines: null,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
    
                              //Icon(Icons.done_all),
                            //],
                          //),
                        ),
    
                        Padding(
                          padding: EdgeInsets.only(left: 4.0), 
                          child: Text(
                            //getTime(index),
                            getTime(docs[index]),
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        /*Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Hace ${getTime(index)}",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        )*/
                      ],
                    )
                  )
                ],
              ),
            );
          }
        );
      }
    ),)),
    Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              elevation: 2,
              shape: StadiumBorder(),
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  controller: message,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.emoji_emotions),
                    border: InputBorder.none,
                    hintText: 'Mensaje',
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: (){
              createMessage();
              //addMessage();
              //getMessagesSended();
              //Deberia ir al maxscrollextent******
              scroll.animateTo(scroll.position.minScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
            },
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    )*/
          ],
        ),
      ),
    );
  }

  Widget listMessages() {
    return StreamBuilder<QuerySnapshot<Map>>(
      stream: /*streamMore == false ?*/ 
        streamSnapshot(widget.conver["id"]),// : streamController,

      builder: (context, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
        if(!snapshot.hasData){
          print("Docsssssss");
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        print("Docsssssss1");
        print(snapshot);

        /*if(snapshot.data != null){
          docs = snapshot.data!.docs;
        }else{
          docs = [];
        }*/
        
        queries.add(snapshot.data!);
        docs = snapshot.data!.docs;
        List<DocumentSnapshot> reverseDocs = List.from(docs.reversed);

        print("Print docsssssssssssssss:\n" + "${docs}");

        return Expanded(
          child: ListView.builder(
            reverse: true,
            controller: scroll,
            itemCount: docs == null ? 0 : docs.length,//.first + 10, //messages.length - 4
            itemBuilder: (BuildContext context, int index){
              //if(messages.length > 10){
              /*if(scroll.hasClients){
                scroll.jumpTo(scroll.position.maxScrollExtent);
              }*/
              /*if(index == docs.length && more == true){
                return Center(
                  child: Container(
                    /*padding: EdgeInsets.all(5),
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),*/
                    child: TextButton(
                      child: Text("Cargar mensajes"),
                      onPressed: (){
                        getMoreMessages();
                      },
                    ),
                  ),
                );
              }*/
              /*if(index == messages.length && more == false){
                return Container(
                  child: Text(""),
                );
              }*/
              //}
              
              return 
              /*Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(width: 1.0),
                ),
                child:ListTile(
                  title: Text("${messagesList[index]["text"]}"),
                  subtitle: Text("${messagesList[index]["hour"]}"),
                ),
              );*/
              SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: docs[index]["sender"] == widget.myProfile[0]["id"] ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: docs[index]["sender"] != widget.myProfile[0]["id"] ? 
                        CircleAvatar(
                          backgroundImage: NetworkImage("${usersData["image"]}"),
                          radius: 20.0,
                        ) : Text(""),
                    ),
                    
                    Container(
                      //constraints: BoxConstraints(maxWidth: 300),
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: docs[index]["sender"] != widget.myProfile[0]["id"] ? Radius.circular(20) : Radius.zero,
                          bottomLeft: docs[index]["sender"] == widget.myProfile[0]["id"] ? Radius.circular(20) : Radius.zero,
                        ),
                        color: Colors.blue.shade100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints(maxWidth: 170),
                            child: //Row(
                              //children: [
                                Text(
                                  "${docs[index]["text"]}",
                                  maxLines: null,
                                  style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                                ),
            
                                //Icon(Icons.done_all),
                              //],
                            //),
                          ),
            
                          Padding(
                            padding: EdgeInsets.only(left: 4.0), 
                            child: Text(
                              //getTime(index),
                              getTime(docs[index]),
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          /*Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Hace ${getTime(index)}",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          )*/
                        ],
                      )
                    )
                  ],
                ),
              );
            }
          ),
        );
      }
    );
  }

  Widget inputMessage() {
    return /*Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
            ),
            child: Expanded(
            child: Material(
              elevation: 2,
              shape: StadiumBorder(),
              color: Colors.blue.shade100,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  controller: message,
                  decoration: InputDecoration(
                    //icon: Icon(Icons.emoji_emotions),
                    border: InputBorder.none,
                    hintText: 'Mensaje',
                  ),
                ),
              ),
            ),
            ),
          ),
          IconButton(
            onPressed: (){
              createMessage();
              //addMessage();
              //getMessagesSended();
              //Deberia ir al maxscrollextent******
              scroll.animateTo(scroll.position.minScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
            },
            icon: Icon(
              Icons.send,
              color: Colors.blue,
            ),
          ),
        ],
      ),*/
      Container(
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          elevation: 2,
                          shape: StadiumBorder(),
                          color: Colors.blue.shade100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: TextField(
                              style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              controller: message,
                              decoration: InputDecoration(
                                //icon: Icon(Icons.emoji_emotions),
                                border: InputBorder.none,
                                hintText: 'Mensaje',
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          createMessage();
                          //addMessage();
                          //getMessagesSended();
                          //Deberia ir al maxscrollextent******
                          scroll.animateTo(scroll.position.minScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeOut);
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        )
      );
  }
}