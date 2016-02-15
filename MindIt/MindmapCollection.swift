    //
    //  MindmapCollection.swift
    //  MindIt
    //
    //  Created by Swapnil Gaikwad on 09/02/16.
    //  Copyright © 2016 ThoughtWorks Inc. All rights reserved.
    //
    
    import SwiftDDP
    
    class MindmapCollection: MeteorCollection<Node> {
        
        var delegate : CollectionDelegate!
        
        //MARK: Initialisers
        override init(name: String) {
            super.init(name: name)
        }
        
        
        //MARK : Methods
        override func documentWasAdded(collection: String, id: String, fields: NSDictionary?) {
            super.documentWasAdded(collection, id: id, fields: fields)
            //sleep(1)
            print("Newly Added " , id)
            delegate.notifyDocumentChanged(id , fields:  fields)
        }
        
        //Delete Will nerver be called (Soft delete)
        override func documentWasRemoved(collection: String, id: String) {
            super.documentWasRemoved(collection, id: id)
            print("Newly Removed")
        }
        
        override func documentWasChanged(collection: String, id: String, fields: NSDictionary?, cleared: [String]?) {
            super.documentWasChanged(collection, id: id, fields: fields, cleared: cleared)
            print("Newly changed " , id)
            delegate.notifyDocumentChanged(id , fields:  fields)
        }
    }