import 'dart:convert';

import 'package:cardonapp/app/models/business_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/app/providers/card_provider.dart';

/// Provider for Firebase queries.
class QueryProvider with ChangeNotifier {
  String userID = '';
  String get getUserID => userID;
  void setUserId(String? uid) {
    if (uid == null) {
      userID = '';
    } else {
      userID = uid;
    }
  }

  /// Collects the cards found in the users wallet and stores the most updated
  /// version locally in the Cards provider.
  Future<void> updateWallet(BuildContext context) async {
    if (!context.read<Cards>().isEmpty(false)) {
      context.read<Cards>().clear(false);
    }
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .get()
        .then((DocumentSnapshot value) {
      value.get('wallet').forEach(
            (element) async => {
              await FirebaseFirestore.instance
                  .collection('Cards')
                  .doc(element)
                  .get()
                  .then((value) async {
                BusinessCard card =
                    BusinessCard.fromJson(jsonDecode(value.get('card')));

                card.refreshcount = value.get('refreshcount');
                card.scancount = value.get('scancount');
                context.read<Cards>().add(card, false);

                if (element != userID) {
                  await FirebaseFirestore.instance
                      .collection('Cards')
                      .doc(card.id)
                      .update({'refreshcount': FieldValue.increment(1)});
                  card.refreshcount = value.get('refreshcount') + 1;
                }
              })
            },
          );
    });
  }

  /// Populates the Cards provider with all the users personally created cards.
  Future<void> updatePersonalcards(BuildContext context) async {
    if (!context.read<Cards>().isEmpty(true)) {
      context.read<Cards>().clear(true);
    }
    await FirebaseFirestore.instance
        .collection('Cards')
        .where('owner', isEqualTo: userID)
        .get()
        .then((doc) async {
      for (var element in doc.docs) {
        BusinessCard card =
            BusinessCard.fromJson(jsonDecode(element.get('card')));
        card.refreshcount = element.get('refreshcount');
        card.scancount = element.get('scancount');
        context.read<Cards>().add(card, true);
      }
    });
  }
}
