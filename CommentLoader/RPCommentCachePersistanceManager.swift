//
//  RPCommentCachePersistanceManager.swift
//  CommentLoader
//
//  Created by Dean on 2017-03-19.
//  Copyright © 2017 DeanGaudet. All rights reserved.
//

import Foundation

enum PersistanceError: CommentErrorType{
    case CommentToLong
    case CommentToShort
    case InvalidComment
    
    var description: String {
        switch self {
            case .CommentToLong: return "Comment was to long to store"
            case .CommentToShort: return "Comment was to short"
            case .InvalidComment: return "Invalid comment was encountered"
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
            completion(.Failure(PersistanceError.CommentToLong))
            return
        }
        
        if persistableComment.value.characters.count < 1 {
            completion(.Failure(PersistanceError.CommentToShort))
            return
        }
        
        commentStorage[commentId] = comment.comment
        comment.id = commentId
        completion(.Success(comment))
        return
    }
    
    func getAll(_ completion: @escaping(Result<[RPComment]>) -> Void){
        var results: [RPComment] = []
        for comment in self.commentStorage {
            if comment.value.characters.count < 1 {
                completion(.Failure(PersistanceError.CommentToShort))
                return
            }
            let comment = PersistableRecord(key: comment.key, value: comment.value)
            results.append(RPComment.init(record: comment))
        }
        
        completion(.Success(results))
        return
    }
    
    fileprivate func nextSequence() -> Int {
        self.idSequence = self.idSequence + 1
        return self.idSequence
    }
}
