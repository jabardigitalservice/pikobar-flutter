import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/SocialMedia.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'package:url_launcher/url_launcher.dart';

class Bansos extends StatefulWidget {
  Bansos({Key key}) : super(key: key);

  @override
  _BansosState createState() => _BansosState();
}

class _BansosState extends State<Bansos> {
  ScrollController _scrollController;
  String imageBansosUrl =
      'https://firebasestorage.googleapis.com/v0/b/jabarprov-covid19.appspot.com/o/public%2Fcara%20cek%20bansos.jpeg?alt=media&token=d9d769fa-5072-46d6-98ef-bb6a5138efed';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.13 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.animatedAppBar(
          title: Dictionary.portalBansos, showTitle: _showTitle),
      body: SingleChildScrollView(
          controller: _scrollController, child: _buildContent()),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimens.padding, horizontal: Dimens.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: _showTitle ? 0 : 1,
            duration: Duration(milliseconds: 250),
            child: Text(
              Dictionary.portalBansos,
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontSize: 20,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            Dictionary.bansosWelcomeText,
            style: TextStyle(
                color: Colors.grey[600],
                fontFamily: FontsFamily.roboto,
                height: 1.5,
                fontSize: 14),
          ),
          const SizedBox(height: 20),
          Center(child: Image.asset('${Environment.imageAssets}charity.png')),
          const SizedBox(height: 20),
          Text(
            Dictionary.bansosDescriptionText,
            style: TextStyle(
                color: Colors.black,
                fontFamily: FontsFamily.roboto,
                height: 1.5,
                fontSize: 14),
          ),
          const SizedBox(height: 20),
          Text(
            Dictionary.bansosDisclaimerText,
            style: TextStyle(
                color: Colors.grey[600],
                fontFamily: FontsFamily.roboto,
                fontStyle: FontStyle.italic,
                height: 1.5,
                fontSize: 12),
          ),
          const SizedBox(height: 20),
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HeroImagePreview(
                        Dictionary.heroImageTag,
                        imageUrl: imageBansosUrl,
                      ),
                    ));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imageBansosUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              )),
          const SizedBox(height: 20),
          _buildContainer(Dictionary.findBansosData,
              '${Environment.imageAssets}find_bansos.png', () async {
            await openChromeSafariBrowser(
                url: 'https://cekbansos.kemensos.go.id/');
          }),
          const SizedBox(height: 20),
          _buildContainer(Dictionary.checkBansosData,
              '${Environment.imageAssets}ministry_of_social.png', _launchEmail),
          const SizedBox(height: 40),
          SocialMedia()
        ],
      ),
    );
  }

  Widget _buildContainer(String title, image, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorBase.greyContainer,
            borderRadius: BorderRadius.circular(8)),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Image.asset(
              image,
              width: 70,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                    fontSize: 14),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[800],
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail() async {
    dynamic params;
    if (Platform.isAndroid) {
      params = Uri(
        scheme: 'mailto',
        path: 'dtks@kemsos.go.id',
      );
    } else if (Platform.isIOS) {
      const String subject = "Subject:";
      const String stringText = "Message:";
      params =
          'mailto:dtks@kemsos.go.id?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    }

    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
