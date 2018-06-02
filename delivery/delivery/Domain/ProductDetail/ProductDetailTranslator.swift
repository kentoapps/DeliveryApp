//
//  ProductDetailTranslator.swift
//  delivery
//
//  Created by Kento Uchida on 2018/02/24.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

class ProductDetailTranslator: TranslatorProtocol {
    func translateList(from list: [ProductEntity]) -> [Product] {
        return list.map { entity in translate(entity) }
    }
    
    func translate(_ entity: ProductEntity) -> Product {
        return Product(
            averageRating: entity.averageRating,
            branch: translateBranch(from: entity.branch),
            brand: entity.brand,
            description: entity.description,
            discountPercent: entity.discountPercent,
            events: entity.events,
            images: entity.images,
            name: entity.name,
            originalPrice: entity.originalPrice,
            price: entity.price,
            category: entity.category,
            subCategory: entity.subCategory,
            productId: entity.productId,
            reviews: translateReviews(entity.reviews),
            ratingCount: entity.ratingCount)
    }
    
    func translateBranch(from branch: [BranchInventoryEntity]) -> [BranchInventory] {
        return branch.map { entity in
            BranchInventory(quantity: entity.quantity, name: entity.name)
        }
    }
    
    private func translateReviews(_ reviews: [ReviewEntity]?) -> [Review]? {
        guard let reviews = reviews else { return nil }
        return reviews.map{ r in
            Review(userId: r.userId, userName: r.userName, title: r.title, comment: r.comment, rating: r.rating, date: r.date)
        }
    }
}
