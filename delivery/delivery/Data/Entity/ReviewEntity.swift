//
//  ReviewEntity.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/11.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct ReviewEntity {
    public let comment: String
    public let date: Date
    public let rating: Double
    public let title: String
    public let userId: String
    public let userName: String
    
    var dictionary: [String: Any] {
        return [
            "comment": comment,
            "date": date,
            "rating": rating,
            "title": title,
            "userId": userId,
            "userName": userName
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let comment = dictionary["comment"] as? String,
            let date = dictionary["date"] as? Date,
            let rating = dictionary["rating"] as? Double,
            let title = dictionary["title"] as? String,
            let userId = dictionary["userId"] as? String,
            let userName = dictionary["userName"] as? String else { return nil }
        
        self.comment = comment
        self.date = date
        self.rating = rating
        self.title = title
        self.userId = userId
        self.userName = userName
    }
    
    init(comment: String, rating: Double, title: String, userId: String, userName: String) {
        self.comment = comment
        self.date = Date()
        self.rating = rating
        self.title = title
        self.userId = userId
        self.userName = userName
    }
}
