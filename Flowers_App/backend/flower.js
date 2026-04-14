const mongoose=require('mongoose');

const flowerSchema={
    name :{
        type:String,
        required:true   
    },
    description:{
        type:String,
        required:true,
    },
    imageUrl:{
        type:String,
        required:true,
    },
    pdfUrl:{
        type:String,
        required:true,
    }
}

const flower=mongoose.model('Flower',new mongoose.Schema(flowerSchema));

module.exports=flower;