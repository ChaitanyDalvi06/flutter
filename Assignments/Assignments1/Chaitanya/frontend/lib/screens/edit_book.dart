import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class EditBookScreen extends StatefulWidget {
  EditBookScreenState createState() => EditBookScreenState();
}

class EditBookScreenState extends State<EditBookScreen> {
  final idController = TextEditingController();
  final titleController = TextEditingController();
  final authorNameController = TextEditingController();
  final genreController = TextEditingController();
  final priceController = TextEditingController();
  final publishedYearController = TextEditingController();

  void handleSubmit() async {
    Book b = Book(
      id: idController.text,
      title: titleController.text,
      authorName: authorNameController.text,
      genre: genreController.text,
      price: priceController.text,
      publishedYear: publishedYearController.text,
      createdDate: DateTime.now().toIso8601String(),
    );
    await BookService.updateBook(b);
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)!.settings.arguments as Book;
    idController.text = book.id;
    titleController.text = book.title;
    authorNameController.text = book.authorName;
    genreController.text = book.genre;
    priceController.text = book.price;
    publishedYearController.text = book.publishedYear;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Book')),
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
              child: Text("Update Book"),
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
