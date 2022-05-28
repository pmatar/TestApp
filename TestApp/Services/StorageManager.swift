//
//  StorageManager.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class StorageManager {
    static let shared = StorageManager()
    private var db = Firestore.firestore()
    
    private init() {}
    
    func fetchAll(completion: @escaping ([Product]) -> Void) {
        var products = [Product]()
        
        let collectionRef = db.collection("products")
        collectionRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("failed snapshot")
                return
            }
            
            snapshot.documents.forEach { document in
                do {
                    let product  = try document.data(as: Product.self)
                    products.append(product)
                } catch {
                    print(error)
                    print("failed decoding")
                }
            }
            
            completion(products)
            
        }
    }
    
    func add(product: Product) {
        
        let collectionRef = db.collection("products").document(String(product.id))
        do {
            try collectionRef.setData(from: product)
            print("Product stored with new document reference: \(collectionRef.documentID)")
        }
        catch {
            print(error)
        }
    }
    
    func update(product: Product) {
        print(product.id)
        let id = String(product.id)
        let docRef = db.collection("products").document(id)
        
        do {
            try docRef.setData(from: product)
            print("success")
        } catch {
            print(error)
        }
    }
    
    func delete(product: Product) {
        let id = String(product.id)
        
        db.collection("products").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
        
}
