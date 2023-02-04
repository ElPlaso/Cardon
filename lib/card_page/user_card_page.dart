import 'dart:typed_data';
import 'package:cardonapp/app/models/business_card.dart';
import 'package:cardonapp/app/providers/card_provider.dart';
import 'package:cardonapp/app/providers/cardcreator_provider.dart';
import 'package:cardonapp/app/providers/query_provider.dart';
import 'package:cardonapp/app/widgets/card_view.dart';
import 'package:cardonapp/app/widgets/small_button.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:cardonapp/card_page/widgets/qr_image_gen.dart';
import 'package:cardonapp/upload_card/edit_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

// * Allows user to view a card of their own
// * Requires business card
// * Users can then edit or delete card
// * Users can also save, print, and view QR Code of card

class UserCardPage extends StatefulWidget {
  final BusinessCard card;
  const UserCardPage({Key? key, required this.card}) : super(key: key);

  @override
  State<UserCardPage> createState() => UserCardPageState();
}

class UserCardPageState extends State<UserCardPage> {
  final WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 5,
            elevation: 0,
            backgroundColor: Colors.grey[50],
            leading: Padding(
              padding: const EdgeInsets.only(left: 13),
              child: TappedTextButton(
                text: 'Done',
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            leadingWidth: 120,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TappedTextButton(
                  text: '',
                  onTap: () {},
                  iconData: Icons.pending,
                ),
              ),
            ],
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              _refreshPage();
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 325,
                      child: Card(
                        color: CardView.themes[widget.card.theme]?.background,
                        margin: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: WidgetsToImage(
                                controller: controller,
                                child: CardView(
                                  card: widget.card,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Scans: ${widget.card.scancount}',
                                  style: TextStyle(
                                    color: CardView
                                        .themes[widget.card.theme]?.foreground,
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                  height: 1,
                                ),
                                Text(
                                  'Refreshes: ${widget.card.refreshcount}',
                                  style: TextStyle(
                                    color: CardView
                                        .themes[widget.card.theme]?.foreground,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            bottom: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SmallButton(
                                text: 'Edit Card',
                                onClicked: () {
                                  _prepareEditCard();
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              SmallButton(
                                text: 'Add to photos',
                                onClicked: () {
                                  _saveCardAsImage();
                                },
                                icon: const Icon(Icons.collections),
                              ),
                              SmallButton(
                                text: 'Display QR Code',
                                onClicked: () {
                                  _showQRCode(context);
                                },
                                icon: const Icon(Icons.qr_code),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            // Floating action button on Scaffold.
            onPressed: () {
              _deleteCard(context);
            },
            child: const Icon(
              Icons.delete_forever,
              size: 35,
            ),
          ),
        ),
      );

  _showQRCode(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => Center(child: QRImageGen(card: widget.card)),
    );
  }

  _refreshPage() async {
    await context.read<QueryProvider>().updatePersonalcards(context);
  }

  _saveCardAsImage() async {
    final bytes = await controller.capture();
    setState(() {
      this.bytes = bytes;
    });
    if (bytes != null) {
      ImageGallerySaver.saveImage(
        bytes,
        quality: 60,
        name: 'file_name${DateTime.now()}',
      );
    }
    Fluttertoast.showToast(
      msg: 'Image saved!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  _prepareEditCard() {
    context.read<CardCreator>().setName(widget.card.name);
    context.read<CardCreator>().setPostion(widget.card.position);
    context.read<CardCreator>().setEmail(widget.card.email);
    context.read<CardCreator>().setCellphone(widget.card.cellphone);
    context.read<CardCreator>().setWebsite(widget.card.website);
    context.read<CardCreator>().setCompany(widget.card.company);
    context.read<CardCreator>().setCompanyAddress(widget.card.companyaddress);
    context.read<CardCreator>().setCompanyPhone(widget.card.companyphone);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditCard(card: widget.card)),
    );
  }

  _deleteCard(BuildContext context) async {
    // delete card from db
    await FirebaseFirestore.instance
        .collection('Cards')
        .doc(widget.card.id)
        .delete();
    // delete card from owners' personal collection
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(context.read<QueryProvider>().getUserID)
        .update({
      'personalcards': FieldValue.arrayRemove([widget.card.id])
    });

    // ! delete every other reference to the card
    await FirebaseFirestore.instance
        .collection('Users')
        .where('wallet', arrayContains: widget.card.id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.update({
          'wallet': FieldValue.arrayRemove([widget.card.id])
        });
      }
    });

    /// * Deletes seleted card from local storage
    context.read<Cards>().delete(widget.card, true);

    /// * refreshes the local storage
    await context.read<QueryProvider>().updatePersonalcards(context);

    /// * Popup to notify user of change.
    Fluttertoast.showToast(
      msg: 'Card deleted!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pop(context);
  }
}
