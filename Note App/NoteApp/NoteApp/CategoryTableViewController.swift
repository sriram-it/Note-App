//
//  CategoryTableViewController.swift
//  NoteApp
//
//  Created by Arunkumar Nachimuthu on 2020-06-21.
//  Copyright © 2020 user176097. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.retrieveCategories()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let addAlert = UIAlertController(title: "New Category", message: "Enter category name", preferredStyle: .alert)
        addAlert.addTextField()
        
        let addAlertAction = UIAlertAction(title: "Add", style: .default, handler: {(alertAction) in
            //call savaCategory call
            let email = AppDelegate.shared().userEmail
            if email != "NO_USER" {
                let categoryName = addAlert.textFields![0].text!
                let changedName = categoryName.replacingOccurrences(of: " ", with: "+")
                let url  = "http://alllinks.online/iosproject/addCategory.php?email=\(email)&name=\(changedName)"
                
                let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                    guard error == nil else {
                        print ("error \(error!)")
                        return
                    }
                    
                    var result: AddCategoryResponse?
                    do {
                        result = try JSONDecoder().decode(AddCategoryResponse.self, from: data!)
                    }catch{
                        print("parse error")
                    }
                    
                    if(result?.status == "success") {
                        DispatchQueue.main.async {
                            //self.navigationController?.popToRootViewController(animated: true)
                            self.displayAlert(title: "Category", message: "Category Added Successfully")
                            self.viewWillAppear(true)
                        }
                    } else {
                        self.displayAlert(title: "Category", message: "Category Creation Failed")
                    }
                })
                task.resume()
            } else {
                self.displayAlert(title: "Category", message: "Please Login to add category")
            }
        })
        
        let closeAlerAction = UIAlertAction(title: "Cancel", style: .default, handler: {(alertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        addAlert.addAction(closeAlerAction)
        addAlert.addAction(addAlertAction)
        present(addAlert, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //call delete call
            self.deleteCategory(category: categories[indexPath.row])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addAlert = UIAlertController(title: "Edit Category", message: "Enter category name", preferredStyle: .alert)
        addAlert.addTextField()
        addAlert.textFields![0].text = categories[indexPath.row].name
        let addAlertAction = UIAlertAction(title: "Save", style: .default, handler: {(alertAction) in
            //call updateCategory call
            self.updateCategory(newName: addAlert.textFields![0].text!)
        })
        
        let closeAlerAction = UIAlertAction(title: "Cancel", style: .default, handler: {(alertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        addAlert.addAction(closeAlerAction)
        addAlert.addAction(addAlertAction)
        present(addAlert, animated: true)
    }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func retrieveCategories(){
        let email = AppDelegate.shared().userEmail
        if email != "NO_USER" {
            let url  = "http://alllinks.online/iosproject/getCategoriesOfUser.php?email=\(email)"
            
            let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                
                var result: GetCategoryResponse?
                do {
                    result = try JSONDecoder().decode(GetCategoryResponse.self, from: data!)
                }catch{
                    print("parse error")
                }
                
                if(result?.status == "success") {
                    AppDelegate.shared().categories.removeAll()
                    //self.navigationController?.popToRootViewController(animated: true)
                    for cat in result!.categories {
                        let category = Category(id: cat.id, name: cat.name, user_id: cat.user_id)
                        AppDelegate.shared().categories.append(category)
                    }
                    self.categories =  AppDelegate.shared().categories
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    self.displayAlert(title: "Category", message: "Category Creation Failed")
                }
            })
            task.resume()
        } else {
            displayAlert(title: "Category", message: "Please Login to View Categories")
        }
    }
    
    func updateCategory(newName: String){
        let email = AppDelegate.shared().userEmail
        
        if email != "NO_USER" {
            let category = categories[self.tableView.indexPathForSelectedRow!.row]
            let changedName = newName.replacingOccurrences(of: " ", with: "+")
            let url  = "http://alllinks.online/iosproject/updateCategory.php?id=\(category.id)&name=\(changedName)"
            
            let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                
                var result: UpdateCategoryResponse?
                do {
                    result = try JSONDecoder().decode(UpdateCategoryResponse.self, from: data!)
                }catch{
                    print("parse error")
                }
                
                if(result?.status == "success") {
                    self.displayAlert(title: "Category", message: "Category Updated Successfully")
                    DispatchQueue.main.async {
                        self.viewWillAppear(true)
                    }
                } else {
                    self.displayAlert(title: "Category", message: "Category Updation Failed")
                }
            })
            task.resume()
        } else {
            displayAlert(title: "Category", message: "Update Category Failed")
        }
    }
    
    func deleteCategory(category: Category) {
        let email = AppDelegate.shared().userEmail
        if email != "NO_USER" {
            let url  = "http://alllinks.online/iosproject/deleteCategory.php?id=\(category.id)"
            
            let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                
                var result: DeleteCategoryResponse?
                do {
                    result = try JSONDecoder().decode(DeleteCategoryResponse.self, from: data!)
                }catch{
                    print("parse error")
                }
                
                if(result?.status == "success") {
                    self.displayAlert(title: "Category", message: "Category Deleted Successfully")
                    DispatchQueue.main.async {
                        self.viewWillAppear(true)
                    }
                } else {
                    self.displayAlert(title: "Category", message: "Category Deletion Failed")
                }
            })
            task.resume()
        } else {
            displayAlert(title: "Category", message: "Delete Category Failed")
        }
    }
    
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: {(alertActionData) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
}

struct AddCategoryResponse:Codable {
    var status: String
    var id: Int
}

struct  GetCategoryResponse: Codable {
    var status: String
    var categories: [Category]
}

struct  UpdateCategoryResponse: Codable {
    var status: String
}

struct  DeleteCategoryResponse: Codable {
    var status: String
}
