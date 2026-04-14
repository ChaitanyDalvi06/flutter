import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatingBox extends StatefulWidget{
  RatingBoxState createState()=>RatingBoxState();
}

class RatingBoxState extends State<RatingBox>{

  int rating = 0;

  void setOneStar(){
    setState((){
      rating = 1;
    });
  }

  void setTwoStar(){
    setState((){
      rating = 2;
    });
  }

  void setThreeStar(){
    setState(() {
      rating = 3;
    });
  }

  void setFourStar(){
    setState((){
      rating = 4;
    });
  }

  void setFiveStar(){
    setState((){
      rating = 5;
    });
  }

  Widget build(BuildContext context){
    return Row(
      children: [
        Container(
          child: IconButton(
            icon: rating>=1?Icon(Icons.star):Icon(Icons.star_border),
            onPressed: setOneStar,
            color: Colors.amber,
          ),
        ),
        Container(
          child: IconButton(
            icon: rating>=2?Icon(Icons.star):Icon(Icons.star_border),
            onPressed: setTwoStar,
            color: Colors.amber,
          ),
        ),
        Container(
          child: IconButton(
            icon: rating>=3?Icon(Icons.star):Icon(Icons.star_border),
            onPressed: setThreeStar,
            color: Colors.amber,
          ),
        ),
        Container(
          child: IconButton(
            icon: rating>=4?Icon(Icons.star):Icon(Icons.star_border),
            onPressed: setFourStar,
            color: Colors.amber,
          ),
        ),
        Container(
          child: IconButton(
            icon: rating>=5?Icon(Icons.star):Icon(Icons.star_border),
            onPressed: setFiveStar,
            color: Colors.amber,
          ),
        )
      ]
    );
  }
}