#import <Cordova/CDV.h>
#import <Cordova/CDVPlugin.h>

typedef struct {
  BOOL iPhone;
  BOOL iPad;
  BOOL iPhone4;
  BOOL iPhone5;
  BOOL iPhone6;
  BOOL iPhone6Plus;
  BOOL iPhoneX;
  BOOL iPhoneXS;
  BOOL iPhoneXR;
  BOOL iPhone11;
  BOOL iPhone15Pro;
  BOOL iPhone12;
  BOOL iPhone12ProMax;
  BOOL iPhone13;
  BOOL iPhone13ProMax;
  BOOL iPadPro11;
  BOOL iPadPro12_9;
  BOOL retina;
  
} CDV_iOSDevice;

@interface ScreenshotBlocker : CDVPlugin

@end
