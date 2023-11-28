import 'package:flutter/material.dart';
import 'package:waveform_demo/core/models/wave_data_model.dart';
import 'package:waveform_demo/core/services/waveform_data_loader.dart';
import 'package:waveform_demo/ui/widgets/painted_waveform.dart';

class PainterView extends StatelessWidget {
  const PainterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('loading new data');
    return Center(
      child: FutureBuilder<WaveData>(
        future: loadWaveData("loop.json"),
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
    );
  }
}



///Shaping 2 - 3 cycles
///UX Design 2 - 3 cycles
///Architect each capability - backend - rpc - frontend
///Develop each capability - golden, unit, & domain transform testing




