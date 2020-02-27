//
//  OrderList+CoreDataProperties.swift
//  OrderListGenerator
//
//  Created by Vitaliy on 27.02.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderList> {
        return NSFetchRequest<OrderList>(entityName: "OrderList")
    }

    @NSManaged public var name: String
    @NSManaged public var fields: NSSet

}

// MARK: Generated accessors for fields
extension OrderList {

    @objc(addFieldsObject:)
    @NSManaged public func addToFields(_ value: OrderField)

    @objc(removeFieldsObject:)
    @NSManaged public func removeFromFields(_ value: OrderField)

    @objc(addFields:)
    @NSManaged public func addToFields(_ values: NSSet)

    @objc(removeFields:)
    @NSManaged public func removeFromFields(_ values: NSSet)

}
