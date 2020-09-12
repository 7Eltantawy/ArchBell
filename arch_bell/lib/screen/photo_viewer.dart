import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatefulWidget {
  PhotoViewer(this.url);
  final url;
  @override
  _PhotoViewerState createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: PhotoView(
        minScale: 0.4,
        maxScale: 2.0,
        enableRotation: true,
        imageProvider: widget.url != ''
            ? NetworkImage(widget.url)
            : AssetImage(
                "assets/avatar.jpg",
              ),
      )),
    );
  }
}
