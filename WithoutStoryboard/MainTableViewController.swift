//
//  ViewController.swift
//  WithoutStoryboard
//
//  Created by Yury on 24/03/2023.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    // MARK: Properties
    private let cellName = "Cell"
    private var persons: [NSManagedObject] = []

    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Contacts"
        
        // Adding delegates
        tableView.dataSource = self
        tableView.delegate = self
        
        // Registering the cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellName)
        
        // Adding right bar buton item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddWindow))
        
        // Display an Edit button
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadManagedObjects()
        if persons.isEmpty { navigationItem.leftBarButtonItem?.isEnabled = false }
    }

}

extension MainTableViewController {
    // MARK: TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = persons[indexPath.row].value(forKey: "name") as? String
        cell.contentConfiguration = content
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = persons[indexPath.row]
            
            // Core Data block
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.persistanseContainer.viewContext.delete(person)
            appDelegate.saveContext()
            
            // Array block
            persons.remove(at: indexPath.row)
            
            // TableView block
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Targets
    @objc private func openAddWindow() {
        let addViewController = AddViewController()
        addViewController.delegate = self
        present(addViewController, animated: true)
    }
    
    // MARK: Loading managed objects
    private func loadManagedObjects() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistanseContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            try persons = context.fetch(request)
        } catch let error as NSError {
            print("Cant fetch \(error), \(error.userInfo)")
        }
    }
    
}

// MARK: AddViewController Delegate
extension MainTableViewController: AddViewControllerDelegate {
    func saveContact(contactName: String) {
        // Core Data block
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistanseContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }
        let person = NSManagedObject(entity: entity, insertInto: context)
        person.setValue(contactName, forKey: "name")
        appDelegate.saveContext()
        
        // Array block
        persons.append(person)
        
        // TableView block
        let indexPath: IndexPath = [0, persons.count - 1]
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // Navigation Controller block
        if navigationItem.leftBarButtonItem?.isEnabled == false {
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
    }

}
