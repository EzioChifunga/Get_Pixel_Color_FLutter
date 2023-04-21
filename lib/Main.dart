import 'dart:async';
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
  // Stores the Url of the image that will be used
  final coverData =
      'https://s2.glbimg.com/h3Duok3KWVA8yaIOzZZIESkNLC4DKPsVVGWWhNMHhpNIoz-HdGixxa_8qOZvMp3w/e.glbimg.com/og/ed/f/original/2013/08/02/imagem_para_sexta_51.jpg';

  img.Image photo = img.Image(0, 0);
// The variable of type Tmage have the atributes height and width

  var Android_Graphics_Color; // Global variable of Android Graphics Color Code

  double Y = 0; //Global variable that stores the current Y of the Image
  double X = 0; // Global variable that stores the current X of the Image

  TextEditingController X_Controller = TextEditingController();
  TextEditingController Y_Controller = TextEditingController();
// Necessário para

  List<int> Rgb_Code = [
    0,
    0,
    0,
    0
  ]; // Array with integer values ​​of the RGB code

// This function add 1 at y, after call two functions _getColor and convertToRGB and show the android graphics color and the rgb code
  void update() {
    setState(() {
      _getColor();
      convertToRGB();
      print("Value of Y = $Y, Value of Y = $X");
      print("Android Graphics Color Code: $Android_Graphics_Color");
      print("RGB Code: $Rgb_Code");
    });
  }

// Convert Android_Graphics_Color to RGB codde
  void convertToRGB() {
    setState(() {
      Rgb_Code[0] = (Android_Graphics_Color >> 16) & 0xFF; // Set Code to R
      Rgb_Code[1] = (Android_Graphics_Color >> 8) & 0xFF; // Set Code to G
      Rgb_Code[2] = Android_Graphics_Color & 0xF; // Set Code to B
      Rgb_Code[3] = (Android_Graphics_Color >> 32) & 0xF; // A Set Code
    });
  }

  void setImageBytes(imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = img.decodeImage(values) ??
        img.Image(0,
            0); // assigning the decoded image or an empty Image object with width and height of 0 if decoding failed
  }

  // image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  Future<Color> _getColor() async {
    Uint8List? data;
    if (data != null) {
      // use data
    } else {
      // handle null case
    }

    try {
      data = (await NetworkAssetBundle(Uri.parse(coverData)).load(coverData))
          .buffer
          .asUint8List();
    } catch (ex) {
      print(ex.toString());
    }

    setImageBytes(data);

    //FractionalOffset(1.0, 0.0); //represents the top right of the [Size].
    double px = X;
    double py = Y;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    Android_Graphics_Color = abgrToArgb(pixel32);
    return Color(Android_Graphics_Color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Size of Image: ${photo.height},${photo.width}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "RGB Code: ${Rgb_Code[0]}, ${Rgb_Code[1]}, ${Rgb_Code[2]}, ${Rgb_Code[3]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            "X: $X, Y: $Y",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
          Spacer(),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter X Value',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: X_Controller,
            onChanged: (value) {
              if (double.tryParse(value) == null) {
                X_Controller.clear();
              }
              X = double.parse(X_Controller.text) - 1;
              update();
            },
            style: TextStyle(
              color: Color.fromARGB(255, 220, 220, 220),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter Y Value',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            controller: Y_Controller,
            onChanged: (value) {
              if (double.tryParse(value) == null) {
                Y_Controller.clear();
              }
              Y = double.parse(Y_Controller.text);
              update();
            },
            style: TextStyle(
              color: Color.fromARGB(255, 88, 88, 88),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
