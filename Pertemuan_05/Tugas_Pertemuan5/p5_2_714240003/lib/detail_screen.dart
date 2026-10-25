import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String nama;
  final String npm;

  // Constructor untuk menerima passing data
  const DetailScreen({super.key, required this.nama, required this.npm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Profil"),
        backgroundColor: const Color.fromARGB(255, 0, 103, 147),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan kembali Nama dan NPM
            Text(
              nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "NPM: $npm",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Deskripsi Singkat
            const Text(
              "Saya memiliki minat dalam bidang teknologi, pengembangan aplikasi, desain UI/UX, serta komunikasi dan manajemen organisasi. Saya senang mengeksplorasi hal-hal baru, mengembangkan ide kreatif, terlibat dalam kegiatan kepanitiaan, dan berkolaborasi dalam tim. Saya juga memiliki ketertarikan pada pembuatan konten digital sebagai sarana untuk mengasah kreativitas dan keterampilan komunikasi.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gallery Aktivitas:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Horizontal ListView (Gallery Aktivitas)
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const AlwaysScrollableScrollPhysics(), // Efek scroll
                children: [
                  _buildGalleryItem('images/activity1.jpg'),
                  _buildGalleryItem('images/activity2.jpg'),
                  _buildGalleryItem('images/activity3.jpg'),
                ],
              ),
            ),
            const Spacer(),
            // Tombol Kembali
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman utama
                },
                child: const Text("Kembali"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryItem(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath,
          width: 250, 
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 250, 
            color: Colors.grey[300],
            child: const Icon(Icons.image, size: 50),
          ),
        ),
      ),
    );
  }
}
