//
//  DetailedViewController.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import UIKit
import SDWebImage

class DetailedViewController: UIViewController {
    var product: Product?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        productTextView.delegate = self
        productTextView.text = product?.description
        productImageView.sd_setImage(with: product?.image,
                                     placeholderImage: UIImage(systemName: "photo"))
      }
    
    override func viewDidDisappear(_ animated: Bool) {
        StorageManager.shared.update(product: product!)
        super.viewDidDisappear(animated)
    }
    
}
 

extension DetailedViewController: UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Did end Editing")
        product?.description = textView.text
    }
    
}

