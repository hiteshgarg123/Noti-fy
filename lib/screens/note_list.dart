import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/database_helper.dart';
import '../models/Note.dart';
import 'note_details.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return NoteDetail(note, title);
      }),
    );
    if (result == true) {
      updateListView();
    }
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4.0,
          child: GestureDetector(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    getPriorityColor(this.noteList[index].priority),
                child: getPriorityIcon(this.noteList[index].priority),
              ),
              title: Text(
                this.noteList[index].title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  fontFamily: 'OpenSans',
                ),
              ),
              subtitle: Text(
                this.noteList[index].date,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                color: Colors.black54,
                icon: Icon(
                  Icons.delete,
                ),
                onPressed: () {
                  _delete(context, noteList[index]);
                },
              ),
            ),
            onTap: () {
              navigateToDetail(this.noteList[index], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.amber;
        break;

      default:
        return Colors.amber;
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(
        seconds: 5,
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              navigateToDetail(Note('', '', 2), 'Add Note');
            },
          ),
        ],
        title: Text(
          'Noti-fy',
          style: TextStyle(
            fontSize: 23.0,
          ),
        ),
      ),
      body: noteList.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraints) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15.0),
                        child: Text(
                          'Add a Note please',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: constraints.maxHeight * 0.4,
                        child: Image.asset(
                          'assets/images/waiting.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : getNoteListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          navigateToDetail(Note('', '', 2), 'Add Note');
        },
      ),
    );
  }
}
