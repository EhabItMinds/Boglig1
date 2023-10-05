import 'package:bolig/model/apartment.dart';
import 'package:bolig/services/apartment_service.dart';
import 'package:bolig/util/apartment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';

class ApartemtItemList extends StatefulWidget {
  const ApartemtItemList({super.key});

  @override
  State<ApartemtItemList> createState() => _ApartemtItemListState();
}

class _ApartemtItemListState extends State<ApartemtItemList> {
  QueryDocumentSnapshot? lastVisible;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  MatchEngine? _matchEngine;
  List<SwipeItem> swipeItems = <SwipeItem>[];
  AparrmentService apartmentService = AparrmentService();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _matchEngine = MatchEngine(swipeItems: swipeItems);

    final snapshot = await apartmentService.getApartmentsInit();

    if (snapshot.docs.isNotEmpty) {
      lastVisible = snapshot.docs.last;
      for (var apartment in snapshot.docs) {
        swipeItems.add(SwipeItem(
          content: _buildApartmetItem(apartment),
          likeAction: () {
            apartmentService.likeApartment(_buildApartmetItem(apartment));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Liked"),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            apartmentService.unLikeApartment(_buildApartmetItem(apartment));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Nope"),
              duration: Duration(milliseconds: 500),
            ));
          },
        ));
      }
      _matchEngine = MatchEngine(swipeItems: swipeItems);

      setState(() {
        lastVisible = snapshot.docs.last;
      });
    }
  }

  Future<void> _loadMoreData() async {
    swipeItems = [];
    final snapshot = await apartmentService.getApartmentsNext(lastVisible!);
    if (snapshot.docs.isNotEmpty) {
      lastVisible = snapshot.docs.last;

      for (var apartment in snapshot.docs) {
        swipeItems.add(SwipeItem(
          content: _buildApartmetItem(apartment),
          likeAction: () {
            apartmentService.likeApartment(_buildApartmetItem(apartment));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Liked"),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            apartmentService.unLikeApartment(_buildApartmetItem(apartment));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Nope"),
              duration: Duration(milliseconds: 500),
            ));
          },
        ));
      }

      setState(() {}); // Trigger a rebuild to display the new data.
      _matchEngine = MatchEngine(swipeItems: swipeItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: [
        SizedBox(
          height: 451,
          child: SwipeCards(
            matchEngine: _matchEngine!,
            onStackFinished: () {
              _loadMoreData();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Loading"),
                duration: Duration(milliseconds: 500),
              ));
            },
            itemBuilder: (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                child: ApartmentCard(
                  apartment: swipeItems[index].content,
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5, // Add a subtle elevation for a raised effect
                    shadowColor: Colors.black, // Shadow color
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32), // Button padding
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.heart_broken,
                        color: Colors.red,
                      )
                    ],
                  ),
                  onPressed: () {
                    _matchEngine!.currentItem?.nope();
                  },
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5, // Add a subtle elevation for a raised effect
                    shadowColor: Colors.black, // Shadow color
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32), // Button padding
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.blue,
                      )
                    ],
                  ),
                  onPressed: () {
                    _matchEngine!.currentItem?.superLike();
                  },
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5, // Add a subtle elevation for a raised effect
                    shadowColor: Colors.black, // Shadow color
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32), // Button padding
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.green,
                      )
                    ],
                  ),
                  onPressed: () {
                    _matchEngine!.currentItem?.like();
                  },
                ),
              ),
            ],
          ),
        )
      ]),
    );
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
