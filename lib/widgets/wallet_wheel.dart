import 'package:flutter/material.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/pages/card_page.dart';
import 'card_view.dart';
import '../providers/card_provider.dart';

// * Clickable Wheel Scroll View of user's collected cards

class WalletWheel extends StatefulWidget {
  const WalletWheel({super.key});

  @override
  WalletWheelState createState() {
    return WalletWheelState();
  }
}

class WalletWheelState extends State<WalletWheel> {
  final _scrollController = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 500,
      child: ClickableListWheelScrollView(
          itemCount: context.read<Cards>().collectedcards.length,

          // When a card in the list is tapped, go to CardPage for that card.
          onItemTapCallback: (index) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CardPage(
                      card: context.read<Cards>().collectedcards[index])),
            );
          },
          itemHeight: 200,
          scrollController: _scrollController,
          child: ListWheelScrollView(
            controller: _scrollController,
            itemExtent: 200,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) => {},

            // Get scanned cards and create a list of CardViews to be displayed.
            children: context.watch<Cards>().collectedcards.map(
              (card) {
                return Builder(
                  builder: (BuildContext context) {
                    return CardView(
                      card: card,
                    );
                  },
                );
              },
            ).toList(),
          )));
}
