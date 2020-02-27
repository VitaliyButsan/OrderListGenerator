//
//  CoreDataManager.swift
//  OrderListGenerator
//
//  Created by Vitaliy on 27.02.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    // read
    func readOrders(callback: @escaping ([Order]?) -> Void) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.persistentContainer.performBackgroundTask { context in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderList")
            var orders: [Order] = []
            
            do {
                let result = try context.fetch(fetchRequest) as! [OrderList]
                for obj in result {
                    let fields = obj.value(forKey: "fields") as? Set<OrderField> ?? []
                    guard let firstField = fields.first else { return }
                    let field = Field(id: Int(firstField.id), title: firstField.title)
                    let order = Order(field: field)
                    
                    orders.append(order)
                }
                callback(orders)
            } catch {
                print(error)
                callback(nil)
            }
        }
    }
    
    // write
    func write(orderFields: [Field]) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        delegate.persistentContainer.performBackgroundTask { context in
            for field in orderFields {
                guard let orderFieldEntity = NSEntityDescription.entity(forEntityName: "OrderField", in: context) else { return }
                guard let orderListEntity = NSEntityDescription.entity(forEntityName: "OrderList", in: context) else { return }
                let managedOrderField = NSManagedObject(entity: orderFieldEntity, insertInto: context) as! OrderField
                let managedOrderList = NSManagedObject(entity: orderListEntity, insertInto: context) as! OrderList
                
                managedOrderField.id = Int64(field.id)
                managedOrderField.title = field.title
                managedOrderField.owner = managedOrderList
                
                managedOrderList.name = String(describing: field.id)
                managedOrderList.fields.adding(managedOrderField)
            }
            
            self.save(context: context)
        }
    }
    
    // delete
    func deleteAllData(_ entityName: String) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.persistentContainer.performBackgroundTask { context in
        
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
                print("All \(entityName) data deleted.")
            } catch {
                print(error)
            }
            
            self.save(context: context)
        }
    }
    
    // save context
    private func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Could not save context. \(error)")
        }
    }
}
