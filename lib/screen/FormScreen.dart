import 'package:flutter/material.dart';
import 'package:notesbytes/screen/Helper/DatabaseHelper.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:notesbytes/screen/HomeScreen.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  TextEditingController _title=TextEditingController();
  TextEditingController _description=TextEditingController();
  TextEditingController dateInput=TextEditingController();
  var _onSelectionChanged=0;

  get dateCtl => null;

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
                padding: EdgeInsets.only(top: 20.0,left:10.0,right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 10.0,),
                          Center(
                            child: Text("This is for adding new activity",style: TextStyle(
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
                                  firstDate: DateTime.now(),
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
                                var id = await obj.insertProduct(title,description,date);
                               if(_title==null || _description==null || dateInput==null)
                               {
                                 final snackBar = SnackBar(

                                   /// need to set following properties for best effect of awesome_snackbar_content
                                   elevation: 0,
                                   behavior: SnackBarBehavior.floating,
                                   backgroundColor: Colors.transparent,
                                   content: AwesomeSnackbarContent(
                                     title: 'Error!',
                                     message:
                                     'This is a message that data will be added in the databasw!',

                                     /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                     contentType: ContentType.failure,
                                   ),
                                 );

                                 ScaffoldMessenger.of(context)
                                   ..hideCurrentSnackBar()
                                   ..showSnackBar(snackBar);
                                }
                               else{
                                 final snackBar = SnackBar(

                                   /// need to set following properties for best effect of awesome_snackbar_content
                                   elevation: 0,
                                   behavior: SnackBarBehavior.floating,
                                   backgroundColor: Colors.transparent,
                                   content: AwesomeSnackbarContent(
                                     title: 'Added Successfully!',
                                     message:
                                     'This is a message that data are incomeplete so Please complete the data!',

                                     /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                     contentType: ContentType.success,
                                   ),
                                 );

                                 ScaffoldMessenger.of(context)
                                   ..hideCurrentSnackBar()
                                   ..showSnackBar(snackBar);

                               }
                               Navigator.of(context).push(
                                 MaterialPageRoute(builder: (context)=>HomeScreen())
                               );
                                },
                                child: Text("Add",style: TextStyle(
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

