import 'package:flutter/material.dart';
import 'package:cardonapp/widgets/card_stack.dart';
import 'add_card.dart';
import '../widgets/floater.dart';

// * Page to display user's created cards
// * Allows user to then create a new card

class UserCards extends StatelessWidget {
  const UserCards({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Your Cards'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 24),
              const CardStack(),
              // Navigates to the add card page
              Floater(
                  text: 'Add Card',
                  onClicked: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddCard()),
                      ),
                  icon: const Icon(Icons.add))
            ],
          ),
        ),
      );
}
