import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as prefix;
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
//import 'dart:html';

/*class Second extends StatefulWidget{
  @override
  _SecondState createState() => _SecondState();
}*/

class CreateOfferPage extends StatefulWidget{

  List profileData;
  CreateOfferPage(this.profileData);

  @override
  OfferCreation createState() => OfferCreation();
}

//Id de la oportunidad;

class OfferCreation extends State<CreateOfferPage> {

  var titleCont = TextEditingController();
  var desCont = TextEditingController();
  var reCont = TextEditingController();
  var typeReCont = TextEditingController();
  var teamCont = TextEditingController();

  bool wall = false;
  String selection = '';
  String id = "";

  String idTeam = "";
  //var image = File();

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List teams = [];
  String idT = "";
  List <String> nameTeams = [];
  Map t = {};
  bool change = false;

  Map chooseTeam = {};
  bool photo = false;

  bool loadingImage = false;
  
  Future<void> myTeams(String id) {
    // code to convert the first character to uppercase
    /*String searchKey;
    if(name[0] != name[0].toUpperCase()){
      searchKey = name[0].toUpperCase() + name.substring(1);
    }else{
      searchKey = name[0] + name.substring(1);
    }*/
    
    return firestore
      .collection("teams")
      .doc(id)
      /*.orderBy("name")
      .startAt([searchKey])
      .endAt([searchKey + "\uf8ff"])*/
      .get()
      .then((result) {
        //for (DocumentSnapshot<Map<String, dynamic>> team in result.data()) {
          setState(() {
            t = result.data()!;
            t["id"] = result.id;
            teams.add(t);
            nameTeams.add(t["name"]);
            print(t);
            print(t["name"]);
          });
        //}

        //return filterTeams;
      });
  }

  Future<void> teamsAdmin(String name) {
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
        for (DocumentSnapshot<Map<String, dynamic>> team in result.docs) {
          setState(() {
            t = team.data()!;
            t["id"] = team.id;
            teams.add(t);
            nameTeams.add(t["name"]);
            print(t);
            print(t["name"]);
          });
        }

        //return filterTeams;
      });
  }

  /*Future<List> searchTeamsMinus(String name) {
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
  }*/

  @override
  void initState() {
    super.initState();
    id = getRandomString(8);
    print(id);
    print(widget.profileData[0]);

    if(widget.profileData[0]["role"] == "administrator"){
      teamsAdmin("");
    }else{
      List teams = widget.profileData[0]["idTeam"].split("/");
      for(int i=0; i<teams.length; i++){
        myTeams(teams[i]);
      }
    }
  }

  Widget pickTeam() {
    return AlertDialog(
      title: Text('Tus equipos'),
      content: Container(
        width: double.minPositive,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: teams.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(teams[index]["name"]),
              onTap: () {
                print(teams[index]);
                setState(() {
                  chooseTeam = teams[index];
                  teamCont.text = teams[index]["name"];
                });
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear oferta'),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ), 

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.profileData[0]["role"] == "user" ?
              Container() :
              Container(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)
                    ),
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                      controller: teamCont,
                      decoration: InputDecoration(
                        labelText: "Nombre del equipo",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.arrow_circle_down),
                          onPressed: (){
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return pickTeam();
                              }
                            );
                          },
                        ),
                        /*suffixIcon: PopupMenuButton<String>(
                          color: Colors.white,
                          icon: Icon(Icons.arrow_drop_down),
                          onSelected: (String result){
                            setState(() {
                              typeReCont.text = result;
                            });
                          },
                          itemBuilder: (BuildContext context) => 
                            //ListView.builder(itemBuilder: context) =>
                            <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: '%',
                              child: Text('%'),
                            ),
                            PopupMenuItem<String>(
                              value: '€',
                              child: Text('€'),
                            ),
                          ]
                        ),*/
                      ),
                      textAlign: TextAlign.left,
                    ),
                    /*child: 
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return nameTeams.where((String option) {
                          //idT = teams[]
                          
                          return option.contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selection) {
                        debugPrint('You just selected $selection');
                      },)*/
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)
                    ),
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                      controller: titleCont,
                      decoration: InputDecoration(
                        labelText: "Título",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                      textAlign: TextAlign.left,
                    )
                  ),
                ),
              ),

              Container(
                height: 200,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey)
                    ),
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                      controller: desCont,
                      decoration: InputDecoration(
                        labelText: "Descripción",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                      textAlign: TextAlign.left,
                    )
                  ),
                ),
              ),
              
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(top: 5.0),
                      width: 150,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                          ),
                          padding: const EdgeInsets.all(3.0),
                          child: TextField(
                            style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                            controller: reCont,
                            decoration: InputDecoration(
                              labelText: "Recompensa",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            textAlign: TextAlign.left,
                          )
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Info'),
                          content: const Text('Campo donde se introduce la recompensa por oportunidad deseada.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.info_rounded)
                  ),

                  Container(
                    padding: EdgeInsets.only(top: 5.0),
                    width: 150,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)
                        ),
                        padding: const EdgeInsets.all(3.0),
                        child: TextField(
                          style: TextStyle(color: Color(0xff1B2434), fontSize: 15, fontFamily: 'roboto',),
                          controller: typeReCont,
                          decoration: InputDecoration(
                            labelText: "Tipo de recompensa",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            suffixIcon: PopupMenuButton<String>(
                              color: Colors.blue,
                              icon: Icon(Icons.arrow_drop_down),
                              onSelected: (String result){
                                setState(() {
                                  typeReCont.text = result;
                                });
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: '%',
                                  child: Text('%'),
                                ),
                                PopupMenuItem<String>(
                                  value: '€',
                                  child: Text('€'),
                                ),
                              ]
                            ),
                          ),
                          textAlign: TextAlign.left,
                        )
                      ),
                    ),
                  ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: <Widget>[
                    loadingImage == true ?
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ) :
                    photo == true ? 
                    Container(
                      padding: EdgeInsets.fromLTRB(130, 10, 0, 5),
                      child: Text("Foto cargada",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: 20,
                        ),
                      )
                    ) :
                    IconButton(
                      onPressed: (){
                        showPhotoSheet();
                      }, 
                      icon: Icon(Icons.photo)
                    ),
                    /*IconButton(
                      onPressed: (){
                        Text("No se pueden colgar videos aun.");
                      }, 
                      icon: Icon(Icons.video_camera_back),
                    ),*/
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      checkColor: Colors.white,
                      value: wall,
                      onChanged: (bool? value) {
                        setState(() {
                          wall = value!;
                          print(value);
                        });
                      },
                    ),
                    Text(
                      "Publicarlo en el muro",
                      style: TextStyle(
                          fontSize: 10,
                      ),
                    ),
                  ],
                )
              ),

              Padding(
                padding: const EdgeInsets.all(3.0),
                child: OutlinedButton.icon(
                  onPressed: (){
                    //Navigator.pop(context);
                    createOffer();
                    if(wall == true){
                      setWall();
                    }
                  }, 
                  icon: Icon(Icons.public, size: 18), 
                  label: Container(
                    padding: EdgeInsets.all(5),
                    child: Text("Publicar oferta")
                  ),
                ),
              ),
            ],
          )
        )
      )
    );
  }

//Al dar al botón llamar una función que actualice la lista de 
//ids de oportunidades con el id de la nueva oportunidad dentro 
//de la tabla de ofertas, para así poder mostrar las oportunidades 
//enviadas a la oferta.

  String imageOffer = "";

  Future<void> createOffer() async{
    print(id);
    if(desCont.text.isNotEmpty && titleCont.text.isNotEmpty 
    && reCont.text.isNotEmpty && typeReCont.text.isNotEmpty){
      var response = await http.post(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createOffer'), 
        body: ({
          'idOffer': id,
          'user': widget.profileData[0]["id"],
          'title': titleCont.text,
          'description': desCont.text, 
          'reward': reCont.text,
          'typeReward': typeReCont.text,
          'image': imageOffer,
          'video': "",
        }),
      );

      Map newOffer = {
        'idOffer': id,
        'user': widget.profileData[0]["id"],
        'title': titleCont.text,
        'description': desCont.text, 
        'reward': reCont.text,
        'typeReward': typeReCont.text,
        'image': imageOffer,
        'video': "",
      };
      print(newOffer);

      if(response.statusCode==204){
        Navigator.pop(context, newOffer);
        debugPrint("Inserted correctly.");
        
        //updateEmailOpor(emailCont.text);

        //ScaffoldMessenger.of(context)
        //.showSnackBar(SnackBar(content: Text("Oportunity Sended.")));
        //Navigator.push(
          //context, MaterialPageRoute(builder: (context) => Second()));
      }else{
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      }
    }else{
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text("Not Allowed")));
    }
  }

  Future<void> setWall() async{
    print(id);
    print(idTeam);

    //List teams = widget.profileData[0]["idTeam"].split("/");
    //print(teams.length);

    //for(int i=0; i<teams.length; i++){
      if(desCont.text.isNotEmpty && titleCont.text.isNotEmpty 
      && reCont.text.isNotEmpty && typeReCont.text.isNotEmpty){
        var response = await http.post(
          Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/setWall'), 
          body: ({
            'id': id,
            'idTeam': chooseTeam["id"],
            'type': 'offer',
          }),
        );

        if(response.statusCode==204){
          debugPrint("Inserted correctly.");
          //updateEmailOpor(emailCont.text);

          //ScaffoldMessenger.of(context)
          //.showSnackBar(SnackBar(content: Text("Oportunity Sended.")));
          //Navigator.push(
            //context, MaterialPageRoute(builder: (context) => Second()));
        }else{
          ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
        }
      }else{
        ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Not Allowed")));
      }
    //}
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

  /*ImagePicker imagePicker = ImagePicker();

  void openCamera () async{
    var picture = await imagePicker.pickImage(
      source: ImageSource.camera
    );
  }

  void openGallery () async{
    var picture = await imagePicker.pickImage(
      source: ImageSource.gallery
    );
  }*/

  ImagePicker imagePicker = ImagePicker();
  FileImage? image;
  var imagePath = "";
  FirebaseStorage storage = FirebaseStorage.instance;

  final _charsIm = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rndIm = Random();

  String getRandomStringImage(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _charsIm.codeUnitAt(_rndIm.nextInt(_charsIm.length))));

  void openCamera () async{
    var picture = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );
    if(picture == null) return;
    String idImage = getRandomStringImage(8);
    
    File file = File(picture.path);
    //String nameFile = base(picture.path);
    setState(() {
      loadingImage = true;
    });

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
      //usersData[0]["image"] = imageUrl;
      imageOffer = imageUrl;
      photo = true;
      loadingImage = false;
      //Navigator.pop(context);
    });
    
    print("URL: " + imageUrl);

    //editImageOffer(imageUrl);
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

    String idImage = getRandomStringImage(8);
    setState(() {
      loadingImage = true;
    });
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
      //usersData[0]["image"] = imageUrl;
      imageOffer = imageUrl;
      photo = true;
      loadingImage = false;
      //Navigator.pop(context);
    });

    print("URL: " + imageUrl);

    //editImageOffer(imageUrl);
  }
}