import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesbytes/screen/Helper/DatabaseHelper.dart';
import 'package:notesbytes/screen/HomeScreen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Updatenotes extends StatefulWidget {
  var uid="";
  Updatenotes({required this.uid});
  @override
  State<Updatenotes> createState() => _UpdatenotesState();
}

class _UpdatenotesState extends State<Updatenotes> {
  TextEditingController _title=TextEditingController();
  TextEditingController _description=TextEditingController();
  TextEditingController dateInput=TextEditingController();
  var _onSelectionChanged=0;
  get dateCtl => null;

  getdata()async{
    DatabaseHelper obj = new DatabaseHelper();
    var data= await obj.get_notes(widget.uid);
    setState(() {
      _title.text=data[0]["title"].toString();
      _description.text=data[0]["description"].toString();
      dateInput.text=data[0]["taskdate"].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffe8eaf6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Image.asset("img/large_notebyte1.png"),
              SizedBox(height: 30.0,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0)
                ),
                padding: EdgeInsets.only(top: 20.0,left:10.0,right: 10.0),
                child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0)
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 10.0,),
                              Center(
                                child: Text("This is for update notes",style: TextStyle(
                                  fontSize: 25.0,
                                  fontFamily: "oswald",
                                  fontWeight: FontWeight.bold,
                                ),),
                              ),
                              SizedBox(height: 35.0,),
                              Text("Title",style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 10.0,),
                              TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: 'Title',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xff283593),),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffF4F4F4)),
                                    borderRadius: BorderRadius.circular(10.0),

                                  ),
                                ),
                                controller: _title,
                                keyboardType: TextInputType.multiline,
                                maxLines: 1,
                              ),
                              SizedBox(height: 25.0,),
                              Text("Description",style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 10.0,),
                              TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: 'Description',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xff283593),),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffF4F4F4)),
                                    borderRadius: BorderRadius.circular(10.0),

                                  ),
                                ),
                                controller: _description,
                                keyboardType: TextInputType.multiline,
                                maxLines: 1,
                              ),
                              SizedBox(height: 25.0,),
                              Text("Date",style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 10.0,),
                              TextField(
                                controller: dateInput,
                                //editing controller of this TextField
                                decoration: InputDecoration(
                                  filled: true,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Color(0xff283593),),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color:Color(0xffF4F4F4)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                readOnly: true,
                                //set it true, so that user will not able to edit text
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950),
                                      //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2100),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Color(0xff283593), // <-- SEE HERE
                                              onPrimary: Colors.white, // <-- SEE HERE
                                              onSurface: Colors.blueAccent, // <-- SEE HERE
                                            ),
                                            textButtonTheme: TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                primary: Colors.blueAccent, // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      }
                                  );
                                  Container(
                                    child: SfDateRangePicker(
                                      selectionMode: DateRangePickerSelectionMode.range,
                                    ),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                    setState(() {
                                      dateInput.text =formattedDate.toString(); //set output date to TextField value.
                                    });
                                  }
                                },
                              ),

                              SizedBox(height: 25.0,),
                              Center(
                                child: SizedBox(
                                  width: 125.0,
                                  child: ElevatedButton(onPressed: ()async{
                                    var title=_title.text.toString();
                                    var description=_description.text.toString();
                                    var date=dateInput.text.toString();
                                    DatabaseHelper obj =new DatabaseHelper();
                                    var data = await obj.updateproduct(title,description,date,widget.uid);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context)=>HomeScreen())
                                    );
                                  },
                                    child: Text("Update",style: TextStyle(
                                      fontSize: 20.0,
                                    ),),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff283593),
                                        padding: const EdgeInsets.fromLTRB(25, 13, 25, 13),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        )
                                    ),
                                  ),
                                ),
                              ),

                            ]
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
