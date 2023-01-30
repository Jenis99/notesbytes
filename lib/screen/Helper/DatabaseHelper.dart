import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  Database? db;

  Future<Database>creat_database()async{
   if(db==null){
     print("New Database created Successfully!!!");
     Directory dir =await getApplicationDocumentsDirectory();
     String path = join(dir.path,"everydaynote_db");
     var db= await openDatabase(path,version:1,onCreate: create_table);
     return db!;
   }

   else{
     print("Already Database created");
     return db!;
   }
 }
 create_table(Database db, int version) async{
    print("Table Created");
    db.execute("create table notes (pid integer primary key autoincrement,title text, description text,taskdate text)");
 }

  Future<int> insertProduct(title,description,date)async{
    print("Data Added");
    var db = await creat_database();
    var id = await db .rawInsert("insert into notes (title,description,taskdate) values(?,?,?)",[title,description,date]);
    return id;
  }
  Future<List> getNotes()async{
    var db = await creat_database();
    var data = await db.rawQuery("select * from notes");
    return data.toList();
}

  Future<int> deleteNotes(id)async{
    var db = await creat_database();
    var status= await db.rawDelete("delete from notes where pid=?",[id]);
    return status;

  }

  Future<List> get_notes(id)async{
    var db = await creat_database();
    var data=await db.rawQuery("select * from notes where pid=?",[id]);
    return data;
  }

  updateproduct(title,description,date,id)async{
    var db = await creat_database();
    var data= await db.rawUpdate("update notes set title=?,description=?,taskdate=? where pid=?",[title,description,date,id]);
  }
}