import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flip_painter.dart';

class FlipWidget extends StatefulWidget {
  const FlipWidget({Key key}) : super(key: key);

  @override
  _FlipWidgetState createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget> with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation<double> animation;
  ui.Image _assetImageFrame;//本地图片

  @override
  Future<void> initState() {
    super.initState();
    _getAssetImageAsync();
    animationController = new AnimationController(
        vsync: this, duration: Duration(seconds: 3));
    animation = Tween<double>(begin: 0, end: 360).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animationController.repeat();
  }


  @override
  void deactivate() {
    super.deactivate();
    animationController.stop();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _assetImageFrame == null ? Center() : CustomPaint(
        painter: FlipPainter(_assetImageFrame,animation.value),
      ),
    );
  }

  //获取本地图片
  _getAssetImageAsync() async{
    ui.Image imageFrame = await getAssetImage('assets/images/xhzy.png',width: 200,height: 200);
    setState(() {
      _assetImageFrame = imageFrame;
    });
  }

  //获取本地图片 返回ui.Image
  Future<ui.Image> getAssetImage(String asset,{width,height}) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),targetWidth: width,targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
