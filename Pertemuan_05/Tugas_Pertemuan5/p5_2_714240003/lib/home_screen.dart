import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Data dummy mahasiswa
  final String namaMahasiswa = "Zahra Ramanayshilla";
  final String npmMahasiswa = "71424003";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tugas Pertemuan 5"),
         backgroundColor: const Color.fromARGB(255, 0, 103, 147),
        foregroundColor: Colors.white, // Title sesuai ketentuan
      ),
      body: Center( // Posisi konten di tengah
        child: Card( // Menggunakan widget Card
          elevation: 5,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column( // Elemen disusun vertikal
              mainAxisSize: MainAxisSize.min,
              children: [
                // Foto Profil dengan ClipRRect
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'images/profile.jpg', // Ganti Image.network jika ingin dari internet
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 150),
                  ),
                ),
                const SizedBox(height: 16),
                // Nama Mahasiswa
                Text(
                  namaMahasiswa,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // NPM
                Text(
                  npmMahasiswa,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                // Tombol Navigasi
                ElevatedButton(
                  onPressed: () {
                    // Navigasi dengan passing data ke Halaman Kedua
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          nama: namaMahasiswa,
                          npm: npmMahasiswa,
                        ),
                      ),
                    );
                  },
                  child: const Text("Lihat Detail Profil"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

