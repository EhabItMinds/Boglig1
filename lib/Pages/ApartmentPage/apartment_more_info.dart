import 'package:bolig/Pages/ApartmentPage/favorite_apartment_page.dart';
import 'package:bolig/Pages/Chat/chate_page.dart';
import 'package:bolig/model/apartment.dart';
import 'package:bolig/services/apartment_service.dart';
import 'package:bolig/theme/theme_provioder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ApartmentMoreInfo extends StatefulWidget {
  final Apartment apartment;
  final bool loved;
  const ApartmentMoreInfo({
    super.key,
    required this.apartment,
    required this.loved,
  });

  @override
  State<ApartmentMoreInfo> createState() => _ApartmentMoreInfoState();
}

class _ApartmentMoreInfoState extends State<ApartmentMoreInfo> {
  AparrmentService aparrmentService = AparrmentService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.apartment.address,
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Provider.of<ThemeProvider>(context).dark
            ? Colors.white
            : Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            // Define your custom back button functionality here
            // For example, you can navigate back to a specific route or perform some other action.
            Navigator.pop(context, 'refresh');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // List view of the apartmet
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView(
                children: [
                  //images
                  SizedBox(
                    height: 350,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.apartment.imagePath.length,
                      itemBuilder: (context, index) {
                        // You should return a widget here, not define children
                        final imagePath = widget.apartment.imagePath[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(imagePath),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //rating
                  Row(
                    children: [
                      //star icon
                      Icon(Icons.star, color: Colors.yellow[800]),

                      const SizedBox(
                        width: 10,
                      ),
                      //rating number
                      Text(widget.apartment.renterRating,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //adress
                  Text(
                    widget.apartment.address,
                    style: GoogleFonts.dmSerifDisplay(fontSize: 21),
                  ),

                  const SizedBox(
                    height: 18,
                  ),
                  //about
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    widget.apartment.about,
                    style: const TextStyle(height: 2, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 15, 98, 6),
            padding: const EdgeInsets.all(25),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.apartment.rent} kr a month",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  (widget.loved)
                      ? Row(children: [
                          IconButton(
                            onPressed: () async {
                              await aparrmentService
                                  .unLikeApartment(widget.apartment);
                              Navigator.pop(context, 'refresh');
                            },
                            icon: const Icon(
                              Icons.heart_broken,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatePage(
                                    receiverUserEmail:
                                        widget.apartment.tantEmail,
                                    resiveruserid: widget.apartment.reciverId,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.message,
                              color: Colors.blue,
                              size: 35,
                            ),
                          ),
                        ])
                      : IconButton(
                          onPressed: () {
                            aparrmentService.LikeApartment(widget.apartment);
                          },
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 35,
                          ),
                        )
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
