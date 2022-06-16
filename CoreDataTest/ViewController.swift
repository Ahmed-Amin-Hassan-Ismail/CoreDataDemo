//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Ahmed Amin on 16/06/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // reference to managed object context
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Person]?
    
    let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Core Data"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapButton))
        navigationItem.rightBarButtonItem = rightButtonItem
        
        // Fetch people
        fetchPeople()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchPeople() {
        
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            /// filter with specific creteria
            //let pred = NSPredicate(format: "name CONTAINS %@", "Ahmed")
            //request.predicate = pred
            
            
            /// Sort the fetch data
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
    @objc private func didTapButton() {
        let alertController = UIAlertController(title: "Add Person", message: "what is the name?", preferredStyle: .alert)
        alertController.addTextField()
        let alertAction = UIAlertAction(title: "Add", style: .default) { _ in
            let textField = alertController.textFields?.first!
            //  create person object
            let newPerson = Person(context: self.context)
            newPerson.name = textField?.text
            newPerson.gender = "male"
            
            //save the data
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            // retrieve the data
            self.fetchPeople()
            
        }
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = items![indexPath.row]
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = person.gender
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let person = items![indexPath.row]
        let editAlert = UIAlertController(title: "Edit Person", message: "Edit Name", preferredStyle: .alert)
        editAlert.addTextField()
        let textField = editAlert.textFields?.first!
        textField?.text = person.name
        let action = UIAlertAction(title: "Save", style: .default) { _ in
            let textField = editAlert.textFields?.first!
            
            // Edit name
            person.name = textField?.text!
            
            // save
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            // retireve from data
            self.fetchPeople()
            
            
        }
        editAlert.addAction(action)
        self.present(editAlert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let contextualAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
         
            // which person needs to remove
            let presonToRemove = self.items![indexPath.row]
            
            // Remove from core data
            self.context.delete(presonToRemove)
            
            //save to data
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }
            
            // retrieve the data
            self.fetchPeople()
        }
        
        return UISwipeActionsConfiguration(actions: [contextualAction])
    }
}

