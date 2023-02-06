import 'package:cardonapp/app/models/business_card.dart';
import 'package:flutter/material.dart';

/// Provider for the list of personal and collected cards.
///
/// Read list with context.watch<Cards>().cards.
/// Call other methods with context.read<Cards>().method()
/// e.g. context.read<Cards>().add(card).
class CardProvider with ChangeNotifier {
  /// Personal Card List.
  final List<BusinessCard> _personalcards = [];

  /// Collected Card List.
  final List<BusinessCard> _collectedcards = [];

  /// Personal Card Getter.
  List<BusinessCard> get personalcards => _personalcards;

  /// Collected Card Getter.
  List<BusinessCard> get collectedcards => _collectedcards;

  /// Adds a given business card to the personal or collected list.
  ///
  /// Adds only new cards to the provided list
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
  void add(BusinessCard b, bool personal) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    if (list.contains(b)) {
      return;
    }
    list.add(b);
    notifyListeners();
  }

  /// Deletes a given business card from the personal or collected list.
  void delete(BusinessCard b, bool personal) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    list.remove(b);
    notifyListeners();
  }

  /// Deletes multiple business cards from the personal or collected list.
  void deleteAll(List<BusinessCard> del, bool personal, String uid) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    for (var element in del) {
      list.remove(element);
    }
    notifyListeners();
  }

  /// Clears the personal or collected list.
  void clear(bool personal) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    list.clear();
    // Uncommented as it throws an error when hot reloading.
    // notifyListeners();
  }

  /// Check if the personal or collected list are empty.
  bool isEmpty(bool personal) {
    List<BusinessCard> list = personal ? _personalcards : _collectedcards;
    return list.isEmpty;
  }
}
