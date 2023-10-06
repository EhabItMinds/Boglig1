import 'package:bolig/Pages/ApartmentPage/apartment_more_info.dart';
import 'package:bolig/model/apartment.dart';
import 'package:bolig/services/apartment_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteApsrtmentPage extends StatefulWidget {
  const FavoriteApsrtmentPage({super.key});

  @override
  State<FavoriteApsrtmentPage> createState() => _FavoriteApsrtmentPageState();
}

class _FavoriteApsrtmentPageState extends State<FavoriteApsrtmentPage> {
  bool value = false;
  Future<void> refreshData() async {
    setState(() {
      value = true;
    }); // This will trigger a rebuild of the widget
  }

  final AparrmentService apartmentService = AparrmentService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text(
            'Favorits',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 10,
          ),
          RefreshIndicator(
            onRefresh: refreshData,
            child: SizedBox(
              height: 500,
              child: _buildApartmentList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApartmentList() {
    return FutureBuilder<QuerySnapshot>(
      future: apartmentService.getLikedApartments(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) {
            return Dismissible(
              key: Key(doc.id), // Use a unique key for each item
              onDismissed: (direction) {
                apartmentService.unLikeApartment(_buildApartmetItem(doc));
              },
              background: Container(
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: _buildUserListItem(doc),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //display all but not the curren user
    if (data.isNotEmpty) {
      Apartment apartment = Apartment(
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
      return ListTile(
        leading: SizedBox(
          width: 80, // Set a fixed width for the image container
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
                8), // Optional: Add rounded corners to the image
            child: Image.asset(
              data['imagePath'][0],
              fit: BoxFit
                  .cover, // Optional: Adjust the image fit to cover the container
            ),
          ),
        ),
        title: Text(
          data['address'],
          style: const TextStyle(
            fontSize: 18, // Increase the font size for the title
            fontWeight: FontWeight.bold, // Add bold style to the title
          ),
        ),
        subtitle: Text(
          'Rent: \$${data['rent']}', // Assuming rent is in dollars, format it as currency
          style: const TextStyle(
            fontSize: 14, // Adjust the font size for the subtitle
            color: Colors.grey, // Use a grey color for the subtitle
          ),
        ),
        onTap: () async {
          String refresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApartmentMoreInfo(
                apartment: apartment,
                loved: true,
              ),
            ),
          );
          if (refresh == 'refresh') {
            refreshData();
          }
        },
      );
    } else {
      return Container();
    }
  }

  Apartment _buildApartmetItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    Apartment apartment = Apartment(
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
}
