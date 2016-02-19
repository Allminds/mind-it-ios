import SwiftDDP

class Node: MeteorDocument {
    
    //MARK : Properties
    private var collection:String = "Mindmaps"
    private var id : String?
    private var parentId:String?
    private var position:String?
    private var rootId:String?
    private var left:[String]?
    private var right:[String]?
    private var name:String?
    private var childSubTree:[String]?
    private var index:Int?
    private var depth : Int?
    private var state: String = Config.UNDEFINED
    
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
            print("No Such element found : " , key);
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
    
    func isRoot() ->Bool {
        if(self.parentId == nil && self.rootId == nil){
            return true;
        }
        else{
            return false;
        }
    }
    
    func setDepth(depth : Int) {
        self.depth = depth
    }
    
    func setNodeState(state : String) {
        self.state = state
    }
    
    func hasChilds() -> Bool {
        if(parentId == nil) {
            if(left?.count > 0 || right?.count > 0) {
                return true
            }
            else {
                return false
            }
        }
        else if(childSubTree?.count == 0) {
            return false
        }
        else {
            return true
        }
    }
}
