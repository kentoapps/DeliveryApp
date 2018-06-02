//
//  ReviewListTranslator.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/23.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

class ReviewTranslator {
    func translate(_ reviews: [ReviewEntity]?) -> [Review] {
        guard let reviews = reviews else { return [] }
        return reviews.map{ translate($0) }
    }
    
    func translate(_ review: ReviewEntity) -> Review {
        return Review(
                userId: review.userId,
                userName: review.userName,
                title: review.title,
                comment: review.comment,
                rating: review.rating,
                date: review.date)
    }
}
