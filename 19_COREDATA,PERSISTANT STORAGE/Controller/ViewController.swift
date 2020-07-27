//
//  ViewController.swift
//  19_COREDATA,PERSISTANT STORAGE
//
//  Created by swapnil jadhav on 14/07/20.
//  Copyright © 2020 t. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

   
    var items = [Item]()
    
    var selectedCategory : Category? {
        
        didSet
        {
            loadData()
        }
    }
    
    @IBOutlet weak var tables: UITableView!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
       // loadData()
        
        
        print(selectedCategory?.name)
        
       // print(try! FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          
       }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        var alert = UIAlertController(title: "Add Item", message: "Enter Name", preferredStyle: .alert)
        
        var action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            
            let item = Item(context:self.context)
            
            item.title = textField.text
            
            item.parentCategory = self.selectedCategory
            
            self.items.append(item)
                
            self.saveData()
            
            }
        
        alert.addTextField { (alerttext) in
            
        alerttext.placeholder = "enter Item Name"
            
        textField = alerttext
            
    }
       
        alert.addAction(action)
        
       present(alert, animated: true, completion: nil)
    }
    
    //save data
    func saveData()
    {
        do{
            
            try context.save() //only one method to save data
          }
        catch
        {
          print("error to save \(error)")
        }
        
        tables.reloadData()
    }
    
    //read data from coreData Model
    func loadData(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil)
    {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)


        if let additonalPredicate = predicate
        {

            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additonalPredicate])
        }
        else
        {

            request.predicate = categoryPredicate
        }
        do
        {
            
            //Item is Entity
            
            //let request : NSFetchRequest<Item> = Item.fetchRequest() //we already add in funcation defination
            
            items =  try context.fetch(request)
            
        }
        catch
        {
            print("cannot load data from CoreDataModel \(error)")
            
        }
    
        
        
         
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tables.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        
        cell.accessoryType = items[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       // context.delete(items[indexPath.row])
        //items.remove(at:indexPath.row)
        
        //items[indexPath.row].done = !items[indexPath.row].done
        
        saveData()
        
        tables.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {


        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, handler) in
            

            self.context.delete(self.items[indexPath.row])
            self.items.remove(at: indexPath.row)
            
            self.saveData()
            
        }
        
        deleteAction.backgroundColor = .red
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return config
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var textfiled = UITextField()
        
        let editAction = UIContextualAction(style: .normal,title: "Edit") { (action , view, handler) in
            
         
            let alert = UIAlertController(title: "Edit data", message: "Write a new name", preferredStyle: .alert)
        
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
                self.items[indexPath.row].title = textfiled.text
                
                self.saveData()
                
                
                    }
            alert.addTextField { (alerttext) in
                

                alerttext.text = self.items[indexPath.row].title
                
                textfiled = alerttext
                 
            }
            
         
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }

        editAction.backgroundColor = .green
        let config = UISwipeActionsConfiguration(actions: [editAction])
        
        return config
    }
}

//MARK: search Bar Method

extension ViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {


        let request : NSFetchRequest<Item> = Item.fetchRequest()

//        print(searchBar.text)

        //Following Line which describe when we type in search box search text can be display
       // let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

       let predicate = NSPredicate(format: "title BEGINSWITH[c] %@", searchBar.text!)
//
//
        //request.predicate = predicate
//
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
       loadData(with: request,predicate:predicate)

}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0
        {
            loadData()
            
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()

            }
        }
    }
        
        
        
    }
    
    
   
    
    


