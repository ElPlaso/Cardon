import 'dart:convert';
import 'package:cardonapp/app/models/business_card.dart';
import 'package:cardonapp/app/providers/cardcreator_provider.dart';
import 'package:cardonapp/app/providers/query_provider.dart';
import 'package:cardonapp/app/widgets/card_view.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:cardonapp/card_page/user_card_page.dart';
import 'package:cardonapp/upload_card/wigets/card_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
// * Page to allow users to update an existing card of theirs
// * Requires a business card object
// * Allows users to preview changes made

class EditCard extends StatelessWidget {
  final BusinessCard card;

  const EditCard({super.key, required this.card});
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 5,
            elevation: 0,
            backgroundColor: Colors.grey[50],
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TappedTextButton(
                iconData: Icons.chevron_left,
                text: 'Cancel',
                onTap: () {
                  Navigator.pop(context);
                },
                textDirection: TextDirection.ltr,
              ),
            ),
            leadingWidth: 120,
            foregroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: TappedTextButton(
                  iconData: Icons.done,
                  text: 'Done',
                  onTap: () {
                    _updateCard(context);
                  },
                  textDirection: TextDirection.rtl,
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
                      const EdgeInsets.only(left: 25, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CardForm(card: card),
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
        card: context.read<CardCreator>().getBusinessCard(card.id),
      ),
    );
  }

  void _updateCard(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    // ! get UID
    // ! get the current id of the users' card
    String cardId = card.id;

    var bCard = BusinessCard(
      id: cardId,
      theme: context.read<CardCreator>().theme,
      name: context.read<CardCreator>().name,
      position: context.read<CardCreator>().postion,
      email: context.read<CardCreator>().email,
      cellphone: context.read<CardCreator>().cellphone,
      website: context.read<CardCreator>().website,
      company: context.read<CardCreator>().company,
      companyaddress: context.read<CardCreator>().companyAddress,
      companyphone: context.read<CardCreator>().companyPhone,
    );
    await FirebaseFirestore.instance.collection('Cards').doc(cardId).update({
      'card_id': cardId,
      'card': jsonEncode(bCard),
      'owner': context.read<QueryProvider>().userID,
    }).onError((error, stackTrace) => ('$error + $stackTrace =========== '));
    // ! is this how we can exit the create page flutterly?

    await context.read<QueryProvider>().updatePersonalcards(context);
    Fluttertoast.showToast(
      msg: 'Card updated!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserCardPage(card: bCard)),
    );
  }
}
