//
//  RPComment.swift
//  CommentLoader
//
//  Created by Dean on 2017-03-19.
//  Copyright © 2017 DeanGaudet. All rights reserved.
//

import Foundation

class RPComment {
    var id: Int?
    var comment: String
    
    init(comment: String){
        self.comment = comment
        self.id = nil
    }
    
    var description: String {
        return "ID: \(self.id) Comment: \(self.comment)"
    }
}

extension RPComment {
    var persistableRecord: PersistableRecord {
        return PersistableRecord(key: self.id, value: self.comment)
    }
}
