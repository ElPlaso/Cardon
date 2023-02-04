import 'package:cardonapp/scan/scan.dart';
import 'package:cardonapp/app/widgets/tapped_text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/providers/query_provider.dart';
import 'widgets/wallet_wheel.dart';

// * Page to display whallet wheel of user's collected cards

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey[50],
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              title: const Text(
                'Wallet.',
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
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RefreshIndicator(
                    onRefresh: () async {
                      _refreshPage(context);
                    },
                    child: const WalletWheel(),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              // Floating action button on Scaffold.
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Scan()),
              ),
              child: const Icon(
                Icons.crop_free_outlined,
                size: 35,
              ),
            ),
          ),
        ),
      );

  _refreshPage(BuildContext context) async {
    await context.read<QueryProvider>().updateWallet(context);
  }
}
