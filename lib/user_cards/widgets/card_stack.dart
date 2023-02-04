import 'package:cardonapp/app/providers/card_provider.dart';
import 'package:cardonapp/app/widgets/card_view.dart';
import 'package:cardonapp/card_page/user_card_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:card_stack_widget/card_stack_widget.dart';

// * List view of user's cards
// * Displays the cards stacked on top of eachother

class CardStack extends StatefulWidget {
  const CardStack({super.key});

  @override
  CardStackState createState() {
    return CardStackState();
  }
}

class CardStackState extends State<CardStack> {
  final double cardHeight = 200;

  @override
  Widget build(BuildContext context) {
    final cardList = buildCardList(context);
    final int numCards = context.watch<Cards>().personalcards.length;
    return SizedBox(
      height: cardHeight + (numCards) * 0.3 * cardHeight,
      width: MediaQuery.of(context).size.width,
      child: CardStackWidget(
        opacityChangeOnDrag: true,
        swipeOrientation:
            numCards > 1 ? CardOrientation.both : CardOrientation.none,
        cardDismissOrientation:
            numCards > 1 ? CardOrientation.both : CardOrientation.none,
        positionFactor: 3,
        scaleFactor: 0,
        alignment: Alignment.center,
        animateCardScale: false,
        cardList: cardList,
      ),
    );
  }

  /// Creates the list of Card Models.
  static buildCardList(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width * 0.8;

    return context.watch<Cards>().personalcards.map(
      (card) {
        return CardModel(
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: containerWidth,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserCardPage(card: card)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CardView.themes[card.theme]?.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: CardView(card: card),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).toList();
  }
}
