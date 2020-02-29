//
//  ViewController.swift
//  OrderListGenerator
//
//  Created by Vitaliy on 27.02.2020.
//  Copyright © 2020 Vitaliy. All rights reserved.
//

import UIKit
import CoreData

class OrdersTableViewController: UITableViewController {
    
    private var activityIndicator = UIActivityIndicatorView()
    private var refreshBarButton = UIBarButtonItem()
    private var activityBarButton = UIBarButtonItem()
    private var isRewound: Bool = false
    
    private let dataModel = OrderFieldViewModel()
    
    private let redCircle: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 100, width: 50, height: 50))
        view.backgroundColor = .red
        view.layer.cornerRadius = 25
        view.tintColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set(title: "writing...")
        setupBarButtons()
        setupObserver()
        addTestAnimationRedView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataModel.setupData()
    }
    
    private func set(title: String) {
        DispatchQueue.main.async {
            self.navigationItem.title = title
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(performObj(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc func performObj(_ notification: Notification) {
        print("-- Saved to db, reading... --")
        set(title: "reading...")
        getOrders()
    }
    
    private func setupBarButtons() {
        activityIndicator.sizeToFit()
        activityIndicator.color = view.tintColor
        activityIndicator.startAnimating()
        
        activityBarButton = UIBarButtonItem(customView: activityIndicator)
        refreshBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(rewindRows))
        showActivityIndicator()
    }
    
    private func showActivityIndicator() {
        navigationItem.setRightBarButton(activityBarButton, animated: true)
    }
    
    private func showRefreshBarButton() {
        navigationItem.setRightBarButton(refreshBarButton, animated: true)
    }
    
    @objc func rewindRows() {
        if isRewound {
            let indexPath = IndexPath(row: dataModel.orders.startIndex, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else {
            let indexPath = IndexPath(row: dataModel.orders.endIndex - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        isRewound.toggle()
    }
    
    private func addTestAnimationRedView() {
        tableView.addSubview(redCircle)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.repeat, .autoreverse], animations: {
            self.redCircle.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        }, completion: nil)
    }
    
    private func deleteAllData() {
        dataModel.delAllData("OrderList")
        dataModel.delAllData("OrderField")
    }

    private func getOrders() {
        dataModel.getOrders { result in
            if result {
                self.dataModel.orders.sort(by: { $0.field.id < $1.field.id })
                DispatchQueue.main.async {
                    self.set(title: "Completed!")
                    self.activityIndicator.stopAnimating()
                    self.showRefreshBarButton()
                    self.tableView.reloadData()
                }
            } else {
                // call Alert
                print("ERROR: Orders not received!.")
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

