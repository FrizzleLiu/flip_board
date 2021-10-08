import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class FlipPainter extends CustomPainter{
  ui.Image assetImage;
  //旋转角度
  double angle;
  FlipPainter(this.assetImage,this.angle);
  Paint _paint;

  //x轴旋转矩阵 （旋转45度）
  List<double> matrix = [
    1,      0,     0    ,   0,
    0,      sqrt(2)/2   ,-sqrt(2)/2 ,   0,
    0,      sqrt(2)/2   ,sqrt(2)/2  ,   0,
    0,      0,     0    ,   1];

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    if(null == _paint){
      _paint = new Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill;
    }
    //上半部分旋转后剪切，再旋转回来（只有z轴旋转）
    canvas.save();
    //参数要的是弧度，使用的是角度转换一下
    canvas.rotate(angle2Radians(angle));
    //剪切，这里按矩形剪切，边界计算一下
    canvas.clipRect(Rect.fromLTRB(-sqrt(2*100*100), -sqrt(2*100*100), sqrt(2*100*100), 1));
    canvas.rotate(-angle2Radians(angle));
    canvas.drawImage(assetImage, Offset(-100, -100), _paint);
    canvas.restore();
    //下半部分 绕z轴旋转后剪切，剪切完后绕x轴旋转（折叠效果），然后z轴旋转回原位
    canvas.save();
    //z轴旋转
    canvas.rotate(angle2Radians(angle));
    canvas.clipRect(Rect.fromLTRB(-sqrt(2*100*100), 0, sqrt(2*100*100), sqrt(2*100*100)));
    //x轴旋转，折叠效果
    canvas.transform(Float64List.fromList(matrix));
    //z轴旋转回原位
    canvas.rotate(-angle2Radians(angle));
    canvas.drawImage(assetImage, Offset(-100, -100), _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }

  //角度转弧度
  double angle2Radians(double angle){
    return angle * pi/180;
  }
}