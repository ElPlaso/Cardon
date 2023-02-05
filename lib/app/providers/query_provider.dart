import 'dart:convert';

import 'package:cardonapp/app/models/business_card.dart';
import 'package:cardonapp/app/providers/cardcreator_provider.dart';
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
    if (!context.read<CardProvider>().isEmpty(false)) {
      context.read<CardProvider>().clear(false);
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
                context.read<CardProvider>().add(card, false);

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
    if (!context.read<CardProvider>().isEmpty(true)) {
      context.read<CardProvider>().clear(true);
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
        context.read<CardProvider>().add(card, true);
      }
    });
  }

  /// Adds a card to a user's wallet if it exists
  Future<void> addToWallet(String id) async {
    await FirebaseFirestore.instance
        .collection('Cards')
        .doc(id)
        .update({'scancount': FieldValue.increment(1)});
    // ! append new card to current users' scanned cards
    await FirebaseFirestore.instance.collection('Users').doc(userID).get().then(
          (document) => {
            if (!document.exists)
              {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(
                      userID,
                    )
                    .set({'card-id': 0, 'wallet': []})
              }
          },
        );
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'wallet': FieldValue.arrayUnion([id])
    });
  }

  /// Removes a card from the user's Wallet / collected cards.
  Future<void> removeFromWallet(String id) async {
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'wallet': FieldValue.arrayRemove([id])
    });
  }

  Future<void> deleteCard(String id) async {
    // Delete card from db.
    await FirebaseFirestore.instance.collection('Cards').doc(id).delete();
    // Delete card from owners' personal collection.
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'personalcards': FieldValue.arrayRemove([id])
    });

    // Delete every other reference to the card.
    await FirebaseFirestore.instance
        .collection('Users')
        .where('wallet', arrayContains: id)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.update({
          'wallet': FieldValue.arrayRemove([id])
        });
      }
    });
  }

  Future<void> uploadCard(BuildContext context) async {
    // Increment the ID.
    // Get the current id of the users' card.
    String cardId = '0';
    try {
      // If the user has an account.
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(context.read<QueryProvider>().userID)
          .update({'card-id': FieldValue.increment(1)});
    } on FirebaseException catch (_) {
      // If the user was not found init their profile.
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(context.read<QueryProvider>().userID)
          .set({'card-id': 0, 'wallet': []});
    }

    // Get the ID of the next card to upload.
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userID)
        .get()
        .then((doc) {
      int val = doc.get('card-id');
      cardId = '$userID-$val';
    }).then((_) {
      // Create the business card object.
      var bCard = context.read<CardCreator>().getBusinessCard(cardId);
      // Pass the bussiness card to the DB.
      FirebaseFirestore.instance.collection('Cards').doc(cardId).set({
        'card_id': cardId,
        'card': jsonEncode(bCard),
        'owner': userID,
        'scancount': 0,
        'refreshcount': 0,
      }).onError((error, stackTrace) => ('$error + $stackTrace =========== '));
    }).then(
      (_) => // Update the user profile with the ownership of the new card.
          FirebaseFirestore.instance
              .collection('Users')
              .doc(context.read<QueryProvider>().userID)
              .update({
        'personalcards': FieldValue.arrayUnion([cardId])
      }).onError((error, stackTrace) => ('$error + $stackTrace ===========')),
    );
  }

  Future<void> updateCard(BuildContext context, BusinessCard card) async {
    await FirebaseFirestore.instance.collection('Cards').doc(card.id).update({
      'card_id': card.id,
      'card': jsonEncode(card),
      'owner': context.read<QueryProvider>().userID,
    }).onError((error, stackTrace) => ('$error + $stackTrace =========== '));
  }
}
