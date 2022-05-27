//
//  ProductViewController.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.
//

import UIKit

class ProductViewController: UITableViewController {
    
    private var categories: [String] = []
    private var products: [Product] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibCell()
        getProducts()
        
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
            
            self.products.removeAll { pr in
                pr.id == product.id
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

// MARK: - Private methods

extension ProductViewController {
    
    private func getProducts() {
        let nm = NetworkManager.shared
        nm.fetchProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedProducts):
                self.products = fetchedProducts
                self.categories = Array(Set(self.products.map { $0.category })).sorted()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func registerNibCell() {
        let productCell = UINib(nibName: "ProductCell", bundle: nil)
        tableView.register(productCell, forCellReuseIdentifier: "ProductCell")
    }
    
}
