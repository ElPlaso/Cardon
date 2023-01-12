import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/data/business_card.dart';
import 'package:cardonapp/providers/cardcreator_provider.dart';
import 'package:cardonapp/providers/query_provider.dart';
import '../widgets/card_view.dart';
import '../widgets/logo_button.dart';
import '../widgets/theme_toggle.dart';
import '../widgets/card_form.dart';

// * Page that allows user to preview and create cards

class AddCard extends StatelessWidget {
  const AddCard({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Upload Card'),
          centerTitle: true,
        ),
        body: Center(
          child: SizedBox(
            height: 1000,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  CardForm(
                      card: BusinessCard(id: '', name: '', theme: 'nimbus')),
                  const ThemeToggle(),

                  /// * used as a style choice to display the icon to the right.
                  LogoButton(
                    text: 'Preview',
                    onClicked: () => previewCard(context),
                    icon: const Icon(Icons.remove_red_eye, size: 40),
                  ),

                  /// * Sends a upload query to the data base
                  /// *
                  LogoButton(
                    text: 'Upload',
                    onClicked: () => uploadCard(context),
                    icon: const Icon(Icons.upload, size: 40),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void previewCard(context) {
    showModalBottomSheet(
        // * Displays preview of business card
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (context) => CardView(
            // * Create the mock BusinessCard from the providers
            card: context.read<CardCreator>().getBusinessCard("preview")));
  }

  void uploadCard(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    // * Increment the ID
    // * get the current id of the users' card
    String cardId = '0';
    try {
      /// * if the user has an account
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(context.read<QueryProvider>().userID)
          .update({'card-id': FieldValue.increment(1)});
    } on FirebaseException catch (e) {
      // * if the user was not found init their profile
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(context.read<QueryProvider>().userID)
          .set({"card-id": 0, 'wallet': []});
    }

    /// * Gets the ID of the next card to upload.
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(context.read<QueryProvider>().userID)
        .get()
        .then((doc) {
      int val = doc.get('card-id');
      cardId = "${context.read<QueryProvider>().userID}-$val";
    });

    // * create the businesscard obj
    var bCard = context.read<CardCreator>().getBusinessCard(cardId);
    // pass the bussiness card to the DB
    await FirebaseFirestore.instance.collection('Cards').doc(cardId).set({
      'card_id': cardId,
      'card': jsonEncode(bCard),
      'owner': context.read<QueryProvider>().userID,
      'scancount': 0,
      'refreshcount': 0,
    }).onError(
        (error, stackTrace) => ("${error} + ${stackTrace} =========== "));

    // Update the user profile with the ownership of the new card
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(context.read<QueryProvider>().userID)
        .update({
      'personalcards': FieldValue.arrayUnion([cardId])
    }).onError((error, stackTrace) => ("$error + $stackTrace ==========="));

    // * Updates the personal card provider with the latest
    // * * copy of the users cards

    await context.read<QueryProvider>().updatePersonalcards(context);

    Fluttertoast.showToast(
        msg: "Card uploaded!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.pop(context);
  }
}
