import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'card_view.dart';
import '../providers/card_provider.dart';

// * Displays user's cards as an automatic carousel

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  CarouselState createState() => CarouselState();
}

class CarouselState extends State<Carousel> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) => CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 1000),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
        ),
        items: context.watch<Cards>().personalcards.map(
          (card) {
            return Builder(
              builder: (BuildContext context) {
                return Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Center(
                    child: CardView(card: card),
                  ),
                );
              },
            );
          },
        ).toList(),
      );
}
