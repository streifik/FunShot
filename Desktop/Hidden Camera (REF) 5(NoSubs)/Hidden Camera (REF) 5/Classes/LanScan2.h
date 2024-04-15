//
//  LanScan2.h
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 16.11.2023.
//

#import <Foundation/Foundation.h>

@protocol LANScanDelegate2 <NSObject>

#define MAX_IP_RANGE 254
#define TIMEOUT 0.1

#define DEVICE_NAME @"DEVICE_NAME"
#define DEVICE_IP_ADDRESS @"DEVICE_IP_ADDRESS"
#define DEVICE_MAC @"DEVICE_MAC"
#define DEVICE_BRAND @"DEVICE_BRAND"

@optional
- (void)lanScanDidFinishScanning;
- (void)lanScanDidFindNewDevice:(NSDictionary *) device;
- (void)lanScanHasUpdatedProgress:(NSInteger) counter address:(NSString*) address;
@end

@interface LanScan2 : NSObject

@property(nonatomic,weak) id<LANScanDelegate2> delegate;

- (id)initWithDelegate:(id<LANScanDelegate2>)delegate;
- (void)start_S32HP_lan;
- (void)stop_S32HP_lan;
- (NSString *)getMacAddress: (NSString*)deviceIpAddress;
- (NSString *)getMacAddressMyCustom;
@end
