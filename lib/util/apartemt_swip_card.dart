import 'package:bolig/model/apartment.dart';
import 'package:bolig/services/apartment_service.dart';
import 'package:bolig/util/apartment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class ApartmentSwipCard extends StatefulWidget {
  const ApartmentSwipCard({super.key});

  @override
  State<ApartmentSwipCard> createState() => _ApartmentSwipCardState();
}

class _ApartmentSwipCardState extends State<ApartmentSwipCard> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  AparrmentService aparrmentService = AparrmentService();
  List<String> imagePaths = [
    'lib/images/Lejlighed1.png',
    'lib/images/Lejlighed2.png'
  ];

  @override
  void initState() {
    Apartment apartment = Apartment(
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
        'HwTR6FMDJCUaNTiNdnyECT76PEq1');

    for (int i = 0; i < 1; i++) {
      _swipeItems.add(SwipeItem(
          content: apartment,
          likeAction: () {
            aparrmentService.LikeApartment(apartment);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Liked"),
              duration: Duration(milliseconds: 500),
            ));
          },
          nopeAction: () {
            aparrmentService.unLikeApartment(apartment);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Nope"),
              duration: Duration(milliseconds: 500),
            ));
          },
          superlikeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Superliked"),
              duration: Duration(milliseconds: 500),
            ));
          },
          onSlideUpdate: (SlideRegion? region) async {
            print("Region $region");
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            child: Stack(children: [
          SizedBox(
            height: 451,
            child: SwipeCards(
              matchEngine: _matchEngine!,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  child: ApartmentCard(
                    apartment: _swipeItems[index].content,
                  ),
                );
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Stack Finished"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                print("item: ${item.content.text}, index: $index");
              },
              leftSwipeAllowed: true,
              rightSwipeAllowed: true,
              upSwipeAllowed: true,
              fillSpace: true,
              likeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: const Text('Like'),
              ),
              nopeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.red)),
                child: const Text('Nope'),
              ),
              superLikeTag: Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.orange)),
                child: const Text('Super Like'),
              ),
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
                      elevation:
                          5, // Add a subtle elevation for a raised effect
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
                      elevation:
                          5, // Add a subtle elevation for a raised effect
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
                      elevation:
                          5, // Add a subtle elevation for a raised effect
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
        ])));
  }
}
