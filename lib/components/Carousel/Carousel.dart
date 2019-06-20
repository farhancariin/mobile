import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class Carousel extends StatefulWidget {
  final List<Widget> landingItem;
  final int activeIndex;

  const Carousel({Key key, this.landingItem, this.activeIndex})
      : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  @override


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(top: 5.0),
      child:  PageView(
        children: widget.landingItem,
      ),
    );
  }
}


