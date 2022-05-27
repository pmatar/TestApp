//
//  ProductCell.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    func configure(with product: Product) {
        titleLabel.text = product.title
        ratingLabel.text = "⭐️ \(product.rating.rate) 📈 \(product.rating.count)"
        priceLabel.text = "🆔 \(product.id)  💲\(product.price)"
    }

}
