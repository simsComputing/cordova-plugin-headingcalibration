#import "HeadingCalibration.h"

@implementation HeadingCalibration

- (void)pluginInitialize
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.watchCalibrationCallbackId = nil;
    self.accuracy = nil;
    self.isCalibrationCallbackFirstCall = true;
}

- (void)watchCalibration:(CDVInvokedUrlCommand*)command
{
    if ([CLLocationManager headingAvailable]) {
        if (self.watchCalibrationCallbackId) {
            [self.locationManager stopUpdatingHeading];
        }
        self.watchCalibrationCallbackId = command.callbackId;
        self.isCalibrationCallbackFirstCall = true;
        [self.locationManager startUpdatingHeading];
    } else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Heading is not available on this device"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

    self.iterations++;
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
- (void)locationManager: (CLLocationManager*)manager didUpdateHeading: (CLHeading*)newHeading
{
    CDVPluginResult* pluginResult = nil;
    double iosAccuracy = (double)[newHeading headingAccuracy];

    if (self.accuracy != iosAccuracy || self.isCalibrationCallbackFirstCall == true) {
        self.isCalibrationCallbackFirstCall = false;
        self.accuracy = iosAccuracy;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:self.accuracy];
        [pluginResult setKeepCallbackAsBool: true];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.watchCalibrationCallbackId];
    }
}

- (bool)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    if (manager.heading.headingAccuracy > 5 || manager.heading.headingAccuracy < 0) {
        return true;
    }

    return false;
}

@end