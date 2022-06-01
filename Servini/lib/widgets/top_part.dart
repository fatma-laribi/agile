import 'package:flutter/material.dart';
import 'package:servini_app/modals/recommendation.dart';
import 'package:servini_app/screens/search_page.dart';
import 'package:servini_app/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../handlers/recommendation_backend.dart';
import '../handlers/user_backend.dart';
import '../modals/user.dart';
import 'dart:math' as math;
Widget topPart(BuildContext context,String username) {
  double numberStars;
  final size = MediaQuery.of(context).size;
  final stars = <Widget>[];
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  return Container(
    //height: size.height * 0.5,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: AlignmentDirectional.topCenter,
        end: AlignmentDirectional.bottomCenter,
        colors: [
          specialBlue,
          specialPurple,
        ],
      ),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(91),
        bottomRight: Radius.circular(91),
      ),
      boxShadow: [
        BoxShadow(
          color: specialPurple.withOpacity(0.4),
          spreadRadius: 0,
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  size.width * 0.05, size.width * 0.05, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
                child: SvgPicture.asset("assets/arrow.svg"),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.all(size.height * 0.015),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                child: Image.asset(
                  "assets/level_3.png",
                  height: size.height * 0.18 + 8,
                ),
              ),
              ClipOval(
                child: Image.asset(
                  "assets/user.png",
                  width: size.height * 0.18,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Text(
          username,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "GilroySemiBold",
            fontSize: 25,
          ),
        ),
        /*const Text(
          "Science Professor & part-time tutor",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "GilroyRegular",
            fontSize: 13,
          ),
        ),*/
        SizedBox(height: size.height * 0.020),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/location.png",
                  height: 19,
                ),FutureBuilder(
                    future: getUser(username),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data == null) {
                          return Text('no data');
                        } else {
                          return Text(
                            snapshot.data["location"],
                            style: TextStyle(
                              fontFamily: "GilroyRegular",
                              color: Colors.white,
                            ),
                          );
                        }
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Error'); // error
                      } else {
                        return CircularProgressIndicator(); // loading
                      }
                    }
                )

              ],
            ),
            Row(
              children: [
                FutureBuilder(
                future: getUser(username),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState==ConnectionState.done){
                    if (snapshot.data == null) {
                      return Text('no data');
                    }
                  else {
                   if(snapshot.data["rating"]==0){numberStars=0.0;}
                    else {numberStars=snapshot.data["rating"];}
                    List<Widget> stars = <Widget>[];
                    for (var i = 0; i < 5; i++){
                      if (numberStars >= 1) {
                        stars.add(Image.asset("assets/full_star.png", height: 22));
                        numberStars--;
                      }
                      else if (numberStars > 0) {
                        stars.add(Image.asset("assets/half_star.png", height: 22));
                        numberStars--;
                      }
                      else {
                        stars.add(Image.asset("assets/empty_star.png", height: 22));
                      }
                    }
                    return Row(children:stars);
                  }

                  }
                else {return CircularProgressIndicator();}
                }
                  )],
            ),
          ],
        ),
        SizedBox(height: size.height * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(child: Image.asset("assets/recommend.png"),onTap: ()=>{
            showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
            title: const Text('Recommendation'),
            content: SingleChildScrollView(
            child: ListBody(
            children:  <Widget>[
            Center(
              child: SizedBox(
                // height: size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextField(
                  controller: descriptionController,
                  style: const TextStyle(
                    color: writingBlue,
                  ),
                  decoration: InputDecoration(
                    labelText: "Description",
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0, color: Colors.white),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),

              ),
            ),
              Center(
                child: TextFormField(
                  controller: ratingController,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),],
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              )
            ],
            ),
            ),
            actions: <Widget>[
            TextButton(
            child: const Text('Cancel'),
            onPressed: () {
            Navigator.of(context).pop();
            },
            ),
            TextButton(
            child: const Text('Approve'),
            onPressed: () {
              addRecommendation(new Recommendation(giver: "fatma laribi", receiver: username, rating: double.parse(ratingController.text), description: descriptionController.text));
            Navigator.of(context).pop();
            },
            ),
            ],
            );
            }
            )}
            ),

            SizedBox(width: size.width * 0.09),
            Image.asset("assets/message.png"),
          ],
        ),
        SizedBox(height: size.height * 0.02),
      ],
    ),
  );
}
