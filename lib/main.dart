import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
//import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:negocios360app/createOffer.dart';
import 'package:negocios360app/otherProfile.dart';
import 'dart:async';
import 'dart:convert';
import 'myChats.dart';
import 'myProfile.dart';
import 'wall.dart';
import 'sendOportunity.dart';
import 'editMyProfile.dart';
import 'createOffer.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:get/get.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:meta/meta.dart';

/*void main() => runApp(UserApp());

class UserApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Tareas'),),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            List<DocumentSnapshot> docs = snapshot.data!.documents;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index){
                Map<String, dynamic> data = docs[index].data;
                return ListTile(
                  title: Text(data['name']),
                );
              },
            );
          },
        ),
      ),
    );
  }
}*/

void main() async{
  List profileData;
  var signIn = SignIn().usersData;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //final FirebaseFirestore firestore = FirebaseFirestore.instanceFor(app: app);
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();

  //await FirebaseAuth.instance.useAuthEmulator('localhost', 5000);

  runApp(
    MaterialApp(
      //home: HomePage()
      //theme: ThemeData(primarySwatch: Colors.teal),
      routes: {
        '/one': (context) => HomePage(signIn),//Wall
        //'/two': (context) => SecondPage(signIn),//Send oportunity
        '/three': (context) => SignInPage(),//Sign in
        '/four': (context) => ProfilePage(signIn),//My profile
        '/five': (context) => EditProfilePage(signIn),//Edit my profile
        //'/six': (context) => CreateOfferPage(signIn),//Create offer
        '/myChats': (context) => ChatPage(signIn),
      },
      initialRoute: '/three',
      //home: MenuPage(),
    ),
  );
}

class SignInPage extends StatefulWidget{
  @override
  SignIn createState() => SignIn();
}

class SignIn extends State<SignInPage>{

  //FirebaseAuth auth = FirebaseAuth.instance;
  //User? user;
  //final formKey = GlobalKey<FormState>();
  var emailCont = TextEditingController();
  var passCont = TextEditingController();

  List usersData = [];
  /*@override
  void initState(){
    auth.userChanges().listen(
      (event) => setState(()=> user = event),
    );
    super.initState();
  }*/

  /*@override
  void dispose() {
    emailCont.dispose();
    passCont.dispose();
    super.dispose();
  }*/

  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Image.network("https://www.elcampus360.com/wp-content/uploads/2021/10/Logged-out.png").image,
          fit: BoxFit.cover,
        ), 
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Stack(
            children:[
              Container(
                child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            key: Key("email"),
                            controller: emailCont,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: "Email",
                              border: OutlineInputBorder(), 
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextFormField(
                            key: Key("password"),
                            controller: passCont,
                            obscuringCharacter: '*',
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              labelText: "Contraseña",
                              border: OutlineInputBorder(),
                            )
                          ),
                        ),
                      SizedBox(
                        width:double.infinity, 
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: MaterialButton(//RaisedButton
                            color: Color.fromRGBO(27, 36, 52, 1.0),
                            textColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.transparent)
                                                
                            ),
                            
                            onPressed: () async{
                              try{
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: emailCont.text, 
                                  password: passCont.text,
                                );

                                List profileData = [];
                                //getProfile();
                                profileData = await getProfile();
                                print("ProfileData: " + "${profileData}");
                                if(emailCont.text.isNotEmpty && passCont.text.isNotEmpty){
                                  if(profileData == []){
                                    ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("No estás registrado")));
                                  }else{
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(
                                        builder: (BuildContext context){
                                          return HomePage(profileData);
                                        }
                                      )
                                    );
                                    ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("Bienvenido")));
                                  }
                                }else{
                                  ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text("El campo está vacío")));
                                }
                              }catch(e){
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text("No estás registrado")));
                              }

                                
                                /*print("Signed in correcly");
                              }catch(e){
                                /*Get.snackbar("Fallo", "No puede ingresar", 
                                  snackPosition: SnackPosition.BOTTOM);*/
                                  print("Error when sign in");
                              }*/
                              
                            },
                            child: Text(
                              "Iniciar sesión",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                )
              )
            ),    
          ),
        ],
      ),
      )
    ),
  );
       
  }

  Future <List> getProfile() async {
    http.Response response = await http.get(Uri.parse("https://us-central1-negocios360-5683c.cloudfunctions.net/app/myProfile" + "/${emailCont.text}" + "/${passCont.text}"));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersData = data['profile'];
    });
    debugPrint(response.body);
    print(emailCont.text);
    //ProfilePage(usersData);
    return usersData;
  }

  /*Future<void> signInEmailPass() async {
    try{
      final User user = (await auth.signInWithEmailAndPassword(
          email: emailCont.text, 
          password: passCont.text,
        )
      ).user!;
      //ScaffoldMessenger.of(context).("Sign in correctly");
      /*Future.delayed(
        Duration(hours: 2),
        (){
          
        }
      );*/
      print("Signed in correcly");
    }catch(e){
      /*Get.snackbar("Fallo", "No puede ingresar", 
        snackPosition: SnackPosition.BOTTOM);*/
        print("Error when sign in");
    }
  }*/
}
