const express = require('express');
const flowerRouter = require('./routes/flowerRouter.js');
const db = require('./db.js');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());
app.use('/flowers', flowerRouter);

app.listen(4000, () => {
    console.log('Server is running on port 4000');
});
