//
//  Scene.swift
//  SwiftRPG
//
//  Created by andyge on 16/6/26.
//
//

import Foundation
import NavMesh2D

/// 弱引用，不托管生命周期
struct ObjectEntry {
    weak var object: GameObject? = nil
}

/// 地块屏
struct SceneGreen {
    /// 屏内物件列表
    var objectDic = [UInt64: ObjectEntry]()
    /// 激活屏物件数量
    var activeObjectCount = 0
}

/// 场景INFO
public protocol SceneInfoProtocol {
    /// 
    var infoId: Int { get }
    /// 是否是静态大地图（非副本地图)
    var isStatic: Bool { get }
    
    /// 地图宽度
    var width: Double { get }
    /// 地图高度
    var height: Double { get }
}

/// 场景类
public class Scene {
    /// 唯一实例ID
    public var uid: UInt32 = 0
    /// 配置Info
    public var info: SceneInfoProtocol
    /// 地图宽度
    public var width = 0.0
    /// 地图高度
    public var height = 0.0
    /// 地图场景中所有物件列表
    var objectDic = [UInt64: ObjectEntry]()
    /// 地图所有屏物件列表
    var greenObject: [SceneGreen]
    /// 是否地图上所有物件都激活
    public var isAllActived = true
    /// 需要激活屏的地图，已经激活的屏列表
    var activedGreenSet = Set<Int>()
    
    /// 初始化
    public required init(info: SceneInfoProtocol) {
        self.uid = 0
        self.info = info
        self.width = info.width
        self.height = info.height
        self.greenObject = [SceneGreen](repeating: SceneGreen(), count: SceneUtil.maxGreenSize)
    }
    
    /// 增加场景物件
    public func add(object: GameObject) throws {
        if object.pos.x < 0.0 || object.pos.y < 0.0 {
            throw RPGError.ObjectPosInvalid(object.uid, object.pos.x, object.pos.y)
        }
        if self.objectDic[object.uid] != nil {
            throw RPGError.ObjectIDHasExisted(object.uid)
        }
        
        self.objectDic[object.uid] = ObjectEntry(object: object)
        
        let green = SceneUtil.getGreen(pos: object.pos)
        if green < 0 || green >= self.greenObject.count {
            throw RPGError.ObjectGreenInvalid(object.uid, green)
        }
        
        self.greenObject[green].objectDic[object.uid] = ObjectEntry(object: object)
        
        // 没有地图全部激活，就是屏激活
        if !self.isAllActived {
            if object.isActiveGreen {
                self.greenObject[green].activeObjectCount += 1
                if !self.activedGreenSet.contains(green) {
                    self.activedGreenSet.insert(green)
                }
            }
        }
    }
    
    /// 删除场景物件
    public func remove(object: GameObject) throws {
        self.objectDic.removeValue(forKey: object.uid)
        
        let green = SceneUtil.getGreen(pos: object.pos)
        if green < 0 || green >= self.greenObject.count {
            throw RPGError.ObjectGreenInvalid(object.uid, green)
        }
        self.greenObject[green].objectDic.removeValue(forKey: object.uid)
        
        if !self.isAllActived {
            if object.isActiveGreen {
                self.greenObject[green].activeObjectCount -= 1
                if self.greenObject[green].activeObjectCount <= 0 && self.activedGreenSet.contains(green) {
                    self.activedGreenSet.remove(green)
                }
            }

        }

    }
    
    /// 删除场景物件
    public func remove(uid: UInt64) throws {
        //self.objectDic.removeValue(forKey: uid)
        if let object = self.getGameObject(uid: uid) {
            try self.remove(object: object)
        }
    }
    
    /// 获取场景物件
    public func getGameObject(uid: UInt64) -> GameObject? {
        return self.objectDic[uid]?.object
    }
    
    /// 物件坐标更新后要调用该方法，更改物件所在屏
    public func onGameObjectPosChanged(object: GameObject, oldPos: Vector2D) throws {
        let oldGreen = SceneUtil.getGreen(pos: oldPos)
        let newGreen = SceneUtil.getGreen(pos: object.pos)
        if oldGreen == newGreen {
            return
        }
        
        if oldGreen < 0 || oldGreen >= self.greenObject.count {
            throw RPGError.ObjectGreenInvalid(object.uid, oldGreen)
        }
        if newGreen < 0 || newGreen >= self.greenObject.count {
            throw RPGError.ObjectGreenInvalid(object.uid, newGreen)
        }
        
        // 旧屏删除物件，添加到新屏
        self.greenObject[oldGreen].objectDic.removeValue(forKey: object.uid)
        self.greenObject[newGreen].objectDic[object.uid] = ObjectEntry(object: object)
        
        // 通知物件屏变化
        object.onGreenChanged(oldGreen: oldGreen, newGreen: newGreen)
        
        if !self.isAllActived {
            // 激活所在屏
            if object.isActiveGreen {
                //self.activedGreenSet.insert(newGreen)
                if self.greenObject[oldGreen].objectDic.isEmpty {
                    self.activedGreenSet.remove(oldGreen)
                }
                self.activedGreenSet.insert(newGreen)
            }
        }
        
    }
    
    /// 帧更新
    public func update(date: Date) {
        if self.isAllActived {
            // 地图模型，所有物件默认激活
            for objectEntry in self.objectDic.values {
                if let object = objectEntry.object {
                    object.update(date: date)
                }
            }
        } else {
            // 激活的屏
            for green in self.activedGreenSet {
                for objectEntry in self.greenObject[green].objectDic.values {
                    if let object = objectEntry.object {
                        object.update(date: date)
                    }
                }
            }
        }
    }
}
