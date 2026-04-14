import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  AddBookScreenState createState() => AddBookScreenState();
}

class AddBookScreenState extends State<AddBookScreen> {
  final titleController = TextEditingController();
  final authorNameController = TextEditingController();
  final genreController = TextEditingController();
  final priceController = TextEditingController();
  final publishedYearController = TextEditingController();

  void handleSubmit() async {
    Book b = Book(
      id: "",
      title: titleController.text,
      authorName: authorNameController.text,
      genre: genreController.text,
      price: priceController.text,
      publishedYear: publishedYearController.text,
      createdDate: DateTime.now().toIso8601String(),
    );
    await BookService.addBook(b);
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Book')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: authorNameController,
              decoration: InputDecoration(labelText: 'Author Name'),
            ),
            TextField(
              controller: genreController,
              decoration: InputDecoration(labelText: 'Genre'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: publishedYearController,
              decoration: InputDecoration(labelText: 'Published Year'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Add Book"),
              onPressed: () {
                handleSubmit();
              },
            ),
          ],
        ),
      ),
    );
  }
}
