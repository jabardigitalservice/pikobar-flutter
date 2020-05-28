import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/banners/BannersBloc.dart';
import 'package:pikobar_flutter/blocs/banners/BannersState.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerListSlider extends StatefulWidget {
  @override
  BannerListSliderState createState() => BannerListSliderState();
}

class BannerListSliderState extends State<BannerListSlider> {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<BannersBloc, BannersState>(
      builder: (context, state) {
       return state is BannersLoading ? _buildLoading() : state is BannersLoaded ? _buildSlider(state) : _buildLoading();
      },
    );
  }

  Widget _buildLoading() {
    return AspectRatio(
      aspectRatio: 21 / 9,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Skeleton(
                    width: MediaQuery.of(context).size.width,
                  ),
                ));
          }),
    );
  }

  _buildSlider(BannersLoaded state) {
    return CarouselSlider(
      initialPage: 0,
      enableInfiniteScroll: state.records.length > 1 ? true : false,
      aspectRatio: 21 / 9,
      viewportFraction: state.records.length > 1 ? 0.8 : 0.95,
      autoPlay: state.records.length > 1 ? true : false,
      autoPlayInterval: Duration(seconds: 5),
      items: state.records.map((BannerModel data) {
        return Builder(builder: (BuildContext context) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    imageUrl: data.url ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                        heightFactor: 10.2,
                        child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                        ),
                        child: PikobarPlaceholder())),
              ),
            ),
            onTap: () {
              if (data.actionUrl != null) {
                _clickAction(
                    url: data.actionUrl,
                    isLoginRequired: data.login);
                AnalyticsHelper.setLogEvent(Analytics.tappedBanner,
                    <String, dynamic>{'url': data.actionUrl});
              }
            },
          );
        });
      }).toList(),
    );
  }

  _clickAction({@required String url, bool isLoginRequired}) async {
    if (isLoginRequired != null && isLoginRequired) {
      bool hasToken = await AuthRepository().hasToken();

      if (!hasToken) {
        bool isLoggedIn = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));

        if (isLoggedIn != null && isLoggedIn) {
          url = await userDataUrlAppend(url);
          await _launchUrl(url);
        }
      } else {
        url = await userDataUrlAppend(url);
        await _launchUrl(url);
      }
    } else {
      url = await userDataUrlAppend(url);
      await _launchUrl(url);
    }
  }

  _launchUrl(String url) async {
    if (url.contains('youtube')) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      openChromeSafariBrowser(url: url);
    }
  }
}
