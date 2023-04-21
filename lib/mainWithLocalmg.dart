import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(home: ColorDetect()));
}

class ColorDetect extends StatefulWidget {
  @override
  _ColorDetectState createState() => _ColorDetectState();
}

class _ColorDetectState extends State<ColorDetect> {
  final coverData =
      'https://inglesnoteclado.com.br/wp-content/uploads/2016/04/Cores-em-Ingl%C3%AAs-lista-das-cores-em-Ingl%C3%AAs.jpg';

  img.Image photo = img.Image(0, 0);
  double num = 10;

  void add() {
    num += 10;
    print('número $num');
  }

  void setImageBytes(imageBytes) {
    //print("setImageBytes");
    List<int> values = imageBytes.buffer.asUint8List();
    photo = img.decodeImage(values) ??
        img.Image(0,
            0); // assigning the decoded image or an empty Image object with width and height of 0 if decoding failed
  }

  // image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
  int abgrToArgb(int argbColor) {
    //print("abgrToArgb");
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  Future<Color> _getColor() async {
    // print("_getColor");
    Uint8List? data;
    if (data != null) {
      // use data
    } else {
      // handle null case
    }

    try {
      data = (await rootBundle.load('assets/images/Foto1.jpg'))
          .buffer
          .asUint8List();
    } catch (ex) {
      // print(ex.toString());
    }

    // Or any other way to get a File instance.
    var img = await rootBundle.load('assets/images/Foto1.jpg');
    var decodedImage = await decodeImageFromList(img.buffer.asUint8List());
    int imgWidth = decodedImage.width;
    int imgHeight = decodedImage.height;

    print('x $imgWidth y $imgHeight');

    //print("setImageBytes....");
    setImageBytes(data);

    //FractionalOffset(1.0, 0.0); //represents the top right of the [Size].

    double px = .0;
    double py = num;
    int x = 0;
    for (int i = 0; i < 5; i++) {
      int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
      int hex = abgrToArgb(pixel32);

      print('posição $py cor $hex');
      py += 2;
      add;
    }
    ;

    return Color(x);
  }

  @override
  Widget build(BuildContext context) {
    // print("build");

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(coverData),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: FutureBuilder(
              future: _getColor(),
              builder: (_, AsyncSnapshot<Color> data) {
                if (data.connectionState == ConnectionState.done) {
                  return Container(
                    color: data.data,
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    padding: EdgeInsets.all(15.0),
                    color: Colors.grey,
                    child: Text("Get Sizes"),
                    onPressed: add),
                MaterialButton(
                  elevation: 5.0,
                  color: Colors.grey,
                  padding: EdgeInsets.all(15.0),
                  child: Text("Get Positions"),
                  onPressed: _getColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
