import 'package:cardonapp/app/providers/google_sign_in_provider.dart';
import 'package:cardonapp/app/widgets/home_banner.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:cardonapp/home/widgets/carousel.dart';
import 'package:cardonapp/main.dart';
import 'package:cardonapp/scan/scan.dart';
import 'package:cardonapp/upload_card/add_card.dart';
import 'package:cardonapp/app/widgets/menu_button.dart';
import 'package:cardonapp/user_cards/user_cards.dart';
import 'package:cardonapp/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/app/providers/card_provider.dart';
import 'package:cardonapp/app/providers/query_provider.dart';

/// Page that users are redirected to when logged in.
///
/// Displays a welcome banner or the user's cards if they exist.
/// Provides navigation to other pages.

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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                stretch: true,
                collapsedHeight: 325.0,
                flexibleSpace: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            MyApp.title,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TappedTextButton(
                            text: '',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddCard(),
                              ),
                            ),
                            iconData: Icons.library_add,
                          ),
                        ],
                      ),
                    ),
                    context.watch<CardProvider>().isEmpty(true)
                        ? const HomeBanner(
                            subheading: 'Add a card to get started',
                          )
                        : const Carousel(),
                  ],
                ),
              ),
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
                      child: Column(
                        children: [
                          MenuButton(
                            count: context
                                .read<CardProvider>()
                                .personalcards
                                .length,
                            icon: const Icon(Icons.person),
                            onClicked: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserCards(),
                              ),
                            ),
                            text: 'Your cards',
                          ),
                          MenuButton(
                            count: context
                                .read<CardProvider>()
                                .collectedcards
                                .length,
                            icon: const Icon(Icons.wallet),
                            onClicked: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Wallet(),
                                ),
                              )
                            },
                            text: 'Wallet',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          highlightElevation: 0,
          elevation: 0,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Scan()),
          ),
          child: const Icon(
            Icons.crop_free_outlined,
            size: 35,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              SizedBox(
                height: 100,
                width: 50,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.3, 1],
                      colors: [
                        Colors.blueAccent,
                        Colors.lightBlue,
                      ],
                    ),
                  ),
                  child: Text(
                    'Cardon.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Transform.scale(
                  alignment: Alignment.center,
                  scaleX: -1,
                  child: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  'Sign out',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showSignOutDialog(context);
                },
              ),
            ],
          ),
        ),
      );

  Future<void> _showSignOutDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.signOut();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
