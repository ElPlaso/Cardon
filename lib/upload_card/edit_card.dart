import 'package:cardonapp/app/models/business_card.dart';
import 'package:cardonapp/app/providers/cardcreator_provider.dart';
import 'package:cardonapp/app/providers/query_provider.dart';
import 'package:cardonapp/app/widgets/card_view.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:cardonapp/card_page/user_card_page.dart';
import 'package:cardonapp/upload_card/widgets/card_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

/// Page that allows users to update an existing card of theirs.
///
/// It also allows users to preview changes they've made in the form of a [CardView].
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
    var bCard = context.read<CardCreator>().getBusinessCard(card.id);
    await context
        .read<QueryProvider>()
        .updateCard(context, bCard)
        .then(
          (_) => context.read<QueryProvider>().updatePersonalcards(context),
        )
        .then((_) {
      // This takes us to a user card page with the newly updated card.
      Navigator.pop(context); // Pop to the user card page.
      Navigator.pushReplacement(
        // Push to the user card page with a new card.
        context,
        MaterialPageRoute(builder: (context) => UserCardPage(card: bCard)),
      );
    });
    Fluttertoast.showToast(
      msg: 'Card updated!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
