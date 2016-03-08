
import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    //MARK : Properties
    
    @IBOutlet weak var openMindmap: UIButton!
    @IBOutlet weak var mindmapIdTextField: UITextField!
    var mindmapIdInURL : String?
    
    //MARK : Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "header")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        mindmapIdTextField.delegate = self
        mindmapIdTextField.text = mindmapIdInURL
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
            let text : String = mindmapIdTextField.text!;
            let mindmapId : String
            
            if(text.containsString("mindit.xyz/create/")) {
                let urlSpilt : [String] = text.componentsSeparatedByString("/")
                mindmapId = urlSpilt[urlSpilt.count - 1]
            }
            else {
                mindmapId = text
            }
            //Passing mindmap ID
            let tableViewController = segue.destinationViewController as! MindmapTableViewController;
            tableViewController.mindmapId = mindmapId
        }
    }
    override func viewWillAppear(animated: Bool) {
        let meteorTracker : MeteorTracker = MeteorTracker.getInstance()
        if(meteorTracker.mindmapId == nil){
            //mindmapIdTextField.text = Config.MINDMAPID
        }
        else{
            mindmapIdTextField.text = meteorTracker.mindmapId
        }
    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        mindmapIdTextField.resignFirstResponder()
        return true
    }
}
