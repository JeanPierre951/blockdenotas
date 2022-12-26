import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simply_notes_app/services/database_sqflite.dart';

class FormNote extends StatelessWidget {
  final dynamic id;
  final dynamic title;
  final dynamic description;

  const FormNote({
    Key? key,
    this.id,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    if (id != null) {
      titleController.text = title;
      descriptionController.text = description;
    }

    
    Future<void> addItem() async {
      await SQLHelper.createItem(
        titleController.text,
        descriptionController.text,
      );
    }

    
    Future<void> updateItem(int id) async {
      await SQLHelper.updateItem(
        id,
        titleController.text,
        descriptionController.text,
      );
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text(
          id == null ? 'Agrregar Nota' : 'Editar Nota',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: 80,
        ),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Titulo',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white54,
                ),
              ),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ingresar descripcion',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (id == null) {
                  await addItem();
                } else {
                  await updateItem(id);
                }

                titleController.text = '';
                descriptionController.text = '';

                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 10,
                  bottom: 10,
                ),
                backgroundColor: Colors.white,
              ),
              child: Text(
                id == null ? 'Guardar Nota' : 'Actualizar Nota',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}