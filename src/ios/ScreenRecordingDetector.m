//
//  ScreenRecordingDetector.m
//  ScreenCaptureDetector
//
 
#import "ScreenRecordingDetector.h"
 
float const kScreenRecordingDetectorTimerInterval = 1; // Reduced interval for faster detection
NSString *kScreenRecordingDetectorRecordingStatusChangedNotification = @"kScreenRecordingDetectorRecordingStatusChangedNotification";
 
@interface ScreenRecordingDetector()
 
@property BOOL lastRecordingState;
@property NSTimer *timer;
 
@end
 
@implementation ScreenRecordingDetector
 
+ (instancetype)sharedInstance {
    static ScreenRecordingDetector *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
 
- (id)init {
    if (self = [super init]) {
        // Initialize properties
        self.lastRecordingState = NO; // Default state: not recording
        self.timer = NULL;
    }
    return self;
}
 
- (BOOL)isRecording {
#if TARGET_IPHONE_SIMULATOR
    return NO; // Screen recording detection does not work on the simulator
#endif
    for (UIScreen *screen in UIScreen.screens) {
        if ([screen respondsToSelector:@selector(isCaptured)]) {
            // iOS 11+ has isCaptured method
            if ([screen performSelector:@selector(isCaptured)]) {
                return YES; // Screen capture is active
            } else if (screen.mirroredScreen) {
                return YES; // Screen mirroring is active
            }
        } else {
            // iOS version below 11.0
            if (screen.mirroredScreen) {
                return YES;
            }
        }
    }
    return NO;
}
 
+ (void)triggerDetectorTimer {
    ScreenRecordingDetector *detector = [ScreenRecordingDetector sharedInstance];
    if (detector.timer) {
        [self stopDetectorTimer];
    }
    // Immediate check for recording state
    [detector checkCurrentRecordingStatus:nil];
    // Start the timer for periodic checks
    detector.timer = [NSTimer scheduledTimerWithTimeInterval:kScreenRecordingDetectorTimerInterval
                                                      target:detector
                                                    selector:@selector(checkCurrentRecordingStatus:)
                                                    userInfo:nil
                                                     repeats:YES];
}
 
- (void)checkCurrentRecordingStatus:(NSTimer *)timer {
    BOOL isRecording = [self isRecording];
    if (isRecording != self.lastRecordingState) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:kScreenRecordingDetectorRecordingStatusChangedNotification object:nil];
    }
    self.lastRecordingState = isRecording;
}
 
+ (void)stopDetectorTimer {
    ScreenRecordingDetector *detector = [ScreenRecordingDetector sharedInstance];
    if (detector.timer) {
        [detector.timer invalidate];
        detector.timer = NULL;
    }
}
 
@end
