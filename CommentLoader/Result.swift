//
//  Result.swift
//  CommentLoader
//
//  Created by Dean on 2017-03-19.
//  Copyright © 2017 DeanGaudet. All rights reserved.
//

import Foundation

protocol CommentErrorType: Error {
    var description: String { get }
}

enum Result<T> {
    case Success(T)
    case Failure(CommentErrorType)
}
