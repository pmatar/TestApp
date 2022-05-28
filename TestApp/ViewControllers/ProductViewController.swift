//
//  ProductViewController.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import UIKit

class ProductViewController: UITableViewController {
    
    private var categories: [String] = []
    private var products: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibCell()
        setProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailedVC = segue.destination as? DetailedViewController {
            detailedVC.product = sender as? Product
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        categories[section].uppercased()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.filter { $0.category == categories[section] }.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UITableViewCell()
        }
        
        let filteredProducts = products.filter { $0.category == categories[indexPath.section] }
        
        let product = filteredProducts[indexPath.row]
        
        cell.configure(with: product)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filteredProducts = products.filter { $0.category == categories[indexPath.section] }
        let product = filteredProducts[indexPath.row]
        performSegue(withIdentifier: "toDetailedVC", sender: product)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            //            StorageManager.shared.delete(person)
            let filteredProducts = self.products.filter { $0.category == self.categories[indexPath.section] }
            let product = filteredProducts[indexPath.row]
            
            self.products.removeAll { temp in
                temp.id == product.id
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

// MARK: - Private methods

extension ProductViewController {
    
    private func registerNibCell() {
        let productCell = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(productCell, forCellReuseIdentifier: "ProductCell")
    }
    
    private func fetchFromAPI() {
        let nm = NetworkManager.shared
        nm.fetchProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedProducts):
                self.store(products: fetchedProducts)
                self.fetchFromFirestore()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func store(products: [Product]) {
        let sm = StorageManager.shared
        
        for product in products {
            sm.add(product: product)
        }
    }
    
    private func fetchFromFirestore() {
        let sm = StorageManager.shared
        
        sm.fetchAll { [weak self] fproducts in
            guard let self = self else { return }
                self.products = fproducts
                self.categories = Array(Set(fproducts.map { $0.category })).sorted()
        }
    }
    
    private func setProducts() {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "First Launch") == true {
            fetchFromFirestore()
            defaults.set(true, forKey: "First Launch")
        } else {
            fetchFromAPI()
            defaults.set(true, forKey: "First Launch")
        }
    }
    
}
