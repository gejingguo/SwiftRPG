//
//  SceneManager.swift
//  SwiftRPG
//
//  Created by andyge on 16/7/17.
//
//

import Foundation

struct SceneEntry {
    weak var scene: Scene?
}

/// 场景管理器，单例模式
public class SceneManager {
    /// 场景ID分配序列最大值
    var maxUid: UInt32 = 0
    /// 静态地图索引
    var staticSceneDic = [Int: SceneEntry]()
    /// 实例索引
    var sceneDic = [UInt32: Scene]()
    
    /// 单例实例对象
    public static var sharedInstance = SceneManager()
    
    private init() {
        
    }
    
    /// 分配新的场景对象
    public func alloc(info: SceneInfoProtocol) -> Scene {
        let scene = Scene(info: info)
        self.maxUid += 1
        scene.uid = self.maxUid
        
        self.sceneDic[scene.uid] = scene
        
        if info.isStatic {
            self.staticSceneDic[info.infoId] = SceneEntry(scene: scene)
        }
        return scene
    }
    
    /// 删除实例
    public func remove(scene: Scene) {
        self.sceneDic.removeValue(forKey: scene.uid)
        if scene.info.isStatic {
            self.staticSceneDic.removeValue(forKey: scene.info.infoId)
        }
    }
    
    /// 删除实例
    public func remove(uid: UInt32) {
        if let scene = self.get(uid: uid) {
            self.remove(scene: scene)
        }
    }
    
    /// 获取
    public func get(uid: UInt32) -> Scene? {
        return self.sceneDic[uid]
    }
    
    /// 获取
    public func get(infoId: Int) -> Scene? {
        return self.staticSceneDic[infoId]?.scene
    }
    
    /// 更新
    public func update(date: Date) {
        for scene in self.sceneDic.values {
            scene.update(date: date)
        }
    }
}
