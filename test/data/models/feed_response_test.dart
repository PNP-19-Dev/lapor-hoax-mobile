import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/data/models/feed_response.dart';

import '../../json_reader.dart';

void main() {
  final tFeedModel = FeedModel(
      id: 26,
      title: "Libur Maulid Nabi 2021 Digeser: Tanggal dan Alasannya",
      content:
          "<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\"><span style=\"font-size: 12.0pt; font-family: 'Times New Roman', serif;\">Jakarta - Libur Maulid Nabi 2021 telah ditetapkan pemerintah. Namun libur Maulid Nabi tahun ini mengalami perubahan dan tidak sesuai dengan kalender sebelumnya.<br /><br />\"Pemerintah memutuskan untuk mengubah dua hari libur nasional dan meniadakan satu hari libur cuti bersama,\" ucap Menko PMK Muhadjir Effendy dalam konferensi pers beberapa waktu lalu.<br /><br />Kalau sebelumnya libur Maulid Nabi 2021 ditetapkan tanggal 19 Oktober 2021, kini digeser menjadi tanggal 20 Oktober 2021. Lantas, apa alasan pemerintah menggeser libur Maulid Nabi tahun ini? Mari simak penjelasan berikut ini. Hari Ini Tanggal Merah atau Tidak? Simak Lagi SKB Terbaru.</span></p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\">&nbsp;</p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\"><span style=\"font-size: 12.0pt; font-family: 'Times New Roman', serif;\"><br /><strong>Libur Maulid Nabi 2021: Sudah Diatur Dalam SKB</strong><br /><br />Perubahan libur Maulid Nabi 2021 sudah diatur dalam Surat Keputusan Bersama (SKB) Menteri Agama, Menteri Ketenagakerjaan dan Menteri Pendayagunaan Aparatur Negara dan Reformasi Birokrasi. Dari SKB itu, ada 3 perubahan pada libur nasional dan cuti bersama pada tahun ini.<br /><br />Berdasarkan SKB tersebut, terlihat ada ada 3 poin perubahan yang terjadi pada libur nasional dan cuti bersama pada 2021. Salah satu yang mengalami perubahan yakni libur Maulid Nabi 2021.<br /><br />Dengan digesernya libur Maulid Nabi 2021, tanggal merah pada bulan Oktober 2021 hanya berlangsung 1 hari, yakni tanggal 20 Oktober 2021. Perubahan hari libur nasional bukan pertama kalinya direvisi pemerintah. Sebelumnya, hari libur tahun baru Islam 1443 H yang awalnya jatuh pada 10 Agustus 2021, diubah menjadi Rabu 11 Agustus 2021.<br /><br />Bukan hanya libur Maulid Nabi 2021, dalam SKB itu pemerintah juga merevisi libur dan cuti bersama Natal 2021. Semula, hari libur dan cuti bersama Natal jatuh pada tanggal 24 Desember 2021. Namun, tahun ini hari libur cuti bersama Natal ditiadakan.</span></p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\">&nbsp;</p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\">&nbsp;</p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\"><span style=\"font-size: 12.0pt; font-family: 'Times New Roman', serif;\"><strong>Libur Maulid Nabi 2021: Antisipasi Klaster Baru COVID-19</strong><br /><br />Digesernya libur Maulid Nabi 2021 didasari karena beberapa alasan, salah satunya pemerintah hendak mengantisipasi klaster baru COVID-19. Meski hari libur Maulid Nabi digeser, namun peringatannya tetap jatuh pada tanggal 12 Rabiul Awal.<br /><br />\"Sebagai antisipasi munculnya kasus baru Covid-19, hari libur Maulid Nabi digeser 20 Oktober 2021. Maulid Nabi Muhammad Saw tetap 12 Rabiul Awal. Tahun ini bertepatan 19 Oktober 2021 M. Hari libur peringatannya yang digeser menjadi 20 Oktober 2021 M,\" ujar Dirjen Bimas Islam Kamaruddin Amin sebagaimana dikutip dari laman resmi Kemenag.<br /><br />Menteri Agama Yaqut Cholil Qoumas menambahkan, perubahan libur Maulid Nabi 2021 mempertimbangkan kondisi dan situasi COVID-19. Ke depan, Kemenag bersama dua Menteri lainnya bakal menentukan cuti bersama 2022.<br /><br />\"Pelaksanaan cuti bersama tahun 2022 akan ditetapkan kemudian dengan mempertimbangkan kondisi pandemi COVID-19,\" bunyi poin keempat di SKB 3 menteri tersebut.</span></p>\r\n<p style=\"text-align: justify; margin: 0in 0in 10pt; line-height: 115%; font-size: 11pt; font-family: Calibri, sans-serif;\">&nbsp;</p>",
      thumbnail:
          "https://django-lapor-hoax.s3.amazonaws.com/feeds/1.jpeg?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=yXthBiGVfwxxC%2Flai%2FvL0PZAMz4%3D&Expires=1634826461",
      date: "2021-10-13T01:34:58.831621+07:00",
      view: 0,
      author: 1);

  final tFeedResponseModel = FeedResponse(
    count: 1,
    next: "null",
    previous: "null",
    feedList: [tFeedModel],
  );

  group('from json', () {
    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/feed.json'));
      // act
      final result = FeedResponse.fromJson(jsonMap);
      // assert
      expect(result, tFeedResponseModel);
    });
  });

  group('to json', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tFeedResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "count": 1,
        "next": "null",
        "previous": "null",
        "results": [
          {
            "id": 26,
            "title": "Libur Maulid Nabi 2021 Digeser: Tanggal dan Alasannya",
            "content":
                "<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\"><span style=\"font-size: 12.0pt; font-family: 'Times New Roman', serif;\">Jakarta - Libur Maulid Nabi 2021 telah ditetapkan pemerintah. Namun libur Maulid Nabi tahun ini mengalami perubahan dan tidak sesuai dengan kalender sebelumnya.<br /><br />\"Pemerintah memutuskan untuk mengubah dua hari libur nasional dan meniadakan satu hari libur cuti bersama,\" ucap Menko PMK Muhadjir Effendy dalam konferensi pers beberapa waktu lalu.<br /><br />Kalau sebelumnya libur Maulid Nabi 2021 ditetapkan tanggal 19 Oktober 2021, kini digeser menjadi tanggal 20 Oktober 2021. Lantas, apa alasan pemerintah menggeser libur Maulid Nabi tahun ini? Mari simak penjelasan berikut ini. Hari Ini Tanggal Merah atau Tidak? Simak Lagi SKB Terbaru.</span></p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\">&nbsp;</p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\"><span style=\"font-size: 12.0pt; font-family: 'Times New Roman', serif;\"><br /><strong>Libur Maulid Nabi 2021: Sudah Diatur Dalam SKB</strong><br /><br />Perubahan libur Maulid Nabi 2021 sudah diatur dalam Surat Keputusan Bersama (SKB) Menteri Agama, Menteri Ketenagakerjaan dan Menteri Pendayagunaan Aparatur Negara dan Reformasi Birokrasi. Dari SKB itu, ada 3 perubahan pada libur nasional dan cuti bersama pada tahun ini.<br /><br />Berdasarkan SKB tersebut, terlihat ada ada 3 poin perubahan yang terjadi pada libur nasional dan cuti bersama pada 2021. Salah satu yang mengalami perubahan yakni libur Maulid Nabi 2021.<br /><br />Dengan digesernya libur Maulid Nabi 2021, tanggal merah pada bulan Oktober 2021 hanya berlangsung 1 hari, yakni tanggal 20 Oktober 2021. Perubahan hari libur nasional bukan pertama kalinya direvisi pemerintah. Sebelumnya, hari libur tahun baru Islam 1443 H yang awalnya jatuh pada 10 Agustus 2021, diubah menjadi Rabu 11 Agustus 2021.<br /><br />Bukan hanya libur Maulid Nabi 2021, dalam SKB itu pemerintah juga merevisi libur dan cuti bersama Natal 2021. Semula, hari libur dan cuti bersama Natal jatuh pada tanggal 24 Desember 2021. Namun, tahun ini hari libur cuti bersama Natal ditiadakan.</span></p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\">&nbsp;</p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\">&nbsp;</p>\r\n<p style=\"margin: 0in; text-align: justify; line-height: normal; font-size: 11pt; font-family: Calibri, sans-serif;\"><span style=\"font-size: 12.0pt; font-family: 'Times New Roman', serif;\"><strong>Libur Maulid Nabi 2021: Antisipasi Klaster Baru COVID-19</strong><br /><br />Digesernya libur Maulid Nabi 2021 didasari karena beberapa alasan, salah satunya pemerintah hendak mengantisipasi klaster baru COVID-19. Meski hari libur Maulid Nabi digeser, namun peringatannya tetap jatuh pada tanggal 12 Rabiul Awal.<br /><br />\"Sebagai antisipasi munculnya kasus baru Covid-19, hari libur Maulid Nabi digeser 20 Oktober 2021. Maulid Nabi Muhammad Saw tetap 12 Rabiul Awal. Tahun ini bertepatan 19 Oktober 2021 M. Hari libur peringatannya yang digeser menjadi 20 Oktober 2021 M,\" ujar Dirjen Bimas Islam Kamaruddin Amin sebagaimana dikutip dari laman resmi Kemenag.<br /><br />Menteri Agama Yaqut Cholil Qoumas menambahkan, perubahan libur Maulid Nabi 2021 mempertimbangkan kondisi dan situasi COVID-19. Ke depan, Kemenag bersama dua Menteri lainnya bakal menentukan cuti bersama 2022.<br /><br />\"Pelaksanaan cuti bersama tahun 2022 akan ditetapkan kemudian dengan mempertimbangkan kondisi pandemi COVID-19,\" bunyi poin keempat di SKB 3 menteri tersebut.</span></p>\r\n<p style=\"text-align: justify; margin: 0in 0in 10pt; line-height: 115%; font-size: 11pt; font-family: Calibri, sans-serif;\">&nbsp;</p>",
            "thumbnail":
                "https://django-lapor-hoax.s3.amazonaws.com/feeds/1.jpeg?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=yXthBiGVfwxxC%2Flai%2FvL0PZAMz4%3D&Expires=1634826461",
            "date": "2021-10-13T01:34:58.831621+07:00",
            "view": 0,
            "author": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
