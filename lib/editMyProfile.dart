import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'myProfile.dart';
import 'sendOportunity.dart';
//import 'dart:html';
//import 'dart:js';

class EditProfilePage extends StatefulWidget{
  
  List profileData;
  EditProfilePage(this.profileData);

  @override
  EditProfile createState() => EditProfile();
}

class EditProfile extends State<EditProfilePage>{
  List usersData = [];

  var nameCont = TextEditingController();
  var emailCont = TextEditingController();
  var telCont = TextEditingController();
  var busNameCont = TextEditingController();
  var tradenameCont = TextEditingController();
  var profCatCont = TextEditingController();
  var comCont = TextEditingController();
  var presCont = TextEditingController();
  var keyWordsCont = TextEditingController();
  var passCont = TextEditingController();
  var passCont1 = TextEditingController();
  var cardNumCont = TextEditingController();
  var cardMonthCont = TextEditingController();
  var cardYearCont = TextEditingController();
  var cvcCont = TextEditingController();
  var IBANCont = TextEditingController();
  var keywordsCont = TextEditingController();

  /*editProfile() async {
    http.Response response = await http.get(Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/showOffers'));
    Map data = json.decode(response.body);
    //coger solo unos datos determinados:
    setState(() {
      usersData = data['offers'];
    });
    debugPrint(response.body);
  }*/

  @override
  void initState(){
    super.initState();
    presCont = TextEditingController(text: "${widget.profileData[0]["presentation"]}");
    keywordsCont = TextEditingController(text: "${widget.profileData[0]["keywords"]}");
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar perfil'),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: (){
            Navigator.pop(context, false);
          },
        )
      ), 

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Nombre de usuario",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: nameCont,
                        decoration: InputDecoration(
                          hintText: widget.profileData[0]["name"],
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Email",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: emailCont,
                        decoration: InputDecoration(
                          hintText: widget.profileData[0]["email"],
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("teléfono",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: telCont,
                        decoration: InputDecoration(
                          hintText: widget.profileData[0]["telephone"],
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Razón social",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: busNameCont,
                        decoration: InputDecoration(
                          hintText: widget.profileData[0]["businessName"],
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Nombre comercial",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: tradenameCont,
                        decoration: InputDecoration(
                          hintText: widget.profileData[0]["tradename"],
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Categoría profesional",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: profCatCont,
                        decoration: InputDecoration(
                          hintText: widget.profileData[0]["profCategory"],
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Comunidad",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: comCont,
                        decoration: InputDecoration(
                          hintText: widget.profileData[0]["community"],
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Presentación",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: presCont,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Palabras clave",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextField(
                        controller: keywordsCont,
                        decoration: InputDecoration(
                          hintText: widget.profileData[0]["keywords"],
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                ),

                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Cambiar contraseña",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Nueva contraseña",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TextField(
                            controller: passCont,
                            decoration: InputDecoration(
                              hintText: "Nueva contraseña",
                              hintStyle: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Repite contraseña",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TextField(
                            controller: passCont1,
                            decoration: InputDecoration(
                              hintText: "Repite contraseña",
                              hintStyle: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )
                    ]
                  )    
                ),

                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Tarjeta asociada",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )
                      ),
                      Align(
                        alignment: Alignment.centerLeft, 
                        child: ListTile(
                          title: Text("Tarjeta: " + "*" * 12 + "${widget.profileData[0]["cardNumber"]}".substring(8)),//En vez de 8 son 13 o 12
                          subtitle: Text("Tipo: ${widget.profileData[0]["cardType"]}",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),

                /*Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Nueva tarjeta",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Text("Nº de tarjeta",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.credit_card_rounded,
                              ),
                              Container(
                                width: 350,
                                child: TextField(
                                  controller: cardNumCont,
                                  decoration: InputDecoration(
                                    hintText: "Nº de tarjeta",
                                    hintStyle: TextStyle(
                                      color: Colors.grey
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Text("Mes de vencimiento",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                              ),
                              Container(
                                width: 350,
                                child: TextField(
                                  controller: cardMonthCont,
                                  decoration: InputDecoration(
                                    hintText: "Mes de vencimiento",
                                    hintStyle: TextStyle(
                                      color: Colors.grey
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Text("Año de vencimiento",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                              ),
                              Container(
                                width: 350,
                                child: TextField(
                                  controller: cardYearCont,
                                  decoration: InputDecoration(
                                    hintText: "Año de vencimiento",
                                    hintStyle: TextStyle(
                                      color: Colors.grey
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Text("cvc",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 350,
                              child: TextField(
                                controller: cvcCont,
                                decoration: InputDecoration(
                                  hintText: "cvc",
                                  hintStyle: TextStyle(
                                    color: Colors.grey
                                  ),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                  )    
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Nº de IBAN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        )
                      ),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:Text("Nº de IBAN",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.archive,
                              ),
                              Container(
                                width: 350,
                                child: TextField(
                                  controller: IBANCont,
                                  decoration: InputDecoration(
                                    hintText: "${widget.profileData[0]["IBAN"]}",
                                    hintStyle: TextStyle(
                                      color: Colors.grey
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]
                  )    
                ),*/
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: OutlinedButton.icon(
                    onPressed: (){
                      /*Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return ProfilePage(widget.profileData);
                          }
                        ),
                        //(Route<dynamic> route) => route is ProfilePage,
                      );*/
                      editProfile();
                    }, 
                    icon: Icon(Icons.save, size: 18), 
                    label: Text("Guardar")
                  ),
                ),
              ],
            )
          )
        )
      )
    );
  }

  Future<void> editProfile() async{
    var id = widget.profileData[0]["id"];
    print(widget.profileData[0]);
    debugPrint(id);
    
    var response = await http.patch(
      Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/editMyProfile/${id}'), 
      body: ({
        'businessName': (busNameCont.text.isNotEmpty)?busNameCont.text : widget.profileData[0]["businessName"], 
        'name': (nameCont.text.isNotEmpty)?nameCont.text : widget.profileData[0]["name"],
        'telephone': (telCont.text.isNotEmpty)?telCont.text : widget.profileData[0]["telephone"],
        'email': (emailCont.text.isNotEmpty)?emailCont.text : widget.profileData[0]["email"],
        'tradename': (tradenameCont.text.isNotEmpty)?tradenameCont.text : widget.profileData[0]["tradename"],
        'profCategory': (profCatCont.text.isNotEmpty)?profCatCont.text : widget.profileData[0]["profCategory"],
        'community': (comCont.text.isNotEmpty)?comCont.text : widget.profileData[0]["community"],
        'presentation': (presCont.text.isNotEmpty)?presCont.text : widget.profileData[0]["presentation"],
        'password': (passCont.text.isNotEmpty)?passCont.text : widget.profileData[0]["password"],
        'cardNumber': (cardNumCont.text.isNotEmpty)?cardNumCont.text : widget.profileData[0]["cardNumber"],
        'cardMonthExpir': (cardMonthCont.text.isNotEmpty)?cardMonthCont.text : widget.profileData[0]["cardMonthExpir"],
        'cardYearExpir': (cardYearCont.text.isNotEmpty)?cardYearCont.text : widget.profileData[0]["cardYearExpir"],
        'cvc': (cvcCont.text.isNotEmpty)?cvcCont.text : widget.profileData[0]["cvc"],
        'IBAN': (IBANCont.text.isNotEmpty)?IBANCont.text : widget.profileData[0]["IBAN"],
        'keywords': (keywordsCont.text.length > widget.profileData[0]["keywords"].length)?
          (keywordsCont.text + "/") : (keywordsCont.text.length < widget.profileData[0]["keywords"].length)?
            (keywordsCont.text + "/") : widget.profileData[0]["keywords"],
      }),
    );
    //if(passCont.text != passCont1.text){

      if(response.statusCode==204){
        debugPrint("Inserted correctly.");
        Navigator.pop(context, true);
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
    /*}else{
      debugPrint("Not Allowed");
      //ScaffoldMessenger.of(context)
      //.showSnackBar(SnackBar(content: Text("Not Allowed")));
    }*/
  }
}