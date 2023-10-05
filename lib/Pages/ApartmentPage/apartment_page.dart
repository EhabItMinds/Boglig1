import 'package:bolig/util/apartmet_item_list.dart';
import 'package:flutter/material.dart';

class ApartmentPage extends StatefulWidget {
  const ApartmentPage({super.key});

  @override
  State<ApartmentPage> createState() => _ApartmentPageState();
}

class _ApartmentPageState extends State<ApartmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
//message

        Text('Find your dream apartment', style: TextStyle(fontSize: 20)),

//picks
// arbejde med den her
        SizedBox(height: 525, width: 600, child: ApartemtItemList()),

        Padding(
          padding: EdgeInsets.only(top: 2),
          child: Divider(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
