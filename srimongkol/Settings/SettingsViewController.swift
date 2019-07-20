//
//  SettingsViewController.swift
//  srimongkol
//
//  Created by win on 20/7/19.
//  Copyright © 2019 Srimongkol. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            
            if granted == true && error == nil {
                
                //NotificationsManager.schedule()
            }
        }
    }
}

class NotificationsManager {
    static func scheduleNotificationsForDateComponents(_ dateComponents: DateComponents) {
        let content = UNMutableNotificationContent()
        
        
        content.title = NSString.localizedUserNotificationString(forKey: String.localized(key: AllKey.hello) + "", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Rise and shine! It's morning time!", arguments: nil)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
        // Create the request object.
        let request = UNNotificationRequest(identifier: "weekday_\(0)", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
}
