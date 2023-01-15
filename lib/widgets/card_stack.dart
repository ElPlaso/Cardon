import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/user_card_page.dart';
import '../providers/card_provider.dart';
import 'card_view.dart';

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
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.8,
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: context.watch<Cards>().personalcards.map(
                      (card) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Align(
                              // Stack effect
                              heightFactor: 0.5,
                              alignment: Alignment.topCenter,
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserCardPage(card: card)),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        CardView.themes[card.theme]?.background,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.15),
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
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
