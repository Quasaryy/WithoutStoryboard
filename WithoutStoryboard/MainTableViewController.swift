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
    private var person = UserDefaults.standard.array(forKey: "person") as? [String] ?? []
    let addViewController = AddViewController()

    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Contacts"
        
        // Adding delegates
        tableView.dataSource = self
        tableView.delegate = self
        addViewController.delegate = self
        
        // Registering the cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellName)
        
        // Adding right bar buton item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddWindow))
        
        // Display an Edit button
        navigationItem.leftBarButtonItem = editButtonItem
        if person.isEmpty { navigationItem.leftBarButtonItem?.isEnabled = false }
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            person.remove(at: indexPath.row)
            UserDefaults.standard.set(person, forKey: "person")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let removed = person.remove(at: sourceIndexPath.row)
        person.insert(removed, at: destinationIndexPath.row)
        UserDefaults.standard.set(person, forKey: "person")
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
        UserDefaults.standard.set(person, forKey: "person")
        let indexPath: IndexPath
        indexPath = [0, person.count - 1]
        tableView.insertRows(at: [indexPath], with: .automatic)
        if navigationItem.leftBarButtonItem?.isEnabled == false {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }

}
