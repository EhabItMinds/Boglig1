import 'package:flutter/material.dart';

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
                  .map((accommodationFilter exercise) {
                return FilterChip(
                  label: Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  selected: accofilters.contains(exercise),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        accofilters.add(exercise);
                      } else {
                        accofilters.remove(exercise);
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
          ],
        ),
      ),
    );
  }
}
