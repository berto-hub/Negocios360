import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as prefix;
import 'dart:math';
//import 'dart:html';

/*class Second extends StatefulWidget{
  @override
  _SecondState createState() => _SecondState();
}*/

class BaseRewardPage extends StatefulWidget{

  List profileData;
  BaseRewardPage(this.profileData);

  @override
  BaseReward createState() => BaseReward();
}

class BaseReward extends State<BaseRewardPage> {

  var rewardCont = TextEditingController();
  var typeRewardCont = TextEditingController();

  bool wall = false;
  String selection = '';
  //var image = File();
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar recompensa base'),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context, false);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ), 

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget> [
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(top: 5.0),
                      width: MediaQuery.of(context).size.width*0.50,
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
                            controller: rewardCont,
                            decoration: InputDecoration(
                              hintText: "${widget.profileData[0]["baseReward"]}",
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
                    padding: EdgeInsets.only(top: 5.0, left: 15),
                    width: MediaQuery.of(context).size.width*0.30,
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
                          controller: typeRewardCont,
                          decoration: InputDecoration(
                            hintText: "${widget.profileData[0]["typeBaseReward"]}",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            suffixIcon: PopupMenuButton<String>(
                              color: Colors.blue.shade100,
                              icon: Icon(Icons.arrow_drop_down),
                              onSelected: (String result){
                                setState(() {
                                  typeRewardCont.text = result;
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

              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical:20.0,),
                child: MaterialButton(
                  child: Text("Actualizar recompensa", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'roboto',)),
                  color: Color(0xff1B2434),
                  splashColor: Color(0xff303C50),
                  onPressed: (){
                    updateReward();
                  },
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0))
                ),
              ),
            ]
          ),
        )
      )
    );
  }

  Future<void> updateReward() async{
    if(rewardCont.text.isNotEmpty || typeRewardCont.text.isNotEmpty){
      var response = await http.patch(
        Uri.parse('https://us-central1-negocios360-5683c.cloudfunctions.net/app/updateBaseReward/${widget.profileData[0]["id"]}'), 
        body: ({
          'baseReward': rewardCont.text,
          'typeBaseReward': typeRewardCont.text,
        }),
      );

      if(response.statusCode==204){
        debugPrint("Inserted correctly.");
        Navigator.pop(context, true);
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