import 'package:flutter/material.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';
import'dart:async';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';

const textColor = Color(0xFFdcf6e1);
const backgroundColor = Color(0xFF030a03);
const primaryColor = Color(0xFF8ce098);
const primaryFgColor = Color(0xFF030a03);
const secondaryColor = Color(0xFF213d7a);
const secondaryFgColor = Color(0xFFdcf6e1);
const accentColor = Color(0xFF574ace);
const accentFgColor = Color(0xFFdcf6e1);

const colorScheme = ColorScheme(
  brightness: Brightness.dark,
  background: backgroundColor,
  onBackground: textColor,
  primary: primaryColor,
  onPrimary: primaryFgColor,
  secondary: secondaryColor,
  onSecondary: secondaryFgColor,
  tertiary: accentColor,
  onTertiary: accentFgColor,
  surface: backgroundColor,
  onSurface: textColor,
  error: Brightness.dark == Brightness.light ? Color(0xffB3261E) : Color(0xffF2B8B5),
  onError: Brightness.dark == Brightness.light ? Color(0xffFFFFFF) : Color(0xff601410),
);

void main() {
  runApp(WhatsAppMessageGenerator());
}

class WhatsAppMessageGenerator extends StatefulWidget {
  const WhatsAppMessageGenerator({super.key});
  @override
  State<WhatsAppMessageGenerator> createState() => WhatsAppMessageGeneratorState();
}

class WhatsAppMessageGeneratorState extends State<WhatsAppMessageGenerator> {
  final howOftenMessageSent = TextEditingController();
  final textToSend = TextEditingController();
  final FlutterNativeContactPicker _contactPicker =
  FlutterNativeContactPicker();
  Contact? contact;
  String phoneNumber = "not selected yet";
  String finalTextToSend = "";
  String contactName = "not selected yet";


  Future<void> OpenWhatsAppLink() async {
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
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: primaryFgColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: textColor),
          bodyMedium: TextStyle(color: textColor),
          bodySmall: TextStyle(color: textColor),
        ),
      ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('Your Whatsapp Message Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: textToSend,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Text you want to send',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: howOftenMessageSent,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'How often should the message be sent',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
           ElevatedButton(
              onPressed: () async {
                contact = await _contactPicker.selectContact();
                setState(() {
                  phoneNumber = contact!.phoneNumbers!.isNotEmpty ? contact?.phoneNumbers?.first as String : "unknown number";
                });
                if (contact != null) {
                  setState(() {
                    contactName = contact?.fullName ?? "unknown Name";
                  });
                } else {
                  setState(() {
                    contactName = "no Contact selected";
                  });
                }
              },
              child: Text('Select a Contact'),
            ),
            SizedBox(height: 16),
            Text('Selected Contact'),
            SizedBox(height: 5),
            Text('$contactName', key: Key("nameKey")),
            Text('$phoneNumber', key: Key("numberKey")),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                OpenWhatsAppLink();
                setState(() {
                  phoneNumber = "not selected yet";
                  contactName = "not selected yet";
                  contact = null;
                });
                howOftenMessageSent.text = "";
                textToSend.text = "";
              },
              child: Text('send Message'),
            )
          ],
        ),
      ),
    ),
    );
  }
}
