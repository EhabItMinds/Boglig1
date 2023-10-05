import 'package:bolig/model/apartment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AparrmentService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<QuerySnapshot> getLikedApartments() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('liked_apartments')
        .where('senderId', isEqualTo: currentUserId)
        .get();
  }

  Future<QuerySnapshot> getApartmentsInit() async {
    return FirebaseFirestore.instance.collection("apartments").limit(5).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getApartmentsNext(
      QueryDocumentSnapshot lastVisible) async {
    final query = FirebaseFirestore.instance
        .collection("apartments")
        .startAfterDocument(lastVisible)
        .limit(5);

    final snapshot = await query.get();

    return snapshot;
  }

  Future<void> likeApartment(Apartment apartment) async {
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
    final Timestamp timestamp = Timestamp.now();

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
