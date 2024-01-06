import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proiect_chs_r/providers/user_provider.dart';
import 'package:proiect_chs_r/resources/firestore_methods.dart';
import 'package:proiect_chs_r/screens/home_screen.dart';
import 'package:proiect_chs_r/utils/colors.dart';
import 'package:proiect_chs_r/utils/utils.dart';
import 'package:provider/provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  Uint8List? _file;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _portionsController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _ingredientController = TextEditingController();

  List<String> ingredientsList = [];
  bool _isLoading = false;
  void addRecipe(String uid, String username) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().addRecipe(
          _instructionsController.text,
          _nameController.text,
          uid,
          _file!,
          _timeController.text,
          _portionsController.text,
          _difficultyController.text,
          username,
          ingredientsList);
      if (res == "succes") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Posted", context);

        clearImage();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("New Recipe"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _difficultyController.dispose();
    _instructionsController.dispose();
    _nameController.dispose();
    _portionsController.dispose();
    _timeController.dispose();
    _ingredientController.dispose();
  }

  void addIngredient(String ingredient) {
    setState(() {
      print(ingredientsList);
      print(ingredient);
      ingredientsList.add(ingredient);
    });
  }

  void removeIngredient(String ingredient) {
    setState(() {
      ingredientsList.remove(ingredient);
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("New Recipe"),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => addRecipe(
                userProvider.getUser!.uid, userProvider.getUser!.username),
            child: Text(
              'Add',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/wallpaper.svg',
                fit: BoxFit.cover,
              ),
            ),
            Column(children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Recipe name",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: EdgeInsets.symmetric(
                              horizontal: 13.0, vertical: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(Icons.access_time,
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: TextField(
                                    controller: _timeController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "Time",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 25),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(Icons.assessment,
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: TextField(
                                    controller: _difficultyController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "Difficulty",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.person,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: TextField(
                              controller: _portionsController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Portions",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12.0),
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.food_bank,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                controller: _ingredientController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: "Add Ingredient",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 12.0),
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      addIngredient(_ingredientController.text);
                      _ingredientController.clear();
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ingredientsList.map((ingredient) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 119, 107, 5),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ingredient,
                            style: TextStyle(color: Colors.black),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              removeIngredient(ingredient);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.89,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _instructionsController,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: " Write instructions",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 7.0),
                              ),
                              maxLines: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
              _file == null
                  ? Center(
                      child: Container(
                        width: 300.0,
                        height: 150.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.upload),
                          onPressed: () => _selectImage(context),
                        ),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 46),
                            width: 300.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
            ]),
          ],
        ),
      ),
    );
  }
}
