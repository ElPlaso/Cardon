import 'package:cardonapp/app/models/business_card.dart';
import 'package:cardonapp/app/providers/card_provider.dart';
import 'package:cardonapp/app/providers/cardcreator_provider.dart';
import 'package:cardonapp/app/providers/query_provider.dart';
import 'package:cardonapp/app/widgets/card_view.dart';
import 'package:cardonapp/app/widgets/small_button.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:cardonapp/card_page/widgets/qr_image_gen.dart';
import 'package:cardonapp/upload_card/edit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Page that allows user to view a card of their own.
///
/// Users can then edit or delete the card.
/// Users can also save, print, and view QR Code of card.
class UserCardPage extends StatefulWidget {
  final BusinessCard card;
  const UserCardPage({Key? key, required this.card}) : super(key: key);

  @override
  State<UserCardPage> createState() => UserCardPageState();
}

class UserCardPageState extends State<UserCardPage> {
  final WidgetsToImageController _controller = WidgetsToImageController();

  bool _deleting = false;

  @override
  Widget build(BuildContext context) => _deleting
      ? const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Uploading',
            ),
          ),
        )
      : Scaffold(
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
                                controller: _controller,
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
                                iconData: Icons.edit,
                              ),
                              SmallButton(
                                text: 'Add to photos',
                                onClicked: () {
                                  _saveCardAsImage();
                                },
                                iconData: Icons.collections,
                              ),
                              SmallButton(
                                text: 'Display QR Code',
                                onClicked: () {
                                  _showQRCode(context);
                                },
                                iconData: Icons.qr_code,
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
            onPressed: () {
              _showDeleteWarning(context);
            },
            child: const Icon(
              Icons.delete_forever,
              size: 35,
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
    final bytes = await _controller.capture();

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
    setState(() {
      _deleting = true;
    });

    await context
        .read<QueryProvider>()
        .deleteCard(widget.card.id)
        .then(
          (_) => // Delete seleted card from local storage.
              context.read<CardProvider>().delete(widget.card, true),
        )
        .then((_) => Navigator.pop(context));

    // Notify user of change.
    Fluttertoast.showToast(
      msg: 'Card deleted!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _showDeleteWarning(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Delete Card?'),
        content: const Text(
          'This will delete your card from the database which can\'t be undone. \n'
          'Your card will be removed from other users\' wallets. \n\n'
          'Are you sure you want to proceed?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteCard(context);
            },
            child: const Text('Delete'),
          )
        ],
      ),
    );
  }
}
