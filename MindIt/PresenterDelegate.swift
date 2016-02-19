
import Foundation

protocol PresenterDelegate: NSObjectProtocol {
    func didConnectSuccessfully()
    func didFailToConnectWithError(error: String)
    func updateChanges()
}
