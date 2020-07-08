//
//  ViewController.swift
//  NoteApp
//
//  Created by user176097 on 6/8/20.
//  Copyright © 2020 user176097. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation


class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var attachmentTable: UITableView!
    @IBOutlet weak var sView: UIView!
    @IBOutlet weak var ntitle: UITextField!
    @IBOutlet weak var ncategory: UITextField!
    @IBOutlet weak var ndescription: UITextView!
    @IBOutlet weak var recAudioEffectView: UIView!
    @IBOutlet weak var recAudioView: UIView!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var tapToRecordLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    
    var userLocation:CLLocationCoordinate2D?
    var local : String?
    var subLocal : String?
    let locationManager = CLLocationManager()
    let imagePicker = UIImagePickerController()
    let videoPicker = UIImagePickerController()
    
    var timer: Timer?
    var totalTime = 60
    
    
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var recordingSession : AVAudioSession!
    
    var audioArray : [String] = []
    var tempAudioName : String?
    var audioFilename : URL?
    var numberOfAudio = 0
    var audioData = NSData()
    
    
    var isAddOnShow = false
    var images: [UIImage] = []
    var imageUploadedPaths: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var detailNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ntitle.text = detailNote?.title;
        ncategory.text = detailNote?.category;
        ndescription.text  = detailNote?.note;
        
        
        recAudioEffectView.isHidden = true
        recAudioView.isHidden = true
        attachmentTable.delegate = self
        attachmentTable.dataSource = self
        attachmentTable.rowHeight = UITableView.automaticDimension
        locationText.text = ""
        checkLocationServices()
        checkAudioPersmission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.images = []
        self.loadImage()
        if (self.detailNote?.location != nil)  {
            let extractLocation = self.detailNote!.location.split(separator: "-")
            self.locationText.text = "\(extractLocation[1]),\(extractLocation[0])"
        }
        if detailNote?.audio != nil {
            audioArray.append(detailNote!.audio)
        }
        
        self.attachmentTable.reloadData()
        self.attachmentTable.separatorColor = UIColor.clear
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        activityIndicator.startAnimating()
        self.uploadImage()
    }
    
    
    func updateNote(categoryId:String, noteId: String) {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let email = AppDelegate.shared().userEmail
        
        let locationMerged = "\(self.local!)-\(self.subLocal!)-\(self.userLocation!.latitude)-\(self.userLocation!.longitude)"
        let changedTitleName = ntitle.text!.replacingOccurrences(of: " ", with: "+")
        let changedDescName = ndescription.text!.replacingOccurrences(of: " ", with: "+")
        let changedLocationMerged = locationMerged.replacingOccurrences(of: " ", with: "+")
        if email != "NO_USER" {
            var url  = "http://alllinks.online/iosproject/updateNote.php?created_date=\(df.string(from: Date()))&updated_date=&title=\(changedTitleName)&content=\(changedDescName)&category_id=\(categoryId)&location=\(changedLocationMerged)&secured="
            if imageUploadedPaths != nil {
                url.append("&image=\(imageUploadedPaths!)")
            }else{
                url.append("&image=")
            }
            
            if audioArray.count > 0 {
                url.append("&audio=\(audioArray[0])")
            }else{
                url.append("&audio=")
            }
            url.append("&video=&id=\(noteId)")
            
            
            let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                
                var result: UpdateNoteResponse?
                do {
                    result = try JSONDecoder().decode(UpdateNoteResponse.self, from: data!)
                }catch{
                    print("parse error")
                }
                
                if(result?.status == "success") {
                    DispatchQueue.main.async {
                        //self.navigationController?.popToRootViewController(animated: true)
                        self.activityIndicator.stopAnimating()
                        self.displayAlert(title: "Add Note", message: "Note Saved Successfully")
                    }
                } else {
                    self.displayAlert(title: "Add Note", message: "Note Creation Failed")
                }
            })
            task.resume()
        } else {
            self.displayAlert(title: "Note", message: "Please Login to add note")
        }
    }
    
    
    func createNote(categoryId: String) {
        // do {
        
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let email = AppDelegate.shared().userEmail
        let locationMerged = "\(self.local!)-\(self.subLocal!)-\(self.userLocation!.latitude)-\(self.userLocation!.longitude)"
        let changedTitleName = ntitle.text!.replacingOccurrences(of: " ", with: "+")
        let changedDescName = ndescription.text!.replacingOccurrences(of: " ", with: "+")
        let changedLocationMerged = locationMerged.replacingOccurrences(of: " ", with: "+")
        if email != "NO_USER" {
            var url  = "http://alllinks.online/iosproject/addNote.php?created_date=\(df.string(from: Date()))&updated_date=&title=\(changedTitleName)&content=\(changedDescName)&category_id=\(categoryId)&location=\(changedLocationMerged)&secured="
            if imageUploadedPaths != nil {
                url.append("&image=\(imageUploadedPaths!)")
            }else{
                url.append("&image=")
            }
            
            if audioArray.count > 0 {
                url.append("&audio=\(audioArray[0])")
            }else{
                url.append("&audio=")
            }
            url.append("&video=&email=\(email)")
            
            
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
                        self.activityIndicator.stopAnimating()
                        self.displayAlert(title: "Add Note", message: "Note Saved Successfully")
                    }
                } else {
                    self.displayAlert(title: "Add Note", message: "Note Creation Failed")
                }
            })
            task.resume()
        } else {
            self.displayAlert(title: "Note", message: "Please Login to add note")
        }
        
        /* var urlReq = URLRequest(url: URL(string: url)!)
         urlReq.httpMethod = "GET"
         urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
         let dt = try JSONEncoder().encode(AddNoteRequest(created_date: df.string(from: Date()), updated_date: "", title: ntitle.text!, content: ndescription.text!, category_id: categoryId, location: "", secured: "", image: "", audio: "", video: "", email: AppDelegate.shared().userEmail))
         urlReq.httpBody = dt
         
         let dataTask = URLSession.shared.dataTask(with: urlReq) { data, response, error in
         guard error == nil else {
         print ("error \(error!)")
         return
         }
         
         var result: NoteResponse?
         do {
         result = try JSONDecoder().decode(NoteResponse.self, from: data!)
         print(result!)
         self.displayAlert(title: "Add Note", message: "Note Saved Successfully")
         }catch{
         print("parse error")
         }
         }
         dataTask.resume()
         } catch {
         print("error")
         }*/
    }
    
    func getCategory(categoryName: String) {
        for category in AppDelegate.shared().categories {
            if category.name == categoryName {
                if self.detailNote?.id != nil {
                    self.updateNote(categoryId: String(category.id), noteId: self.detailNote!.id)
                }else {
                    self.createNote(categoryId: String(category.id))
                }
                return
            }
        }
        
        let email = AppDelegate.shared().userEmail
        if email != "NO_USER" {
            let changedCatName = categoryName.replacingOccurrences(of: " ", with: "+")
            let url  = "http://alllinks.online/iosproject/addCategory.php?email=\(email)&name=\(changedCatName)"
            
            let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                
                var result: NoteResponse?
                do {
                    result = try JSONDecoder().decode(NoteResponse.self, from: data!)
                }catch{
                    print("parse error")
                }
                
                if(result?.status == "success") {
                    DispatchQueue.main.async {
                        if self.detailNote?.id != nil {
                            self.updateNote(categoryId: String(result!.id), noteId: self.detailNote!.id)
                        }else {
                            self.createNote(categoryId: String(result!.id))
                        }
                    }
                } else {
                    self.displayAlert(title: "Category", message: "Category Creation Failed")
                }
            })
            task.resume()
        } else {
            self.displayAlert(title: "Note", message: "Please Login to add note")
        }
        
        
    }
    
    @IBAction func deleteNote(_ sender: UIBarButtonItem) {
        
        let email = AppDelegate.shared().userEmail
        if email != "NO_USER" && detailNote != nil {
            let url  = "http://alllinks.online/iosproject/deleteNote.php?id=\(detailNote!.id)"
            
            
            let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                
                var result: UpdateNoteResponse?
                do {
                    result = try JSONDecoder().decode(UpdateNoteResponse.self, from: data!)
                }catch{
                    print("parse error")
                }
                
                if(result?.status == "success") {
                    DispatchQueue.main.async {
                        self.displayAlert(title: "Delete Note", message: "Note Deleted Successfully")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    self.displayAlert(title: "Delete Note", message: "Note Deletion Failed")
                }
            })
            task.resume()
        } else {
            self.displayAlert(title: "Note", message: "Cannot Delete Note")
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
    struct AddCategoryResponse:Codable {
        var status: String
        var id: Int
    }
    
    struct NoteResponse: Codable {
        let status: String
        let id: Int
    }
    
    struct UpdateNoteResponse:Codable {
        let status: String
    }
    
    func uploadImage(){
        if(images.count > 0){
            var indx = 0
            for image in images {
                let imageData = image.jpegData(compressionQuality: 0.4)?.base64EncodedString()
                
                let url = URL(string: "http://alllinks.online/iosproject/fileUpload.php")
                var urlReq = URLRequest(url:url!)
                urlReq.httpMethod = "post"
                
                let lineBreak = "\r\n"
                let boundary = "----------------\(UUID().uuidString)"
                
                urlReq.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
                
                var reqData = Data()
                reqData.append("--\(boundary)\r\n".data(using: .utf8)!)
                reqData.append("content-disposition: form-data; name=\"fileToUpload\" \(lineBreak + lineBreak)".data(using: .utf8)!)
                reqData.append((imageData?.data(using: .utf8))!)
                
                reqData.append("--\(lineBreak)--\(boundary)\r\n".data(using: .utf8)!)
                reqData.append("content-disposition: form-data; name=\"type\" \(lineBreak + lineBreak)".data(using: .utf8)!)
                reqData.append(("jpg\(lineBreak)".data(using: .utf8))!)
                
                reqData.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
                
                urlReq.addValue("\(reqData.count)", forHTTPHeaderField: "content-length")
                urlReq.httpBody = reqData
                
                let decData = String(decoding: reqData, as: UTF8.self)
                
                URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
                    guard error == nil else {
                        print ("error \(error!)")
                        return
                    }
                    var result: UploadResponse?
                    do {
                        result = try JSONDecoder().decode(UploadResponse.self, from: data!)
                        print(result!)
                        self.imageUploadedPaths = result!.path
                        indx += 1
                        if (indx == self.images.count) {
                            self.uploadAudio()
                        }
                    }catch{
                        print("parse error")
                    }
                    print (result!)
                }.resume()
            }
        } else {
            self.uploadAudio()
        }
    }
    
    func uploadAudio(){
        if(audioArray.count > 0) {
            var audioData :String?
            do{
                let filePath = Bundle.main.url(forResource: "test", withExtension: "mp3")!
                let data = try NSData(contentsOf: filePath, options: .mappedIfSafe)
                audioData = data.base64EncodedString(options: .endLineWithCarriageReturn)
                
            }catch{
                print("error")
            }
            
            
            let url = URL(string: "http://alllinks.online/iosproject/fileUpload.php")
            var urlReq = URLRequest(url:url!)
            urlReq.httpMethod = "post"
            
            let lineBreak = "\r\n"
            let boundary = "----------------\(UUID().uuidString)"
            
            urlReq.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "content-type")
            
            var reqData = Data()
            reqData.append("--\(boundary)\r\n".data(using: .utf8)!)
            reqData.append("content-disposition: form-data; name=\"fileToUpload\" \(lineBreak + lineBreak)".data(using: .utf8)!)
            reqData.append((audioData?.data(using: .utf8))!)
            
            reqData.append("--\(lineBreak)--\(boundary)\r\n".data(using: .utf8)!)
            reqData.append("content-disposition: form-data; name=\"type\" \(lineBreak + lineBreak)".data(using: .utf8)!)
            reqData.append(("mp3\(lineBreak)".data(using: .utf8))!)
            
            reqData.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
            
            urlReq.addValue("\(reqData.count)", forHTTPHeaderField: "content-length")
            urlReq.httpBody = reqData
            
            let decData = String(decoding: reqData, as: UTF8.self)
            
            URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                var result: UploadResponse?
                do {
                    result = try JSONDecoder().decode(UploadResponse.self, from: data!)
                    DispatchQueue.main.async {
                        self.getCategory(categoryName: self.ncategory.text!)
                    }
                    
                    
                }catch{
                    print("parse error")
                }
                print (result!)
            }.resume()
            
        }else{
            getCategory(categoryName: ncategory.text!)
        }
    }
    
    func loadImage() {
        if self.detailNote != nil && self.detailNote!.images.count > 0 {
            for imgPath in detailNote!.images {
                let task =  URLSession.shared.dataTask(with: URL(string: "http://\(imgPath)")!, completionHandler: {(data, response, error) in
                    guard error == nil else {
                        print ("image load error \(error!)")
                        return
                    }
                    let image = UIImage(data: data!)
                    self.images.append(image!)
                    DispatchQueue.main.async {
                        self.attachmentTable.reloadData()
                    }
                    //                    self.nTableView.reloadData()
                })
                task.resume()
            }
        }
    }
}




extension ViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBAction func addImage(_ sender: UIBarButtonItem) {
        imagePicker.delegate = self
        let actionSource = UIAlertController(title: "Select source", message: "", preferredStyle: .actionSheet)
        actionSource.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true,completion: nil)
            }else{
                let noCamera = UIAlertController(title: "Alert" ,message: "Camera Not Availabel", preferredStyle: .alert)
                noCamera.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(noCamera,animated: true,completion: nil)
            }
            
        }))
        actionSource.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true,completion: nil)
        }))
        actionSource.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSource,animated: true,completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let photo = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        images.append(photo)
        picker.dismiss(animated: true, completion: nil)
        attachmentTable.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func checkAudioPersmission(){
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission{(hasPermission) in
            if hasPermission {
                print("Granted")
            }else{
                //alert
            }
            
        }
    }
    @IBAction func addAudio(_ sender: UIBarButtonItem) {
        let actionSource = UIAlertController(title: "Select source", message: "", preferredStyle: .actionSheet)
        actionSource.addAction(UIAlertAction(title: "Record Audio", style: .default, handler: { (action: UIAlertAction) in
            self.recAudioEffectView.isHidden = false
            self.recAudioView.isHidden = false
        }))
        actionSource.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSource,animated: true,completion: nil)
    }
    
    
    
    private func startOtpTimer() {
        self.totalTime = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        print(self.totalTime)
        self.timerLbl.text = self.timeFormatted(self.totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    @IBAction func recordPlayPause(_ sender: UIButton) {
        sender.isSelected.toggle()
        if audioRecorder == nil {
            startOtpTimer()
            tapToRecordLbl.text = "Stop"
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
            let date = (formatter.string(from: Date()) as NSString) as String
            tempAudioName = "voice_\(date).m4a"
            let fileName = getDocumentsDirector().appendingPathComponent(tempAudioName!)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ] as [String : Any]
            
            do{
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
            }catch{
                print(error)
            }
        }else{
            tapToRecordLbl.text = "Tap to Record"
            audioRecorder?.stop()
            audioRecorder = nil
            timer!.invalidate()
            self.timer = nil
        }
        
    }
    func getDocumentsDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recAudioEffectView.isHidden = true
        recAudioView.isHidden = true
        audioArray.append(tempAudioName!)
        attachmentTable.reloadData()
        
        guard let audioPathString = getDocumentsDirector().appendingPathComponent(tempAudioName!).path as? String else {
            return
        }
        do{
            if (FileManager.default.fileExists(atPath: audioPathString)) {
                audioData = try NSData(contentsOfFile: NSString(string: audioPathString) as String)
            } else {
                print("error")
            }
        }catch{
            print(error)
        }
        
    }
    func playAudio(index : Int) {
        let audioFilename = getDocumentsDirector().appendingPathComponent(audioArray[index])
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.play()
        }catch{
            print(error)
        }
        
    }
    
}

extension ViewController : CLLocationManagerDelegate{
    func checkLocationServices (){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            checkLocationAuthorization()
        }else {
            locationAlert(alertType: "noGps")
        }
    }
    func checkLocationAuthorization (){
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            locationAlert(alertType: "denied")
            break
        case .notDetermined :
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse :
            locationManager.startUpdatingLocation()
        case .restricted:
            break
        default:
            break
        }
    }
    func getUserLocation(){
        let geoCoder = CLGeocoder()
        let getMovedMapCenter: CLLocation =  CLLocation(latitude: userLocation!.latitude, longitude: userLocation!.longitude)
        geoCoder.reverseGeocodeLocation(getMovedMapCenter, completionHandler:{ (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                self.subLocal = firstLocation?.subLocality
                self.local = firstLocation?.locality
                if (self.detailNote?.location != nil)  {
                    let extractLocation = self.detailNote!.location.split(separator: "-")
                    self.locationText.text = "\(extractLocation[1]),\(extractLocation[0])"
                }else{
                    self.locationText.text = "\(self.subLocal!),\(self.local!)"
                }
            }
            else {
                
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = manager.location?.coordinate
        getUserLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    func locationAlert(alertType : String){
        var msg : String?
        if alertType == "noGps" {
            msg = "Enable Gps to save note with Location"
        }else if alertType == "denied" {
            msg = "Acess to Location has been denied. Please grant permission in settings"
        }
        let actionSource = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        actionSource.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSource,animated: true,completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap"{
            let mapController = segue.destination as! mapViewController
            mapController.userLocation = userLocation
            mapController.placeName = "\(subLocal!),\(local!)"
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (images.count+audioArray.count)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < images.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageRow") as! imageTableViewCell
            cell.attachedImage.image = images[indexPath.row]
            cell.attachedImage.contentMode = .scaleAspectFill
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.sizeToFit()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "audioRow") as! audioTableViewCell
            cell.audioName.text = audioArray[indexPath.row - images.count]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if indexPath.row > images.count{
        
        print(indexPath.row)
        var audioIndex = indexPath.row - images.count
        playAudio(index : audioIndex)
        // }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if indexPath.row < images.count{
                images.remove(at: indexPath.row)
            }else{
                audioArray.remove(at: indexPath.row)
            }
            attachmentTable.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

