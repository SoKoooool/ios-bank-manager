//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

class BankManager {
    
    let lock = NSLock()
    let counter = OperationQueue()
    var clients = [Client]()
    var clientsWhoFinishedBusiness = [Client]()
    
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
        
        var client = Client(waitingNumber: waitingNumber, clientClass: randomClientClass, businessType: randomBusinessType, workIsDone: false)
        
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
    
    private func banking(number: UInt) -> Double {
        let numberOfClient = number
        var workTime: Double = 0
        
            for _ in 0..<numberOfClient {
                if self.clients.count == 0 { break }
                
                self.lock.lock()
                var clientInfo = self.clients.removeFirst()
                self.lock.unlock()
                
                workTime += clientInfo.businessType.rawValue
                self.workTask(order: &clientInfo)
            }
        return workTime
    }
    
    private func addToClient(personnel: UInt) {
        let block1 = BlockOperation {
            self.banking(number: personnel)
        }
        let block2 = BlockOperation {
            self.banking(number: personnel)
        }
        let block3 = BlockOperation {
            self.banking(number: personnel)
        }
        
        counter.addOperations([block1,block2,block3], waitUntilFinished: true)
    }
    
    func workTask(order: inout Client) {
        let tellerStartWorkMessage = "⭕️ \(order.waitingNumber)번 \(order.clientClass)고객님 \(order.businessType)업무 시작"
        let tellerFinishWorkMessage = "🛑 \(order.waitingNumber)번 \(order.clientClass)고객님 \(order.businessType)업무 완료"
        
        order.workIsDone = true
        clientsWhoFinishedBusiness.append(order)
        
        print(tellerStartWorkMessage)
        Thread.sleep(forTimeInterval: order.businessType.rawValue)
        print(tellerFinishWorkMessage)
    }
    
    func closeBank() {
        totalNumberOfClient = waitingNumber
        
        let closeBankMessage = "업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(Int(totalNumberOfClient))명이며, 총 업무시간은 \(Float(totalNumberOfClient) * 0.7)초입니다."
        
        print(closeBankMessage)
        
        waitingNumber = 0
        totalNumberOfClient = 0
    }
    
    func processOfTellerTask() {
        let numberOfClient = generateNumberOfClient()
        totalNumberOfClient = numberOfClient
        for _ in 1...numberOfClient {
            generateClient()
        }
        sortedByClientPriority()
        addToClient(personnel: numberOfClient)
        closeBank()
    }
}


