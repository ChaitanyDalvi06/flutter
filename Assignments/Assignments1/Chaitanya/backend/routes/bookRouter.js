const express = require('express');
const Book = require('../models/book');
const router = express.Router();

router.get('/', async (request, response) => {
    try {
        const books = await Book.find({});
        response.json(books);
    } catch (error) {
        response.status(500).json({ message: "Error fetching books", error: error.message });
    }
});

router.get('/:id', async (request, response) => {
    try {
        const book = await Book.findById(request.params.id);
        response.json(book);
    } catch (error) {
        response.status(500).json({ message: "Error fetching book", error: error.message });
    }
});

router.post('/', async (request, response) => {
    try {
        const newBook = new Book(request.body);
        await newBook.save();
        response.status(201).json({ message: "Book created successfully", book: newBook });
    } catch (error) {
        response.status(500).json({ message: "Error creating book", error: error.message });
    }
});

router.put('/:id', async (request, response) => {
    try {
        const book = await Book.findByIdAndUpdate(request.params.id, request.body, { new: true });
        if (!book) {
            return response.status(404).json({ message: "Book not found" });
        }
        response.status(200).json({ message: "Book updated successfully", book: book });
    } catch (error) {
        response.status(500).json({ message: "Error updating book", error: error.message });
    }
});

router.delete('/:id', async (request, response) => {
    try {
        const book = await Book.findByIdAndDelete(request.params.id);
        if (!book) {
            return response.status(404).json({ message: "Book not found" });
        }
        response.status(200).json({ message: "Book deleted successfully" });
    } catch (error) {
        response.status(500).json({ message: "Error deleting book", error: error.message });
    }
});

module.exports = router;