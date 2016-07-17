//
//  GameObject.swift
//  SwiftRPG
//
//  Created by andyge on 16/6/26.
//
//

import Foundation
import NavMesh2D

/// 游戏中场景中物件协议
public protocol GameObject:class {
    /// 唯一标识ID
    var uid: UInt64 { get }
    /// 名称
    var name: String { get }
    /// 标识
    var flag: Int { get }
    /// 当前位置
    var pos: Vector2D { get set }
    /// 所在三角形ID
    var triangleId: Int { get set }
    /// 该物件是否激活所在屏
    var isActiveGreen: Bool { get }
    
    /// 更新物件（帧更新)
    func update(date: Date)
    /// 物件所在屏变化
    func onGreenChanged(oldGreen: Int, newGreen: Int)
}
