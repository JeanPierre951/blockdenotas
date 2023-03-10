import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simply_notes_app/screen/form_note.dart';
import 'package:simply_notes_app/services/database_sqflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  List<Map<String, dynamic>> notes = [];
  bool isLoading = true;

  
  void refreshNotes() async {
    final data = await SQLHelper.getItems();
    setState(() {
      notes = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshNotes(); 
  }

  
  void deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nota eliminada correctamente!'),
      ),
    );
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormNote(),
            ),
          ).then(
            (value) => setState(() {
              refreshNotes();
            }),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        title: Text(
          'Fire Nots',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormNote(
                          id: notes[index]['id'],
                          title: notes[index]['titulo'],
                          description: notes[index]['descripcion'],
                        ),
                      ),
                    ).then(
                      (value) => setState(() {
                        refreshNotes();
                      }),
                    );
                  },
                  child: notesCard(notes[index]),
                );
              },
            ),
    );
  }

  Widget notesCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['titulo'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  deleteItem(data['id']);
                },
                icon: const Icon(
                  Icons.clear,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            data['descripcion'],
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}