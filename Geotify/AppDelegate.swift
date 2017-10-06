import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  let locationManager = CLLocationManager ()
  let center = UNUserNotificationCenter.current()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization ()
    // application.registerUserNotificationSettings (UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
    // UIApplication.shared.cancelAllLocalNotifications ()
    
    // Override point for customization after application launch.
    // let center = UNUserNotificationCenter.current()
    UNUserNotificationCenter.current().delegate = self
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
      // Enable or disable features based on authorization.
      if((error != nil)) {
        print("Request authorization failed!")
      } else {
        print("Request authorization succeeded!")
        self.showAlert()
        self.sendEnteredNotification(); ()
      }
    }
    return true
  }
  
  func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
  {
    completionHandler([.alert, .sound])
  }
  
  func showAlert() {
    let objAlert = UIAlertController(title: "Alert", message: "Request authorization succeeded", preferredStyle: UIAlertControllerStyle.alert)
    
    objAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    //self.presentViewController(objAlert, animated: true, completion: nil)
    
    UIApplication.shared.keyWindow?.rootViewController?.present(objAlert, animated: true, completion: nil)
  }
  
  func handleEvent(forRegion region: CLRegion!) {
    sendEnteredNotification();
    /*
    if UIApplication.shared.applicationState == .active {
      // guard let message = note (fromRegionIdentifier: region.identifier) else { return }
      // window?.rootViewController?.showAlert (withTitle: nil, message: message)
      sendEnteredNotification();
    } else {
      // let notification = UILocalNotification ()
      // notification.alertBody = note (fromRegionIdentifier: region.identifier)
      // notification.soundName = "Default"
      // UIApplication.shared.presentLocalNotificationNow (notification)
      sendEnteredNotification();
    } */
  }
  
  func sendEnteredNotification () {
    let content = UNMutableNotificationContent()
    content.title = "Entered Geofence "
    content.subtitle = "Entered"
    content.body = "Entered"
    content.badge = 1
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    
    let requestIdentifier = "EnterNotification"
    let request = UNNotificationRequest(identifier: requestIdentifier,
                                        content: content,
                                        trigger: trigger)
    center.add(request)
    {
      _ in
      // handle error
    }
  }
  
  func sendExitNotification () {
    let content = UNMutableNotificationContent()
    content.title = "Exited Geofence "
    content.subtitle = "Entered"
    content.body = "Exited"
    content.badge = 1
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    
    let requestIdentifier = "EnterNotification"
    let request = UNNotificationRequest(identifier: requestIdentifier,
                                        content: content,
                                        trigger: trigger)
    center.add(request)
    {
      _ in
      // handle error
    }
  }
  
  func locationManager (_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleEvent(forRegion: region)
    }
  }
  
  func locationManager (_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleEvent (forRegion: region)
    }
  }
  
  func note(fromRegionIdentifier identifier: String) -> String? {
    let savedItems     = UserDefaults.standard.array (forKey: PreferencesKeys.savedItems) as? [NSData]
    let geotifications = savedItems?.map {NSKeyedUnarchiver.unarchiveObject (with: $0 as Data) as? Geotification}
    let index          = geotifications?.index {$0?.identifier == identifier}
    return index != nil ? geotifications?[index!]?.note : nil
  }
  
}
