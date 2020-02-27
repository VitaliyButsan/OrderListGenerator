//
//  OrderFieldViewModel.swift
//  OrderListGenerator
//
//  Created by Vitaliy on 27.02.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import Foundation

class OrderFieldViewModel {
    
    private let dataManager = CoreDataManager()
    var orders: [Order] = []
    
    func setupData() {
        var newFields: [Field] = []
        
        for num in 1...100_000 {
            let field = Field(id: num, title: UUID().uuidString)
            newFields.append(field)
        }
        
        dataManager.write(orderFields: newFields)
    }
    
    func getOrders(callback: @escaping (Bool) -> Void) {
        dataManager.readOrders { result in
            if let result = result {
                self.orders = result
                callback(true)
            } else {
                callback(false)
            }
        }
    }
    
    func delAllData(_ entityName: String) {
        dataManager.deleteAllData(entityName)
    }
}
