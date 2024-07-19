//
//  ViewController.swift
//  Todo
//
//  Created by Vishakh on 15/07/24.
//

import UIKit
import CoreData


class TodoListViewController: UITableViewController {
    
    var arrayItem=[Item]()
    
    var context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //var defaults = UserDefaults.standard  ##USer defaults store some small data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
          loadItems() // Retreving data from own plist
        //        if let item=defaults.array(forKey: "ToDo") as? [Item]{
        //            arrayItem=item
        //        }  //Retreving data from userdefault plist to array
        
    }
    
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayItem.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item=arrayItem[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none // ternary operator
        //        if item.done==true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    
    //TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //[indexPath.row].setValue("Completed", forKey: "title")
        
//        context.delete(arrayItem[indexPath.row])
//        arrayItem.remove(at: indexPath.row)
        
        arrayItem[indexPath.row].done = !arrayItem[indexPath.row].done  //This line with assign the opposite of current boolean.
        //        if arrayItem[indexPath.row].done == false{
        //            arrayItem[indexPath.row].done=true
        //        }else{
        //            arrayItem[indexPath.row].done=false
        //        }
        self.saveItems()  //Save items when
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func AddItemPressed(_ sender: UIBarButtonItem) {
        
        var textField=UITextField()
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem=Item(context: self.context)
            newItem.title=textField.text!  //copy the item from textfield
            newItem.done=false
            self.arrayItem.append(newItem)
            
            self.saveItems() // save items when added new items
            
        }
        
        alert.addTextField { alertTextfield in
            alertTextfield.placeholder="Create new item"
            textField=alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){  //saving the items to plist
        //self.defaults.set(self.arrayItem, forKey: "ToDo")
        //        let encoder=PropertyListEncoder()
        //        do{
        //            let data=try encoder.encode(self.arrayItem)
        //            try data.write(to: self.dataFilePath!)
        //        }catch{
        //            print(error)
        //        }
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    //    func loadItems(){
    //        do{
    //            let data=try Data(contentsOf: dataFilePath!)
    //            let decoder=PropertyListDecoder()
    //            arrayItem=try decoder.decode([Item].self, from: data)
    //
    //        }catch{
    //            print(error)
    //        }
    //    }
    func loadItems(with request:NSFetchRequest<Item>=Item.fetchRequest()){
//        let request : NSFetchRequest<Item>=Item.fetchRequest()
        do{ 
            arrayItem = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
}

extension TodoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item>=Item.fetchRequest()
        
        request.predicate=NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "null")
        
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
 
