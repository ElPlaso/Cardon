import 'package:flutter/material.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/card_page/card_page.dart';
import '../../app/widgets/card_view.dart';
import '../../app/providers/card_provider.dart';

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
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: ClickableListWheelScrollView(
        itemCount: context.read<Cards>().collectedcards.length,
        // When a card in the list is tapped, go to CardPage for that card.
        onItemTapCallback: (index) {
          if (index >= 0 &&
              index < context.read<Cards>().collectedcards.length) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CardPage(
                      card: context.read<Cards>().collectedcards[index])),
            );
          }
        },
        itemHeight: 200,
        scrollController: _scrollController,
        child: ListWheelScrollView(
          renderChildrenOutsideViewport: true,
          clipBehavior: Clip.none,
          controller: _scrollController,
          itemExtent: 200,
          physics:
              const FixedExtentScrollPhysics(parent: BouncingScrollPhysics()),
          onSelectedItemChanged: (index) => {},
          perspective: 0.001,
          // Get scanned cards and create a list of CardViews to be displayed.
          children: context.watch<Cards>().collectedcards.map(
            (card) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 6,
                          offset: const Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: CardView.themes[card.theme]?.background,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: CardView(card: card),
                    ),
                  );
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
