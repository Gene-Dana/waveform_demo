import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

class WaveData {
  final int? version;
  final int? channels;
  final int? sampleRate;
  final int? sampleSize;
  final int? bits;
  final int? length;
  final List<int>? data;
  List<double>? _scaledData;

  WaveData({
    this.version,
    this.channels,
    this.sampleRate,
    this.sampleSize,
    this.bits,
    this.length,
    this.data,
  });

  List<double>? scaledData() {
    if (!_isDataScaled()) {
      _scaleData();
    }
    return _scaledData;
  }

  factory WaveData.fromJson(String str) => WaveData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WaveData.fromMap(Map<String, dynamic> json) => WaveData(
        version: json["version"] as int?,
        channels: json["channels"] as int?,
        sampleRate: json["sample_rate"] as int?,
        sampleSize: json["samples_per_pixel"] as int?,
        bits: json["bits"] as int?,
        length: json["length"] as int?,
        data: (json["data"] as List<dynamic>?)?.map((x) => x as int).toList(),
      );

  Map<String, dynamic> toMap() => {
        "version": version,
        "channels": channels,
        "sample_rate": sampleRate,
        "samples_per_pixel": sampleSize,
        "bits": bits,
        "length": length,
        "data": data,
      };

  int frameIdxFromPercent(double? percent) {
    if (percent == null) {
      return 0;
    }

    if (percent < 0.0) {
      percent = 0.0;
    } else if (percent > 100.0) {
      percent = 100.0;
    }

    if (percent > 0.0 && percent < 1.0) {
      return ((data!.length.toDouble() / 2) * percent).floor();
    }

    int idx = ((data!.length.toDouble() / 2) * (percent / 100)).floor();
    final maxIdx = (data!.length.toDouble() / 2 * 0.98).floor();
    if (idx > maxIdx) {
      idx = maxIdx;
    }
    return idx;
  }

  Path path(Size size, {double zoomLevel = 1.0, int fromFrame = 0}) {
    if (!_isDataScaled()) {
      _scaleData();
    }

    if (zoomLevel < 1.0) {
      zoomLevel = 1.0;
    } else if (zoomLevel > 100.0) {
      zoomLevel = 100.0;
    }

    if (zoomLevel == 1.0 && fromFrame == 0) {
      return _path(_scaledData!, size);
    }

    if (fromFrame * 2 > (data!.length * 0.98).floor()) {
      debugPrint("from frame is too far at $fromFrame");
      fromFrame = ((data!.length / 2) * 0.98).floor();
    }

    int endFrame = (fromFrame * 2 +
            ((_scaledData!.length - fromFrame * 2) * (1.0 - (zoomLevel / 100))))
        .floor();

    return _path(_scaledData!.sublist(fromFrame * 2, endFrame), size);
  }

  Path _path(List<double> samples, Size size) {
    final middle = size.height / 2;
    var i = 0;

    List<Offset> minPoints = [];
    List<Offset> maxPoints = [];

    final t = size.width / samples.length;
    for (var _i = 0, _len = samples.length; _i < _len; _i++) {
      var d = samples[_i];

      if (_i % 2 != 0) {
        minPoints.add(Offset(t * i, middle - middle * d));
      } else {
        maxPoints.add(Offset(t * i, middle - middle * d));
      }

      i++;
    }

    final path = Path();
    path.moveTo(0, middle);
    maxPoints.forEach((o) => path.lineTo(o.dx, o.dy));
    path.lineTo(size.width, middle);
    minPoints.reversed
        .forEach((o) => path.lineTo(o.dx, middle - (middle - o.dy)));

    path.close();
    return path;
  }

  bool _isDataScaled() {
    return _scaledData != null && _scaledData!.length == data!.length;
  }

  void _scaleData() {
    final max = pow(2, bits! - 1).toDouble();

    final dataSize = data!.length;
    _scaledData = List.generate(dataSize, (i) {
      double scaledValue = data![i].toDouble() / max;
      if (scaledValue > 1.0) {
        scaledValue = 1.0;
      }
      if (scaledValue < -1.0) {
        scaledValue = -1.0;
      }
      return scaledValue;
    });
  }
}
