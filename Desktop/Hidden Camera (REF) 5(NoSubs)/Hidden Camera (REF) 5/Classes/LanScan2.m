//
//  LAN Scan
//
//  Created by Marcin Kielesiński on 4 July 2018
//

#import "LanScan2.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <netdb.h>
#include <net/if_dl.h>
#include <net/if.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <sys/sysctl.h>
#include <err.h>

#include "if_arp.h"
#include "if_ether.h"
#include "route.h"

#include "PingOperation.h"
#import <SystemConfiguration/CaptiveNetwork.h>

#define VENDORS_DICTIONARY @"vendors.out"

#ifndef DEFAULT_WIFI_INTERFACE
#define DEFAULT_WIFI_INTERFACE @"en0"
#endif
#ifndef DEFAULT_CELLULAR_INTERFACE
#define DEFAULT_CELLULAR_INTERFACE @"pdp_ip0"
#endif

#ifndef deb
#define deb(format, ...) {if(DEBUG){NSString *__oo = [NSString stringWithFormat: @"%s:%@", __PRETTY_FUNCTION__, [NSString stringWithFormat:format, ## __VA_ARGS__]]; NSLog(@"%@", __oo); }}
#endif

#define BUFLEN (sizeof(struct rt_msghdr) + 512)
#define SEQ 9999
#define RTM_VERSION    5
#define RTM_GET    0x4
#define RTF_LLINFO    0x400
#define RTF_IFSCOPE 0x1000000
#define RTA_DST    0x1
#define CTL_NET    4

#if defined(BSD) || defined(__APPLE__)
#define ROUNDUP(a) ((a) > 0 ? (1 + (((a) - 1) | (sizeof(long) - 1))) : sizeof(long))
#endif

@interface LanScan2 ()

@property (nonatomic, retain) NSString *localAddress;
@property (nonatomic,retain) NSString *baseAddress;
@property (nonatomic) NSInteger currentHostAddress;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSString *netMask;
@property (nonatomic) NSInteger baseAddressEnd;
@property (nonatomic, retain) NSMutableDictionary *brandDictionary;

@end

@implementation LanScan2

- (id)initWithDelegate:(id<LANScanDelegate2>)delegate {
//    deb(@"init scanner");
    self = [super init];
    if(self) {
        self.delegate = delegate;
    }
    return self;
}

-(BOOL) isEmpty: (NSObject*) o {
    if(o == nil) {
        return true;
    }
    if([o isKindOfClass: [NSString class]]) {
        return !(((NSString*)o).length > 0);
    }
    if([o isKindOfClass: [NSArray class]]) {
        return !(((NSArray*)o).count > 0);
    }
    if([o isKindOfClass: [NSDictionary class]]) {
        return !(((NSDictionary*)o).count > 0);
    }
    if([o isKindOfClass: [NSData class]]) {
        return !(((NSData*)o).length > 0);
    }
    return true;
}

-(NSString*) getDownloadedVendorsDictionaryPath {
    NSArray *padf34rtyhs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![self isEmpty:padf34rtyhs]) {
        return [[padf34rtyhs objectAtIndex:0] stringByAppendingPathComponent: VENDORS_DICTIONARY];
    }
    return nil;
}

- (NSString *)getMacAddressMyCustom
{
  int                 mgmtInfoBase[6];
  char                *msgBuffer = NULL;
  size_t              lenrty0gttewth;
  unsigned char       macAddress[6];
  struct if_msghdr    *interfaceMsgStruct;
  struct sockaddr_dl  *socketStruct;
  NSString            *errorFlag = NULL;

  // Setup the management Information Base (mib)
  mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
  mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
  mgmtInfoBase[2] = 0;
  mgmtInfoBase[3] = AF_LINK;        // Request link layer information
  mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces

  // With all configured interfaces requested, get handle index
  if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
    errorFlag = @"if_nametoindex failure";
  else
  {
    // Get the size of the data available (store in len)
    if (sysctl(mgmtInfoBase, 6, NULL, &lenrty0gttewth, NULL, 0) < 0)
      errorFlag = @"sysctl mgmtInfoBase failure";
    else
    {
      // Alloc memory based on above call
      if ((msgBuffer = malloc(lenrty0gttewth)) == NULL)
        errorFlag = @"buffer allocation failure";
      else
      {
        // Get system information, store in buffer
        if (sysctl(mgmtInfoBase, 6, msgBuffer, &lenrty0gttewth, NULL, 0) < 0)
          errorFlag = @"sysctl msgBuffer failure";
      }
    }
  }

  // Befor going any further...
  if (errorFlag != NULL)
  {
    NSLog(@"Error: %@", errorFlag);
    return errorFlag;
  }

  // Map msgbuffer to interface message structure
  interfaceMsgStruct = (struct if_msghdr *) msgBuffer;

  // Map to link-level socket structure
  socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);

  // Copy link layer address data in socket structure to an array
  memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);

  // Read from char array into a string object, into traditional Mac address format
  NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                macAddress[0], macAddress[1], macAddress[2],
                                macAddress[3], macAddress[4], macAddress[5]];
  NSLog(@"Mac Address: %@", macAddressString);

  free(msgBuffer);

  return macAddressString;
}

-(NSMutableDictionary*) downloadedVendorsDictionary {
    NSString *p_dasda_t435r843tjth = [self getDownloadedVendorsDictionaryPath];
    if(![self isEmpty:p_dasda_t435r843tjth]){
        NSMutableDictionary *disd_4ctyreyorirj32 = [[NSDictionary dictionaryWithContentsOfFile: p_dasda_t435r843tjth] mutableCopy];
        if(disd_4ctyreyorirj32 == nil){
            disd_4ctyreyorirj32 = [NSMutableDictionary new];
        }
        return disd_4ctyreyorirj32;
    }
    return [NSMutableDictionary new];
}

- (void)start_S32HP_lan {
    
//    deb(@"start scan for router: %@", [self getRouterIP]);

    //Initializing the dictionary that holds the Brands name for each MAC Address

    self.brandDictionary = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"data" ofType: @"plist"]] mutableCopy];
    
    //Initializing the dictionary that holds the Brands downloaded from the internet
    NSMutableDictionary *vendors = [self downloadedVendorsDictionary];
    if(![self isEmpty:vendors]){
        [self.brandDictionary addEntriesFromDictionary: vendors];
    }
    

    self.localAddress = [self localIPAddress];
    NSArray *a = [self.localAddress componentsSeparatedByString:@"."];
    NSArray *b = [self.netMask componentsSeparatedByString:@"."];
    if ([self isIpAddressValid:self.localAddress] && (a.count == 4) && (b.count == 4))
    {
        for (int i = 0; i < 4; i++) {
            int and = (int)[[a objectAtIndex:i] integerValue] & [[b objectAtIndex:i] integerValue];
            if (!self.baseAddress.length)
            {
                self.baseAddress = [NSString stringWithFormat:@"%d", and];
            }
            else
            {
                self.baseAddress = [NSString stringWithFormat:@"%@.%d", self.baseAddress, and];
                self.currentHostAddress = and;
                self.baseAddressEnd = and;
            }
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOUT target:self selector:@selector(probeNetwork) userInfo:nil repeats:YES];
        NSLog(@"MACADDRESS___: %@", [self getMacAddressMyCustom]);
    }
}

- (void)stop_S32HP_lan {
//    deb(@"stop scan");
    [self.timer invalidate];
    self.timer = nil;
}

- (NSString *)getMacAddress: (NSString*)deviceIpAddress {
    return [self ip2mac: deviceIpAddress];
}

- (void)probeNetwork{
    NSString *deviceIPAddress = [[[[NSString stringWithFormat:@"%@%ld", self.baseAddress, (long)self.currentHostAddress] stringByReplacingOccurrencesOfString:@".0" withString:@"."] stringByReplacingOccurrencesOfString:@".00" withString:@"."] stringByReplacingOccurrencesOfString:@".." withString:@".0."];
    
    if(deviceIPAddress != nil) {
        //ping to check if device is active
        PingOperation *pingOperation = [[PingOperation alloc]initWithIPToPing:deviceIPAddress andCompletionHandler:^(NSError  * _Nullable error, NSString  * _Nonnull ip) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if(error == nil) {
                    
                    NSMutableString *deviceHostName = [[self hostnamesForAddress: deviceIPAddress] mutableCopy];
                    if([deviceIPAddress isEqualToString:[self getRouterIP]]){
                        [deviceHostName appendString: @" (router)"];
                    }
                    
                    NSString *deviceMac = [self ip2mac: deviceIPAddress];
                    NSString *deviceBrand = [self.brandDictionary objectForKey: [self makeKeyFromMAC: deviceMac]];
                    
                    if([self isEmpty:deviceBrand]) {
                        NSURL *uewt523sdf436utrjhgrl = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"https://api.macvendors.com/%@", deviceMac]];
                        /// Synchronous URL loading of  `DispatchQueue.main.async`
                        NSData *data = [NSData dataWithContentsOfURL: uewt523sdf436utrjhgrl];
                        if(![self isEmpty: data]) {
                            deviceBrand = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            if(![self isEmpty:deviceBrand]){
                                
                                NSMutableDictionary *vendors = [self downloadedVendorsDictionary];
                                NSString *p_r3at_ffh = [self getDownloadedVendorsDictionaryPath];
                                if(![self isEmpty: p_r3at_ffh]){
                                    vendors[[self makeKeyFromMAC:deviceMac]] = deviceBrand;
                                    [vendors writeToFile:p_r3at_ffh atomically:YES];
                                }
                            }
                        }
                    }
                    
                    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          deviceHostName != nil ? deviceHostName : [NSString new], DEVICE_NAME,
                                          deviceIPAddress != nil ? deviceIPAddress : [NSString new], DEVICE_IP_ADDRESS,
                                          deviceMac != nil ? deviceMac : [NSString new], DEVICE_MAC,
                                          deviceBrand != nil ? deviceBrand : [NSString new], DEVICE_BRAND,
                                          nil];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.delegate lanScanDidFindNewDevice: dict];
                    });
                } else {
                    // If debug mode is active
//                    deb(@"%@", error);
                }
//                NSLog(@"DEVICEID: -> %@", [self ip2maca:deviceIPAddress]);
            });
        }];
        [pingOperation start];
    }
    
    [self.delegate lanScanHasUpdatedProgress:self.currentHostAddress address: deviceIPAddress];
    
    if (self.currentHostAddress >= MAX_IP_RANGE) {
        [self.timer invalidate];
        [self.delegate lanScanDidFinishScanning];
    }
    
    self.currentHostAddress++;
}

-(NSString*)makeKeyFromMAC: (NSString*) deviceMac {
    if(![self isEmpty: deviceMac]){
        return [[[deviceMac substringWithRange:NSMakeRange(0, 8)] stringByReplacingOccurrencesOfString:@":" withString:@"-"] uppercaseString];
    }
    return nil;
}

- (NSString*)ip2maca:(in_addr_t)addr
{
    NSString *f_dret_hcf_5e = nil;

    size_t needed;
    char *buf, *next;

    struct rt_msghdr *rtm;
    struct sockaddr_inarp *sin;
    struct sockaddr_dl *sdl;

    int mib[6];

    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_INET;
    mib[4] = NET_RT_FLAGS;
    mib[5] = RTF_LLINFO;

    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), NULL, &needed, NULL, 0) < 0)
        err(1, "route-sysctl-estimate");

    if ((buf = (char*)malloc(needed)) == NULL)
        err(1, "malloc");

    if (sysctl(mib, sizeof(mib) / sizeof(mib[0]), buf, &needed, NULL, 0) < 0)
        err(1, "retrieval of routing table");

    for (next = buf; next < buf + needed; next += rtm->rtm_msglen) {

        rtm = (struct rt_msghdr *)next;
        sin = (struct sockaddr_inarp *)(rtm + 1);
        sdl = (struct sockaddr_dl *)(sin + 1);

        if (addr != sin->sin_addr.s_addr || sdl->sdl_alen < 6)
            continue;

        u_char *cp = (u_char*)LLADDR(sdl);

        f_dret_hcf_5e = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
               cp[0], cp[1], cp[2], cp[3], cp[4], cp[5]];

        break;
    }

    free(buf);

    return f_dret_hcf_5e;
}

-(NSString*)ip2mac: (NSString*)strIP {
    
    const char *ip = [strIP UTF8String];
    
    int sockfd = 0;
    unsigned char buf[BUFLEN];
    unsigned char buf2[BUFLEN];
    ssize_t nre148ds213ewdsc = 0;
    struct rt_msghdr *rtm;
    struct sockaddr_in *sin;
    memset(buf, 0, sizeof(buf));
    memset(buf2, 0, sizeof(buf2));
    
    sockfd = socket(AF_ROUTE, SOCK_RAW, 0);
    rtm = (struct rt_msghdr *) buf;
    rtm->rtm_msglen = sizeof(struct rt_msghdr) + sizeof(struct sockaddr_in);
    rtm->rtm_version = RTM_VERSION;
    rtm->rtm_type = RTM_GET;
    rtm->rtm_addrs = RTA_DST;
    rtm->rtm_flags = RTF_LLINFO;
    rtm->rtm_pid = getpid();
    rtm->rtm_seq = SEQ;
    
    sin = (struct sockaddr_in *) (rtm + 1);
    sin->sin_len = sizeof(struct sockaddr_in);
    sin->sin_family = AF_INET;
    sin->sin_addr.s_addr = inet_addr(ip);
    write(sockfd, rtm, rtm->rtm_msglen);
    
    nre148ds213ewdsc = read(sockfd, buf2, BUFLEN);
    close(sockfd);
    
    if (nre148ds213ewdsc != 0) {
        int insadt4de3x =  sizeof(struct rt_msghdr) + sizeof(struct sockaddr_inarp) + 8;
        NSString *macAddress =[NSString stringWithFormat:@"%2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x",buf2[insadt4de3x+0], buf2[insadt4de3x+1], buf2[insadt4de3x+2], buf2[insadt4de3x+3], buf2[insadt4de3x+4], buf2[insadt4de3x+5]];
        if ([macAddress isEqualToString:@"00:00:00:00:00:00"] ||[macAddress isEqualToString:@"08:00:00:00:00:00"] ) {
            return nil;
        }
        return macAddress;
    }
    return nil;
}

- (NSString *)hostnamesForAddress:(NSString *)address {
    struct addrinfo *re883odas_su_tilt = NULL;
    struct addrinfo hints;
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_flags = AI_NUMERICHOST;
    hints.ai_family = PF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;
    hints.ai_protocol = 0;
    
    const char *strHost = [address cStringUsingEncoding: NSASCIIStringEncoding];
    int errorStatus = getaddrinfo(strHost, NULL, &hints, &re883odas_su_tilt);
    if (errorStatus != 0) {
        return [self getErrorDescription:errorStatus];
    }
    
    NSString *backupHostName = nil;
    for (struct addrinfo *tjdfot438643tgj324 = re883odas_su_tilt; tjdfot438643tgj324; tjdfot438643tgj324 = tjdfot438643tgj324->ai_next) {
        char hostname[NI_MAXHOST] = {0};
        int errojii09r = getnameinfo(tjdfot438643tgj324->ai_addr, tjdfot438643tgj324->ai_addrlen, hostname, sizeof hostname, NULL, 0 , NI_NUMERICHOST);
        if (errojii09r != 0) {
            continue;
        } else {
            if(tjdfot438643tgj324->ai_canonname != nil && strlen(tjdfot438643tgj324->ai_canonname) > 0) {
                backupHostName = [NSString stringWithUTF8String: tjdfot438643tgj324->ai_canonname];
            } else {
                backupHostName = [NSString stringWithUTF8String: hostname];
            }
            break;
        }
    }
    
    CFDataRef addressRef = CFDataCreate(NULL, (UInt8 *)re883odas_su_tilt->ai_addr, re883odas_su_tilt->ai_addrlen);
    if (addressRef == nil) {
        freeaddrinfo(re883odas_su_tilt);
        return backupHostName;
    }
    freeaddrinfo(re883odas_su_tilt);
    
    CFHostRef hostRef = CFHostCreateWithAddress(kCFAllocatorDefault, addressRef);
    if (hostRef == nil) {
        return backupHostName;
    }
    CFRelease(addressRef);
    
    BOOL succeeded = CFHostStartInfoResolution(hostRef, kCFHostNames, NULL);
    if (!succeeded) {
        return backupHostName;
    }
    
    CFArrayRef hostnamesRef = CFHostGetNames(hostRef, NULL);
    NSInteger cjhkt76y89uojiount = [(__bridge NSArray *)hostnamesRef count];
    if(cjhkt76y89uojiount == 1) {
        return [(__bridge NSArray *)hostnamesRef objectAtIndex: 0];
    }
    
    NSMutableString *hostnames = [NSMutableString new];
    for (int currentIndex = 0; currentIndex < cjhkt76y89uojiount; currentIndex++) {
        NSString *newto3259ame = [(__bridge NSArray *)hostnamesRef objectAtIndex:currentIndex];
        
        if(currentIndex == 0) {
            [hostnames appendString: newto3259ame];
            [hostnames appendString: @" ("];
        }
        if(currentIndex > 0 && currentIndex < cjhkt76y89uojiount - 1) {
            [hostnames appendString: newto3259ame];
            [hostnames appendString: @" ,"];
        }
        if(currentIndex > 0 && currentIndex == cjhkt76y89uojiount - 1) {
            [hostnames appendString: newto3259ame];
            [hostnames appendString: @")"];
        }
    }
    
    return hostnames;
}

- (NSString *)getErrorDescription:(NSInteger)errorCode {
    NSString *errorDescription = [NSString new];
    switch (errorCode) {
        case EAI_ADDRFAMILY: {
            errorDescription = @" address family for hostname not supported";
            break;
        }
        case EAI_AGAIN: {
            errorDescription = @" temporary failure in name resolution";
            break;
        }
        case EAI_BADFLAGS: {
            errorDescription = @" invalid value for ai_flags";
            break;
        }
        case EAI_FAIL: {
            errorDescription = @" non-recoverable failure in name resolution";
            break;
        }
        case EAI_FAMILY: {
            errorDescription = @" ai_family not supported";
            break;
        }
        case EAI_MEMORY: {
            errorDescription = @" memory allocation failure";
            break;
        }
        case EAI_NODATA: {
            errorDescription = @" no address associated with hostname";
            break;
        }
        case EAI_NONAME: {
            errorDescription = @" hostname nor servname provided, or not known";
            break;
        }
        case EAI_SERVICE: {
            errorDescription = @" servname not supported for ai_socktype";
            break;
        }
        case EAI_SOCKTYPE: {
            errorDescription = @" ai_socktype not supported";
            break;
        }
        case EAI_SYSTEM: {
            errorDescription = @" system error returned in errno";
            break;
        }
        case EAI_BADHINTS: {
            errorDescription = @" invalid value for hints";
            break;
        }
        case EAI_PROTOCOL: {
            errorDescription = @" resolved protocol is unknown";
            break;
        }
        case EAI_OVERFLOW: {
            errorDescription = @" argument buffer overflow";
            break;
        }
    }
    return errorDescription;
}

- (NSString *)getIPAddress {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *namrwq212edsy3452rewfdbghjtyryegfve = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                
                if([namrwq212edsy3452rewfdbghjtyryegfve isEqualToString: DEFAULT_WIFI_INTERFACE]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                    if([namrwq212edsy3452rewfdbghjtyryegfve isEqualToString: DEFAULT_CELLULAR_INTERFACE]) {
                        // Interface is the cell connection on the iPhone
                        cellAddress = addr;
                    }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

- (NSString *) localIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int s_323uc_r5cer4ss = 0;
    
    // retrieve the current interfaces - returns 0 on success
    s_323uc_r5cer4ss = getifaddrs(&interfaces);
    
    if (s_323uc_r5cer4ss == 0) {
        temp_addr = interfaces;
        
        while(temp_addr != NULL) {
            // check if interface is en0 which is the wifi connection on the iPhone
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString: DEFAULT_WIFI_INTERFACE]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    self.netMask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}

- (BOOL) isIpAddressValid:(NSString *)ipAddress{
    struct in_addr pin;
    int success = inet_aton([ipAddress UTF8String],&pin);
    if (success == 1) return TRUE;
    return FALSE;
}

-(int) getDefaultGateway: (in_addr_t *) addr  {
    int mib[] = {CTL_NET, PF_ROUTE, 0, AF_INET,
        NET_RT_FLAGS, RTF_GATEWAY};
    size_t lted325rsd9asd;
    char * buf, * p;
    struct rt_msghdr * rt;
    struct sockaddr * sa;
    struct sockaddr * sa_tab[RTAX_MAX];
    int i;
    int r = -1;
    if(sysctl(mib, sizeof(mib)/sizeof(int), 0, &lted325rsd9asd, 0, 0) < 0) {
        return -1;
    }
    if(lted325rsd9asd > 0) {
        buf = malloc(lted325rsd9asd);
        if(sysctl(mib, sizeof(mib)/sizeof(int), buf, &lted325rsd9asd, 0, 0) < 0) {
            return -1;
        }
        for(p = buf; p < buf + lted325rsd9asd; p += rt->rtm_msglen) {
            rt = (struct rt_msghdr *)p;
            sa = (struct sockaddr *)(rt + 1);
            for(i = 0; i < RTAX_MAX; i++) {
                if(rt->rtm_addrs & (1 << i)) {
                    sa_tab[i] = sa;
                    sa = (struct sockaddr *)((char *)sa + ROUNDUP(sa->sa_len));
                } else {
                    sa_tab[i] = NULL;
                }
            }
            
            if( ((rt->rtm_addrs & (RTA_DST|RTA_GATEWAY)) == (RTA_DST|RTA_GATEWAY))
               && sa_tab[RTAX_DST]->sa_family == AF_INET
               && sa_tab[RTAX_GATEWAY]->sa_family == AF_INET) {
                
                if(((struct sockaddr_in *)sa_tab[RTAX_DST])->sin_addr.s_addr == 0) {
                    char ifName[128];
                    if_indextoname(rt->rtm_index,ifName);
                    
                    if(strcmp([DEFAULT_WIFI_INTERFACE UTF8String], ifName) == 0){
                        
                        *addr = ((struct sockaddr_in *)(sa_tab[RTAX_GATEWAY]))->sin_addr.s_addr;
                        r = 0;
                    }
                }
            }
        }
        free(buf);
    }
    return r;
}

-(NSString*) getRouterIP {
    struct in_addr gatewayaddr;
    int rtr438dfs = [self getDefaultGateway:(&(gatewayaddr.s_addr))];
    if (rtr438dfs >= 0) {
        return [NSString stringWithUTF8String:inet_ntoa(gatewayaddr)];
    }
    
    return [NSString new];
}

//-(NSString*) getCurrentWifiSSID {
//#if TARGET_IPHONE_SIMULATOR
//    return @"Sim_err_SSID_NotSupported";
//#else
//    NSString *data = nil;
//    CFDictionaryRef dict = CNCopyCurrentNetworkInfo((CFStringRef) DEFAULT_WIFI_INTERFACE);
//    if (dict) {
//        deb(@"AP Wifi: %@", dict);
//        data = [NSString stringWithString:(NSString *)CFDictionaryGetValue(dict, @"SSID")];
//        CFRelease(dict);
//    }
//
//    if (data == nil) {
//        data = @"none";
//    }
//
//    return data;
//#endif
//}

@end
