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
    
    //MARK : Method
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(node: Node, presenter : TableViewPresenter) {
        self.presenter = presenter
        self.node = node
        
        nodeDataLabel.text = node.getName() + " " + String(node.getDepth())
        
        switch(node.getNodeState()) {
            case Config.COLLAPSED:
                toggleImageView.image = UIImage(named: "1")
                break
            case Config.EXPANDED:
                toggleImageView.image = UIImage(named: "2")
                break
            case Config.CHILD_NODE:
                toggleImageView.image = UIImage(named: "3")
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
            toggleImageView.image = UIImage(named: "1")
            node?.setNodeState(Config.COLLAPSED)
        }
        else if(node?.getNodeState() == Config.COLLAPSED) {
            //Expand Node
            presenter!.addSubtree(node!)
            toggleImageView.image = UIImage(named: "2")
            node?.setNodeState(Config.EXPANDED)
        }
    }
}

