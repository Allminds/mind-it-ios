
import XCTest
@testable import MindIt
class MeteorTracketTests: XCTestCase {
    let meteorTracker : MeteorTracker = MeteorTracker.getInstance()
    
    func connectToServerTest(){
        meteorTracker.mindmapId = nil;
        XCTAssertEqual(meteorTracker.connectToServer(Config.FIRST_CONNECT), false, "Should return false when mindmapId is Not Set and connectToServer is called with firstConnect")
     
        meteorTracker.mindmapId = "78drh54R"
        XCTAssertEqual(meteorTracker.connectToServer(Config.FIRST_CONNECT), true, "Should Return True When mindmapId is set and connectrToServerCalled with config.firstConnect")
    }
    
    
}