
import 'package:flutter/material.dart';
import 'model/tourism_place.dart';

// Font custom untuk judul, hari, jam, dan harga
const TextStyle iniFontCustom = TextStyle(
  fontFamily: 'Staatliches',
  fontSize: 14.0,
  color: Colors.black87,
);

class DetailScreen extends StatelessWidget {
  final TourismPlace place;

  const DetailScreen({
    super.key,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            // GAMBAR UTAMA
            Stack(
              children: <Widget>[
                Image.asset(
                  place.imageAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // JUDUL TEMPAT WISATA
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              child: Text(
                place.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Staatliches',
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),

            // INFORMASI HARI, JAM DAN HARGA
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[

                  // HARI BUKA
                  Column(
                    children: <Widget>[
                      const Icon(
                        Icons.calendar_today,
                        color: Color.fromARGB(255, 34, 107, 0),
                      ),

                      const SizedBox(height: 8.0),

                      Text(
                        place.openDays,
                        style: iniFontCustom,
                      ),
                    ],
                  ),

                  // JAM OPERASIONAL
                  Column(
                    children: <Widget>[
                      const Icon(
                        Icons.access_time,
                        color: Color.fromARGB(255, 34, 107, 0),
                      ),

                      const SizedBox(height: 8.0),

                      Text(
                        place.openTime,
                        style: iniFontCustom,
                      ),
                    ],
                  ),

                  // HARGA TIKET
                  Column(
                    children: <Widget>[
                      const Icon(
                        Icons.monetization_on,
                        color: Color.fromARGB(255, 34, 107, 0),
                      ),

                      const SizedBox(height: 8.0),

                      Text(
                        place.ticketPrice,
                        style: iniFontCustom,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // DESKRIPSI TEMPAT WISATA
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                place.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Color.fromARGB(255, 84, 1, 133),
                ),
              ),
            ),

            // DAFTAR GAMBAR WISATA
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: place.imageUrls.map((url) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
