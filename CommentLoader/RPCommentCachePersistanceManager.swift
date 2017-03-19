//
//  RPCommentCachePersistanceManager.swift
//  CommentLoader
//
//  Created by Dean on 2017-03-19.
//  Copyright © 2017 DeanGaudet. All rights reserved.
//

import Foundation

enum PersistanceError: CommentErrorType{
    case CommentTooLong
    
    var description: String {
        switch self {
            case .CommentTooLong: return "Comment was to long to store"
        }
    }
}

struct PersistableRecord {
    let key: Int?
    let value: String
}

class RPCommentCachPersistanceManager {
    fileprivate var commentStorage: Dictionary<Int, String>
    fileprivate var idSequence: Int
    
    init(){
        self.commentStorage = [Int:String]()
        self.idSequence = 0
    }
    
    func save(_ comment: RPComment, completion: @escaping(Result<RPComment>) -> Void){
        let persistableComment = comment.persistableRecord
        let commentId: Int = persistableComment.key ?? self.nextSequence()
        
        if persistableComment.value.characters.count > 100 {
            completion(.Failure(PersistanceError.CommentTooLong))
            return
        }
        
        commentStorage[commentId] = comment.comment
        comment.id = commentId
        completion(.Success(comment))
        return
    }
    
    fileprivate func nextSequence() -> Int {
        self.idSequence = self.idSequence + 1
        return self.idSequence
    }
}
