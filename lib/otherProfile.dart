import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/Offer.dart';
import 'dart:async';
import 'dart:convert';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'Offer.dart';
import 'message.dart';
import 'sendOportunity.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class OtherProfilePage extends StatefulWidget{

  Map profileData;
  String idUser;
  List myProfile;
  OtherProfilePage(this.profileData, this.idUser, this.myProfile);

  @override
  Profile createState() => Profile();
}

class Profile extends State<OtherProfilePage>{

  Map usersData = {};
  String idUser = "";
  List offersData = [];
  List opporsData = [];
  List recOppors = [];
  List sendOppors = [];
  var import = TextEditingController();
  var concept = TextEditingController();

  getProfile() async {
    //http.Response response = await http.get(Uri.parse('http://localhost:5000/networking-360-5d7b7/us-central1/app/myProfile'));
    //Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersData = widget.profileData;
    });
    print("Viva el id del user: ${widget.idUser}");
    print(usersData);
    print(widget.myProfile[0]);
  }

  getOffers() async{
    idUser = widget.idUser;
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOfferUser/${idUser}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    print("ofertas: ${data}");
    setState(() {
      offersData = data["offer"];
    });
    print(offersData);
  }

  int count = 0;

  getMoreOffers() async{
    count = count + 10;
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/showMoreOffers/${idUser}/${count}'));
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


  getOppors() async{
    idUser = widget.idUser;
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunityUser/${idUser}'));
    Map data = json.decode(response.body);
    print(data);
    //coger solo unos datos determinados:
    if(data != {}){
      setState(() {
        opporsData = data["opportunity"];
      });
    }else{
      setState(() {
        opporsData = [];
      });
    }
    
    print(opporsData);
  }
  
  //Hacer esto***************************************************************
  
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
  
  Map conversation = {};
  List idConvers1 = [];
  List idConvers2 = [];
  String idConver = "";
  bool exist = false;
  String id = "";

  generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    id = List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  getIdConver(){
    idConvers1 = widget.myProfile[0]["conversations"].split("/");
    idConvers2 = widget.profileData["conversations"].split("/");
    print(idConvers1);
    print(idConvers2);

    for(int i=0; i<idConvers1.length; i++){
      for(int j=0; j<idConvers2.length; j++){
        if(idConvers1[i] == idConvers2[j]){
          idConver = idConvers1[i];
        }
      }
    }
    print("ID CONVER::::::::: " + idConver);
    if(idConver == ""){
      createConver();
      editConverMyProfile();
      editConverOtherProfile();
    }else{
      getConversation();
    }
  }

  getConversation() async{
    print("idConver*******************");
    print(idConver);

    try{
      http.Response response = await http.get(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getConversConver/${idConver}')
      );
      Map data = json.decode(response.body);
      print("conversations:");
      print(data);

      setState(() {
        data["conversations"][0]["ID"] = data['conversations'][0]["id"];
        data["conversations"][0]["id"] = idConver;
        conversation = data['conversations'][0];
      });
      print("Conversations: " + "${data}");
    }catch(e){
      print(e);
    }
    
    print(conversation);
  }

  createConver() async{
    var response = await http.post(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createConversation'), 
        body: ({
          'idConver': id,
          'user1': widget.idUser,
          'user2': widget.myProfile[0]["id"],
          'lastMessage': "",
      }),
    );
    
    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      debugPrint("Invalid Credentials");
    }
  }

  String conver = "";
  //String idCon = id;
  Future<void> editConverMyProfile() async{
    if(widget.myProfile[0]['conversations'] == ""){
      conver = id;
    }else{
      conver = widget.myProfile[0]['conversations'];
      conver = conver + "/" + id;
    }
    print(conver);

    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createConver/${widget.myProfile[0]["id"]}'), 
      body: ({
        'conversations': conver,
      }),
    );
    setState(() {
      widget.myProfile[0]["conversations"] = conver;
    });

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      debugPrint("Invalid Credentials");
    }
  }

  String converOther = "";
  //String idConOther = "";
  Future<void> editConverOtherProfile() async{
    if(widget.profileData['conversations'] == ""){
      converOther = id;
    }else{
      converOther = widget.profileData['conversations'];
      converOther = converOther + "/" + id;
    }
    print(converOther);
    setState(() {
      widget.profileData["conversations"] = converOther;
    });

    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createConver/${widget.idUser}'), 
      body: ({
        'conversations': converOther,
      }),
    );

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      debugPrint("Invalid Credentials");
    }
  }

  double rewardsTotal = 0.0;
  List idRewards = [];
  List rewards = [];

  getRewards() async {
    idRewards = widget.profileData["reward"].split("/");
    print(idRewards);
    try{
      for(int i=0; i<idRewards.length; i++){
        http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getReward/${idRewards[i]}'));
        var data = json.decode(response.body);
        //coger solo unos datos determinados:
        setState(() {
          rewards.add(data["rewards"]);
          if(i == 0){
            rewardsTotal = double.parse(rewards[i]["reward"]);
          }else{
            rewardsTotal = rewardsTotal + double.parse(rewards[i]["reward"]);
          }
        });
        print(rewardsTotal);
        print("Rewards::::::: ${rewards}");
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> _launchUrl(String url) async {
    //if(await canLaunch(url)){
      await launch(
        url,
        //forceSafariVC: true,
        //forceWebView: true,
        //headers: <String, String>{'header_key': 'header_value'},
      );
      if(await canLaunch(url)){
      }
      //}else{
      //throw "Could not launch $url";
    //}
  }

  Future openEmail(String toEmail) async{
    String url = 'mailto:${toEmail}';
    print(toEmail);
    
    await _launchUrl(url);
  }

  Future openPhone(String toPhone) async{
    String url = 'tel:${toPhone}';
    print(toPhone);
    
    await _launchUrl(url);
  }

  sendReward(String rewardUser) async {
    idUser = widget.idUser;
    String rew = "";
    //print(usersName['opportunities']);

    if(widget.profileData['reward'] == ""){
      rew = rewardUser;
    }else{
      rew = widget.profileData['reward'];
      rew = rew + "/" + rewardUser;
    }

    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/sendRewardUser/${idUser}'), 
      body: ({
        'reward': rew,
      }),
    );
    print(rewardUser);
    print(idUser);

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

  String reward = "";
  String stars = "";
  String idReward = "";

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  createReward() async {
    //reward = ;//getImport(import.text);
    stars = "";//getStars();
    //idUser = widget.opportunity["idUser"];
    idReward = getRandomString(10);
    print(stars);
    print(idReward);

    var response = await http.post(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createReward'), 
      body: ({
        'idReward': idReward,
        'idSender': widget.myProfile[0]["id"],
        'idReceiver': widget.idUser,
        'reward': import.text,
        'comment': concept.text,
        'stars': ""//stars.toString(),
      }),
    );
    print(reward);
    print(idUser);

    sendReward(idReward);

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
    generateRandomString(8);
    getProfile();
    getRewards();
    getIdConver();
    getOffers();
    getOppors();

    /*for(int i=0; i<idConvers1.length; i++){
      for(int j=0; j<idConvers2.length; j++){
        if(idConvers1[i] == idConvers2[j]){
          exist = true;
        }
      }
    }

    if(exist == true){
      createConver();
    }*/
    recOppors = usersData["opportunities"].split("/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usersData["name"]),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue.shade800,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.money_rounded),
            tooltip: 'Recompensa extra',
            //mouseCursor: MouseCursor.uncontrolled,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Recompensa extra"),
                    content: Container(
                      width: 100,
                      height: 150,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: concept,
                              decoration: InputDecoration(
                                hintText: "Concepto",
                                hintStyle: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              controller: import,
                              decoration: InputDecoration(
                                hintText: "Importe",
                                hintStyle: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                        child: Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          createReward();   
                        }, 
                        child: Text("Enviar"),
                      ),
                    ],
                  );
                }
              );
            },
          ),
        ],
      ),
      body: /*Container(
        child:
            SingleChildScrollView(
              //physics: ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("${usersData["image"]}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: 
                    Text(
                      "${usersData["name"]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 25,
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: 
                                Text(
                                  "${usersData["businessName"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )
                              ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: 
                                Text(
                                  "${usersData["profCategory"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                            ),
                          ],
                        ),
                        Container(
                          height: 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("${usersData["image"]}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Oportunidades",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Recibidas",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      "${recOppors.length}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Enviadas",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      "${opporsData.length}",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ),
                        ]
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Ganancias",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Ganancias",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Sobre mí",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${usersData["presentation"]}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                    )
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Recompensa base",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${usersData["baseReward"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                        /*MaterialButton(
                          color: Colors.blue,
                          child: Text('Cambiar Recompensa Base', style: TextStyle(color: Colors.white)),
                          onPressed: (){}
                        ),*/
                      ],
                    )
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Ofertas publicadas:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),

                  //Crear funcion para buscar offer por iduser y enseñar lista de offers.

                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: offersData == null ? 0 : offersData.length,
                    //scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(offersData[index]["image"]),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("${offersData[index]["title"]}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text("${offersData[index]["description"]}".length >= 30 ?
                            "${offersData[index]["description"]}".substring(0, 30) + "..." : "${offersData[index]["description"]}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context){
                                return DetailOfferPage(offersData[index]);
                              }
                            )
                          );
                        },
                      );
                    }
                  ),
              ],
            )
        ),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),  
          ),
          border: Border.all(width: 1.0),
          /*boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              spreadRadius: 6,
              offset: Offset(0, -10),
            ),
          ],*/
        ),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return MessagePage(
                        widget.idUser,
                        widget.myProfile,
                        {}
                      );
                    }
                  ),
                );
              }, 
              icon: Icon(Icons.message),
            ),
            IconButton(
              onPressed: (){
                openEmail(usersData["email"]);
              },
              icon: Icon(Icons.email),
            ),
            IconButton(
              onPressed: (){
                openPhone(usersData["telephone"]);
              }, 
              icon: Icon(Icons.call),
            ),
            TextButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return SecondPage(
                        idUser, 
                        "",
                        widget.myProfile,
                      );
                    }
                  ),
                );
              },
              child: Text(
                "     Enviar\n" 
                "oportunidad",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),*/
      Column(
        children: <Widget>[
          Flexible(
            child: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage("https://www.elcampus360.com/wp-content/uploads/2021/10/Logged-out-1.png"),
                  fit: BoxFit.cover),
                ),
                child: Container(
                  padding: EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundColor: const Color(0xFF778899),
                          backgroundImage: NetworkImage("${usersData["image"]}"),
                        ),

                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                              child:Text("${usersData["name"]}", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold ,fontFamily: 'comfortaa',),),),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${usersData["businessName"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 12,fontFamily: 'roboto',),),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical:.0,),
                              child: Text("${usersData["profCategory"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 12,fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ],
                    ),
                ),
              ),
              //Oportunidades y ganancias
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                  children: [
                    Container(
                      decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5),),
                      padding: EdgeInsets.fromLTRB(5, 20, 5, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.20),
                                child:Text("Oportunidades", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold , fontFamily: 'comfortaa',),),),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.20),
                                        child: Column(
                                          children: [
                                            Container(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                                              child: Text("Generadas", style: TextStyle(color: Color(0xff303C50), fontSize: 11,fontFamily: 'roboto',),),
                                            ),
                                            Container(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.20),
                                              child: 
                                              Text("${opporsData.length}", style: TextStyle(color: Color(0xff1B2434), fontSize: 12, fontWeight: FontWeight.bold , fontFamily: 'comfortaa',),),
                                            ),
                                          ]
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.20),
                                        child: Column(children: [
                                          Container(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                                          child: Text("Recibidas", style: TextStyle(color: Color(0xff303C50), fontSize: 11,fontFamily: 'roboto',),),
                                          ),
                                          Container(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.20),
                                          child: Text("${recOppors.length}", style: TextStyle(color: Color(0xff1B2434), fontSize: 12, fontWeight: FontWeight.bold , fontFamily: 'comfortaa',),),
                                          ),
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: Colors.grey,
                    height: 50,
                    width: 1.0,
                  ),
                  VerticalDivider(),
                  
                  Column(
                    children: [
                      Container(
                        decoration: new BoxDecoration(color: Colors.white.withOpacity(0.5),),
                        padding: EdgeInsets.fromLTRB(5, 0, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.20),
                                  child:Text("Ganancias", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold , fontFamily: 'comfortaa',),),),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                                  child: 
                                    Text("${rewardsTotal} €")
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
                //Datos fiscales
                Container(
                  child: Column(
                    children: [
                      //Sobre mí
                      Container(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0,),
                              child:Text("SOBRE MÍ", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'comfortaa',),),),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0,),
                              child: Text("${usersData["presentation"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13, fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ),

                      //Recompensa base
                      Container(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0,),
                              child:Text("RECOMPENSA BASE:", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'comfortaa',),),),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0,),
                              child: Text("${usersData["baseReward"]} ${usersData["typeBaseReward"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13, fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ),

                      //Ofertas publicadas
                      Container(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0,),
                              child:Text("OFERTAS PUBLICADAS", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'comfortaa',),),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: offersData == null ? 0 : offersData.length,
                                //scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index){
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor: Color(0xFF778899),
                                      backgroundImage: NetworkImage(offersData[index]["image"]),
                                    ),
                                    title: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                                      child:Text("${offersData[index]["title"]}", style: TextStyle(color: Color(0xff1B2434), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'roboto',),),
                                    ),
                                    subtitle: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.20),
                                      child: Text("${offersData[index]["description"]}".length >= 30 ?
                                        "${offersData[index]["description"]}".substring(0, 30) + "..." : "${offersData[index]["description"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 12, fontFamily: 'roboto',),),
                                    ),
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context){
                                            return DetailOfferPage(offersData[index], widget.myProfile);
                                          }
                                        )
                                      );
                                    },
                                  );
                                }
                              ),
                            ),

                            offersData.length == 0 ?
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text("No existen ofertas de momento")
                            ) :
                            TextButton(
                              onPressed: (){
                                getMoreOffers();
                              }, 
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text("Mas ofertas",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  )
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),  
        ),
        border: Border.all(width: 1.0),
        /*boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            spreadRadius: 6,
            offset: Offset(0, -10),
          ),
        ],*/
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return MessagePage(
                      0,
                      widget.idUser,
                      widget.myProfile,
                      conversation,
                    );
                  }
                ),
              );
            }, 
            icon: Icon(Icons.message),
          ),
          IconButton(
            onPressed: (){
              openEmail(usersData["email"]);
            },
            icon: Icon(Icons.email),
          ),
          IconButton(
            onPressed: (){
              openPhone(usersData["telephone"]);
            }, 
            icon: Icon(Icons.call),
          ),
          TextButton(
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return SecondPage(
                      idUser, 
                      "",
                      widget.myProfile,
                    );
                  }
                ),
              );
            },
            child: Text(
              "     Enviar\n" 
              "oportunidad",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget botonFacturas(){
    return Container(
      child: Text("Ver Facturas", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'roboto',),
      )
    );
  }

  Widget botonOportunidad(){
    return Container(
      child: Text("Crear oportunidad", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'roboto',),
      )
    );
  }
}