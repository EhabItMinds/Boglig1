import 'package:bolig/Pages/ApartmentPage/apartment_more_info.dart';
import 'package:bolig/model/apartment.dart';
import 'package:flutter/material.dart';

class ApartmentCard extends StatefulWidget {
  final Apartment apartment;
  ApartmentCard({super.key, required this.apartment});

  @override
  State<ApartmentCard> createState() => _ApartmentCardState();
}

class _ApartmentCardState extends State<ApartmentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApartmentMoreInfo(
              apartment: widget.apartment,
              loved: false,
            ),
          ),
        );
      },
      child: Container(
        width: 320,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.green),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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

            //apartment pic

            const SizedBox(
              height: 2,
            ),
            // Adress
            Text(
              widget.apartment.address,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 5,
            ),
            //pris
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('Move in price'),
                      Text(widget.apartment.moveInPrice + ' kr'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Rent'),
                      Text(widget.apartment.rent + ' kr'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Tant info'),
                      Text(widget.apartment.tantInfo),
                    ],
                  ),
                ],
              ),
            )

            //button like
          ],
        ),
      ),
    );
  }
}
