import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

import 'PikobarPlaceholder.dart';

class ThumbnailCard extends StatelessWidget {
  const ThumbnailCard({
    Key key,
    @required this.imageUrl,
    this.imageLength,
    @required this.title,
    @required this.date,
    this.label,
    this.centerIcon,
    this.onTap,
  }) : super(key: key);

  final String imageUrl;

  final int imageLength;

  final String title;

  final String date;

  final Widget label;

  final Widget centerIcon;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: Dimens.contentPadding),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  child: CachedNetworkImage(
                      imageUrl: imageUrl ?? '',
                      imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimens.borderRadius),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      placeholder: (context, url) => Center(
                          heightFactor: 10.2,
                          child: const CupertinoActivityIndicator()),
                      errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                          ),
                          child: PikobarPlaceholder()))),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                  color: Colors.white,
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
              centerIcon ?? Container(),
              Positioned(
                left: 10,
                right: 10,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        label ?? Container(),
                        Expanded(
                          child: Text(
                            date,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: FontsFamily.roboto),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: FontsFamily.roboto),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: Dimens.sizedBoxHeight,
                    ),
                  ],
                ),
              ),
              imageLength != null
                  ? Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.5),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              BorderRadius.circular(Dimens.dialogRadius),
                        ),
                        child: Text(
                          '1/$imageLength',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontFamily: FontsFamily.roboto),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
