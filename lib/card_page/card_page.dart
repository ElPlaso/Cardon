import 'package:cardonapp/app/models/business_card.dart';
import 'package:cardonapp/app/providers/query_provider.dart';
import 'package:cardonapp/app/widgets/card_view.dart';
import 'package:cardonapp/app/widgets/small_button.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:cardonapp/card_page/widgets/qr_image_gen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Page that allows user to view a card in their wallet.
///
/// Allows user to then save, print, or remove cards from wallet.
class CardPage extends StatefulWidget {
  final BusinessCard card;
  const CardPage({Key? key, required this.card}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final WidgetsToImageController _controller = WidgetsToImageController();

  bool _discarding = false;

  @override
  Widget build(BuildContext context) => _discarding
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
              padding: const EdgeInsets.only(left: 15),
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
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
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
                                      color: CardView.themes[widget.card.theme]
                                          ?.foreground,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                    height: 1,
                                  ),
                                  Text(
                                    'Refreshes: ${widget.card.refreshcount}',
                                    style: TextStyle(
                                      color: CardView.themes[widget.card.theme]
                                          ?.foreground,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                            // Saves a image of the QRCard to the users android gallery.
                            SmallButton(
                              text: 'Add to Photos',

                              // Save the widget as image bytes.
                              onClicked: () {
                                _saveCardAsImage();
                              },
                              iconData: Icons.collections,
                            ),

                            // Shows the QR code of the selected QRCard.
                            SmallButton(
                              text: 'Display QR Code',
                              onClicked: () {
                                _showQRCode();
                              },
                              iconData: Icons.qr_code,
                            ),

                            SmallButton(
                              text: 'Discard',
                              onClicked: () {
                                _showDiscardWarning(context);
                              },
                              iconData: Icons.remove,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

  _discard(BuildContext context) async {
    setState(() {
      _discarding = true;
    });

    await context
        .read<QueryProvider>()
        .removeFromWallet(widget.card.id)
        .then(
          (_) => context.read<QueryProvider>().updateWallet(context),
        )
        // This refreshes the card and count when there are no more cards in the wallet.
        // TODO: investigate why.
        .then((_) => context.read<QueryProvider>().updatePersonalcards(context))
        .then(
          (_) => Navigator.pop(context),
        );

    Fluttertoast.showToast(
      msg: 'Card removed!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _showDiscardWarning(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Discard?'),
        content: const Text(
          'This will remove this card from your wallet which can\'t be undone. \n\n'
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
              _discard(context);
            },
            child: const Text('Discard'),
          )
        ],
      ),
    );
  }

  _saveCardAsImage() async {
    final bytes = await _controller.capture();

    // If the widget was succesfully turned into image bytes, save image to phone gallery.
    if (bytes != null) {
      ImageGallerySaver.saveImage(
        bytes,
        quality: 60,
        name: 'file_name${DateTime.now()}',
      );
    }

    // Inform the user that the image has been saved.
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

  _showQRCode() {
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
}
