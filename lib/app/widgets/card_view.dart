import 'package:cardonapp/app/models/business_card.dart';
import 'package:cardonapp/app/models/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:cardonapp/card_page/widgets/qr_image_gen.dart';
import 'package:auto_size_text/auto_size_text.dart';

// * Widget to visualise a business card

class CardView extends StatelessWidget {
  final BusinessCard card;
  final BoxFit fit;

  static Map<String, ThemeCard> themes = {
    'nimbus': ThemeCard(
        background: const Color.fromARGB(255, 29, 29, 29),
        foreground: const Color.fromARGB(255, 200, 200, 200)),
    'eggshell': ThemeCard(
        background: const Color.fromARGB(255, 240, 234, 214),
        foreground: const Color.fromARGB(255, 0, 0, 0)),
    'off-white': ThemeCard(
        background: const Color.fromARGB(255, 255, 255, 255),
        foreground: const Color.fromARGB(255, 0, 0, 0)),
  };

  const CardView({Key? key, required this.card, this.fit = BoxFit.contain})
      : super(key: key);

  @override
  // fitted box to ensure consistent sizing
  Widget build(BuildContext context) => FittedBox(
        fit: fit,
        child: Container(
          // container with set width/height to enforce aspect ratio
          width: 540,
          height: 320,
          alignment: Alignment.centerLeft,
          color: themes[card.theme]?.background,
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),

          //Row of columns separated by spacer
          child: Row(
            children: [
              // First column name/position and QR code
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subcolumn for name/position text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          card.name,
                          style: TextStyle(
                              color: themes[card.theme]?.foreground,
                              fontWeight: FontWeight.bold,
                              fontSize: 27),
                          minFontSize: 17,
                        ),
                        AutoSizeText(
                          card.position,
                          style: TextStyle(
                              color: themes[card.theme]?.foreground,
                              fontStyle: FontStyle.italic,
                              fontSize: 17),
                          minFontSize: 9,
                        ),
                      ],
                    ),

                    const Spacer(),

                    // QR code wrapped in 1:1 aspect ratio
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: QRImageGen(
                            card: card,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // Spacer between main columns.
              const Spacer(),

              // Second column personal info and company info
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Subcolumn for personal info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AutoSizeText(
                          'E-mail: ${card.email}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: themes[card.theme]?.foreground,
                              fontSize: 15),
                          minFontSize: 5,
                        ),
                        AutoSizeText(
                          'Cellphone: ${card.cellphone}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: themes[card.theme]?.foreground,
                              fontSize: 15),
                          minFontSize: 5,
                        ),
                        AutoSizeText(
                          'Website: ${card.website}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: themes[card.theme]?.foreground,
                              fontSize: 15),
                          minFontSize: 5,
                        ),
                      ],
                    ),

                    const Spacer(),

                    //Subcolumn for company info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AutoSizeText(
                          card.company,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: themes[card.theme]?.foreground,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                          minFontSize: 11,
                        ),
                        AutoSizeText(
                          'Address: ${card.companyaddress}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: themes[card.theme]?.foreground,
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                          ),
                          minFontSize: 5,
                        ),
                        AutoSizeText(
                          'Phone: ${card.companyphone}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: themes[card.theme]?.foreground,
                              fontStyle: FontStyle.italic,
                              fontSize: 15),
                          minFontSize: 5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
