#import "HeadingCalibration.h"

@implementation HeadingCalibration

- (void)pluginInitialize
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.watchCalibrationCallbackId = nil;
    self.runs = false;
    self.accuracy = -1;
}

- (void)watchCalibration:(CDVInvokedUrlCommand*)command
{
    if ([CLLocationManager headingAvailable]) {
        self.watchCalibrationCallbackId = command.callbackId;
        if (self.runs) {
            [self.locationManager stopUpdatingHeading];
        }
        self.watchCalibrationCallbackId = command.callbackId;
        [self.locationManager startUpdatingHeading];
        self.runs = true;
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Heading is not available on this device"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)stopWatchCalibration:(CDVInvokedUrlCommand*)command
{
    [self stop];
}

- (void)onAppTerminate
{
    [self stop];
}

-(void)stop
{
    [self.locationManager stopUpdatingHeading];
    self.watchCalibrationCallbackId = nil;
}

/**
 * IN ORDER TO IMITATE android behaviour we want to send the accuracy only if its value has changed
 */
- (void)didUpdateHeading: (CLLocationManager*)manager didUpdateHeading: (CLHeading*)newHeading
{
    CDVPluginResult* pluginResult = nil;
    double iosAccuracy = (double)[newHeading headingAccuracy];
    int accuracy = -1;

    if (iosAccuracy < (double)5) {
        accuracy = 3;
    } else if (iosAccuracy < (double)12) {
        accuracy = 2;
    } else if (iosAccuracy < (double)25) {
        accuracy = 1;
    } else {
        accuracy = 0;
    }

    if (self.accuracy != accuracy) {
        self.accuracy = accuracy;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:accuracy];
        [pluginResult setKeepCallbackAsBool: true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.watchCalibrationCallbackId];
    }
}

@end