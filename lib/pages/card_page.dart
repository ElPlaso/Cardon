import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/data/business_card.dart';
import 'package:cardonapp/providers/query_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/card_view.dart';
import '../widgets/qr_image_gen.dart';
import '../widgets/small_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// * Page that allows user to view a card in their wallet
// * Requires a business card object
// * Allows user to then save, print and remove cards from wallet

class CardPage extends StatefulWidget {
  final BusinessCard card;
  const CardPage({Key? key, required this.card}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<CardPage> createState() => _CardPageState(card: card);
}

class _CardPageState extends State<CardPage> {
  final WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;

  final BusinessCard card;

  _CardPageState({required this.card});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Wallet'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // display business card
              Container(
                margin: const EdgeInsets.all(15),
                child: WidgetsToImage(
                  controller: controller,
                  child: CardView(
                    card: widget.card,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Scan count: ${card.scancount}'),
                  const SizedBox(
                    width: 50,
                    height: 1,
                  ),
                  Text('Refresh count: ${card.refreshcount}')
                ],
              ),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// * Saves A image of the QRCard to the users android gallery
                      SmallButton(
                        text: 'Save Image',

                        // save widget as image bytes
                        onClicked: () async {
                          final bytes = await controller.capture();
                          setState(() {
                            this.bytes = bytes;
                          });

                          // if widget was succesfully turned into image bytes, save image to phone gallery.
                          if (bytes != null) {
                            ImageGallerySaver.saveImage(bytes,
                                quality: 60,
                                name: "file_name${DateTime.now()}");
                          }

                          // Inform user that the image has been saved.
                          Fluttertoast.showToast(
                              msg: "Image saved!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        },
                        icon: const Icon(Icons.camera_alt, size: 25),
                      ),

                      /// * Shows the QR code of the selected QRCard
                      SmallButton(
                        text: 'Show QR',
                        onClicked: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) =>
                                  Center(child: QRImageGen(card: card)));
                        },
                        icon: const Icon(Icons.qr_code, size: 25),
                      ),

                      /// * Removes the selected card from the users' wallet
                      SmallButton(
                        text: 'Discard',
                        onClicked: () async {
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(context.read<QueryProvider>().userID)
                              .update({
                            "wallet": FieldValue.arrayRemove([card.id])
                          });
                          await context
                              .read<QueryProvider>()
                              .updateWallet(context);
                          Fluttertoast.showToast(
                              msg: "Card removed!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.remove, size: 25),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
}
