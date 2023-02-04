// Class representing a Business Card.
class BusinessCard {
  String id;
  String theme;
  String cellphone;
  String company;
  String companyaddress;
  String companyphone;
  String email;
  String name;
  String position;
  String website;
  int scancount;
  int refreshcount;

  // Has a unique ID and other fields for useful information.
  BusinessCard({
    required this.id,
    required this.theme,
    this.cellphone = '',
    this.company = '',
    this.companyaddress = '',
    this.companyphone = '',
    this.email = '',
    required this.name,
    this.position = '',
    this.website = '',
    this.scancount = 0,
    this.refreshcount = 0,
  });

  // Create a BusinessCard instance from a Map for serialisation.
  // This Map is returned by jsonDecode() when decoding an encoded
  // card. Usage:
  // BusinessCard card = BusinessCard.fromJson(jsonDecode(JSON_String));
  BusinessCard.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        theme = json['theme'],
        cellphone = json['cellphone'],
        company = json['company'],
        companyaddress = json['companyaddress'],
        companyphone = json['companyphone'],
        email = json['email'],
        name = json['name'],
        position = json['position'],
        website = json['website'],
        scancount = json['scancount'],
        refreshcount = json['refreshcount'];

  // Used to encode a BusinessCard for serialisation. Called by jsonEncode
  // to return an encoded JSON string.
  Map<String, dynamic> toJson() => {
        'id': id,
        'theme': theme,
        'cellphone': cellphone,
        'company': company,
        'companyaddress': companyaddress,
        'companyphone': companyphone,
        'email': email,
        'name': name,
        'position': position,
        'website': website,
        'scancount': scancount,
        'refreshcount': refreshcount,
      };
}
