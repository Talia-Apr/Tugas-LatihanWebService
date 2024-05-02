// Import pustaka dart:convert yang berisi fungsi-fungsi untuk mengubah objek Dart menjadi format JSON dan sebaliknya.
import 'dart:convert';

// Deklarasi fungsi main() yang merupakan entry point dari program Dart.
void main() {
  // JSON transkrip mahasiswa dalam bentuk string.
  String dataTranskrip='''
  {
    "mahasiswa": {
      "nama": "Talia Aprianti",
      "nim": "22082010035",
      "mata_kuliah": [
        {
          "kode": "IF101",
          "nama": "Statistik Komputer",
          "sks": 3,
          "nilai": "B+"
        },
        {
          "kode": "IF102",
          "nama": "Pemrograman Web",
          "sks": 3,
          "nilai": "A"
        },
        {
          "kode": "IF103",
          "nama": "Pemrograman Mobile",
          "sks": 3,
          "nilai": "A-"
        }
      ]
    }
  }
  ''';

  // Mengubah string JSON dataJson menjadi objek Dart menggunakan fungsi jsonDecode().
  Map<String, dynamic> data = jsonDecode(dataTranskrip);

  // Deklarasi variabel totalSks dan totalBobot untuk menyimpan total SKS dan total bobot nilai.
  double totalSks = 0;
  double totalBobot = 0;

  // Pengulangan for untuk setiap mata kuliah dalam transkrip mahasiswa.
  for (var matkul in data['mahasiswa']['mata_kuliah']) {
    // Mengambil nilai SKS dan nilai huruf dari setiap mata kuliah.
    double sks = matkul['sks'].toDouble();
    String nilai = matkul['nilai'];

    // Mengonversi nilai huruf ke bobot nilai sesuai standar pengkonversian.
    double bobot;
    switch (nilai) {
      case 'A':
        bobot = 4.0;
        break;
      case 'A-':
        bobot = 3.75;
        break;
      case 'B+':
        bobot = 3.5;
        break;
      case 'B':
        bobot = 3.0;
        break;
      case 'B-':
        bobot = 2.75;
        break;
      case 'C+':
        bobot = 2.5;
        break;
      case 'C':
        bobot = 2.0;
        break;
      case 'D':
        bobot = 1.0;
        break;
      default:
        bobot = 0.0;
        break;
    }

    // Menambahkan SKS ke total SKS dan menambahkan bobot nilai ke total bobot nilai.
    totalSks += sks;
    totalBobot += sks * bobot;
  }

  // Menghitung IPK dengan membagi total bobot nilai dengan total SKS.
  double ipk = totalBobot / totalSks;

  // Menampilkan nilai IPK ke layar.
  print('IPK: $ipk');
}
