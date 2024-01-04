import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proiect_chs_r/providers/user_provider.dart';
import 'package:proiect_chs_r/resources/firestore_methods.dart';
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
          username);
      if (res == "succes") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar("Posted", context);
        clearImage();
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
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text("New Recipe"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => addRecipe(userProvider.getUser!.uid,
                      userProvider.getUser!.username),
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
            body: Column(children: [
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Recipe name",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  const Divider(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: TextField(
                      controller: _timeController,
                      decoration: const InputDecoration(
                        hintText: "Time",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: TextField(
                      controller: _difficultyController,
                      decoration: const InputDecoration(
                        hintText: "Difficulty",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  const Divider(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: TextField(
                      controller: _portionsController,
                      decoration: const InputDecoration(
                        hintText: "No of portions",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  const Divider(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _instructionsController,
                      decoration: const InputDecoration(
                        hintText: "Write instructions",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  const Divider(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45,
                    width: 45,
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
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
