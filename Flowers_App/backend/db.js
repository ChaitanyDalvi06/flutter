const mongosse = require('mongoose');

mongosse.connect('mongodb://localhost:27017/flowersapp',);

const db=mongosse.connection;

db.on("connected",()=>
{
    console.log("MongoDB connected successfully");
})
db.on("disconnected",()=>
{
    console.log("MongoDB disconnected successfully");
})

db.on("error",(err)=>
{
    console.log("MongoDB connection error:",err);
})

module.exports=db;
