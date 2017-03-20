//
//  ViewController.swift
//  CommentLoader
//
//  Created by Dean on 2017-03-19.
//  Copyright © 2017 DeanGaudet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    
    lazy var dataSource: CommentTableViewDataSource = {
        return CommentTableViewDataSource(tableView: self.tableView, results: [])
    }()
    
    lazy var dataProvider: RPCommentDataProvider = {
        return RPCommentDataProvider(delegate: self.dataSource)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.reuseIdentifier)
        let navigationItem = UINavigationItem(title: "Comments")
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.addCommentTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        self.navigationBar.setItems([navigationItem], animated: false)
        
        // Do any additional setup after loading the view, typically from a nib.
        dataProvider.fetchAll()
        
        self.saveComment(comment: "Test comment1")
        self.saveComment(comment: "Test comment2")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCommentTapped(){
        presentSaveCommentAlertController { comment in
            self.saveComment(comment: comment)
        }
    }
    
    fileprivate func presentSaveCommentAlertController(_ completion: @escaping(String) -> Void) {
        let alertController = UIAlertController(title: "Add Comment", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "New Comment"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { UIAlertAction in
            guard let title = alertController.textFields?.first?.text else {
                completion("")
                return
            }
            
            completion(title)
        }
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func saveComment(comment: String){
        let rpComment = RPComment(comment: comment)
        
        dataProvider.save(comment: rpComment)
    }
}
