//
//  ViewController.swift
//  coreDataApp
//
//  Created by Damirka on 26.11.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    var items:[Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPeople()
       
    }
    
    func fetchPeople() {
        
        do {
            self.items = try context.fetch(Person.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {}
        
    }
    

    @IBAction func addTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add person", message: "Name?",
            preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "M"
            
            do {
                
                try self.context.save()
            }
            catch {}
            
            self.fetchPeople()
            
        }
        
        alert.addAction(submitButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        let person = self.items![indexPath.row]
        
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let person = self.items![indexPath.row]
        
        let alert = UIAlertController(title: "Edit", message: "Edit the name:", preferredStyle: .alert)
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            
            person.name = textField.text
            
            do {
                
                try self.context.save()
            }
            
            catch {}
            
            self.fetchPeople()
        }
        alert.addAction(saveButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let personToRemove = self.items![indexPath.row]
            
            self.context.delete(personToRemove)
            
            do {
                
                try self.context.save()
                
            }
            catch {}
            
            self.fetchPeople()
            
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

