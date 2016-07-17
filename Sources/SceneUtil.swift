//
//  SceneUtil.swift
//  SwiftRPG
//
//  Created by andyge on 16/7/17.
//
//

import Foundation
import NavMesh2D


/// 场景常量配置
class SceneUtil {
    /// 屏宽度
    static let greenWidth = 0.15
    /// 屏高度
    static let greenHeight = 0.15
    /// 横轴屏数量最大值
    static let maxGreenSizeX = 150
    /// 纵轴屏数量最大值
    static let maxGreenSizeY = 150
    /// 屏数量最大值
    static var maxGreenSize: Int {
        return maxGreenSizeX * maxGreenSizeY
    }
    /// 最大地图宽度
    static var maxWidth: Double {
        return greenWidth*Double(maxGreenSizeX)
    }
    /// 最大地图高度
    static var maxHeight: Double {
        return greenHeight * Double(maxGreenSizeY)
    }
    
    /// 获取坐标所在的屏索引
    static func getGreen(pos: Vector2D) -> Int {
        if pos.x > maxWidth {
            return -1
        }
        if pos.y > maxHeight {
            return -1
        }
        
        
        let greenX = Int(ceil(pos.x/greenWidth))
        let greenY = Int(ceil(pos.y/greenWidth))
        
        return greenY * maxGreenSizeX + greenX
    }
    
    /// 获取周围9屏索引列表
    static func getAroundGreenList(green: Int) -> [Int] {
        return []
    }
    
    /// 获取周围25屏索引列表
    static func getAround25GreenList(green: Int) -> [Int] {
        return []
    }
}
