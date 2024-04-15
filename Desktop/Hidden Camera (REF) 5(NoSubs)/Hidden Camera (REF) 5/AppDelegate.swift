//
//  AppDelegate.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//


import UIKit
import CoreData
import Pushwoosh
import Adjust
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      
        HSCFNetworkMonitor.shared.startMonitoring_HSCF()
        
        window = UIWindow()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up AVAudioSession: \(error.localizedDescription)")
        }
        
        ThirdPartyServicesManager.shared.initializeAdjust_HSCF()
        ThirdPartyServicesManager.shared.initializeInApps_HSCF()
        ThirdPartyServicesManager.shared.initializePushwooshHSCF(delegate: self) {}
        
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        func sasfgewrtewdf(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        prepareAppearence()
        let initial = InitialViewController()
        self.window?.rootViewController = initial
        self.window?.makeKeyAndVisible()
        return true
    }
    
    
    private func prepareAppearence() {

        let navigationBarAppearance = UINavigationBarAppearance()
        let backButton = UIBarButtonItemAppearance()
        backButton.normal.backgroundImage = UIImage()
        navigationBarAppearance.backgroundColor = UIColor.white
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont.inter(.InterMedium, size: 20)]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBarAppearance.backButtonAppearance = backButton
        
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        UINavigationBar.appearance().backIndicatorImage = UIImage()
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage()
        
//        let tabbarAppearance = UITabBarAppearance()
//        tabbarAppearance.backgroundColor = UIColor.tabbarBackground
//        UITabBar.appearance().standardAppearance = tabbarAppearance
//        UITabBar.appearance().scrollEdgeAppearance = tabbarAppearance
//
//        tabbarAppearenceSettings(tabbarAppearance.stackedLayoutAppearance)
//        tabbarAppearenceSettings(tabbarAppearance.inlineLayoutAppearance)
//        tabbarAppearenceSettings(tabbarAppearance.compactInlineLayoutAppearance)
        
        UIViewController.classInit
    }
    
    private func tabbarAppearenceSettings(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = UIColor.tabbarItem
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tabbarItem]
         
        itemAppearance.selected.iconColor = UIColor.tabbarItemSelected
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tabbarItemSelected]
    }
}

typealias SO_APP_DEL_GAT_HSCF = AppDelegate

extension SO_APP_DEL_GAT_HSCF : PWMessagingDelegate, UITableViewDelegate {
    
    //handle token received from APNS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Adjust.setDeviceToken(deviceToken)
        Pushwoosh.sharedInstance().handlePushRegistration(deviceToken)
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    //handle token receiving error
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        Pushwoosh.sharedInstance().handlePushRegistrationFailure(error);
    }
    
    //this is for iOS < 10 and for silent push notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Pushwoosh.sharedInstance().handlePushReceived(userInfo)
        completionHandler(.noData)
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    //this event is fired when the push gets received
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageReceived message: PWMessage) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        print("onMessageReceived: ", message.payload?.description ?? "error")
    }
    
    //this event is fired when a user taps the notification
    func pushwoosh(_ pushwoosh: Pushwoosh, onMessageOpened message: PWMessage) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        print("onMessageOpened: ", message.payload?.description ?? "error")
    }
}
