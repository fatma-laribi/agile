import 'package:flutter/material.dart';
import 'package:servini_app/widgets/profile_body.dart';
import 'package:servini_app/widgets/top_part.dart';
import 'package:servini_app/constants/colors.dart';
import 'package:servini_app/widgets/heart_button.dart';

class ProfilePage extends StatefulWidget {
  String username;
  ProfilePage({Key? key,required this.username}) : super(key: key);
  @override
  State<ProfilePage> createState() => _MyProfilePage();
}

//te5edh objet profile mel base
class _MyProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          backgroundColor: coldBackground,
          body: ListView(children: [
            topPart(context, 3.5,widget.username),
            ProfileBody( username: widget.username)
          ])),
    );
  }
}
