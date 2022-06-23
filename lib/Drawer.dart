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

class DrawerList extends StatelessWidget {
  List pData;
  DrawerList(this.pData);

  @override
  Widget build(BuildContext context){
    return Drawer(
    child: ListView(
      padding: EdgeInsets.all(1.0),
      children: <Widget>[
        DrawerHeader(
          child: /*Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage("${pData[0]["image"]}"),
                radius: 30.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12), 
                child: Text("${pData[0]["email"]}"),
              ),
            ],
          ),*/
          Text("Menú"),
          
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
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
                  return ProfilePage(pData);
                }
              )
            );
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
            Navigator.pop(context);
          },
        ),

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
                  return TeamPage(pData, pData[0]["idTeam"]);
                }
              )
            );
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
                  return OfferPage(pData);
                }
              )
            );
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
                  return OpportunityPage(pData);
                }
              )
            );
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
                  return UserSearchPage(pData);
                }
              )
            );
          },
        ),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.person_add),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Invitar"),
              ),
            ],
          ),
          onTap: (){
            Navigator.pop(context);
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
                  return ChatPage(pData);
                }
              )
            );
          },
        ),

        ListTile(
          title: Row(
            children: [
              Icon(Icons.coffee),
              Padding(
                padding: EdgeInsets.only(left: 11.0),
                child: Text("Eventos"),
              ),
            ],
          ),
          onTap: (){
            Navigator.pop(context);
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
            Navigator.pop(context);
          },
        ),
      ],
    ),
    );
  }
}