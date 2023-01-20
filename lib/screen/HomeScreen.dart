import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';
import 'package:notesbytes/screen/FormScreen.dart';
import 'package:notesbytes/screen/Helper/DatabaseHelper.dart';
import 'package:notesbytes/screen/Updatenotes.dart';
// import 'package:intl/intl_browser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List>? allnotes;

  Future<List> getdata() async {
    DatabaseHelper obj = DatabaseHelper();
    var data = await obj.getNotes();
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      allnotes = getdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffece8e5),
        body: SafeArea(
            child: Column(
          children: [
            Container(
                child: Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, bottom: 5.0, top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "oswald"),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xff7a928c)),
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (contect) => FormScreen()));
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                          )))
                ],
              ),
            )),
            FutureBuilder(
                future: allnotes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Container(
                        padding: EdgeInsets.only(top: 250.0),
                        child: Text(
                          "There is no notes",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var dt =
                                  snapshot.data![index]["taskdate"].toString();
                              print(dt);
                              var inputFormat = DateFormat('yyyy-MM-dd');
                              var inputDate = inputFormat.parse(dt);
                              var outputFormat = DateFormat('dd-MM-yyyy');
                              var outputDate = outputFormat.format(inputDate);
                              //             //convert
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.all(10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index]["title"].toString() ?? "-",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          snapshot.data![index]["description"].toString() ??"-",
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          outputDate.toString(),
                                          style: TextStyle(
                                              color: Color(0xffd6dddb)),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Center(
                                          child: Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (contect) => Updatenotes()));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff7a928c),
                                                ),
                                                child: Text("Edit"),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              ElevatedButton(
                                                onPressed: ()async {
                                                  var id = snapshot.data![index]["pid"];
                                                  DatabaseHelper obj =new DatabaseHelper();
                                                  var status = await obj.deleteNotes(id);
                                                  if (status==1){
                                                    print("Notes delected");
                                                    setState(() {
                                                      allnotes = getdata();
                                                    });
                                                  }
                                                  else{
                                                    print("Please try again");
                                                  }

                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff7a928c),
                                                ),
                                                child: Text("Delect"),
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                ),
                              );
                            }),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ))
        );
  }
}
