import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proiect_chs_r/resources/auth_methods.dart';
import 'package:proiect_chs_r/responsive/mobile_screen_layout.dart';
import 'package:proiect_chs_r/responsive/responsive_layout_screen.dart';
import 'package:proiect_chs_r/responsive/web_screen_layout.dart';
import 'package:proiect_chs_r/screens/login_screen.dart';
import 'package:proiect_chs_r/utils/colors.dart';
import 'package:proiect_chs_r/utils/utils.dart';
import 'package:proiect_chs_r/widgets/text_field_input.dart';
import 'package:proiect_chs_r/resources/firestore_methods.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _changeemailController = TextEditingController();
  final TextEditingController _changeusernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _changepasswordController =
      TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void dispose() {
    super.dispose();
    _changeemailController.dispose();
    _passwordController.dispose();
    _changeusernameController.dispose();
    _changepasswordController.dispose();
  }

  Future<void> changePassword(String newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      print("Password changed successfully!");
    } catch (e) {
      print("Error changing password: $e");
      // Handle the error, e.g., show a snackbar or display an error message to the user
    }
  }

  bool _isLoading = false;
  void changeCredentials() async {
    FirestoreMethods controller = FirestoreMethods();
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: currentUser.email.toString(),
        password: _passwordController.text);
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      var user = await FirebaseAuth.instance.currentUser!;
      if (_changepasswordController.text != "") {
        changePassword(_changepasswordController.text);
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Stack(children: [
        Positioned.fill(
          child: Image.asset(
            'assets/wallpaper.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Change Password',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 64,
              ),
              //circularWidget
              Stack(),
              TextFieldInput(
                hintText: 'New password',
                textInputType: TextInputType.text,
                isPass: true,
                textEditingController: _changepasswordController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Current password',
                textInputType: TextInputType.text,
                isPass: true,
                textEditingController: _passwordController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: changeCredentials,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      color: blueColor),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Change'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () async {
                  await AuthMethods().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text("Sign Out"),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
