import 'package:cloud_firestore/cloud_firestore.dart';

class Apartment {
  final String currentUserId;
  final String address;
  final String rent;
  final String moveInPrice;
  final String about;
  final List<String> imagePath;
  final String tantInfo;
  final String renterRating;
  final String tantEmail;
  final Timestamp timestamp;
  final String reciverId;

  Apartment(
      this.address,
      this.rent,
      this.moveInPrice,
      this.about,
      this.tantInfo,
      this.imagePath,
      this.renterRating,
      this.tantEmail,
      this.timestamp,
      this.currentUserId,
      this.reciverId);

  Map<String, dynamic> toMap() {
    return {
      'senderId': currentUserId,
      'address': address,
      'rent': rent,
      'moveInPrice': moveInPrice,
      'about': about,
      'imagePath': imagePath,
      'tantInfo': tantInfo,
      'renterRating': renterRating,
      'tantEmail': tantEmail,
      'timestamp': timestamp,
      'reciverId': reciverId,
    };
  }
}
