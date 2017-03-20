//
//  RPCommentDataProvider.swift
//  CommentLoader
//
//  Created by Dean on 2017-03-19.
//  Copyright © 2017 DeanGaudet. All rights reserved.
//

import Foundation

protocol RPCommentDataProviderDelegate: class {
    func processUpates(updates: [RPCommentDataProviderUpdate<RPComment>])
    func providerFailedWithError(error: CommentErrorType)
}

enum RPCommentDataProviderUpdate<T> {
    case insert(T)
}

class RPCommentDataProvider {
    let manager = RPCommentCachePersistanceManager.sharedInstance
    var updates = [RPCommentDataProviderUpdate<RPComment>]()
    
    fileprivate weak var delegate:RPCommentDataProviderDelegate?
    
    init(delegate: RPCommentDataProviderDelegate){
        self.delegate = delegate
    }
    
    func fetchAll(){
        manager.getAll { result in
            self.processResults(results: result)
        }
    }
    
    func save(comment: RPComment){
        manager.save(comment) { result in
            self.processResult(result: result)
        }
    }
    
    fileprivate func processResult(result: Result<RPComment>){
        DispatchQueue.main.async {
            switch result {
            case .Success(let comment):
                self.updates = [RPCommentDataProviderUpdate.insert(comment)]
                self.delegate?.processUpates(updates: self.updates)
            case .Failure(let error):
                self.delegate?.providerFailedWithError(error: error)
            }
        }
    }
    
    fileprivate func processResults(results: Result<[RPComment]>){
        DispatchQueue.main.async {
            switch results {
            case.Success(let comments):
                self.updates = comments.map { RPCommentDataProviderUpdate.insert($0) }
                self.delegate?.processUpates(updates: self.updates)
            case .Failure(let error):
                self.delegate?.providerFailedWithError(error: error)
            }
        }
    }
}
