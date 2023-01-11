import 'package:cardonapp/pages/add_card.dart';
import 'package:cardonapp/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/providers/card_provider.dart';
import 'package:cardonapp/providers/query_provider.dart';
import '../main.dart';
import '../widgets/banner.dart';
import 'scan.dart';
import 'user_cards.dart';
import 'wallet.dart';
import '../widgets/carousel.dart';

// * Homepage that users are redirected to when logged in
// * Displays a welcome banner or user's cards if they exist
// * Provides navigation to other pages

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<QueryProvider>().updatePersonalcards(context);
    context.read<QueryProvider>().updateWallet(context);
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                  backgroundColor: Colors.transparent,
                  stretch: true,
                  collapsedHeight: 325.0,
                  flexibleSpace: Column(children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 50),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MyApp.title,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                                onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddCard()),
                                    ),
                                icon: Icon(Icons.library_add,
                                    size: 30,
                                    color:
                                        Theme.of(context).colorScheme.primary))
                          ]),
                    ),
                    context.watch<Cards>().isEmpty(true)
                        ? const HomeBanner(
                            subheading: 'Add a card to get started')
                        : const Carousel(),
                  ])),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Column(children: [
                        MenuButton(
                          count: context.read<Cards>().personalcards.length,
                          icon: const Icon(Icons.person),
                          onClicked: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserCards()),
                          ),
                          text: 'Your cards',
                        ),
                        MenuButton(
                          count: context.read<Cards>().collectedcards.length,
                          icon: const Icon(Icons.wallet),
                          onClicked: () => {
                            if (context.read<Cards>().isEmpty(false))
                              {
                                Fluttertoast.showToast(
                                    msg:
                                        "No saved cards. Scan a card to add it to your list!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0)
                              }
                            else
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Wallet()),
                                )
                              }
                          },
                          text: 'Wallet',
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            // Floating action button on Scaffold.
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Scan()),
            ),
            child: const Icon(Icons.crop_free_outlined, size: 35),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const BottomAppBar(
            color: Colors.blue,
            shape: CircularNotchedRectangle(), // Shape of notch.
            notchMargin:
                5, // Notched margin between floating button and bottom app bar.
            child: SizedBox(
              height: 50,
            ),
          ),
        ),
      );
}
