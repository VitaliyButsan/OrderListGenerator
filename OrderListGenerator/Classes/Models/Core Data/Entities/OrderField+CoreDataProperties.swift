//
//  OrderField+CoreDataProperties.swift
//  OrderListGenerator
//
//  Created by Vitaliy on 27.02.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderField {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderField> {
        return NSFetchRequest<OrderField>(entityName: "OrderField")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var owner: OrderList?

}
