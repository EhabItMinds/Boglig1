import 'package:bolig/model/apartment.dart';
import 'package:bolig/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:string_2_icon/string_2_icon.dart';

class AparrmentService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> LoveAnApartment(String receiverId, Apartment apartment) async {
//get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currenUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new apa
    Apartment newapartment = Apartment(
        apartment.address,
        apartment.rent,
        apartment.moveInPrice,
        apartment.about,
        apartment.tantInfo,
        apartment.imagePath,
        apartment.renterRating,
        apartment.tantEmail,
        timestamp,
        currentUserId,
        apartment.reciverId);
    //construct a chat room id from current user ud and receiver id
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same for any pair of peolpe)
    String chaRommsId = ids
        .join("_"); // combine the ids into a single string to use as a chatroom

    //add new message to database
    await _firestore
        .collection('liked_apartments')
        .doc(chaRommsId)
        .collection('apartments')
        .add(newapartment.toMap());
  }

  //get message

  Stream<QuerySnapshot> getApartment_messages(
      String userId, String otherUserId) {
    //construct a chat room id from current user ud and receiver id
    List<String> ids = [userId, otherUserId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same for any pair of peolpe)
    String chaRommsId = ids
        .join("_"); // combine the ids into a single string to use as a chatroom

    return _firestore
        .collection('liked_apartments')
        .doc(chaRommsId)
        .collection('apartments')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<QuerySnapshot> getApartments() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('liked_apartments')
        .where('senderId', isEqualTo: currentUserId)
        .get();
  }

  Future<void> LikeApartment(Apartment apartment) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    Apartment newapartment = Apartment(
        apartment.address,
        apartment.rent,
        apartment.moveInPrice,
        apartment.about,
        apartment.tantInfo,
        apartment.imagePath,
        apartment.renterRating,
        apartment.tantEmail,
        timestamp,
        currentUserId,
        apartment.reciverId);

    await FirebaseFirestore.instance
        .collection('liked_apartments')
        .add(newapartment.toMap());
  }

  Future<void> unLikeApartment(Apartment apartment) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    try {
      // Query for the apartment to delete based on its address
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('liked_apartments')
          .where('address',
              isEqualTo: apartment
                  .address) // Replace 'address' with the actual field name
          .where('senderId',
              isEqualTo: currentUserId) // Assuming you have a 'userId' field
          .get();

      // Check if the query returned any documents
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first document that matches the query
        await querySnapshot.docs.first.reference.delete();
      }
    } catch (e) {
      // Handle any errors that may occur during the deletion process
      print('Error deleting apartment: $e');
    }
  }

  Future<void> initiapartments() async {
    final String currentUserId = '1';
    final Timestamp timestamp = Timestamp.now();
    List<String> imagePaths = [
      'lib/images/Lejlighed1.png',
      'lib/images/Lejlighed2.png'
    ];

    List<Apartment> apartments = [
      Apartment(
          '123 Main Street',
          '1200',
          '2400',
          'A spacious apartment in a prime location.',
          'John Doe',
          ['image1.jpg', 'image2.jpg'],
          '4.5',
          'ehab@gmail.com',
          timestamp,
          '123',
          'HwTR6FMDJCUaNTiNdnyECT76PEq1'),
      Apartment(
          '456 Elm Avenue',
          '1500',
          '3000',
          'Cozy apartment with a beautiful view.',
          'Jane Smith',
          ['image3.jpg', 'image4.jpg'],
          '4.2',
          'ehab@gmail.com',
          timestamp,
          '212',
          'HwTR6FMDJCUaNTiNdnyECT76PEq1'),
      Apartment(
          'Niels jules gade 1 800 aarhus c',
          '12312',
          '1231',
          'Welcome to your new home! This cozy 2-bedroom apartment offers a perfect blend of comfort and convenience in the heart of the city. With stunning panoramic views of the city skyline and modern amenities, you will love living here',
          'Helle helle',
          imagePaths,
          '4.8',
          'ehab@gmail.com',
          Timestamp.now(),
          '213',
          'HwTR6FMDJCUaNTiNdnyECT76PEq1'),
      Apartment(
          '789 Oak Lane',
          '1800',
          '3600',
          'Modern apartment with top-notch amenities.',
          'Michael Johnson',
          ['image5.jpg', 'image6.jpg'],
          '4.8',
          'ehab@gmail.com',
          Timestamp.now(),
          '21',
          'HwTR6FMDJCUaNTiNdnyECT76PEq1'),
      Apartment(
        '101 Pine Street',
        '1300',
        '2600',
        'Charming historic apartment in the city center.',
        'Sarah Brown',
        ['image7.jpg', 'image8.jpg'],
        '4.0',
        'ehab@gmail.com',
        timestamp,
        '21e',
        'HwTR6FMDJCUaNTiNdnyECT76PEq1',
      ),
    ];

    // await FirebaseFirestore.instance
    //     .collection('liked_apartments')
    //     .add(newapartment.toMap());
  }
}
