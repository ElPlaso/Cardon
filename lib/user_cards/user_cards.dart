import 'package:cardonapp/app/providers/card_provider.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:cardonapp/upload_card/add_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cardonapp/user_cards/widgets/card_stack.dart';
import 'package:provider/provider.dart';

/// Page which display a user's personal cards.
class UserCards extends StatelessWidget {
  const UserCards({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          scrolledUnderElevation: 5,
          elevation: 0,
          backgroundColor: Colors.grey[50],
          title: const Text(
            'Your Cards.',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 13),
            child: TappedTextButton(
              text: '',
              iconData: Icons.chevron_left,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: context.watch<CardProvider>().isEmpty(true)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.browser_not_supported,
                      size: 50,
                    ),
                    Text(
                      'No Cards',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
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
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [SizedBox(height: 20), CardStack()],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCard()),
          ),
          child: const Icon(
            Icons.library_add,
            size: 25,
          ),
        ),
      );
}
