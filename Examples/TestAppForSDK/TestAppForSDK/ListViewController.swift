//
//  ListViewControllerTableViewController.swift
//  TestAppForSDK
//
//  Created by Nikolay on 02.05.17.
//  Copyright © 2017 Lognex. All rights reserved.
//

import UIKit
import MoySkladSDK

class ListViewController: UITableViewController {
    
    var auth: Auth!
    var items: [MSEntity<MSAssortment>] = []
    let cellIdentifier: String = "ProductCell"
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = tableView.center
        tableView.addSubview(activityIndicator)
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        
        loadData()
    }
    
    private func loadData() {
        activityIndicator.startAnimating()
        
        _ = DataManager.assortment(
            auth: auth,
            offset: MSOffset(size: 0, limit: 20, offset: 0),
            expanders: [Expander.create(.product, children: [Expander.init(.salePrices)]), Expander(.owner)],
            scope: AssortmentScope.variant
        ).subscribe(onNext: { [unowned self] assortment in
            self.items = assortment
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .value2, reuseIdentifier: cellIdentifier)
        
        if let item = items[indexPath.row].value() {
            cell.textLabel?.text = item.info.name
            if let price = item.salePrices.first {
                let priceValue = price.value.formatted(withStyle: .currency)
                cell.detailTextLabel?.text = priceValue
            } else {
                cell.detailTextLabel?.text = "-"
            }
            
        }

        return cell
    }
}
