import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiProfilSederhana());
}

class AplikasiProfilSederhana extends StatelessWidget {
  const AplikasiProfilSederhana({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFCFD),
        appBar: AppBar(
          title: const Text('Kartu Profil Siswa'),
          backgroundColor: const Color(0xFFFCE4EC),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 80,
                color: Color(0xFFF48FB1),
              ),

              const SizedBox(height: 16),

              const Text(
                'Henik Rindotul Janah',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD81B60),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Siswa XII RPL A',
                style: TextStyle(
                  color: Color.fromRGBO(173, 20, 87, 1),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF8BBD0),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sapa Siswa'),
              ),

              const SizedBox(height: 10),

              const Text(
                'Belajar hari ini, sukses di masa depan!',
                style: TextStyle(
                  color: Color(0xFFC2185B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}