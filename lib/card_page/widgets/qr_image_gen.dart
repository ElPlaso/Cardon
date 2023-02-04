import 'dart:convert';

import 'package:cardonapp/app/models/business_card.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// A widget which displays a [BusinessCard]'s QR Code.
class QRImageGen extends StatelessWidget {
  final BusinessCard card;

  const QRImageGen({
    required this.card,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QrImage(data: jsonEncode(card));
  }
}
