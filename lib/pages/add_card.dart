import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/data/business_card.dart';
import 'package:cardonapp/providers/cardcreator_provider.dart';
import 'package:cardonapp/providers/query_provider.dart';
import '../widgets/card_view.dart';
import '../widgets/card_form.dart';

// * Page that allows user to preview and create cards

class AddCard extends StatelessWidget {
  const AddCard({super.key});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 5,
            elevation: 0,
            backgroundColor: Colors.grey[50],
            leading: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: TextButton.icon(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                icon: const Icon(
                  Icons.chevron_left,
                ),
                label: const Text("Back", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            leadingWidth: 100,
            foregroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 20),
                child: TextButton(
                  onPressed: () => {_uploadCard(context)},
                  child: const Text("Done", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create.",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
                CardForm(card: BusinessCard(id: '', name: '', theme: 'nimbus')),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            // Floating action button on Scaffold.
            onPressed: () {
              _previewCard(context);
            },
            child: const Icon(
              Icons.remove_red_eye,
              size: 35,
            ),
          ),
        ),
      );

  void _previewCard(context) {
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
        card: context.read<CardCreator>().getBusinessCard("preview"),
      ),
    );
  }

  void _uploadCard(BuildContext context) async {
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
