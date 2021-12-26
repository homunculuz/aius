import 'package:flutter/material.dart';

class RenderDataPoseEstimation extends StatefulWidget {
  final List<dynamic> data;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final bool isRecording;

  RenderDataPoseEstimation(
      {this.data,
      this.previewH,
      this.previewW,
      this.screenH,
      this.screenW,
      this.isRecording});
  @override
  _RenderDataPoseEstimationState createState() =>
      _RenderDataPoseEstimationState();
}

class _RenderDataPoseEstimationState extends State<RenderDataPoseEstimation> {
  Map<String, List<double>> inputArr;

  String excercise = 'arm_press';
  double upperRange = 300;
  double lowerRange = 500;
  bool midCount, isCorrectPosture;
  int _counter;
  Color correctColor;
  double shoulderLY;
  double shoulderRY;

  double wristLX, wristLY, wristRX, wristRY, elbowLX, elbowRX;
  double kneeRY;
  double kneeLY;
  bool squatUp;
  String whatToDo = 'Finding Posture';

  var leftEyePos = Vector(0, 0);
  var rightEyePos = Vector(0, 0);
  var nose = Vector(0, 0);
  var leftShoulderPos = Vector(0, 0);
  var rightShoulderPos = Vector(0, 0);
  var leftHipPos = Vector(0, 0);
  var rightHipPos = Vector(0, 0);
  var leftElbowPos = Vector(0, 0);
  var rightElbowPos = Vector(0, 0);
  var leftWristPos = Vector(0, 0);
  var rightWristPos = Vector(0, 0);
  var leftKneePos = Vector(0, 0);
  var rightKneePos = Vector(0, 0);
  var leftAnklePos = Vector(0, 0);
  var rightAnklePos = Vector(0, 0);

  @override
  void initState() {
    inputArr = new Map();
    midCount = false;
    isCorrectPosture = false;
    _counter = 0;
    correctColor = Colors.green.shade100;
    shoulderLY = 0;
    shoulderRY = 0;
    kneeRY = 0;
    kneeLY = 0;
    squatUp = true;
    super.initState();
  }

  _postureAccordingToExercise(Map<String, List<double>> poses) {
    setState(() {
      wristLX = poses['leftWrist'][0];
      wristLY = poses['leftWrist'][1];
      wristRX = poses['rightWrist'][0];
      wristRY = poses['rightWrist'][1];
      elbowLX = poses['leftElbow'][0];
      elbowRX = poses['rightElbow'][0];

      shoulderLY = poses['leftShoulder'][1];
      shoulderRY = poses['rightShoulder'][1];
      kneeLY = poses['leftKnee'][1];
      kneeRY = poses['rightKnee'][1];
    });
    if (excercise == 'arm_press') {
      if (squatUp) {
        return wristLX > 280 &&
            elbowLX > 280 &&
            wristRX < 95 &&
            elbowRX < 95 &&
            wristLY < 240 &&
            wristLY > 200 &&
            wristRY < 240 &&
            wristRY > 200;
      } else {
        return wristLY < 125 && wristRY < 125;
      }
    }
  }

  _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_postureAccordingToExercise(poses)) {
      if (!isCorrectPosture) {
        setState(() {
          isCorrectPosture = true;
          correctColor = Colors.green;
        });
      }
    } else {
      if (isCorrectPosture) {
        setState(() {
          isCorrectPosture = false;
          correctColor = Colors.red;
        });
      }
    }
  }

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      _checkCorrectPosture(poses);

      if (isCorrectPosture && squatUp && midCount == false) {
        //in correct initial posture
        setState(() {
          whatToDo = 'Lift';
          correctColor = Colors.green;
        });
        squatUp = !squatUp;
        isCorrectPosture = false;
      }

      //lowered all the way
      if (isCorrectPosture && !squatUp && midCount == false) {
        midCount = true;
        isCorrectPosture = false;
        squatUp = !squatUp;
        setState(() {
          whatToDo = 'Drop';
          correctColor = Colors.green;
        });
      }

      //back up
      if (midCount && isCorrectPosture) {
        incrementCounter();
        midCount = false;
        squatUp = !squatUp;
        setState(() {
          whatToDo = 'Lift';
        });
      }
    }
  }

  void incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _getKeyPoints(k, x, y) {
      if (k["part"] == 'leftEye') {
        leftEyePos.x = x - 280;
        leftEyePos.y = y - 100;
      }
      if (k["part"] == 'rightEye') {
        rightEyePos.x = x - 280;
        rightEyePos.y = y - 100;
      }

      if (k["part"] == 'nose') {
        nose.x = x - 280;
        nose.y = y - 100;
      }

      if (k["part"] == 'leftShoulder') {
        leftShoulderPos.x = x - 280;
        leftShoulderPos.y = y - 100;
      }
      if (k["part"] == 'rightShoulder') {
        rightShoulderPos.x = x - 280;
        rightShoulderPos.y = y - 100;
      }
      if (k["part"] == 'leftElbow') {
        leftElbowPos.x = x - 280;
        leftElbowPos.y = y - 100;
      }
      if (k["part"] == 'rightElbow') {
        rightElbowPos.x = x - 280;
        rightElbowPos.y = y - 100;
      }
      if (k["part"] == 'leftWrist') {
        leftWristPos.x = x - 280;
        leftWristPos.y = y - 100;
      }
      if (k["part"] == 'rightWrist') {
        rightWristPos.x = x - 280;
        rightWristPos.y = y - 100;
      }
      if (k["part"] == 'leftHip') {
        leftHipPos.x = x - 280;
        leftHipPos.y = y - 100;
      }
      if (k["part"] == 'rightHip') {
        rightHipPos.x = x - 280;
        rightHipPos.y = y - 100;
      }
      if (k["part"] == 'leftKnee') {
        leftKneePos.x = x - 280;
        leftKneePos.y = y - 100;
      }
      if (k["part"] == 'rightKnee') {
        rightKneePos.x = x - 280;
        rightKneePos.y = y - 100;
      }
      if (k["part"] == 'leftAnkle') {
        leftAnklePos.x = x - 280;
        leftAnklePos.y = y - 100;
      }
      if (k["part"] == 'rightAnkle') {
        rightAnklePos.x = x - 280;
        rightAnklePos.y = y - 100;
      }
    }

    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.data.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          inputArr[k['part']] = [x, y];
          //Mirroring
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }

          _getKeyPoints(k, x, y);

          if (k["part"] == 'leftEye') {
            leftEyePos.x = x - 280;
            leftEyePos.y = y - 80;
          }
          if (k["part"] == 'rightEye') {
            rightEyePos.x = x - 280;
            rightEyePos.y = y - 80;
          }

          if (k["part"] == 'nose') {
            nose.x = x - 280;
            nose.y = y - 80;
          }

          return Positioned(
            left: x - 280,
            top: y - 50,
            width: 100,
            height: 15,
            child: Container(
                // child: Text(
                //   "● ${k["part"]}",
                //   style: TextStyle(
                //     color: Color.fromRGBO(37, 213, 253, 1.0),
                //     fontSize: 12.0,
                //   ),
                // ),
                ),
          );
        }).toList();

        _countingLogic(inputArr);
        inputArr.clear();

        lists..addAll(list);
      });
      //lists.clear();

      return lists;
    }

    return widget.isRecording
        ? Stack(
            children: <Widget>[
              Stack(
                children: [
                  CustomPaint(
                    painter: MyPainter(left: leftEyePos, right: nose),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: nose, right: rightEyePos),
                  ),
                  CustomPaint(
                    painter: MyPainter(
                        left: leftShoulderPos, right: rightShoulderPos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: leftElbowPos, right: leftShoulderPos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: leftWristPos, right: leftElbowPos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: rightElbowPos, right: rightShoulderPos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: rightWristPos, right: rightElbowPos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: leftShoulderPos, right: leftHipPos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: leftHipPos, right: leftKneePos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: leftKneePos, right: leftAnklePos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: rightShoulderPos, right: rightHipPos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: rightHipPos, right: rightKneePos),
                  ),
                  CustomPaint(
                    painter:
                        MyPainter(left: rightKneePos, right: rightAnklePos),
                  ),
                  CustomPaint(
                    painter: MyPainter(left: leftHipPos, right: rightHipPos),
                  ),
                ],
              ),
              Stack(children: _renderKeypoints()),
            ],
          )
        : SizedBox.shrink();
  }
}

class Vector {
  double x, y;
  Vector(this.x, this.y);
}

class MyPainter extends CustomPainter {
  Vector left;
  Vector right;
  MyPainter({this.left, this.right});
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(left.x, left.y);
    final p2 = Offset(right.x, right.y);
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
