//
//  ViewController.swift
//  WithoutStoryboard
//
//  Created by Yury on 24/03/2023.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: Properties
    private let cellName = "Cell"
    private var person: [String] = []
    let addViewController = AddViewController()

    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Contacts"
        
        // Adding TableView dataSource and delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Adding AddViewController delegate
        addViewController.delegate = self
        
        
        // Registering the cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellName)
        
        // Adding right bar buton item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddWindow))
    }

}

extension MainTableViewController {
    // MARK: TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return person.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = person[indexPath.row]
        cell.contentConfiguration = content
                
        return cell
    }
    
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Private Methods
    @objc private func openAddWindow() {
        present(addViewController, animated: true)
    }
    
}

extension MainTableViewController: AddViewControllerDelegate {
    func saveContact(contactName: String) {
        person.append(contactName)
        let indexPath: IndexPath
        indexPath = [0, person.count - 1]
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

}
