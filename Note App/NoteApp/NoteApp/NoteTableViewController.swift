//
//  NoteTableViewController.swift
//  NoteApp
//
//  Created by user176097 on 6/8/20.
//  Copyright © 2020 user176097. All rights reserved.
//

import UIKit

class NoteTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data = [Note] ()
    var selectedRow: Note? = nil
    var isSideBarShow = false
    let navView = UIView()
    let lblUserName = UILabel()
    let categoryIcon = UIImageView()
    let categoryBtn = UIButton()
    var userAccessBtn = UIButton()
    let sortByTypes = ["title", "createdDate", "category", "location"]
    var cellImages =  [String: UIImage] ()
    var imgCellIndex = 0
    
    
    @IBOutlet weak var generalSeachField: UITextField!
    @IBOutlet weak var searchLocationField: UITextField!
    @IBOutlet weak var searchCategoryField: UITextField!
    @IBOutlet weak var sortBySelector: UISegmentedControl!
    
    @IBOutlet weak var vEffect: UIView!
    @IBOutlet weak var advanceFilter: UIView!
    @IBOutlet weak var nTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nTableView.delegate = self
        nTableView.dataSource = self
        nTableView.separatorColor = UIColor.clear
        advanceFilter.isHidden = true
        vEffect.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        activityIndicator.hidesWhenStopped = true
        self.buildNavBar()
        self.navBarInit()
        self.getCategory()
        cellImages =  [String: UIImage] ()
        imgCellIndex = 0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if data[indexPath.row].images.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notecellwithimage") as! withImageCellTableViewCell
            cell.ntitle.text  = data[indexPath.row].title
            cell.nCategory.text = data[indexPath.row].category
            cell.nLocation.text = String(data[indexPath.row].location.split(separator: "-")[0])
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            cell.nCreatedDate.text = formatter.string(from: data[indexPath.row].createdDate)
            if(cellImages.count > 0){
                cell.nImage.image = cellImages[data[indexPath.row].title]
                imgCellIndex += 1
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "notecellwithoutimage") as! WithoutImageTableViewCell
            cell.nTitle.text  = data[indexPath.row].title
            cell.nCategory.text = data[indexPath.row].category
            //  cell.nLocation.text = data[indexPath.row].location
            cell.nLocation.text = String(data[indexPath.row].location.split(separator: "-")[0])
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            cell.nCreatedDate.text = formatter.string(from: data[indexPath.row].createdDate)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = data[indexPath.row]
        print("LVC")
    }
    
    func buildNavBar(){
        navView.frame = CGRect(x: 0, y: 0, width: -30, height: self.view.frame.height)
        navView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.75)
        lblUserName.frame = CGRect(x: 0, y: 80, width: -30, height: 20)
        lblUserName.text = AppDelegate.shared().userEmail != "NO_USER" ?  AppDelegate.shared().userEmail : "Guest"
        lblUserName.textColor = UIColor.white
        lblUserName.font = UIFont(name: "Helvetica-Bold", size: 20.0)
        navView.addSubview(lblUserName)
        
        //        userAccessBtn.frame = CGRect(x: 0, y: 120, width: -30, height: 20)
        //        userAccessBtn.titleLabel?.text = "Login"
        //        userAccessBtn.setTitleColor(UIColor.red, for: .normal)
        //        userAccessBtn.titleLabel?.font = UIFont(name: "Helvetica-SemiBold", size: 25.0)
        //        userAccessBtn.addTarget(self, action: #selector(self.loginNav), for: .touchUpInside)
        //        navView.addSubview(userAccessBtn)
        
        userAccessBtn.frame = CGRect(x: 0, y: 110, width: -30, height: 20)
        let userAccessBtnTitle  = AppDelegate.shared().userEmail != "NO_USER" ?  "Logout": "Login"
        userAccessBtn.setTitle(userAccessBtnTitle, for: .normal)
        userAccessBtn.setTitleColor(UIColor(red: 63/255, green: 111/255, blue: 221/255, alpha: 1.0), for: .normal)
        userAccessBtn.titleLabel?.textAlignment = .left
        userAccessBtn.titleLabel?.font = UIFont(name: "Helvetica-SemiBold", size: 18.0)
        userAccessBtn.addTarget(self, action: #selector(self.loginNav), for: .touchUpInside)
        navView.addSubview(userAccessBtn)
        
        categoryIcon.frame = CGRect(x: 0, y: 150, width: -30, height: 20)
        categoryIcon.image = UIImage(named: "category")
        navView.addSubview(categoryIcon)
        
        categoryBtn.frame = CGRect(x: 0, y: 150, width: -30, height: 18)
        categoryBtn.setTitle("Category", for: .normal)
        categoryBtn.setTitleColor(UIColor.white, for: .normal)
        categoryBtn.titleLabel?.font = UIFont(name: "Helvetica-SemiBold", size: 18.0)
        categoryBtn.addTarget(self, action: #selector(self.categoryNavAction), for: .touchUpInside)
        navView.addSubview(categoryBtn)
        
        self.view.addSubview(navView)
    }
    
    @objc func categoryNavAction(){
        performSegue(withIdentifier: "showCategoryController", sender: self)
    }
    
    @objc func loginNav() {
        if (AppDelegate.shared().userEmail != "NO_USER"){
            AppDelegate.shared().userEmail = "NO_USER"
            self.viewWillAppear(true)
        }else {
            performSegue(withIdentifier: "showLogin", sender: self)
        }
    }
    
    @IBAction func navigationAction(_ sender: UIBarButtonItem) {
        if !isSideBarShow {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.navView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
                self.lblUserName.frame = CGRect(x: 5, y: 80, width: self.view.frame.width/2, height: 20)
                self.userAccessBtn.frame = CGRect(x: 5, y: 110, width: 100, height: 20)
                self.categoryIcon.frame = CGRect(x: 10, y: 150, width: 20, height: 20)
                self.categoryBtn.frame = CGRect(x: 45, y: 150, width: 100, height: 20)
            }, completion: nil)
            isSideBarShow = true
        }else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.lblUserName.frame = CGRect(x: 0, y: 80, width: -30, height: 20)
                self.userAccessBtn.frame = CGRect(x: 0, y: 110, width: -30, height: 20)
                self.categoryIcon.frame = CGRect(x: 0, y: 150, width: -30, height: 20)
                self.categoryBtn.frame = CGRect(x: 0, y: 150, width: -30, height: 20)
                self.navView.frame = CGRect(x: 0, y: 0, width: -30, height: self.view.frame.height)
            }, completion: nil)
            isSideBarShow = false
        }
    }
    
    func navBarInit() {
        self.lblUserName.frame = CGRect(x: 0, y: 80, width: -30, height: 20)
        self.userAccessBtn.frame = CGRect(x: 0, y: 110, width: -30, height: 20)
        self.categoryIcon.frame = CGRect(x: 0, y: 150, width: -30, height: 20)
        self.categoryBtn.frame = CGRect(x: 0, y: 150, width: -30, height: 20)
        self.navView.frame = CGRect(x: 0, y: 0, width: -30, height: self.view.frame.height)
    }
    
    
    @IBAction func advanceFilter(_ sender: UIButton) {
        self.advanceFilter.isHidden = false
        self.vEffect.isHidden = false
        self.vEffect.backgroundColor = UIColor.black.withAlphaComponent(0.75)
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "newNoteSegue" {
            let destinationVC = segue.destination as? ViewController
            if destinationVC != nil {
                destinationVC?.detailNote = data[nTableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    @IBAction func closeAdvanceSearch(_ sender: UIButton){
        self.advanceFilter.isHidden = true
        self.vEffect.isHidden = true
        self.vEffect.backgroundColor = UIColor.clear
        self.getCategory()
    }
    
    @IBAction func filterNote(_ sender: UIButton) {
        let notes = notesObj.notesArray
        var filteredNotes = [Note] ()
        
        let gSText = generalSeachField.text
        let lSText = searchLocationField.text
        let catSText = searchCategoryField.text
        
        for note in notes {
            
            //if only one filter entered
            if (gSText != "" && lSText == "" && catSText == "" && (note.title.contains(gSText!) || note.note.contains(gSText!))) {
                filteredNotes.append(note)
            } else if (lSText != "" && gSText == "" && catSText == "" &&  note.location.contains(lSText!)) {
                filteredNotes.append(note)
            } else if (catSText != "" && lSText == "" && gSText == "" && note.category.contains(catSText!)) {
                filteredNotes.append(note)
                //if two filters are entered
            } else if (gSText != "" && lSText != "" && catSText == "" && (note.title.contains(gSText!) || note.note.contains(gSText!)) &&  note.location.contains(lSText!)) {
                filteredNotes.append(note)
            } else if (gSText != "" && lSText == "" && catSText != "" && (note.title.contains(gSText!) || note.note.contains(gSText!)) && note.category.contains(catSText!)) {
                filteredNotes.append(note)
            } else if (gSText == "" && lSText != "" && catSText != "" &&  note.location.contains(lSText!) && note.category.contains(catSText!)) {
                filteredNotes.append(note)
                //if all there filters are entered
            } else if (gSText != "" && lSText != "" && catSText != "" && (note.title.contains(gSText!) || note.note.contains(gSText!)) && note.location.contains(lSText!) && note.category.contains(catSText!)) {
                filteredNotes.append(note)
            }
            
            
        }
        
        // if no filtered apply then just sort the default notes
        if (filteredNotes.count == 0 && gSText == "" && lSText == "" && catSText == "") {
            filteredNotes = notes
        }
        
        let sortBy = self.sortByTypes[sortBySelector.selectedSegmentIndex]
        switch sortBy {
        case "title":
            filteredNotes.sort{
                $0.title < $1.title
            }
        case "createdDate":
            filteredNotes.sort{
                $0.createdDate < $1.createdDate
            }
        case "category":
            filteredNotes.sort{
                $0.category < $1.category
            }
        case "location":
            filteredNotes.sort{
                $0.location < $1.location
            }
        default:
            print("Nothing sorted")
        }
        
        
        self.data = filteredNotes
        self.nTableView.reloadData()
        
        self.advanceFilter.isHidden = true
        self.vEffect.isHidden = true
        self.vEffect.backgroundColor = UIColor.clear
        
    }
    
    
    
    @IBAction func generalSearch(_ sender: UITextField) {
        var filteredNotes = [Note]()
        let notes = notesObj.notesArray
        for note in notes {
            if (sender.text! != "" && (note.title.contains(sender.text!) || note.note.contains(sender.text!))) {
                filteredNotes.append(note)
            }
        }
        if sender.text! == "" {
            self.data = notes
        } else {
            self.data = filteredNotes
        }
        self.nTableView.reloadData()
    }
    
    func getNotes(){
        let email = AppDelegate.shared().userEmail
        if email != "NO_USER" {
            let url  = "http://alllinks.online/iosproject/getNotesForUser.php?email=\(email)"
            
            
            let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                
                var result: RetrieveNoteRespone?
                do {
                    result = try JSONDecoder().decode(RetrieveNoteRespone.self, from: data!)
                }catch{
                    print("parse error")
                }
                
                if(result?.status == "success") {
                    DispatchQueue.main.async {
                        //self.navigationController?.popToRootViewController(animated: true)
                        var notes = [Note] ()
                        for note in result!.notes{
                            var category: Category?
                            for cat in AppDelegate.shared().categories {
                                if cat.id == note.category_id {
                                    category = cat
                                }
                            }
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            dateFormatter.timeZone = TimeZone.current
                            dateFormatter.locale = Locale.current
                            let ctd =  dateFormatter.date(from: note.created_date)
                            let n = Note(id: note.id, title: note.title, category: category!.name, note: note.content , location: note.location, images: note.image != "" ? [note.image]:[], audio: note.audio, createdDate: ctd!)
                            notes.append(n)
                        }
                        notesObj.notesArray = notes
                        self.data = notesObj.notesArray
                        self.loadImage()
                        
                        //self.displayAlert(title: "Retrieve Note", message: "Note Retrieve Successfully")
                    }
                } else {
                    self.displayAlert(title: "Retrieve Note", message: "Note Retrieve Failed")
                }
            })
            task.resume()
        } else {
            self.displayAlert(title: "Note", message: "Please Login to add note")
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
    
    func getCategory(){
        self.activityIndicator.startAnimating()
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
                    DispatchQueue.main.async {
                        if result!.categories.count == 0 {
                             self.activityIndicator.stopAnimating()
                        }
                        AppDelegate.shared().categories.removeAll()
                        //self.navigationController?.popToRootViewController(animated: true)
                        for cat in result!.categories {
                            let category = Category(id: cat.id, name: cat.name, user_id: cat.user_id)
                            AppDelegate.shared().categories.append(category)
                        }
                        self.getNotes()
                    }
                } else {
                    self.displayAlert(title: "Category", message: "Category Creation Failed")
                }
            })
            task.resume()
        } else {
            data = [Note] ()
            self.nTableView.reloadData()
            self.activityIndicator.stopAnimating()
            displayAlert(title: "Notes", message: "Please Login to View Notes")
        }
    }
    
    func loadImage() {
        var totalImgCellCount = 0
        for note in data {
            if note.images.count > 0{
                totalImgCellCount += 1
            }
        }
        
        for note in data{
            if note.images.count > 0 {
                let task =  URLSession.shared.dataTask(with: URL(string: "http://\(note.images[0])")!, completionHandler: {(data, response, error) in
                    guard error == nil else {
                        print ("image load error \(error!)")
                        return
                    }
                    let image = UIImage(data: data!)
                    self.cellImages[note.title] = image
                    //                    self.nTableView.reloadData()
                    if totalImgCellCount == self.cellImages.count {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            self.nTableView.reloadData()
                        }
                    }
                })
                task.resume()
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.nTableView.reloadData()
                }
            }
            
        }
    }
    
    struct RetrieveNoteRespone: Codable {
        let status: String
        let notes: [NoteServerFormat]
    }
    
    struct NoteServerFormat: Codable {
        var id: String
        var created_date: String
        var updated_date: String
        var title: String
        var content: String
        var category_id: String
        var location: String
        var secured: String
        var image: String
        var audio: String
        var video: String
        var user_id: String
    }
}
