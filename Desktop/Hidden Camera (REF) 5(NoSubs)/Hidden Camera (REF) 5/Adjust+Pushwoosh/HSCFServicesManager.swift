//
//  ServicesManager.swift
//  template
//
//  Created by Alexander N on 14.07.2023.
//

import Foundation
import UIKit
import Adjust
import Pushwoosh
import AppTrackingTransparency
import AdSupport

class ThirdPartyServicesManager {
    
    static let shared = ThirdPartyServicesManager()
    
    func initializeAdjust_HSCF() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        let yourAppToken = Configurations_HSCF.adjustToken
        #if DEBUG
        let environment = (ADJEnvironmentSandbox as? String)!
        #else
        let environment = (ADJEnvironmentProduction as? String)!
        #endif
        let adjustConfig = ADJConfig(appToken: yourAppToken, environment: environment)
        
        adjustConfig?.logLevel = ADJLogLevelVerbose

        Adjust.appDidLaunch(adjustConfig)
        
    }
    
    func initializePushwooshHSCF(delegate: PWMessagingDelegate, pushNotificationCompletion: @escaping () -> Void) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        //set custom delegate for push handling, in our case AppDelegate
        Pushwoosh.sharedInstance().delegate = delegate;
        PushNotificationManager.initialize(withAppCode: Configurations_HSCF.pushwooshToken, appName: Configurations_HSCF.pushwooshAppName)
        PWInAppManager.shared().resetBusinessCasesFrequencyCapping()
        PWGDPRManager.shared().showGDPRDeletionUI()
        Pushwoosh.sharedInstance().registerForPushNotifications { _, _ in
            self.makeATT_HSCF {
                pushNotificationCompletion()
            }
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    func initializeInApps_HSCF(){
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    
    func makeATT_HSCF(completion: @escaping () -> Void) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("Authorized")
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier
                        print("Пользователь разрешил доступ. IDFA: ", idfa)
                        let authorizationStatus = Adjust.appTrackingAuthorizationStatus()
                        Adjust.updateConversionValue(Int(authorizationStatus))
                        Adjust.checkForNewAttStatus()
                        print(ASIdentifierManager.shared().advertisingIdentifier)
                    case .denied:
                        print("Denied")
                    case .notDetermined:
                        print("Not Determined")
                    case .restricted:
                        print("Restricted")
                    @unknown default:
                        print("Unknown")
                    }
                    completion()
                }
        }
    }
}

