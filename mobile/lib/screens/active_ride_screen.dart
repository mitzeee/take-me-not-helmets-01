import 'package:flutter/material.dart';
import 'package:vodummygo/components/round_button.dart';
import 'package:vodummygo/constants/constants.dart';
import 'package:vodummygo/services/networking.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:vodummygo/components/helmet_alert_dialog.dart';


class ActiveRide extends StatefulWidget {
  @override
  _ActiveRideState createState() => _ActiveRideState();
}

class _ActiveRideState extends State<ActiveRide> {
  String messageText = 'NULL';

  Future<dynamic> sendEndRide({String appId}) async {
    NetworkHelper networkHelper = NetworkHelper(
        // url: 'http://10.0.2.2:5000/vodummygo/api/v1/ride/end/$appId');
        url: 'http://192.168.10.176:5000/vodummygo/api/v1/ride/end/$appId');
    var responseData = await networkHelper.getData();
    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = new ProgressDialog(context);
    pr.style(
  message: 'Downloading file...',
  borderRadius: 10.0,
  backgroundColor: Colors.white,
  progressWidget: CircularProgressIndicator(),
  elevation: 10.0,
  insetAnimCurve: Curves.easeInOut,
  progress: 0.0,
  maxProgress: 100.0,
  progressTextStyle: TextStyle(
     color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
  messageTextStyle: TextStyle(
     color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
  );
    return Scaffold(
      body: SafeArea(
              child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/blurlights.jpg'),
              fit: BoxFit.cover,
            )
          ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Center(
              child: Text('Ride in progress...',
              style: const_LabelTextStyle,
              ),
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.blue,
                ),             
                child: Image(
                  image: AssetImage('assets/images/map.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundButton(
                buttonText: 'End Ride',
                onPressed: () async {
                  pr.style(message: 'Scan helmet to end ride...');
                  pr.show();
                  dynamic apiResp = await sendEndRide(appId: 'app1000');
                  pr.hide();
                  bool success = false;
                  try {
                    success = apiResp['success'];
                    messageText = apiResp['message'];
                  } catch (e) {
                    HelmetDialog().showInfoDialog(
                            context: context,
                            messageText: 'Error occured',
                            extraText: 'Could not communicate with station',
                          );
                  }
                  if (success) {
                    // messageText = apiResp[messageText];
                    Navigator.pop(context);
                  } else {

                    HelmetDialog().showInfoDialog(
                            context: context,
                            messageText: 'Could not end ride',
                            extraText: messageText,
                          );
                  }
                },
              ),
            ),            
            Text(messageText),
          ],
        )),
      ),
    );
  }
}
