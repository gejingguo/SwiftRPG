//
//  GameObject.swift
//  SwiftRPG
//
//  Created by andyge on 16/6/26.
//
//

import Foundation
import NavMesh2D

/// 游戏中场景中物件
public class GameObject {
    /// 唯一标识ID
    public var uid: UInt64 = 0
    /// 名称
    public var name: String = ""
    /// 标识
    public var flag: Int = 0
    /// 当前位置
    public private(set) var pos = Vector2D()
    /// 所在三角形ID
    public private(set) var triangleId: Int = -1
    /// 该物件是否激活所在屏
    var isActiveGreen: Bool = false
    
    
    /// 当前朝向(单位向量)
    public var direct = Vector2D()
    /// 当前移动速度
    public var moveSpeed = 0.0
    /// 目标点(移动）
    public private(set) var moveTargetPos = Vector2D()
    /// 目标三角形（移动）
    public private(set) var moveTargetTriangle = -1
    /// 上次移动时间
    private var lastMoveTime = Date()
    
    
    /// 初始化
    public init(uid: UInt64, flag: Int, triangle: Int, pos: Vector2D) {
        self.uid = uid
        self.flag = flag
        self.triangleId = triangle
        self.pos = pos
    }
}

extension GameObject {
    /// 更新物件（帧更新)
    public func update(date: Date) {
        self.moveUpdate(date: date)
    }
    
    /// 物件所在屏变化
    public func onGreenChanged(oldGreen: Int, newGreen: Int) {
        
    }
    
    /// 设置移动目标，要保证可以直线无阻碍的移动到目标点
    public func setMoveTarget(triangleId: Int, pos: Vector2D) {
        self.moveTargetTriangle = triangleId
        self.moveTargetPos = pos
        self.lastMoveTime = Date()
        self.direct = normalize(vector: self.moveTargetPos - self.pos)
    }
    
    /// 移动更新
    private func moveUpdate(date: Date) {
        if self.moveTargetTriangle < 0 {
            return
        }
        
        // 检查是否移动到目标点
        let ab = self.moveTargetPos - self.pos
        let moveTime = date.timeIntervalSince(self.lastMoveTime)
        let moveLen = self.moveSpeed * moveTime
        if ab.length <= moveLen {
            self.pos = self.moveTargetPos
            self.triangleId = self.moveTargetTriangle
            self.moveTargetTriangle = -1
            self.moveTargetPos.reset()
            return
        }
        
        // 向目标移动
        self.pos = self.pos + self.direct * moveLen
        self.lastMoveTime = date
    }
}
