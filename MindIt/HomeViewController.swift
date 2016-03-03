
import UIKit

class HomeViewController: UIViewController {
    
    //MARK : Properties
    
    @IBOutlet weak var openMindmap: UIButton!
    @IBOutlet weak var mindmapIdTextField: UITextField!
    var mindmapIdInURL : String?
    
    //MARK : Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Default Id
        if(mindmapIdInURL == nil) {
            mindmapIdTextField.text = Config.MINDMAPID
        }
        else {
            mindmapIdTextField.text = mindmapIdInURL
        }
    }
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if(sender === openMindmap) {
            let text = mindmapIdTextField.text
            if(text == "") {
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender === openMindmap) {
            let mindmapId : String = mindmapIdTextField.text!;
            //Passing mindmap ID
            let tableViewController = segue.destinationViewController as! MindmapTableViewController;
            tableViewController.mindmapId = mindmapId
        }
    }
    override func viewWillAppear(animated: Bool) {
        let meteorTracker : MeteorTracker = MeteorTracker.getInstance()
        if(meteorTracker.mindmapId == nil){
            mindmapIdTextField.text = Config.MINDMAPID
        }
        else{
            mindmapIdTextField.text = meteorTracker.mindmapId
        }
    
    }
}
