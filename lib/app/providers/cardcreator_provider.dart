import 'package:cardonapp/app/models/business_card.dart';
import 'package:flutter/material.dart';

class CardCreator with ChangeNotifier {
  String _theme = 'nimbus';
  String get theme => _theme;
  void setTheme(String theme) {
    _theme = theme;
    notifyListeners();
  }

  String _name = '';
  String get name => _name;
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  String _position = '';
  String get postion => _position;
  void setPostion(String temp) {
    _position = temp;
    notifyListeners();
  }

  String _email = '';
  String get email => _email;
  void setEmail(String temp) {
    _email = temp;
    notifyListeners();
  }

  String _cellphone = '';
  String get cellphone => _cellphone;
  void setCellphone(String temp) {
    _cellphone = temp;
    notifyListeners();
  }

  String _website = '';
  String get website => _website;
  void setWebsite(String temp) {
    _website = temp;
    notifyListeners();
  }

  String _company = '';
  String get company => _company;
  void setCompany(String temp) {
    _company = temp;
    notifyListeners();
  }

  String _companyAddress = '';
  String get companyAddress => _companyAddress;
  void setCompanyAddress(String temp) {
    _companyAddress = temp;
    notifyListeners();
  }

  String _companyPhone = '';
  String get companyPhone => _companyPhone;
  void setCompanyPhone(String temp) {
    _companyPhone = temp;
    notifyListeners();
  }

  BusinessCard getBusinessCard(id) => BusinessCard(
        id: id,
        theme: theme,
        name: name,
        position: postion,
        email: email,
        cellphone: cellphone,
        website: website,
        company: company,
        companyaddress: companyAddress,
        companyphone: companyPhone,
      );
}
