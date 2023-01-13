import 'package:cardonapp/widgets/theme_toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cardonapp/providers/cardcreator_provider.dart';
import '../data/business_card.dart';

// * Form to take user input in order to create a new business card
// * Is scrollable and features multiple text form fields

class CardForm extends StatefulWidget {
  final BusinessCard card;

  const CardForm({super.key, required this.card});

  @override
  CardFormState createState() {
    return CardFormState();
  }
}

typedef TextCallback = void Function(String input);

// Create a corresponding State class. This class holds data related to the form.
class CardFormState extends State<CardForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  final ScrollController controller = ScrollController();

  late BusinessCard card;

  @override
  void initState() {
    super.initState();
    card = widget.card;
  }

  /// * The card is constructed from named text fields below.
  /// * The corresponding provider fields are updated with every change to the text
  /// * * fields
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: Form(
            key: _formKey,
            child: CupertinoScrollbar(
              controller: controller,
              thumbVisibility: true,
              thickness: 5,
              radius: const Radius.circular(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: controller,
                child: Container(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        initialValue: card.name,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter your name',
                          labelText: 'Name',
                        ),
                        onChanged: (value) =>
                            context.read<CardCreator>().setName(value),
                      ),
                      TextFormField(
                        initialValue: card.position,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.work),
                          hintText: 'Enter your position',
                          labelText: 'Position',
                        ),
                        onChanged: (value) =>
                            context.read<CardCreator>().setPostion(value),
                      ),
                      TextFormField(
                        initialValue: card.email,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: 'Enter your email',
                          labelText: 'Email',
                        ),
                        onChanged: (value) =>
                            context.read<CardCreator>().setEmail(value),
                      ),
                      TextFormField(
                        initialValue: card.cellphone,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone_android),
                          hintText: 'Enter your phone number',
                          labelText: 'Cellphone',
                        ),
                        onChanged: (value) =>
                            context.read<CardCreator>().setCellphone(value),
                      ),
                      TextFormField(
                        initialValue: card.website,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.web),
                          hintText: 'Enter your website url',
                          labelText: 'Website',
                        ),
                        onChanged: (value) =>
                            context.read<CardCreator>().setWebsite(value),
                      ),
                      TextFormField(
                        initialValue: card.company,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.business),
                          hintText: 'Enter the name of your company',
                          labelText: 'Company',
                        ),
                        onChanged: (value) =>
                            context.read<CardCreator>().setCompany(value),
                      ),
                      TextFormField(
                        initialValue: card.companyaddress,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.home),
                          hintText: 'Enter the address of your company',
                          labelText: 'Address',
                        ),
                        onChanged: (value) => context
                            .read<CardCreator>()
                            .setCompanyAddress(value),
                      ),
                      TextFormField(
                        initialValue: card.companyphone,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          hintText: 'Enter the phone number of your company',
                          labelText: 'Company Phone',
                        ),
                        onChanged: (value) =>
                            context.read<CardCreator>().setCompanyPhone(value),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 25, bottom: 10),
                        child: ThemeToggle(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
