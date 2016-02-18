//
//  NodeTableViewCell.swift
//  MindIt
//
//  Created by Swapnil Gaikwad on 09/02/16.
//  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
//

import UIKit

class NodeViewCell: UITableViewCell {
    //MARK: Properties
    var node: Node?
    var presenter : TableViewPresenter?
    
    @IBOutlet weak var nodeDataLabel: UILabel!
    @IBOutlet weak var toggleImageView: UIImageView!
    @IBOutlet weak var leftPaddingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var saperatorView: UIView!
    
    
    //MARK : Method
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(node: Node, presenter : TableViewPresenter) {
        self.presenter = presenter
        self.node = node
        
        if(node.getName() == ""){        // To add blank node on label
            nodeDataLabel.text = "  "
        }else{
            nodeDataLabel.text = node.getName()
        }
        saperatorView.hidden = (node.getId() != presenter.lastRightNode)
    
         leftPaddingConstraint.constant = CGFloat(node.getDepth() * 20)
        
        if(node.isRoot()) {
            nodeDataLabel.font = UIFont.boldSystemFontOfSize(20)
            nodeDataLabel.textColor = UIColor.orangeColor()
            return
        }
        
        switch(node.getNodeState()) {
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
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("imageClicked"))
        toggleImageView.addGestureRecognizer(tap)
        toggleImageView.userInteractionEnabled = true
    }
    
    //Expand Collapse
    func imageClicked() {
        if(node?.getNodeState() == Config.EXPANDED) {
            //Collapse Node
            presenter!.removeSubtree(node!)
            toggleImageView.image = UIImage(named: Config.COLLAPSED)
            node?.setNodeState(Config.COLLAPSED)
        }
        else if(node?.getNodeState() == Config.COLLAPSED) {
            //Expand Node
            presenter!.addSubtree(node!)
            toggleImageView.image = UIImage(named: Config.EXPANDED)
            node?.setNodeState(Config.EXPANDED)
        }
    }
}

