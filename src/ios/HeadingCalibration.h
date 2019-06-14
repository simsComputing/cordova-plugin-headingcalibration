#import <Cordova/CDV.h>
#import <CoreLocation/CoreLocation.h>
#import <Cordova/CDVPlugin.h>

@interface HeadingCalibration : CDVPlugin <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager* locationManager;
@property (nonatomic) NSString* watchCalibrationCallbackId;
@property (nonatomic) bool runs;
@property (nonatomic) int accuracy;

- (void)watchCalibration:(CDVInvokedUrlCommand*)command;
- (void)stopWatchCalibration:(CDVInvokedUrlCommand*)command;
- (void)stop;

@end