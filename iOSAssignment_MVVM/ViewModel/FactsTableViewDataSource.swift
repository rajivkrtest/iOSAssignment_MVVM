//
//  FactsTableViewDataSource.swift
//  iOSAssignment_MVVM
//
//  Created by Rajiv Kumar on 08/10/20.
//

import Foundation
import UIKit

class FactsTableViewDataSource<CELL : HomeTableViewCell,T> : NSObject, UITableViewDataSource {
    
    private var cellIdentifier : String!
    private var items : T!
    var configureCell : (CELL, Row) -> () = {_,_ in }
    
    
    init(cellIdentifier : String, items : T, configureCell : @escaping (CELL, Row) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itms = items as? [Row] {
            return itms.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        if let itms = items as? [Row] {
            let item = itms[indexPath.row]
            self.configureCell(cell, item)
        }
        
        return cell
    }
}
