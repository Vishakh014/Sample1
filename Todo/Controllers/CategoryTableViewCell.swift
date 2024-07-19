//
//  CategoryTableViewCell.swift
//  Todo
//
//  Created by Vishakh on 18/07/24.
//

import UIKit
import CoreData

class CategoryTableViewCell: UITableViewController {
    
    var categories=[Category]()
    var context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    
    //MARK: -TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryItem", for: indexPath)
       
        cell.textLabel?.text=categories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    //MARK: -TableView Delegate method

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "GoItemList", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TodoListViewController{
            
            if let indexPath=tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory=categories[indexPath.row]
            }
        }
    }
    
    //MARK: -Adding Categories
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField=UITextField()
        let alert=UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action=UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory=Category(context: self.context)
            newCategory.name=textField.text
            self.categories.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField{
            alertTextField in
            alertTextField.placeholder="Create new category"
            textField=alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true)
    }
    

    //MARK: - Data Manipulation method
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        let request:NSFetchRequest<Category>=Category.fetchRequest()
        
        do{
            categories = try context.fetch(request)
        }catch{
            print("Error")
        }
    }
}
