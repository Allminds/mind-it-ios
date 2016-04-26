
import UIKit
import SwiftDDP

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var isConnected : Bool = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        connectToServerMindIt(){ () -> Void in
        }
        
        return true
    }
    
    
    private func connectToServerMindIt(callback: ()-> Void) {
        if(isConnected == true) {
            callback()
            return
        }
        else {
            Meteor.client.logLevel = .Debug
            let meteorTracker : MeteorTracker = MeteorTracker.getInstance()
            
            if(meteorTracker.isConnectedToNetwork()) {
                Meteor.connect(Config.URL) {
                    self.isConnected = true
                    meteorTracker.connectToServer(Config.FIRST_CONNECT)
                    callback()
                }
            }
        }
    }
    
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        connectToServerMindIt({()-> Void in
            
            let id : String = self.getIdFromURL(String(url))
            
            //Render MindmapTableView
            if(id != "") {
                let currentNavC = self.window?.rootViewController as? UINavigationController
                let mindMapVC = currentNavC?.topViewController as? MindmapTableViewController
                if mindMapVC != nil {
                    mindMapVC?.mindmapId = id
                    mindMapVC?.retrieveMindMap()
                } else {
                    let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let navigationVC = mainStoryboard.instantiateInitialViewController() as! UINavigationController
                    let mindmapTableViewController : MindmapTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MindmapTableView") as! MindmapTableViewController
                    mindmapTableViewController.mindmapId = id
                    navigationVC.pushViewController(mindmapTableViewController, animated: false)
                    self.window?.rootViewController = navigationVC
                    self.window?.makeKeyAndVisible()
                }
            }
        })
        return true
    }
    
    
    private func getIdFromURL(url : String) -> String {
        var  id : String = ""
        
        if(url.containsString("mindit.xyz://create/")) {
            id = url.stringByReplacingOccurrencesOfString("mindit.xyz://create/", withString: "")
        }
        else if(url.containsString("mindit.xyz://sharedLink/")){
            id = "sharedLink/" + url.stringByReplacingOccurrencesOfString("mindit.xyz://sharedLink/", withString: "")
        }
        
        return id
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        Meteor.unsubscribe(Config.SUBSCRIPTION_NAME)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        MeteorTracker.getInstance().connectToServer(Config.FIRST_CONNECT)
    }
}
