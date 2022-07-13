/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hashids2/hashids2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:fluttertoast/fluttertoast.dart';



/// This is the screen that you'll see when the app starts
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey _globalKey = GlobalKey();

  static var hashids = HashIds(
    salt: 'this is my salt',
    minHashLength: 8,
    alphabet: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
  );


  //Create a text controller and use this to retrieve the current value of the TextField
  final numbersTextController = TextEditingController();
  late StatefulWidget qrFutureBuilder;
  //codes added on 2022-07-07
  late QrPainter qrPainter;

   var message ="";


  static List<int> intList = [999999,99999];


 static var id = hashids.encode(intList);
 static var numbers = hashids.decode(id);
  /*  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)
    );
  }

 Future<void> saveQrImage() async {
   
    final pictureData=await qrPainter.toImageData(2048, format: ui.ImageByteFormat.png);

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$tempPath/$ts.png';

    await writeToFile(pictureData!, path);

  }*/
  //codes added on 2022-07-12

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print('path ${path}');
    return File('$path/bsg_image.jpg');
  }

  Future<int> deleteFile() async {

    try {
      final file = await _localFile;

      await file.delete();
      return 0;
    } catch (e) {
      return -1;
    }


  }




  Future<void> saveToGallery(String theMessage) async{
    imageCache.clear();
    ByteData? pictureData1=await qrPainter .toImageData(2048, format: ui.ImageByteFormat.png);
    ByteData? pictureData=await qrPainter .toImageData(2048, format: ui.ImageByteFormat.png);
    var pngBytes = pictureData?.buffer.asUint8List();
    //var byteData = await qrPainter.toImageData(2048,format:ui);
    String picturesPath = "bsg_image.jpg";
    String partName=getDateTimeString(DateTime.now());
    picturesPath=partName+"bsg_image.jpg";

    await SaverGallery.saveImage(
        pngBytes!,
        quality: 60,
        name: picturesPath,
        androidRelativePath: "Pictures/");
    _toastInfo(theMessage);
  }
  Future<void> _toastInfo(String info) async {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  String getDateTimeString(DateTime theDateTime){
    String result="";
    String yearString = theDateTime.year.toString();
    String monthString = theDateTime.month.toString();
    String dayString = theDateTime.day.toString();
    String hourString = theDateTime.hour.toString();
    String minuteString = theDateTime.minute.toString();
    String secondString = theDateTime.second.toString();

    result=yearString+"-"+monthString+"-"+dayString+"_"+hourString+"-"+minuteString+"-"+secondString+"_";
    return result;
  }

  void updateImage() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;

      //intList=inputNumbers;
      id = hashids.encode(intList);
      numbers = hashids.decode(id);
      message =id;
      qrFutureBuilder = FutureBuilder<ui.Image>(
        future: _loadOverlayImage(),
        builder: (ctx, snapshot) {
          final size = 180.0;
          if (!snapshot.hasData) {
            return Container(width: size, height: size);
          }
          return  CustomPaint(
            size: Size.square(size),
            painter: qrPainter=QrPainter(
              data: message,
              version: QrVersions.auto,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xff128760),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: Color(0xff1a5441),
              ),
              // size: 320.0,
              embeddedImage: snapshot.data,
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size.square(1),
              ),
            ),
          );
        },
      );


    });

  }
  void _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  @override
  void initState() {
    super.initState();

    _requestPermission();

  }
  @override
  Widget build(BuildContext context) {
    final message1 =
    // ignore: lines_longer_than_80_chars
        'Hey this is a QR code. Change this value in the main_screen.dart file.';

/*    final hashids = HashIds(
      salt: 'this is my salt',
      minHashLength: 8,
      alphabet: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
    );*/

    //final id = hashids.encode([4, 6, 3, 8, 2, 10,7,17,35,60,100,215,121,37,96,48,397,1233,53907,124568]);
    //final id = hashids.encode([4, 6, 3, 8, 2, 10,7,17,35,60,100,215,121,37,96,48,397,1233,53907,124568,3567,912356,1900,2700,3600,554433,221345,3894566,1001001001,9121345678]);
    //List<int> intList = [999999,99999];

    //final id = hashids.encode([999999,99999]);
    final id = hashids.encode(intList);
    final numbers = hashids.decode(id);


    message =id;
    // ignore: lines_longer_than_80_chars
    //    'zLtNINhQCwuqFgTnh9TMDt8xIeEc9gFgsepf7KIBOSw5sn83cVbPX';

    updateImage();


/*     qrFutureBuilder = FutureBuilder<ui.Image>(
      future: _loadOverlayImage(),
      builder: (ctx, snapshot) {
        final size = 180.0;
        if (!snapshot.hasData) {
          return Container(width: size, height: size);
        }
        return  CustomPaint(
          size: Size.square(size),
          painter: qrPainter=QrPainter(
            data: message,
            version: QrVersions.auto,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Color(0xff128760),
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.circle,
              color: Color(0xff1a5441),
            ),
            // size: 320.0,
            embeddedImage: snapshot.data,
            embeddedImageStyle: QrEmbeddedImageStyle(
              size: Size.square(60),
            ),
          ),
        );
      },
    );*/


    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          child: Column(
            children: <Widget>[


              SizedBox(width: 25),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 86),

                child: TextField(
                  controller: numbersTextController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter numbers',
                  ),
                ),
              ),
              SizedBox(width: 25),
              Container(
                child: TextButton(
                    child: Text(
                      'Encode and Save QR Image',
                      style: TextStyle(fontSize: 11.0),
                    ),
                    onPressed: () async {
                      //Clipboard.setData(ClipboardData(text: '$_readCodesString'));
                      //_readCodesString = "";
                      //_scanCode();

                      //get the numbers string value
                      String numbersString =numbersTextController.text;

                      List<String> numbersArray=numbersString.split(",");

                      bool inputInvalid=false;
                      int theNumber=1;
                      List<int> theIntList = [];
                      for(var numberItem in numbersArray){

                          try{
                            theNumber=int.parse(numberItem);
                            theIntList.add(theNumber);
                          }catch(_)
                          {
                            inputInvalid=true;
                          }
                      }

                      if(inputInvalid){
                        _toastInfo("The input numbers are not correct. Please input numbers again.");
                        theIntList = [];
                      }
                      else{
                        // generate the QR code
                        intList=theIntList;
                        updateImage();
                        if(theIntList.length>0){
                          await saveToGallery(" The  QR image has been saved.");
                        }
                        else{
                          await saveToGallery(" The default QR image has been saved.");
                        }

                      }


                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(color: Colors.red))))),
              ),

              SizedBox(width: 25),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 40)
                    .copyWith(bottom: 40),
                child: Text( "Generatede Hashids: "+ message),
              ),

              SizedBox(width: 25),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 86),
                child: Center(
                  child: Container(
                    width: 180,
                    child: qrFutureBuilder,
                  ),
                ),
              ),


            ],
          ),

        ),
      ),

    );
  }

  Future<ui.Image> _loadOverlayImage() async {
    var completer = Completer<ui.Image>();
    var byteData = await rootBundle.load('assets/images/4.0x/logo_yakka.png');
    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);
    return completer.future;
  }
}
