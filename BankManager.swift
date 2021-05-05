//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

class BankManager {
    let counter = OperationQueue()
    var clients = [Client]()
    
    private var numberOfTeller: UInt
    private var totalNumberOfClient: UInt = 0
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
    
    func sortedByClientPriority() {
        for y in 0..<clients.count {
            for x in 0..<clients.count {
                if clients[y].clientClass > clients[x].clientClass {
                    let tempClientInformation = clients[y]
                    clients[y] = clients[x]
                    clients[x] = tempClientInformation
                }
            }
        }
    }
    
    private func addToClient(number: UInt) {
           for index in 0..<clients.count {
               counter.addOperation {
                   self.workTask(order: self.clients[index])
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
    
    func processOfTellerTask() {
        let numberOfClient = generateNumberOfClient()
        totalNumberOfClient = numberOfClient
        for _ in 1...numberOfClient {
            generateClient()
        }
        sortedByClientPriority()
        addToClient(number: numberOfClient)
        counter.waitUntilAllOperationsAreFinished()
        closeBank()
    }
    
    func closeBank() {
        totalNumberOfClient = waitingNumber
        
        let closeBankMessage = "업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(Int(totalNumberOfClient))명이며, 총 업무시간은 \(Double(totalNumberOfClient) * 0.7)초입니다."
        
        print(closeBankMessage)
        
        waitingNumber = 0
        totalNumberOfClient = 0
    }
}
