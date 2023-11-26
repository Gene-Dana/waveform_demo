import 'package:flutter/services.dart';
import 'package:waveform_demo/core/models/wave_data_model.dart';

Future<WaveData> loadWaveData(String filename) async {
  final data = await rootBundle.loadString("assets/$filename");
  return WaveData.fromJson(data);
}
