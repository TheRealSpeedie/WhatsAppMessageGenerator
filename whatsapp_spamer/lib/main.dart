import 'package:flutter/material.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';
import'dart:async';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  State<MyApp> createState() => _WhatsAppSpamerState();
}

class _WhatsAppSpamerState extends State<MyApp> {
  final howOftenMessageSent = TextEditingController();
  final textToSend = TextEditingController();
  final FlutterNativeContactPicker _contactPicker =
  FlutterNativeContactPicker();
  Contact? contact;
  String phoneNumber = "noch nicht ausgewählt";
  String finalTextToSend = "";
  String contactName = "noch nicht ausgewählt";


  Future<void> _openWhatsAppLink() async {
    Multiplytext();
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: finalTextToSend,
    );
    await launchUrl(link.asUri());
  }

  void Multiplytext(){
    int number = int.parse(howOftenMessageSent.text);
    String basicText = textToSend.text;
    for(int x = 0; x <= number; x++){
      finalTextToSend += '\n$basicText';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Your Whatsapp Spamer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: howOftenMessageSent,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Wie oft soll die Nachricht gesendet werden',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: textToSend,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Text der gesendet werden soll',
                border: OutlineInputBorder(),
              ),
            ),
           ElevatedButton(
              onPressed: () async {
                contact = await _contactPicker.selectContact();
                setState(() {
                  phoneNumber = contact!.phoneNumbers!.isNotEmpty ? contact?.phoneNumbers?.first as String : "[nummer]";
                });
                if (contact != null) {
                  setState(() {
                    contactName = contact?.fullName ?? "[unbekannter Name]";
                  });
                } else {
                  setState(() {
                    contactName = "kein Kontakt ausgewählt";
                  });
                }
              },
              child: Text('Selektiere den Kontakt'),
            ),
            SizedBox(height: 16),
            Text('Der ausgewählte Kontakt:'),
            SizedBox(height: 5),
            Text('Name: $contactName', key: Key("nameKey")),
            Text('Nummer: $phoneNumber', key: Key("numberKey")),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _openWhatsAppLink();
              },
              child: Text('Whatsapp Nachricht senden'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  phoneNumber = "noch nicht ausgewählt";
                  contactName = "noch nicht ausgewählt";
                  contact = null;
                });
                howOftenMessageSent.text = "";
                textToSend.text = "";
              },
              child: Text('Reset'),
            )
          ],
        ),
      ),
    ),
    );
  }
}
