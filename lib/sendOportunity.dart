import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'Contacts.dart';
//import 'dart:html';

/*class Second extends StatefulWidget{
  @override
  _SecondState createState() => _SecondState();
}*/

class SecondPage extends StatefulWidget{

  String idUser = "";
  String idOffer = "";
  List myProfile = [];
  SecondPage(this.idUser, this.idOffer, this.myProfile);

  @override
  OportunityCreation createState() => OportunityCreation();
}

class OportunityCreation extends State<SecondPage> {

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


  var desCont = TextEditingController(
    text: "Te paso contacto de alguien interesado en tu oferta."
  );
  var nameCont = TextEditingController();
  var telCont = TextEditingController();
  var emailCont = TextEditingController();
  var usersName;

  List<Contact>? _contacts;
  bool permissionDenied = false;

  String id = "";

  @override
  void initState(){
    super.initState();
    id = getRandomString(10);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear oportunidad'),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ), 
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Text("Introduce los datos requeridos para enviar la oportunidad",
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
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
                      child: Padding(
                        padding: EdgeInsets.only(right: 8, left: 8),
                        child: TextField(
                          style: TextStyle(color: Color(0xff1B2434), fontSize: 15,fontFamily: 'roboto',),
                          controller: desCont,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: "Descripción",
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

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text("Detalles del contacto",
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                        style: TextStyle(color: Color(0xff1B2434), fontSize: 15,fontFamily: 'roboto',),
                        controller: nameCont,
                        decoration: InputDecoration(
                          hintText: "Nombre de contacto",
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
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                        style: TextStyle(color: Color(0xff1B2434), fontSize: 15,fontFamily: 'roboto',),
                        controller: telCont,
                        decoration: InputDecoration(
                          hintText: "Teléfono de contacto",
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
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
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
                        style: TextStyle(color: Color(0xff1B2434), fontSize: 15,fontFamily: 'roboto',),
                        controller: emailCont,
                        decoration: InputDecoration(
                          hintText: "Email de contacto",
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
                
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: OutlinedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue.shade800),
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                      createOportunity(id);
                      getUserOpor(id);
                    }, 
                    icon: Icon(Icons.send, 
                      size: 18,
                      color: Colors.white,
                    ), 
                    label: Container(
                      padding: EdgeInsets.all(5),
                      child: Text("      Enviar\noportunidad",
                        style: TextStyle(
                          color: Colors.white,
                          //backgroundColor: Colors.blue.shade800
                        ),
                      ),
                    )
                  ),
                ),
              ],
            )
          )
        )
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //bottomSheet();
          //final fullContact = await FlutterContacts.getContacts();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context){
                return ContactsPage();
              }
            ),  
          ).then((value) {
              print(value);
              nameCont.text = value["name"];
              telCont.text = value["phone"];
              emailCont.text = value["email"];
            }
          );
        },
        child: const Icon(Icons.contacts_rounded),
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }

//Al dar al botón llamar una función que actualice la lista de 
//ids de oportunidades con el id de la nueva oportunidad dentro 
//de la tabla de ofertas, para así poder mostrar las oportunidades 
//enviadas a la oferta.

  /*Future<void> updateEmailOpor(String email) async {
    var response = await http.put(
        Uri.parse('http://localhost:5000/networking-360-5d7b7/us-central1/app/updateOporOffer'), 
        body: ({
          'oporEmail': email,
        }),
      );
  }*/

  void bottomSheet(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Permitir acceso a contactos",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ListTile(
                title: new Text('Permitir'),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return ContactsPage();
                      }
                    ),  
                  )
                }          
              ),
              ListTile(
                title: new Text('Denegar'),
                onTap: () => {
                  Navigator.pop(context),
                },          
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> getUserOpor(String id) async{
    var response = await http.get(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/getProfile/${widget.idUser}'));
    var data = json.decode(response.body);
    //coger solo unos datos determinados:
    //setState(() {
      usersName = data['profile'];
    //});
    print(usersName);

    String opor = "";
    //print(usersName['opportunities']);

    if(usersName['opportunities'] == ""){
      opor = id;
    }else{
      opor = usersName['opportunities'];
      opor = opor + "/" + id;
    }
    print(opor);

    //setState(() {
      widget.myProfile[0]["opportunities"] = opor;
    //});

    messageUserOpor(opor);
  }

  Future<void> messageUserOpor(String opors) async{
    /*var response = await http.get(
        Uri.parse('http://localhost:5000/networking-360-5d7b7/us-central1/app/getProfile/${widget.idUser}'));
    var data = json.decode(response.body);
    //coger solo unos datos determinados:
    //setState(() {
      usersName = data['profile'];
    //});
    print(usersName);
    List<String> opor = [];
    opor.add("hello");
    print(opor);
    usersName['opportunities'] = opor;*/
    /*Map<String, dynamic> args = {"opportunities": opors};
    print(args);
    var b = json.encode(args);
    print(b);*/

    var res = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/profileOpor/${widget.idUser}'),
      body: {
        'opportunities': opors,
      },
    );
  }

  Future<void> createOportunity(String id) async{
    if(desCont.text.isNotEmpty && nameCont.text.isNotEmpty 
    && emailCont.text.isNotEmpty && telCont.text.isNotEmpty){

      var response = await http.post(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/createOpportunity'), 
        body: ({
          'idOpor': id,
          'idOffer': widget.idOffer,
          'idUser': widget.myProfile[0]["id"],
          'description': desCont.text, 
          'name': nameCont.text,
          'telephone': telCont.text,
          'email': emailCont.text,
        }),
      );

      //print(id);
      //messageUserOpor(id);

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
  }
}