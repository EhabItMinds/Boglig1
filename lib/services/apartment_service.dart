import 'package:bolig/model/apartment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AparrmentService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? lastvisible;

  Future<QuerySnapshot> getLikedApartments() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('liked_apartments')
        .where('senderId', isEqualTo: currentUserId)
        .get();
  }

  Future<List<Apartment>> getApartmentsQuery1() async {
    var apartments = <Apartment>[];

    // [START paginate_data_paginate_a_query]
    // Construct query for first 25 cities, ordered by population
    final first = FirebaseFirestore.instance.collection("apartments").limit(5);

    await first.get().then(
      (QuerySnapshot<Map<String, dynamic>> documentSnapshots) {
        // You can access the data in the documentSnapshots here
        // For example, you can loop through the documents like this:
        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in documentSnapshots.docs) {
          Map<String, dynamic> data = document.data();
          // Now, you can work with the 'data' Map

          apartments.add(mapping(data));
        }
      },
      onError: (e) => print("Error loading first apartments: $e"),
    );
    return apartments;
  }

  Apartment mapping(Map<String, dynamic> data) {
    Apartment apartment;
    //display all but not the curren user

    apartment = Apartment(
        data['address'],
        data['rent'],
        data['moveInPrice'],
        data['about'],
        data['tantInfo'],
        List<String>.from(data['imagePath']),
        data['renterRating'],
        data['tantEmail'],
        data['timestamp'],
        data['senderId'],
        data['reciverId']);

    return apartment;
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
        '1234 Elm Street',
        '1100',
        '2200',
        'A cozy apartment in a quiet neighborhood.',
        'Alice Johnson',
        ['image2.jpg', 'image4.jpg'], // Same image file names
        '4.7',
        'ehab@gmail.com',
        timestamp,
        '456',
        'HwTR6FMDJCUaNTiNdnyECT76PEq1', // Updated user ID
      ),
      Apartment(
        '789 Oak Avenue',
        '1600',
        '3200',
        'Modern apartment with great amenities.',
        'Robert Davis',
        ['image1.jpg', 'image3.jpg'], // Same image file names
        '4.4',
        'ehab@gmail.com',
        timestamp,
        '789',
        'HwTR6FMDJCUaNTiNdnyECT76PEq1', // Updated user ID
      ),
      Apartment(
        '1011 Maple Lane',
        '1350',
        '2700',
        'Spacious 2-bedroom apartment with a view.',
        'Emily Smith',
        ['image7.jpg', 'image8.jpg'], // Same image file names
        '4.9',
        'ehab@gmail.com',
        timestamp,
        '1011',
        'HwTR6FMDJCUaNTiNdnyECT76PEq1', // Updated user ID
      ),
      // Additional Apartments with the same image file names
      Apartment(
        '567 Pine Street',
        '1250',
        '2500',
        'A charming apartment with a garden view.',
        'David Wilson',
        ['image2.jpg', 'image4.jpg'], // Same image file names
        '4.5',
        'ehab@gmail.com',
        timestamp,
        '567',
        'HwTR6FMDJCUaNTiNdnyECT76PEq1', // Updated user ID
      ),
      Apartment(
        '890 Cedar Avenue',
        '1450',
        '2900',
        'Stylish apartment in a vibrant neighborhood.',
        'Linda Brown',
        ['image1.jpg', 'image3.jpg'], // Same image file names
        '4.3',
        'ehab@gmail.com',
        timestamp,
        '890',
        'HwTR6FMDJCUaNTiNdnyECT76PEq1', // Updated user ID
      ),
    ];

    final CollectionReference apartmentsCollection =
        FirebaseFirestore.instance.collection('apartments');

    for (var apartmentData in apartments) {
      await apartmentsCollection.add(apartmentData.toMap());
    }

    print('Apartments added to Firestore');
  }
}
