import 'package:flutter/material.dart';
import 'package:waveform_demo/core/models/wave_data_model.dart';
import 'package:waveform_demo/core/services/waveform_data_loader.dart';
import 'package:waveform_demo/ui/widgets/app_bar.dart';
import 'package:waveform_demo/ui/widgets/bottom_app_bar.dart';
import 'package:waveform_demo/ui/widgets/painted_waveform.dart';

class PainterView extends StatelessWidget {
  const PainterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: sharedAppBar(context, "Waveform Painter"),
      //
      bottomNavigationBar: sharedBottomAppBar(context),
      //
      body: Center(
        child: FutureBuilder<WaveData>(
          future: loadWaveData("oneshot.json"),
          builder: (context, AsyncSnapshot<WaveData> snapshot) {
            if (snapshot.hasData) {
              return PaintedWaveform(sampleData: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Error ${snapshot}",
                  style: TextStyle(color: Colors.red));
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
