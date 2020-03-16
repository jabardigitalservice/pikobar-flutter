import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
// import 'package:sapawarga/models/RWActivityModel.dart';

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
          ? PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  minScale: 0.3,
                  imageProvider:
                      NetworkImage(widget.galleryItems.images[index].url),
                  heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
                  onTapUp: (context, tapDetail, controller) {
                    Navigator.of(context).pop();
                  },
                );
              },
              itemCount: widget.galleryItems.images.length,
              backgroundDecoration: BoxDecoration(color: Colors.white),
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.horizontal,
            )
          : PhotoView(
              imageProvider: NetworkImage(widget.imageUrl),
              minScale: 0.3,
              backgroundDecoration: BoxDecoration(color: Colors.white),
              heroAttributes: PhotoViewHeroAttributes(tag: widget.heroTag),
              onTapUp: (context, tapDetail, controller) {
                Navigator.of(context).pop();
              },
            ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
