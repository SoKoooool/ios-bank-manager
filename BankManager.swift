//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

class BankManager {
    let bankerQueue = OperationQueue()
    var banker: Int
    var customer: Int = 0
    
    init(banker: Int) {
        self.banker = banker
    }
    
    func openBank() {
        generationCustomer()
        print("은행 개점")
        workOfBanker()
    }
    
    func closeBank() {
        print("업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(customer)명이며, 총 업무시간은 \(Double(customer) * 0.7)초입니다.")
    }
    
    func generationCustomer() {
        let customerCount = Int.random(in: 10...30)
        customer = customerCount
    }
    
    func workOfBanker() {
        for _ in 0...customer {
            
        }
    }
}
