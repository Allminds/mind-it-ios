
import UIKit
import SwiftDDP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Meteor.client.logLevel = .Debug
        let meteorTracker : MeteorTracker = MeteorTracker.getInstance()
        
        if(meteorTracker.isConnectedToNetwork()) {
            Meteor.connect(Config.URL) {
                meteorTracker.connectToServer(Config.FIRST_CONNECT)
            }
        }
        return true
    }
    
}
