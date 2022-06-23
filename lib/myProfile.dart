import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/Drawer.dart';
import 'package:negocios360app/Offer.dart';
import 'dart:async';
import 'dart:convert';
import 'editBaseReward.dart';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'Offer.dart';
import 'main.dart';
import 'myChats.dart';
import 'myOffers.dart';
import 'myOpportunities.dart';
import 'myTeam.dart';
import 'myTeams.dart';
import 'searchUsers.dart';
import 'wall.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget{

  List profileData;
  ProfilePage(this.profileData);

  @override
  Profile createState() => Profile();
}

class Profile extends State<ProfilePage>{

  List usersData = [];
  List offersData = [];
  List opporsData = [];
  List recOppors = [];

  bool edit = false;
  Map profile = {};

  List rewards = [];
  List idRewards = [];

  getEditedProfile() async {
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${widget.profileData[0]["id"]}'));
    Map data = json.decode(response.body);
    print(data);
    setState(() {
      profile = data['profile'];
      profile["id"] = widget.profileData[0]["id"];

      usersData[0] = profile;
    });

    print(profile);
    print(usersData);
  }

  getProfile() async {
    setState(() {
      usersData = widget.profileData;
    });
    print(usersData);
  }

  getOffers() async{
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOfferUser/${widget.profileData[0]["id"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      offersData = data["offer"];
    });
    print(offersData);
  }

  getOppors() async{
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getOpportunityUser/${widget.profileData[0]["id"]}'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      opporsData = data["opportunity"];
    });
    print(opporsData);
  }

  double rewardsTotal = 0;
  getRewards() async {
    idRewards = widget.profileData[0]["reward"].split("/");
    print(idRewards);

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
  }

  void showPhotoSheet(){
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("Tomar foto"),
                  onTap: () {
                    openCamera();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.insert_photo_rounded),
                  title: Text("Foto de la galeria"),
                  onTap: () {
                    openGallery();
                  },
                ),
              ],
            ) 
          )
        );
      }
    );
  }

  Future<void> editImageProfile(String path) async{
    var id = widget.profileData[0]["id"];
    print(widget.profileData[0]);
    
    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/editImageProfile/${id}'), 
      body: ({
        'image': path,
      }),
    );
    //if(passCont.text != passCont1.text){

    if(response.statusCode==204){
      debugPrint("Inserted correctly.");
      //Navigator.pop(context, true);
    }else{
      debugPrint("Invalid Credentials");
      //ScaffoldMessenger.of(context)
      //.showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
    
  }

  ImagePicker imagePicker = ImagePicker();
  FileImage? image;
  var imagePath = "";
  FirebaseStorage storage = FirebaseStorage.instance;

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void openCamera () async{
    var picture = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );
    if(picture == null) return;

    File file = File(picture.path);
    //String nameFile = base(picture.path);

    String idImage = getRandomString(8);
    //final TaskSnapshot st;
    var url;
    try{
      final TaskSnapshot st = await storage.ref('negocios360app/${idImage}').putFile(file);
      url = await st.ref.getDownloadURL();
    }catch(e){
      print(e);
    }

    FileImage imageF = FileImage(file);
    String imageUrl = url.toString();

    setState(() {
      image = imageF;
      imagePath = picture.path;
      usersData[0]["image"] = imageUrl;
    });
    
    print("URL: " + imageUrl);

    editImageProfile(imageUrl);
    /*.then(  
      (value) => Navigator.pushReplacement(
        context, MaterialPageRoute(
          builder: (BuildContext context){
            return ProfilePage(widget.profileData);
          }
        )
      )
    )*/;
    print(imagePath);
  }

  void openGallery () async{
    var picture = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    if(picture == null) return;
    File file = File(picture.path);

    String idImage = getRandomString(8);
    //final TaskSnapshot st;
    var url;
    try{
      final TaskSnapshot st = await storage.ref('negocios360app/${idImage}').putFile(file);
      url = await st.ref.getDownloadURL();
    }catch(e){
      print(e);
    }

    FileImage imageF = FileImage(File(picture.path));
    String imageUrl = url.toString();

    setState(() {
      image = imageF;
      imagePath = picture.path;
      usersData[0]["image"] = imageUrl;
    });

    print("URL: " + imageUrl);

    editImageProfile(imageUrl);
  }

  FileImage imageConversion(String path) {
    return FileImage(new File(path));
  }

  @override
  void initState(){
    super.initState();
    getProfile();
    getOffers();
    getOppors();
    getRewards();
    recOppors = usersData[0]["opportunities"].split("/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mi perfil"),
        backgroundColor: Colors.blue.shade800,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context){
                    return EditProfilePage(widget.profileData);
                  }
                )
              ).then((value){
                edit = value;
                if(edit == true){getEditedProfile();}
              });
            },
          ),

          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: DrawerBlock(),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://www.elcampus360.com/wp-content/uploads/2021/10/Logged-out-1.png"),
                  fit: BoxFit.cover),
                ),
                child: Container(
                  padding: EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () {
                            showPhotoSheet();
                          },
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor: const Color(0xFF778899),
                            backgroundImage:
                              NetworkImage(usersData[0]["image"]),
                              //imageConversion(usersData[0]["image"]),//Upload la imagen
                          ),
                        ),

                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                              child:Text("${usersData[0]["name"]}", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold ,fontFamily: 'comfortaa',),),),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${usersData[0]["businessName"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 12,fontFamily: 'roboto',),),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical:.0,),
                              child: Text("${usersData[0]["profCategory"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 12,fontFamily: 'roboto',),),
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
                                              child: Text("${opporsData.length}", style: TextStyle(color: Color(0xff1B2434), fontSize: 12, fontWeight: FontWeight.bold , fontFamily: 'comfortaa',),),
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
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0,),
                        child:Text("DATOS FISCALES", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold ,fontFamily: 'comfortaa',),),),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0),
                              child: Text("CIF:", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${usersData[0]["CIF"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0),
                              child: Text("Dirección:", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${usersData[0]["address"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0),
                              child: Text("CP:", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${usersData[0]["CP"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0),
                              child: Text("Localidad:", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${usersData[0]["location"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0),
                              child: Text("IVA:", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${usersData[0]["IVA"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0),
                              child: Text("IBAN:", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text("${usersData[0]["IBAN"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13,fontFamily: 'roboto',),),
                            ),
                          ],
                        ),
                      ),
                      /*Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical:20.0,),
                        child: MaterialButton(
                          child: botonFacturas(),
                          color: Color(0xff1B2434),
                          splashColor: Color(0xff303C50),
                          onPressed: (){},
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                        ),
                      ),*/

                      //Sobre mí
                      Container(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0,),
                              child:Text("SOBRE MÍ", style: TextStyle(color: Color(0xff1B2434), fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'comfortaa',),),),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0,),
                              child: Text("${usersData[0]["presentation"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13, fontFamily: 'roboto',),),
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
                              child: Text("${usersData[0]["baseReward"]} ${usersData[0]["typeBaseReward"]}", style: TextStyle(color: Color(0xff303C50), fontSize: 13, fontFamily: 'roboto',),),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 35.0, vertical:20.0,),
                              child: MaterialButton(
                                child: botonRecompensaBase(),
                                color: Color(0xff1B2434),
                                splashColor: Color(0xff303C50),
                                onPressed: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context){
                                        return BaseRewardPage(usersData);
                                      }
                                    )
                                  ).then((value) {
                                    if(value == true){getEditedProfile();}
                                  });
                                },
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                              ),
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
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0,),
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
                                            return DetailOfferPage(offersData[index], widget.profileData);
                                          }
                                        )
                                      );
                                    },
                                  );
                                }
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

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), 
                topRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 30,
                  spreadRadius: 10,
                  offset: Offset(0,0),
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical:5.0,),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.07,
              child: botonOferta(),
              color: Color(0xff1B2434),
              splashColor: Color(0xff303C50),
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context){
                      return CreateOfferPage(usersData);
                    }
                  )
                );
              },
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
            ),
          ),
        ],
      ),
    );
  }

  Widget botonFacturas(){
    return Container(
      child: Text("Ver Facturas", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'roboto',),
      )
    );
  }

  Widget botonRecompensaBase(){
    return Container(
      child: Text("Editar", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'roboto',),
      )
    );
  }

  Widget botonOferta(){
    return Container(
      child: Text("Crear oferta", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'roboto',),
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
        Ink(
          color: Colors.blue.shade200,
          child: ListTile(
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
              Navigator.pop(context);
            },
          ),
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

        widget.profileData[0]["role"] == "manager" || 
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