import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter11/models/note.dart';
import 'package:flutter11/utils/database_helper.dart';

import 'package:sqflite/sqflite.dart';

import '../box.dart';
import 'note_detail.dart';


class NoteList extends StatefulWidget {
	String pageNum;

	NoteList(this.pageNum);

  @override
  State<StatefulWidget> createState() {

    return NoteListState(pageNum);
  }
}

class NoteListState extends State<NoteList>with SingleTickerProviderStateMixin  {
	String pageNum;

	NoteListState(this.pageNum);

  DatabaseHelper databaseHelper = DatabaseHelper();
	List<Note> noteList;
	int count = 0;
	 bool checkBoxValue;
	 TabController tabController;

	int index = 0;


@override
  void initState() {
	checkBoxValue=false;
	tabController = TabController(length: 3, vsync: this);
    // TODO: implement initState
    super.initState();
  }
	@override
  Widget build(BuildContext context) {

		if (noteList == null) {
			noteList = List<Note>();
			updateListView();
		}

    return Scaffold(

	    appBar: AppBar(
		    title: Text('Notes'),
				bottom: TabBar(
					controller: tabController,
					tabs: [
						Tab(
							text: 'home',
						),
						Tab(
							text: 'Checked',
						),
						Tab(
							text: 'IsnotChecked',
						),
					],
					isScrollable: true,
				),
	    ),

	    body:Column(
				children: [
					Expanded(
							child: TabBarView(
								controller: tabController,
								children: [getNoteListView("1"), getNoteListView2("1"),getNoteListView3("1")],
							)),
				],
			) ,

	    floatingActionButton: FloatingActionButton(
		    onPressed: () {
		      debugPrint('FAB clicked');
		      navigateToDetail(Note('', '', 2,false), 'Add Note');
		    },

		    tooltip: 'Add Note',

		    child: Icon(Icons.add),

	    ),
    );
  }

	ListView getNoteListView(String pa) {

		TextStyle titleStyle = Theme.of(context).textTheme.subhead;

		return ListView.builder(
			shrinkWrap: true,
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				print("${this.noteList[position].checkBoxValue} jjjjjj" );
				return Card(
					color: Colors.white,
					elevation: 2.0,
					child: ListTile(

						leading: GestureDetector(
							child: Icon(Icons.delete, color: Colors.grey,),
							onTap: () {
								_delete(context, noteList[position]);
							},
						),
						// CircleAvatar(
						// 	backgroundColor: getPriorityColor(this.noteList[position].priority),
						// 	child: getPriorityIcon(this.noteList[position].priority),
						// ),

						title: Center(child: Text(this.noteList[position].title, style: titleStyle,)),


						subtitle: Center(child: Text(this.noteList[position].date)),
						trailing: box(getPriorityColor(this.noteList[position].priority)),
						onTap: () {
							debugPrint("ListTile Tapped");
							navigateToDetail(this.noteList[position],'Edit Note');
						},

					),
				);
			},
		);
	}
	ListView getNoteListView2(String pa) {

		TextStyle titleStyle = Theme.of(context).textTheme.subhead;

		return ListView.builder(
			shrinkWrap: true,
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {

				print("${this.noteList[position].checkBoxValue} jjjjjj" );

				return Card(
					color: Colors.white,
					elevation: 2.0,
					child:this.noteList[position].priority==1? ListTile(

						leading: GestureDetector(
							child: Icon(Icons.delete, color: Colors.grey,),
							onTap: () {
								_delete(context, noteList[position]);
							},
						),
						// CircleAvatar(
						// 	backgroundColor: getPriorityColor(this.noteList[position].priority),
						// 	child: getPriorityIcon(this.noteList[position].priority),
						// ),

				title: Center(child: Text("${this.noteList[position].title}+${this.noteList[position].priority}" , style: titleStyle,)),


						subtitle: Center(child: Text(this.noteList[position].date)),
						trailing: box(getPriorityColor(this.noteList[position].priority)),
						onTap: () {
							debugPrint("ListTile Tapped");
							navigateToDetail(this.noteList[position],'Edit Note');
						},

					):Container(),
				);
			},
		);
	}
	ListView getNoteListView3(String pa) {

		TextStyle titleStyle = Theme.of(context).textTheme.subhead;

		return ListView.builder(
			shrinkWrap: true,
			itemCount: count,
			itemBuilder: (BuildContext context, int position) {
				print("${this.noteList[position].checkBoxValue} jjjjjj" );
				return Card(
					color: Colors.white,
					elevation: 2.0,
					child:this.noteList[position].priority==2? ListTile(

						leading: GestureDetector(
							child: Icon(Icons.delete, color: Colors.grey,),
							onTap: () {
								_delete(context, noteList[position]);
							},
						),
						// CircleAvatar(
						// 	backgroundColor: getPriorityColor(this.noteList[position].priority),
						// 	child: getPriorityIcon(this.noteList[position].priority),
						// ),

						title: Center(child: Text(this.noteList[position].title, style: titleStyle,)),


						subtitle: Center(child: Text(this.noteList[position].date)),
						trailing: box(getPriorityColor(this.noteList[position].priority)),
						onTap: () {
							debugPrint("ListTile Tapped");
							navigateToDetail(this.noteList[position],'Edit Note');
						},

					):Container(),
				);
			},
		);
	}
  // Returns the priority color
	bool getPriorityColor(int priority) {
		switch (priority) {
			case 1:
				return true;
				break;
			case 2:
				return false;
				break;

			default:
				return false;
		}
	}

	// Returns the priority icon
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

	void _delete(BuildContext context, Note note) async {

		int result = await databaseHelper.deleteNote(note.id);
		if (result != 0) {
			_showSnackBar(context, 'Note Deleted Successfully');
			updateListView();
		}
	}

	void _showSnackBar(BuildContext context, String message) {

		final snackBar = SnackBar(content: Text(message));
		Scaffold.of(context).showSnackBar(snackBar);
	}

  void navigateToDetail(Note note, String title) async {
	  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return NoteDetail(note, title);
	  }));

	  if (result == true) {
	  	updateListView();
	  }
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

}

class Navegtion extends StatefulWidget {
	@override
	_NavegtionState createState() => _NavegtionState();
}

class _NavegtionState extends State<Navegtion> {
	myFun() {
		setState(() {});
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			child: SingleChildScrollView(
				child: Column(






			),
			),
		);
	}
}

class Profiel extends StatefulWidget {
	@override
	_ProfielState createState() => _ProfielState();
}

class _ProfielState extends State<Profiel> {
	myFun() {
		setState(() {});
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			child: SingleChildScrollView(
				child: Column(





				),
			),
		);
	}
}








