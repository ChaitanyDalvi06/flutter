import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AddFlower extends StatefulWidget {
  AddFlowerScreenState createState() => AddFlowerScreenState();
}

class AddFlowerScreenState extends State<AddFlower> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  File? image;
  File? pdf;

  void uploadImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  void uploadPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        pdf = File(result.files.single.path!);
      });
    }
  }

  void addFlower() async {}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Flower')),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter flower name',
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Enter flower description',
            ),
          ),
          ElevatedButton(onPressed: uploadImage, child: Text('Upload Image')),
          if (image != null)
            Image.file(
              File(image!.path),
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ElevatedButton(onPressed: uploadPdf, child: Text('Upload PDF')),
          if (pdf != null) Text('PDF Path :- ${pdf!.path}'),
          ElevatedButton(onPressed: addFlower, child: Text('Add Flower')),
        ],
      ),
    );
  }
}