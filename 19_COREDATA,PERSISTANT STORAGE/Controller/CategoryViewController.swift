//
//  CategoryViewController.swift
//  19_COREDATA,PERSISTANT STORAGE
//
//  Created by swapnil jadhav on 21/07/20.
//  Copyright © 2020 t. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    
    var categorys = [Category]()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false))
        
        loadData()
       
    }
    
    //MARK:add Category
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
          
        
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Categry", message: "enter name ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            let cat = Category(context:self.context)
            
            cat.name = textfield.text
            
            
            self.categorys.append(cat)
            
            self.saveData()
            
            
        }
        
        alert.addTextField { (alertTextfield) in
            
            alertTextfield.placeholder = "Add Category Name"
            
            textfield = alertTextfield
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
      }
    
    
    //MARK:DATA MANIPULATION METHOD
    
    func saveData()
    {
        
        do
        {
            try context.save()
        }
        catch
        {
            print("error to save \(error)")
        }
        tableView.reloadData()
        
    }
    
    func loadData()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
            
        do
        {
        categorys = try context.fetch(request)
        }
        catch
        {
            print("error to load data \(error)")
        }
    }
    
    
    //MARK: ON SWIPE EDIT AND DELETE
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
        
            self.context.delete(self.categorys[indexPath.row])
            
            self.categorys.remove(at: indexPath.row)
            
            self.saveData()
            
        }
        
        delete.backgroundColor = .red
        delete.image = UIImage(named: "trash")
        
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        
        return config
        
        
        
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            var textfield = UITextField()
        
            let Edit = UIContextualAction(style: .normal, title: "EDIT") { (action, view, handler) in
            
            
            let alert = UIAlertController(title: "Category", message: "edit name", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                
                
                self.categorys[indexPath.row].name = textfield.text
                
                self.saveData()
                
                
            }
            
                alert.addTextField { (alertText) in
                    
                    alertText.text = self.categorys[indexPath.row].name
                    
                    textfield = alertText
                }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        Edit.backgroundColor = .green
        
        let config = UISwipeActionsConfiguration(actions: [Edit])
        
        return config
    }
    
    // MARK: - Table view data source

  
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categorys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = categorys[indexPath.row].name
        
        return cell
    }

    //MARK:TABLEVIEW Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "gotoItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemTableViewController
        
        if let indexpath = tableView.indexPathForSelectedRow
        {
            
            
            destinationVC.selectedCategory = categorys[indexpath.row]
            
            
        }
    }
   
    
}
