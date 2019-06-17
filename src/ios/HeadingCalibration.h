#import <Cordova/CDV.h>
#import <CoreLocation/CoreLocation.h>
#import <Cordova/CDVPlugin.h>

@interface HeadingCalibration : CDVPlugin <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) NSString* watchCalibrationCallbackId;
@property (nonatomic) double accuracy;
@property (nonatomic) bool isCalibrationCallbackFirstCall;

- (void)watchCalibration:(CDVInvokedUrlCommand*)command;
- (void)stopWatchCalibration:(CDVInvokedUrlCommand*)command;
- (void)stop;

@end