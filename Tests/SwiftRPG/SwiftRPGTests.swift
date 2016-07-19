import XCTest
@testable import SwiftRPG
import NavMesh2D
import Foundation

struct MapInfo: SceneInfoProtocol {
    ///
    var infoId: Int = 0
    /// 是否是静态大地图（非副本地图)
    var isStatic: Bool = false
    
    /// 地图宽度
    var width: Double = 0.0
    /// 地图高度
    var height: Double = 0.0
}

class SwiftRPGTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SwiftRPG().text, "Hello, World!")
    }
    
    func testSceneManager() {
        let info = MapInfo(infoId: 1001, isStatic: true, width: 100.0, height: 100.0)
        let scene = SceneManager.sharedInstance.alloc(info: info)
        //XCTAssert(<#T##expression: Boolean##Boolean#>)
        if let getScene = SceneManager.sharedInstance.get(uid: scene.uid) {
            XCTAssert(scene.uid == getScene.uid)
        }
        //XCTAssertNotNil(getScene)
        SceneManager.sharedInstance.remove(uid: scene.uid)
        if SceneManager.sharedInstance.get(uid: scene.uid) != nil {
            XCTAssert(false)
        }
    }

    func testGameObject() throws {
        let info = MapInfo(infoId: 1001, isStatic: true, width: 100.0, height: 100.0)
        let scene = SceneManager.sharedInstance.alloc(info: info)
        let gameObject = GameObject(uid: 10001, flag: 1, triangle: 1, pos: Vector2D(x: 0.5, y: 0.5))
        gameObject.moveSpeed = 0.4
        //gameObject.direct = Vector2D(x: 1.0, y: <#T##Double#>)
        try scene.add(object: gameObject)
        XCTAssert(scene.getGameObject(uid: 10001) != nil)
        //XCTAssert(scene.getGameObject(uid: 10001) == nil)
        try scene.remove(object: gameObject)
        XCTAssert(scene.getGameObject(uid: 10001) == nil)
        try scene.add(object: gameObject)
        XCTAssert(scene.getGameObject(uid: 10001) != nil)
        
        // test move
        gameObject.setMoveTarget(triangleId: 2, pos: Vector2D(x: 5.5, y: 8.7))
        
        for _ in 0..<50 {
            SceneManager.sharedInstance.update(date: Date())
            print("gameobject pos:", gameObject.pos.x, gameObject.pos.y)
            sleep(1)
        }
    }

    static var allTests : [(String, (SwiftRPGTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
            ("testSceneManager", testSceneManager),
            ("testGameObject", testGameObject),
        ]
    }
}
