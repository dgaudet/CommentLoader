//
//  ViewController.swift
//  CommentLoader
//
//  Created by Dean on 2017-03-19.
//  Copyright © 2017 DeanGaudet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addComment(comment: "Test comment1")
        self.addComment(comment: "Test comment2")
        self.addComment(comment: "Test comment3")
        
        storageManager.getAll { result in
            switch result {
            case .Success(let results): print("success \(results)")
            case .Failure(let error): print("\(error.description)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let storageManager = RPCommentCachePersistanceManager()

    func addComment(comment: String){
        let comment = RPComment(comment: comment)
        
        storageManager.save(comment) { result in
            switch result {
                case .Success(let savedComment): print("saved \(savedComment.description)")
                case .Failure(let error): print("Error while saving - \(error)")
            }
        }
    }

}

