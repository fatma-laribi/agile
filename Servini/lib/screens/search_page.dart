import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:servini_app/handlers/recommendation_backend.dart';
import 'package:servini_app/screens/categories_page.dart';

import 'package:servini_app/widgets/user_container.dart';
import 'package:servini_app/screens/profile_page.dart';
import 'package:servini_app/widgets/home_bar.dart';
import 'package:servini_app/constants/colors.dart';
import '../handlers/category_backend.dart';
import '../handlers/user_backend.dart';
import '../modals/category.dart';
import '../widgets/category.dart';
import '../widgets/search_bar.dart';
import 'package:servini_app/widgets/appbar.dart';
import 'package:servini_app/widgets/small_category.dart';
import '../widgets/title_row.dart';
import '../widgets/see_more.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _MySearchPage();
}

class _MySearchPage extends State<SearchPage> {
  NetworkHelper networkHelper=NetworkHelper("http://10.0.2.2:3000/category");
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Center(
            child: customAppBar(),
          ),
        ),
        backgroundColor: coldBackground,
        body: Container(
            margin: EdgeInsets.fromLTRB(
                size.width * 0.05, size.height * 0.03, size.width * 0.05, 0),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Text(
                                    "Welcome",
                                    style: TextStyle(
                                      color: writingBlue,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Text(
                                    "test" + ' ' + "test",
                                    style: TextStyle(
                                      color: writingBlue,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (
                                        context) => ProfilePage(username: "fatma laribi")),
                                  );
                                },
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/user.png",
                                    width: 43,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      child: searchBar(context),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, size.height * 0.03, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FutureBuilder(
                            future: networkHelper.fetchCategory(),
                            builder: (BuildContext context, AsyncSnapshot snapshot){
                              if(snapshot.hasData){
                                return  Container(
                                  height:MediaQuery.of(context).size.height*0.20,
                                  child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount:  3,//snapshot.data.length>=2?3:snapshot.data.length+1
                                        itemBuilder: (context, index) {
                                          //

                                         if(index<2){
                                           Category category = snapshot.data[index];
                                           List colors=[[darkYellow, lightYellow],[darkBlue, lightBlue]];
                                            return Column(
                                              children: <Widget>[
                                                smallCategory(context,
                                                    category.title,
                                                    category.pic,colors[index][0], colors[index][1]),
                                                SizedBox(
                                                  height: size.height * 0.05,
                                                ),
                                              ],
                                            );
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => CategoryWidget()),
                                                );
                                              },
                                              child: seeMore(context, darkRed, lightRed),
                                            );
                                        }),
                                );
                                }
                              else{
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          ),


                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                   // titleRow("Top Rated",TopRatedPage(),context),
                    const Text(
                      "Top Rated",
                      style: TextStyle(
                        color: writingBlue,
                        fontFamily: "Gilroy",
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    FutureBuilder(
                        future: getUsersByNb(3),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if(snapshot.hasData){
                            if(snapshot.data.length==0){
                              return Text('no data',style:TextStyle(fontSize: 20));
                            }
                            else {
                              return Container(
                                height:300,
                                child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return userContainer(context,snapshot.data[index]["username"],snapshot.data[index]["bio"],snapshot.data[index]["rating"]);

                                  },

                                ),
                              );
                            }}
                          else {return CircularProgressIndicator();}
                        }
                    ),

                  ],
                ),
                Positioned(
                  left: size.width * 0.075,
                  top: size.height * 0.75,
                  height: size.height * 0.1,
                  width: size.width * 0.75,
                  child: homeBar(context),
                ),
              ],
            )
        ),
      ),
    );
  }
}