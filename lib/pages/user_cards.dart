import 'package:cardonapp/providers/card_provider.dart';
import 'package:cardonapp/widgets/tapped_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cardonapp/widgets/card_stack.dart';
import 'package:provider/provider.dart';
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
          body: context.watch<Cards>().isEmpty(true)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.browser_not_supported,
                        size: 50,
                      ),
                      Text(
                        "No Cards",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoScrollbar(
                    thumbVisibility: true,
                    thickness: 5,
                    radius: const Radius.circular(20),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [SizedBox(height: 20), CardStack()],
                      ),
                    ),
                  ),
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
