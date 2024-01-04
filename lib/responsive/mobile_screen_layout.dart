import 'package:flutter/material.dart';
import 'package:proiect_chs_r/model/user.dart';
import 'package:proiect_chs_r/providers/user_provider.dart';
import 'package:proiect_chs_r/model/user.dart' as model;
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Center(
        child: Text(user!.username),
      ),
    );
  }
}
