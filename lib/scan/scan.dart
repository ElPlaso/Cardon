import 'dart:convert';
import 'package:cardonapp/app/providers/query_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Page which allows user to scan a QR-Code.
class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ScanState();
  }
}

class _ScanState extends State<Scan> {
  MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: controller,
              allowDuplicates: false,
              onDetect: (barcode, args) async {
                try {
                  if (barcode.rawValue != null) {
                    var data = barcode.rawValue!;
                    var cardMap = jsonDecode(data);
                    // ! incr scancount

                    try {
                      await context
                          .read<QueryProvider>()
                          .addToWallet(cardMap['id'])
                          .then(
                            (_) => context
                                .read<QueryProvider>()
                                .updateWallet(context),
                          )
                          .then(
                            (_) => Navigator.pop(context),
                          );

                      Fluttertoast.showToast(
                        msg: 'Card scanned!',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } on FirebaseException catch (_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                            'Sorry, this card is not in the database.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Okay'),
                              child: const Text('Okay'),
                            )
                          ],
                        ),
                      );
                    }
                  }
                } catch (_) {
                  // Alert user that something went wrong when scanning.
                  if (mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                          "Couldn't scan. \nIs this a valid QR Code?",
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Okay'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Floating action button on Scaffold.
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.close, size: 35),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
