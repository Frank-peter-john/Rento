import 'package:rento/models/property_model.dart';

class Owner {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final String profileImage;
  final List<Property> properties;

  Owner({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.profileImage,
    required this.properties,
  });
}
