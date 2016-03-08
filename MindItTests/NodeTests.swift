
import XCTest
@testable import MindIt

class NodeTests : XCTestCase{
    let node : Node = Node(id: "abcd1234" ,fields: nil)
    func testgetId() {
        XCTAssertEqual(node.getId(), "abcd1234")
    }
    func testIsRoot() {
        XCTAssertEqual(node.isRoot(), true)
    }
    func testgetState() {s
        XCTAssertEqual(node.getNodeState() , Config.UNDEFINED)
    }
    
    
}