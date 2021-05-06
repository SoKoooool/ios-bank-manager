//
//  Client.swift
//  BankManagerConsoleApp
//
//  Created by TORI on 2021/05/04.
//

import Foundation

enum ClientType: Int, CaseIterable, Comparable {
    case VVIP = 2
    case VIP = 1
    case 일반 = 0
    
    static func < (lhs: ClientType, rhs: ClientType) -> Bool {
        if (lhs == .일반 && rhs == .VIP)
        || (lhs == .일반 && rhs == .VVIP)
        || (lhs == .VIP && rhs == .VVIP) {
            return true
        } else {
            return false
        }
    }
}

enum BusinessType: Double, CaseIterable {
    case 예금 = 0.7
    case 대출 = 1.1
}

struct Client {
    let waitingNumber: UInt
    let clientClass: ClientType
    let businessType: BusinessType
    var workIsDone: Bool
}
