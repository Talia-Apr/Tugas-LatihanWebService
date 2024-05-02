// Import package flutter/material.dart yang berisi widget-widget 
// untuk Material Design
import 'package:flutter/material.dart'; 

// Import package http untuk melakukan HTTP requests
import 'package:http/http.dart' as http; 

// Import package convert untuk mengubah data ke format JSON
import 'dart:convert'; 

// Import package url_launcher untuk membuka URL di browser
import 'package:url_launcher/url_launcher.dart';

// Fungsi main() yang menjalankan aplikasi Flutter
void main() {
  runApp(const MyApp()); 
}

// Class University untuk merepresentasikan data universitas
class University {
  String name;
  String website;

  // Constructor University
  University({required this.name, required this.website});

  // Factory method untuk membuat objek University dari JSON
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'][0],
    );
  }
}

// Class MyApp sebagai root widget aplikasi
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan tulisan debug
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        // AppBar aplikasi
        appBar: AppBar(
          title: const Text(
            // Judul AppBar
            'Universities in Indonesia', 
            style: TextStyle(
              // Warna teks judul AppBar
              color: Colors.white, 
              // Ketebalan teks judul AppBar
              fontWeight: FontWeight.bold, 
            ),
          ),
          // Pusatkan judul AppBar
          centerTitle: true, 
          // Warna latar belakang AppBar
          backgroundColor: const Color.fromARGB(255, 0, 128, 255), 
        ),
          // Membuat FutureBuilder untuk menampilkan data universitas
        body: FutureBuilder<List<University>>(
          // Future untuk mendapatkan data universitas dari API
          future: fetchUniversities(), 
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // Card untuk menampilkan informasi universitas
                  return Card(
                    // Elevasi Card
                    elevation: 2, 
                    // Margin Card
                    margin: const EdgeInsets.all(5), 
                    child: ListTile(
                      // Judul universitas
                      title: Text(snapshot.data![index].name), 
                      // Website universitas
                      subtitle: Text(snapshot.data![index].website), 
                      onTap: () {
                        // Menggunakan URL Launcher untuk 
                        // membuka website universitas
                        launchURL(snapshot.data![index].website); 
                      },
                      // Icon untuk membuka browser
                      trailing: const Icon(Icons.school_rounded), 
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                // Menampilkan pesan error jika terjadi
                child: Text('Error: ${snapshot.error}'), 
              );
            }
            return const Center(
              // Menampilkan indikator loading
              child: CircularProgressIndicator(), 
            );
          },
        ),
      ),
    );
  }

  // Fungsi untuk mengambil data universitas dari API
  Future<List<University>> fetchUniversities() async {
    final response = await http.get(Uri.parse(
      'http://universities.hipolabs.com/search?country=Indonesia'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<University> universities = [];
      for (var item in data) {
        universities.add(University.fromJson(item));
      }
      return universities;
    } else {
      throw Exception('Failed to load universities');
    }
  }

  // Fungsi untuk membuka URL di browser
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
