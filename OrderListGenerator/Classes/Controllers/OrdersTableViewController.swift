//
//  ViewController.swift
//  OrderListGenerator
//
//  Created by Vitaliy on 27.02.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController {

    let dataModel = OrderFieldViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataModel.setupData()
        //deleteAllData()
    }
    
    func deleteAllData() {
        dataModel.delAllData("OrderList")
        dataModel.delAllData("OrderField")
    }
    
    @IBAction func fetchButtonTapped(_ sender: UIBarButtonItem) {
        dataModel.getOrders { result in
            if result {
                self.dataModel.orders.sort(by: { $0.field.id < $1.field.id })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                // call Alert
                print("ERROR: Data not received!.")
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension OrdersTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderFieldTableViewCell.reuseID, for: indexPath) as! OrderFieldTableViewCell
        let field = dataModel.orders[indexPath.row].field
        cell.update(with: field)
        return cell
    }
}

