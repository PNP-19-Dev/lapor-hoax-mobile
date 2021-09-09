import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporhoax/ui/history_page.dart';

class LaporPage extends StatefulWidget {
  @override
  _LaporPageState createState() => _LaporPageState();
}

class _LaporPageState extends State<LaporPage> {
  var selectedCategory;
  bool anonim = false;
  XFile? _image;

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  List categories = [
    "Category 1",
    "Category 2",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lapor',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Laporkan hoax, pornography, penipuan digital',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: getImage,
                  child: Text('Inp. Gambar'),
                ),
                SizedBox(width: 8),
                Text(_image == null ? 'Sertakan Screenshoot' : _image!.name),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: 'URL / Link (optional)', icon: Icon(Icons.link)),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.borderAll),
                SizedBox(width: 20),
                DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Category'),
                  value: selectedCategory,
                  items: categories.map((value) {
                    return DropdownMenuItem<String>(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedCategory = v!;
                    });
                  },
                ),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Checkbox(
                  onChanged: (bool? value) {
                    setState(() {
                      anonim = value!;
                    });
                  },
                  value: anonim,
                ),
                Text('Lapor Secara Anonim'),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Lapor'),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, HistoryPage.routeName),
              child: Center(
                  child: Text(
                'Lihat riwayat pelaporan',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
