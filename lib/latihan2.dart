// Import package flutter/material.dart yang berisi widget-widget 
import 'package:flutter/material.dart'; 
// Import package http untuk melakukan HTTP requests
import 'package:http/http.dart' as http; 
// Import package convert untuk mengubah data ke format JSON
import 'dart:convert'; 

void main() {
  // Menjalankan aplikasi dengan widget MyApp sebagai root
  runApp(const MyApp()); 
}

class Activity {
  String aktivitas;
  String jenis;

  // Constructor Activity
  Activity({required this.aktivitas, required this.jenis}); 

  // Factory method untuk membuat objek Activity dari JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // Variabel untuk menampung hasil pemanggilan API
  late Future<Activity> futureActivity; 
  // URL endpoint API
  String url = "https://www.boredapi.com/api/activity"; 

  // Fungsi untuk inisialisasi nilai awal futureActivity
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  // Fungsi untuk melakukan pemanggilan API dan mengambil data
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Mengembalikan objek Activity dari JSON
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // Jika gagal, lempar exception
      throw Exception('Gagal load');
    }
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi futureActivity
    futureActivity = init(); 
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan tulisan debug
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Rekomendasi Aktivitas',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Pusatkan judul appbar
          centerTitle: true, 
          // Warna latar belakang appbar
          backgroundColor: const Color.fromARGB(255, 255, 140, 57), 
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // Tombol untuk melakukan pemanggilan API
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Memanggil fetchData saat tombol ditekan
                    futureActivity = fetchData(); 
                  });
                },
                style: ElevatedButton.styleFrom(
                  // Warna tombol
                  backgroundColor: const Color.fromARGB(255, 255, 170, 109),
                ),
                child: const Text(
                  "What should I do ...",
                  style: TextStyle(
                    // Warna teks
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Menampilkan aktivitas yang diambil dari API
            FutureBuilder<Activity>(
              future: futureActivity,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.data!.aktivitas,
                          style: const TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.black, 
                          ),
                        ),
                        Text(
                          "Jenis: ${snapshot.data!.jenis}",
                          style: const TextStyle(
                            fontSize: 13, 
                            color: Color.fromARGB(255, 111, 111, 111), 
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // Loading spinner jika sedang memuat data
                return const CircularProgressIndicator();
              },
            ),

          ]),
        ),
      ),
    );
  }
}
