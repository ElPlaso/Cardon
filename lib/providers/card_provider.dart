import 'package:flutter/material.dart';
import 'package:cardonapp/data/business_card.dart';

// Provider for the list of person and collected cards.
class Cards with ChangeNotifier {
  // Personal Card List
  final List<BusinessCard> _personalcards = [];
  // Collected Card List
  final List<BusinessCard> _collectedcards = [];
  // Personal Card Getter
  List<BusinessCard> get personalcards => _personalcards;
  // Collected Card Getter
  List<BusinessCard> get collectedcards => _collectedcards;

  /// adds only new cards to the provided list
  ///
  /// * Example usage
  ///  context.read<Cards>()
  ///  .add(BusinessCard.fromJson(
  ///            jsonDecode(element.get('card'))),
  ///            context.read<Cards>().personalcards);
  ///
  /// * this adds a decoded card from a JSON query
  /// * to the personalcards array
  /// /

  // Add a given business card to the personal or collected list.
  void add(BusinessCard b, bool personal) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    if (list.contains(b)) {
      return;
    }
    list.add(b);
    notifyListeners();
  }

  // Delete a given business card from the personal or collected list.
  void delete(BusinessCard b, bool personal) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    list.remove(b);
    notifyListeners();
  }

  // Delete multiple business cards from the personal or collected list.
  void deleteAll(List<BusinessCard> del, bool personal, String uid) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    del.forEach((element) {
      list.remove(element);
    });
    notifyListeners();
  }

  // Clear the personal or collected list.
  void clear(bool personal) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    list.clear();
    notifyListeners();
  }

  // Check if the personal or collected list are empty.
  bool isEmpty(bool personal) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    return list.isEmpty;
  }

  //read list with context.watch<Cards>().cards
  //call other methods with context.read<Cards>().method()
  //eg context.read<Cards>().add(card)
}
