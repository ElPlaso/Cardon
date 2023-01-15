import 'package:cardonapp/widgets/tapped_text_button.dart';
import 'package:flutter/material.dart';
import 'package:cardonapp/widgets/card_stack.dart';
import 'add_card.dart';

// * Page to display user's created cards
// * Allows user to then create a new card

class UserCards extends StatelessWidget {
  const UserCards({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            scrolledUnderElevation: 5,
            elevation: 0,
            backgroundColor: Colors.grey[50],
            title: const Text(
              "Your Cards.",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 13),
              child: TappedTextButton(
                text: "",
                iconData: Icons.chevron_left,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          body: const Center(
            child: CardStack(),
          ),
          floatingActionButton: FloatingActionButton(
            // Floating action button on Scaffold.
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCard()),
            ),
            child: const Icon(
              Icons.library_add,
              size: 25,
            ),
          ),
        ),
      );
}
