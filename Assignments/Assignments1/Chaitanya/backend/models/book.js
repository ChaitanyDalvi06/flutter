const mongoose = require('mongoose');

const bookSchema = {
    title: {
        type: String,
        required: true
    },
    authorName: {
        type: String,
        required: true,
        unique: true
    },
    genre: {
        type: String,
        required: true
    },
    price: {
        type: String,
        required: true
    },
    publishedYear: {
        type: String,
        required: true,
    },
    createdDate: {
        type: String,
        required: true
    }
};

const Book = new mongoose.Schema(bookSchema);
module.exports = mongoose.model('Book', Book);