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
    var isExpanded : Bool?
    var isChildNode : Bool?
    
    var presenter: TableViewPresenter!
    
    @IBOutlet weak var nodeDataLabel: UILabel!
    @IBOutlet weak var toggleImageView: UIImageView!
    
    //MARK : Method
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData(node: Node , presenter : TableViewPresenter) {
        self.node = node
        
        self.presenter = presenter
        
        nodeDataLabel.text = node.valueForKey("name") as? String;
        if(node.hasChilds()) {
            isChildNode = false
            isExpanded = true
            toggleImageView.image = UIImage(named: "2")
        }
        else {
            isChildNode = true
            toggleImageView.image = UIImage(named: "3")
        }
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("imageClicked"))
        toggleImageView.addGestureRecognizer(tap)
        toggleImageView.userInteractionEnabled = true
    }
    
    func imageClicked() {
        if(isChildNode == false) {
            if(isExpanded == true) {
                toggleImageView.image = UIImage(named: "1")
                isExpanded = false
            }
            else {
                toggleImageView.image = UIImage(named: "2")
                isExpanded = true
            }
        }
    }
    
    
}

