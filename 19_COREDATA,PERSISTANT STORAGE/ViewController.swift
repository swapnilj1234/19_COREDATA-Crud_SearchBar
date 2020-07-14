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
    
    @IBOutlet weak var tables: UITableView!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        loadData()
        
        print(try! FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          
       }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        var alert = UIAlertController(title: "Add Item", message: "Enter Name", preferredStyle: .alert)
        
        var action = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            
            let item = Item(context:self.context)
            
            item.title = textField.text
            
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
    func loadData()
    {
        do
        {
            
            //Item is Entity
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            items =  try context.fetch(request)
            
        }
        catch
        {
            print("cannot load data from CoreDataModel \(error)")
            
        }
        tables.reloadData()
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
        
        
        context.delete(items[indexPath.row])
        items.remove(at:indexPath.row)
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        saveData()
        
        tables.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}

