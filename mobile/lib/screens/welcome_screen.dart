import 'package:flutter/material.dart';
import 'package:vodummygo/components/helmet_alert_dialog.dart';
import 'package:vodummygo/components/round_button.dart';
import 'package:vodummygo/constants/constants.dart';
import 'package:vodummygo/screens/active_ride_screen.dart';
import 'package:vodummygo/services/networking.dart';
import 'package:progress_dialog/progress_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String messageText = "NULL";
  bool helmetNeeded = false;

  // Future<dynamic> getApiData() async {
  // NetworkHelper networkHelper = NetworkHelper(
  //       url:'http://10.0.2.2:5000/vodummygo/api/v1/ride/start/<appId>/<helmetNeeded>'
  //   );
  //   var weatherData = await networkHelper.getData();
  //   return weatherData;
  // }

  Future<dynamic> sendStartRide({String appId, String helmetNeeded}) async {
    NetworkHelper networkHelper = NetworkHelper(
        url:
            // 'http://10.0.2.2:5000/vodummygo/api/v1/ride/start/$appId/$helmetNeeded');
            'http://192.168.10.176:5000/vodummygo/api/v1/ride/start/$appId/$helmetNeeded');
    var responseData = await networkHelper.getData();
    return responseData;
  }

  Future<dynamic> sendResetApp() async {
    NetworkHelper networkHelper = NetworkHelper(
        url:
            // 'http://10.0.2.2:5000/vodummygo/api/v1/ride/start/$appId/$helmetNeeded');
            'http://192.168.10.176:5000/vodummygo/api/v1/ride/admin/reset');
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
      // appBar: AppBar(
      //   title: Center(child: Text("Welcome to VOdummyGO")),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/blurlights.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 20.0,),
              Column(children: <Widget>[
                Text('DoGo', style: const_LogoTextStyle,),
              Text('taking you places...',
              style: const_TagLineTextStyle,
              ),
              ],),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Text(messageText),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Switch(
                        // checkColor: Colors.green,
                        activeColor: Colors.green,
                        value: helmetNeeded,
                        // tristate: false,
                        onChanged: (value) {
                          setState(() {
                            helmetNeeded = value;
                          });
                        },
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'I need a ',
                            style: const_LabelTextStyle,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            child: Image(
                              image: AssetImage('assets/images/helmet_icon.png'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RoundButton(
                      buttonText: 'Start Ride' ,
                      onPressed: () async {
                        pr.style(message: 'Please pick and scan a helmet...');
                        pr.show();
                        dynamic apiResp = await sendStartRide(
                            appId: 'app1000',
                            helmetNeeded: helmetNeeded ? 'true' : 'false');
                        pr.hide();
                        bool success = false;
                        try {
                          success = apiResp['success'];
                        } catch (e) {
                          success = false;
                        }
                        if (success) {
                          messageText = apiResp[messageText];
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ActiveRide()));
                        } else {
                          // setState(() {
                          //   try {
                          //     messageText = apiResp['message'];
                          //   } catch (e) {
                          //     messageText = 'Error occured - $e';
                          //   }
                          // });
                          HelmetDialog().showInfoDialog(
                            context: context,
                            messageText:'Did not recieve any helmet scans',
                            extraText: 'Try again or deselect helmet needed option.',
                          );
                        }
                      },
                    ),
                  ),
                  
                  SizedBox(height:100.0,),
                  MaterialButton(
                    child: Icon(Icons.delete_forever),
                    onPressed: () async {
                      await sendResetApp();
                    },
                  ),
                  // Text('Some text'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
