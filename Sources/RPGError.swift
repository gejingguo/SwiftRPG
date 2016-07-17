//
//  RPGError.swift
//  SwiftRPG
//
//  Created by andyge on 16/7/16.
//
//

import Foundation

public protocol RPGErrorProtocol: ErrorProtocol {
    var code: Int { get }
}

public enum RPGError {
    case ObjectIDHasExisted(UInt64)
    case ObjectPosInvalid(UInt64, Double, Double)
    case ObjectGreenInvalid(UInt64, Int)
}

extension RPGError: RPGErrorProtocol {
    public var code: Int {
        switch self {
        case .ObjectIDHasExisted:
            return 1
        case .ObjectPosInvalid:
            return 2
        case .ObjectGreenInvalid:
            return 3
        }
    }
}

extension RPGError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ObjectIDHasExisted(let uid):
            return "game object id:\(uid) has exited."
        case .ObjectPosInvalid(let uid, let x, let y):
            return "game object id:\(uid) pos:\(x),\(y) invalid."
        case .ObjectGreenInvalid(let uid, let green):
            return "game object id:\(uid) green:\(green) invalid."
        }
    }
}

//public extension RPGError
