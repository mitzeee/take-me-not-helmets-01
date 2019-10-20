#!flask/bin/python
from flask import Flask, request
import json
import serial
import time

app = Flask(__name__)


activeRides = {}
port = "COM4"


def serialMonitorRead():

    ser = serial.Serial(port, 9600, timeout=1)
    ser.flushInput()
    startTime = time.time()
    timeout = 10
    time.sleep(1)
    ser.readline()
    
    while time.time()-startTime < timeout:
        uid = ser.readline().decode('utf-8').strip()
        if len(uid)>0: break
    ser.flushInput()
    return uid

# @app.route('/')
@app.route('/vodummygo/api/v1/ride/start/<appId>/<helmetNeeded>', methods=['POST'])
def RideStart(appId, helmetNeeded):
    print(appId, helmetNeeded)

    if helmetNeeded=='true':
        helmetId = serialMonitorRead()
        if helmetId == "":
            message = "Ride could not be started"
            success = False
            statusCode = 200
        else:
            activeRides[appId]= helmetId
            message = "Ride started successfully"
            success = True
            statusCode = 200
    else:
        activeRides[appId]=""
        message = "Ride started successfully"
        statusCode = 200
        success = True



    response = app.response_class(
        response=json.dumps({"message":message, "success":success}),
        status=statusCode,
        mimetype='application/json'
    )
    print(activeRides)
    return response


@app.route('/vodummygo/api/v1/ride/end/<appId>', methods=['POST'])
def RideEnd(appId):
    if appId in activeRides:
        if activeRides[appId] != "":
            helmetId = serialMonitorRead()
            if helmetId == activeRides[appId]:
                message = "Ride ended successfully"
                success = True
                statusCode = 200
                del activeRides[appId]
            else:
                message = "Scanned helmet is not linked"
                success = False
                statusCode =200
        else:
            message = "Ride ended successfully"
            success = True
            statusCode = 200
            del activeRides[appId]
    else:
        message = "Ride not found"
        success = False
        statusCode = 200


    response = app.response_class(
        response=json.dumps({"message":message, "success":success}),
        status=statusCode,
        mimetype='application/json'
    )
    print(activeRides)
    return response
    
@app.route('/vodummygo/api/v1/ride/admin/reset', methods=['POST'])
def resetApp():
    activeRides.clear()
    message = "App reset successful"
    success = True
    statusCode = 200
    response = app.response_class(
        response=json.dumps({"message":message, "success":success}),
        status=statusCode,
        mimetype='application/json'
    )
    print(activeRides)
    return response

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)