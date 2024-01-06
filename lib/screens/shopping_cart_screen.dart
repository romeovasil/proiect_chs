import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proiect_chs_r/resources/firestore_methods.dart';
import 'package:proiect_chs_r/utils/colors.dart';
import 'package:proiect_chs_r/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  late UserProvider userProvider;
  List<String> shoppingList = [];

  Future<List<String>> getShoppingList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> shoppingListsDoc =
          await FirebaseFirestore.instance
              .collection('shoppingLists')
              .doc(userProvider.getUser!.uid)
              .get();

      if (shoppingListsDoc.exists) {
        setState(() {
          shoppingList =
              List<String>.from(shoppingListsDoc.data()!['ingredients']);
        });
      }

      print(shoppingList);
    } catch (error) {
      print('Error retrieving shopping list: $error');
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getShoppingList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);
  }

  Future<void> deleteIngredient(String ingredient) async {
    try {
      await FirebaseFirestore.instance
          .collection('shoppingLists')
          .doc(userProvider.getUser!.uid)
          .update({
        'ingredients': FieldValue.arrayRemove([ingredient]),
      });

      getShoppingList();
    } catch (error) {
      print('Error deleting ingredient: $error');
    }
  }

  Future<void> clearShoppingList() async {
    await FirestoreMethods().clearShoppingList(userProvider.getUser!.uid);
    getShoppingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Shopping list"),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/wallpaper.svg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: ListView.builder(
                itemCount: shoppingList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 174, 126, 5),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(shoppingList[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteIngredient(shoppingList[index]);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: () async {
                await clearShoppingList();
              },
              child: Text("Clear List"),
            ),
          ),
        ],
      ),
    );
  }
}
