//
//  OrderTableViewCell.swift
//  OrderListGenerator
//
//  Created by Vitaliy on 27.02.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class OrderFieldTableViewCell: UITableViewCell {

    static let reuseID = "OrderFieldCell"
    
    func update(with field: Field) {
        textLabel?.text = "id: " + String(field.id)
        detailTextLabel?.text = "title: " + field.title
    }
}
 
