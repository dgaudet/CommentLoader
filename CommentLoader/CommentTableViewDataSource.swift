//
//  CommentTableViewDataSource.swift
//  CommentLoader
//
//  Created by Dean on 2017-03-19.
//  Copyright © 2017 DeanGaudet. All rights reserved.
//

import Foundation
import UIKit

class CommentTableViewDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var results: [RPComment]
    fileprivate var tableView: UITableView
    
    init(tableView: UITableView, results: [RPComment]){
        self.results = results
        self.tableView = tableView
        
        super.init()
        
        self.tableView.dataSource = self
    }
    
    func objectAtIndexPath(indexPath: IndexPath) -> RPComment {
        return results[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath)
        
        let comment = results[indexPath.row]
        cell.textLabel?.text = comment.comment
        
        return cell
    }
}

extension CommentTableViewDataSource: RPCommentDataProviderDelegate {
    func processUpates(updates: [RPCommentDataProviderUpdate<RPComment>]) {
        tableView.beginUpdates()
        
        for (index, update) in updates.enumerated() {
            switch update {
            case .insert(let comment):
                results.insert(comment, at: index)
                let indexPath = IndexPath(row: index, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        tableView.endUpdates()
    }
    
    func providerFailedWithError(error: CommentErrorType){
        print("Provider failed with error: \(error.description)")
    }
}
