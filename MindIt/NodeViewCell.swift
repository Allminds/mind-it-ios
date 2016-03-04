
import UIKit

class NodeViewCell: UITableViewCell {
    //MARK: Properties
    var node: Node?
    var presenter : TableViewPresenter?
    
    @IBOutlet weak var nodeDataLabel: UILabel!
    @IBOutlet weak var toggleImageView: UIImageView!
    @IBOutlet weak var leftPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var saperatorView: UIView!
    @IBOutlet weak var imageContainer: UIView!
    //MARK : Method
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(node: Node, presenter : TableViewPresenter) {
        self.presenter = presenter
        self.node = node
        
        self.setName(node.getName())
        
        if(node.isRoot()) {
            self.nodeDataLabel.font = UIFont.boldSystemFontOfSize(20)
            self.nodeDataLabel.textColor = UIColor.orangeColor()
            self.toggleImageView.image = UIImage()
        }
        else {
            self.nodeDataLabel.font = UIFont.systemFontOfSize(16)
            self.nodeDataLabel.textColor = UIColor.blackColor()
            self.setNodeImage(node.getNodeState())
            
            let tap = UITapGestureRecognizer(target: self, action: Selector("imageClicked"))
            imageContainer.addGestureRecognizer(tap)
        }
        saperatorView.hidden = (node.getId() != presenter.lastRightNode)
        leftPaddingConstraint.constant = CGFloat((node.getDepth()-1) * 20)
    }
    
    func setName(nodeName : String) {
        if(nodeName != "") {        // To add blank node on label
            nodeDataLabel.text = nodeName
        }
        else {
            nodeDataLabel.text = "  "
        }
    }
    
    func setNodeImage(state : String) {
        switch(state) {
            case Config.COLLAPSED:
                toggleImageView.image = UIImage(named: Config.COLLAPSED)
                break
            case Config.EXPANDED:
                toggleImageView.image = UIImage(named: Config.EXPANDED)
                break
            case Config.CHILD_NODE:
                toggleImageView.image = UIImage(named: Config.CHILD_NODE)
                break
            default:
                print("Didn't get state.")
        }
    }
    
    //Expand Collapse
    func imageClicked() {
        if(node?.getNodeState() == Config.EXPANDED) {
            //Collapse Node
            presenter!.removeSubtree(node!)   //removes subtree of that node from tableview
            toggleImageView.image = UIImage(named: Config.COLLAPSED)
            node?.setNodeState(Config.COLLAPSED)
        }
        else if(node?.getNodeState() == Config.COLLAPSED) {
            //Expand Node
            presenter!.addSubtree(node!) //add subtree of that node to tableview
            toggleImageView.image = UIImage(named: Config.EXPANDED)
            node?.setNodeState(Config.EXPANDED)
        }
    }
    
    
}

