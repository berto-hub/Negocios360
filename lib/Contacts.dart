import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'myChats.dart';
import 'myOffers.dart';
import 'myOpportunities.dart';
import 'searchUsers.dart';
import 'sendOportunity.dart';
import 'main.dart';
import 'myProfile.dart';
import 'myTeam.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactsPage extends StatefulWidget{

  @override
  Contacts createState() => Contacts();
}

class Contacts extends State<ContactsPage> {

  bool permissionDenied = false;
  List<Contact> contacts = [];

  var searchView = TextEditingController();
  String query = "";
  bool firstSearch = true;
  String result = "";

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Contacts(){
    searchView.addListener(() {
      if(searchView.text.isEmpty){
        setState(() {
          firstSearch = true;
          query = "";
        });
      }else{
        setState(() {
          firstSearch = false;
          query = searchView.text;
        });
      }
    });
  }

  Future fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => permissionDenied = true);
      print(permissionDenied);
    } else {
      final cont = await FlutterContacts.getContacts(withProperties: true, withThumbnail: true, withAccounts: true);
      setState(() => contacts = cont);
      print(contacts);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Contactos"),
        backgroundColor: Colors.blue.shade800,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          CreateSearchView(),
          firstSearch ? body() : bodySearch(),
        ]
      ),
    );
  }

  Widget CreateSearchView(){
    new Container(
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
                        //searchUsersMayus(result);//Tengo que hacer que solo busque una vez.
                        //searchUsersMinus(result);
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

    return new Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            //padding: EdgeInsets.only(top: 10, bottom: 10),
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
                    hintText: "Buscar contacto",
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search), 
                      onPressed: (){
                        setState(() {
                          result = searchView.text;
                        });
                      },
                    ),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    if (permissionDenied) return Center(child: Text('Permission denied'));
    if (contacts == null) return Center(child: CircularProgressIndicator());
    
    return Flexible(
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, i) => 
          ListTile(
            title: Text(contacts[i].displayName),
            subtitle: Text('${contacts[i].phones.isNotEmpty ? contacts[i].phones.first.number : ''}'),
            onTap: (){
              Map contact = {
                "id": contacts[i].id,
                "name": contacts[i].displayName,
                "phone": contacts[i].phones.isNotEmpty ? contacts[i].phones.first.number : "",
                "email": contacts[i].emails.isNotEmpty ? contacts[i].emails.first.address : "",
              };
              
              Navigator.pop(context, contact);
            }
          )
      ),
    );
  }

  Widget bodySearch() {
    if (permissionDenied) return Center(child: Text('Permission denied'));
    if (contacts == null) return Center(child: CircularProgressIndicator());

    Map filter = {};
    List filterList = [];
    /*if(firstSearch == false){
      filterList = usersData;
    }*/
    for(int i=0; i<contacts.length; i++){
      String name = contacts[i].displayName;
      if(name.toLowerCase().contains(result.toLowerCase())){
        filter = {
          "id": contacts[i].id,
          "name": name,
          "phone": contacts[i].phones.isNotEmpty ? contacts[i].phones.first.number : "",
          "email": contacts[i].emails.isNotEmpty ? contacts[i].emails.first.address : "",
        };
        filterList.add(filter);
      }
    }
    
    return Flexible(
      child: ListView.builder(
        itemCount: filterList.length,
        itemBuilder: (context, i) => 
          ListTile(
            title: Text(filterList[i]["name"]),
            subtitle: Text('${filterList[i]["phone"]}'),
            onTap: () async {
              Navigator.pop(context, filterList[i]);
            }
          )
      ),
    );
  }
}
