import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fetch data from JSON list ',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new FetchList(title: 'List view',),
    );
  }
}
class FetchList extends StatefulWidget {
  FetchList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FetchList createState() => new _FetchList();
}
class _FetchList  extends State<FetchList> {

  Future<List<UserList>> _getUserList() async{
   var getData = await http.get('https://jsonplaceholder.typicode.com/users');
   var jsonData = jsonDecode(getData.body);

   List<UserList> users = [];

   for (var b in jsonData){

     UserList user = UserList(b["id"], b["name"], b["username"], b["email"], b["phone"]);
     users.add(user);

  }
   print(users.length);
   return users;

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: _getUserList(),
            builder:(BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
              return Container(
                  child: Center(
                    child: Text('Loading...'),
                    ),
                    );
              } else {
                return Container(
                    child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){

                    return ListTile(
                        leading: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png")
                              )
                          ),
                        ),

                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].email),
                      onTap: (){
                          Navigator.push(context,
                            new MaterialPageRoute(builder: (context) => NavigatePage(snapshot.data[index]))
                              
                          );
                        },
                      );
                    }));
                  }
                }


          ),
        ),
    );

  }
}
  class NavigatePage extends StatelessWidget {

  final UserList user;
  NavigatePage(this.user);
    @override
    Widget build (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        body: Padding(
        padding: EdgeInsets.all(16.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
              Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage("https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png")
                        )
                        ),
                        ),
            Row(
            children: [Text(user.name),
                        Text(user.username),
                        Text(user.email),
                        Text(user.phone),
                        ]
      ),
      ]),



      ));
    }


  }
class UserList {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;


  UserList(this.id, this.name, this.username, this.email, this.phone);


}
