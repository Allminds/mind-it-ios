import SwiftDDP

class Node: MeteorDocument {
    
    //MARK : Properties
    var id : String?
    var parentId:String?
    var position:String?
    var rootId:String?
    var left:[String]?
    var right:[String]?
    var name:String?
    var childSubTree:[String]?
    var index:Int?
    var depth : Int?
    var state: String = Config.UNDEFINED
    
    //MARK : Initialiser
    required init(id: String, fields: NSDictionary?) {
        super.init(id: id, fields: fields)
        self.id = id
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        switch(key) {
            
        case "parentId":
            parentId = value as? String;
            break
            
        case "position":
            position = value as? String;
            break
            
        case "rootId":
            rootId = value as? String;
            break
            
        case "left":
            left = value as? [String];
            break
            
        case "right":
            right = value as? [String];
            break
            
        case "name":
            name = value as? String;
            break
            
        case "childSubTree":
            childSubTree = value as? [String];
            break
        case "index":
            index = value as? Int;
            break
        default:
             break
        }
    }
    
    func getName() -> String {
        return self.name!
    }
    
    func getChildSubtree() -> [String] {
        return self.childSubTree!
    }
    
    func getRootId() -> String {
        if(isRoot()){
            return self.id!
        }
        else{
            return self.rootId!
        }
    }
    
    func getLeft() -> [String]{
        return self.left!
    }
    
    func getRight() -> [String]{
        return self.right!
    }
    
    func getDepth() -> Int{
        if(self.depth == nil) {
            self.depth = 0
        }
        return self.depth!
    }
    
    func getNodeState() -> String {
        return state
    }
    
    func getId() -> String {
        return id!
    }
    
    func getRootSubTree() -> [String] {
        return right! + left!
    }
    
    func isRoot() -> Bool {
        return self.rootId == nil
    }
    
    func setDepth(depth : Int) {
        self.depth = depth
    }
    
    func setNodeState(state : String) {
        self.state = state
    }
    
    func hasChilds() -> Bool {
        if(isRoot()) {
            return getRootSubTree().count > 0
        }
        else {
            return childSubTree?.count > 0
        }
    }
}