import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
    ));
class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   List _outputs;
   File _image; 
  bool _loading = false; 
  
  @override
  void initState(){
    super.initState;
    _loading= true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animal Scanner"),
      ),
      body: _loading
      ? Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      )
      : Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image==null? Container() : Image.file(_image),
            const SizedBox(height: 20),
            _outputs != null 
            ? Text(
              "${_outputs[0]["label"]}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                background: Paint()..color = Colors.white
              ),
            )
            :Container()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: pickImage,
      child: const Icon(Icons.image),),
    );
  }

  pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults : 2,
      threshold : 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false; 
    _outputs= output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(model: ,labels: );
  }

  @override dispose(){
    Tflite.close();
    super.dispose();
  }
}