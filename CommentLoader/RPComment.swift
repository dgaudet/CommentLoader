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
    
    init(id: Int?, comment: String){
        self.id = id
        self.comment = comment
    }
    
    convenience init(comment: String){
        self.init(id: nil, comment: comment)
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

extension RPComment {
    convenience init(record: PersistableRecord) {
        self.init(id: record.key, comment: record.value)
    }
}
