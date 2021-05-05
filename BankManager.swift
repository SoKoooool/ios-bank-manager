//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

class BankManager {
    let counter = OperationQueue()
    var clients = [Client]()
    
    private var numberOfClient: UInt = 0
    private var numberOfTeller: UInt
    private var waitingNumber: UInt = 0
    
    init(numberOfTeller: UInt) {
        self.numberOfTeller = numberOfTeller
        counter.maxConcurrentOperationCount = Int(numberOfTeller)
    }
    
    private func generateNumberOfClient() -> UInt {
        let numberOfClient = Int.random(in: 10...30)
        return UInt(numberOfClient)
    }
    
    private func generateClient() {
        waitingNumber += 1
        
        guard let randomClientClass = ClientType.allCases.randomElement(),
              let randomBusinessType = BusinessType.allCases.randomElement() else {
            return
        }
        
        let client = Client(waitingNumber: waitingNumber, clientClass: randomClientClass, businessType: randomBusinessType)
        
        clients.append(client)
    }

    private func addToClient(number: UInt) {
        for index in 0..<numberOfClient {
            counter.addOperation {
                self.workTask(order: self.clients[Int(index)])
            }
        }
    }
    
    
    func workTask(order: Client) {
        let tellerStartWorkMessage = "\(order.waitingNumber)번 \(order.clientClass)고객님 \(order.businessType)업무 시작"
        let tellerFinishWorkMessage = "\(order.waitingNumber)번 \(order.clientClass)고객님 \(order.businessType)업무 완료★"
        
        print(tellerStartWorkMessage)
        Thread.sleep(forTimeInterval: 0.7)
        print(tellerFinishWorkMessage)
    }
    
    func processOfTellerTask(_ completion: @escaping () -> Void) {
        let number = generateNumberOfClient()
        for _ in 1...number {
            generateClient()
        }
        addToClient(number: number)
//        counter.waitUntilAllOperationsAreFinished()
        closeBank()
        completion()
    }
    
    func closeBank() {
        waitingNumber = 1
        let closeBankMessage = "업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(numberOfClient)명이며, 총 업무시간은 \(Double(numberOfClient) * 0.7)초입니다."
        
        print(closeBankMessage)
    }
}
