import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:slide_to_act/slide_to_act.dart';

/// Flutter code sample for [FilterChip].

enum accommodationFilter { Apartment, House, Room }

enum accommodationCityFilter { Aarhus, Copenhagen, Odense, Aalborg }

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Set<accommodationFilter> accofilters = <accommodationFilter>{};
  Set<accommodationCityFilter> ciryfilters = <accommodationCityFilter>{};
  bool value = false;
  Future<void> refreshData() async {
    setState(() {
      value = true;
    }); // Thi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const Text(
              'Choose an accommodation: ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            Wrap(
              spacing: 10.0,
              children: accommodationFilter.values
                  .map((accommodationFilter accommodation) {
                return FilterChip(
                  label: Text(
                    accommodation.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  selected: accofilters.contains(accommodation),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        accofilters.add(accommodation);
                      } else {
                        accofilters.remove(accommodation);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "City:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),
            Wrap(
              spacing: 10.0,
              children: accommodationCityFilter.values
                  .map((accommodationCityFilter city) {
                return FilterChip(
                  label: Text(
                    city.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  selected: ciryfilters.contains(city),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        ciryfilters.add(city);
                      } else {
                        ciryfilters.remove(city);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10.0),
            Text(
                'Looking for: ${accofilters.map((accommodationFilter e) => e.name).join(', ')} ${ciryfilters.map((accommodationCityFilter e) => e.name).join(', ')} '),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SlideAction(
                  borderRadius: 40,
                  elevation: 0,
                  innerColor: Colors.deepPurple,
                  outerColor: Colors.deepPurple[200],
                  sliderButtonIcon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  text: 'Slide to filter',
                  sliderRotate: false,
                  onSubmit: () {
                    for (var acc in accofilters) {
                      print(acc.name);
                    }
                    for (var city in ciryfilters) {
                      print(city.name);
                    }
                    accofilters.clear();
                    ciryfilters.clear();
                    refreshData();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
