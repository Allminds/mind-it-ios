
import Foundation

protocol TrackerDelegate: NSObjectProtocol {
    func connected(result: String)
    func notifyDocumentChanged(id : String , fields : NSDictionary?)
}