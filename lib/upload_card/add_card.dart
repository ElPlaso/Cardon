import 'package:cardonapp/app/models/business_card.dart';
import 'package:cardonapp/app/widgets/card_view.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:cardonapp/upload_card/widgets/card_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/app/providers/cardcreator_provider.dart';
import 'package:cardonapp/app/providers/query_provider.dart';

/// Page that allows user to preview and create cards.

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
                  iconData: Icons.ios_share_outlined,
                  text: 'Done',
                  onTap: () {
                    _uploadCard(context);
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
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CardForm(card: BusinessCard(id: '', name: '', theme: 'nimbus')),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
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
      // Displays preview of business card.
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => CardView(
        // Create the mock BusinessCard from the providers.
        card: context.read<CardCreator>().getBusinessCard('preview'),
      ),
    );
  }

  void _uploadCard(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();

    await context
        .read<QueryProvider>()
        .uploadCard(context)
        .then(
          (_) =>
              // Updates the personal card provider with the latest
              // copy of the users cards.

              context.read<QueryProvider>().updatePersonalcards(context),
        )
        .then((_) => Navigator.pop(context));

    Fluttertoast.showToast(
      msg: 'Card uploaded!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
