import 'package:swe_project/Classes/user.dart';

class Driver
{
  final User user;
  final String governmentID;
  final String address;
  final String licenseNumber;
  const Driver ({
    required this.user,
    required this.governmentID,
    required this.address,
    required this.licenseNumber,
});

}