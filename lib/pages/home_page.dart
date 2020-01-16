import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data.dart';
import '../widgets/gradient_background.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = 'Piattaforma S.TEL.LA';

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = 'Permessi camera richiesti non accettati';
        });
      } else {
        setState(() {
          result = 'Errore grave!';
        });
      }
    } on FormatException {
      setState(() {
        result = 'Hai premuto indietro prima di fare scan';
      });
    } catch (ex) {
      setState(() {
        result = 'Errore sconosciuto! $ex';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.50),
              child: _imageScrollBackground()),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.35),
              child: gradientBackground(
                  Colors.transparent, Color.fromRGBO(35, 45, 59, 1))),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.3),
              child: Center(
                  child: Text(
                result,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _imageScrollBackground() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: PageScrollPhysics(),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                  image: NetworkImage(lista[index].imageUrl),
                  fit: BoxFit.cover)),
        );
      },
    );
  }
}
