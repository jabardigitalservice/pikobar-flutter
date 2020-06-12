import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:pikobar_flutter/components/DotsIndicator.dart';

class HeroImagePreview extends StatefulWidget {
  final String heroTag;
  final String imageUrl;
  final galleryItems;
  final int initialIndex;
  final PageController pageController;

  HeroImagePreview(this.heroTag,
      {this.imageUrl, this.galleryItems, this.initialIndex})
      : pageController = PageController(initialPage: initialIndex ?? 0);

  @override
  _HeroImagePreviewState createState() => _HeroImagePreviewState();
}

class _HeroImagePreviewState extends State<HeroImagePreview> {
  int currentIndex;

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  @override
  initState() {
    if (widget.initialIndex != null) {
      currentIndex = widget.initialIndex;
    }

    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.imageUrl == null
          ? _buildPhotoViewGallery()
          : PhotoView(
              imageProvider: NetworkImage(widget.imageUrl),
              maxScale: PhotoViewComputedScale.covered * 2.0,
              minScale: PhotoViewComputedScale.contained * 0.8,
              backgroundDecoration: BoxDecoration(color: Colors.white),
              heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
              onTapUp: (context, tapDetail, controller) {
                Navigator.of(context).pop();
              },
            ),
    );
  }

  Widget _buildPhotoViewGallery() {
    return Stack(children: <Widget>[
      PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            maxScale: PhotoViewComputedScale.covered * 2.0,
            minScale: PhotoViewComputedScale.contained * 0.8,
            imageProvider: NetworkImage(widget.galleryItems[index]),
            heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
            onTapUp: (context, tapDetail, controller) {
              Navigator.of(context).pop();
            },
          );
        },
        itemCount: widget.galleryItems.length,
        backgroundDecoration: BoxDecoration(color: Colors.white),
        pageController: widget.pageController,
        onPageChanged: onPageChanged,
        scrollDirection: Axis.horizontal,
      ),
      widget.galleryItems.length > 1
          ? Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: Colors.grey[800].withOpacity(0.5),
                width: MediaQuery.of(context).size.width,
                height: 40,
              ),
            )
          : Container(),
      widget.galleryItems.length > 1
          ? Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: new Center(
                      child: DotsIndicator(
                        controller: widget.pageController,
                        itemCount: widget.galleryItems.length,
                        onPageSelected: (int page) {
                          widget.pageController.animateToPage(
                            page,
                            duration: _kDuration,
                            curve: _kCurve,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ))
          : Container(),
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
