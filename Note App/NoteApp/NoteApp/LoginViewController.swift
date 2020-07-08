//
//  LoginViewController.swift
//  NoteApp
//
//  Created by Arunkumar Nachimuthu on 2020-06-21.
//  Copyright © 2020 user176097. All rights reserved.
//
import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.isSecureTextEntry = true
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func login(_ sender: UIButton) {
        let email = emailTxt.text!
        let password = passwordTxt.text!
        let url = "http://alllinks.online/iosproject/loginUser.php?email=\(email)&password=\(password)"
        
        let task =  URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {(data, response, error) in
            guard error == nil else {
                print ("error \(error!)")
                return
            }
            
            var result: MyResult?
            do {
                result = try JSONDecoder().decode(MyResult.self, from: data!)
            }catch{
                print("parse error")
            }
            
            if(result?.status == "success") {
                DispatchQueue.main.async {
                    AppDelegate.shared().userEmail = email
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Login", message: "No user found", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default, handler: {(alertActionData) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(alertAction)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        })
        task.resume()
        //self.uploadImage()
        // self.uploadAudio()
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func postSamp() {
        let url = "https://reqres.in/api/users"
        
        do {
            var urlReq = URLRequest(url: URL(string: url)!)
            urlReq.httpMethod = "POST"
            urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlReq.httpBody = try JSONEncoder().encode(File(name: "morpheus", job: "leader"))
            
            let dataTask = URLSession.shared.dataTask(with: urlReq) { data, response, error in
                guard error == nil else {
                    print ("error \(error!)")
                    return
                }
                
                var result: MySampleResponse?
                do {
                    result = try JSONDecoder().decode(MySampleResponse.self, from: data!)
                }catch{
                    print("parse error")
                }
            }
            dataTask.resume()
        } catch {
            print("error")
        }
    }
    
    func uploadImage(){
        let image = UIImage(named: "nt1")
        let imageData = image!.jpegData(compressionQuality: 0.4)?.base64EncodedString()
        
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
            }catch{
                print("parse error")
            }
            print (result!)
        }.resume()
        
        
        
        
        
        
    }
    
    func uploadAudio(){
        
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
            }catch{
                print("parse error")
            }
            print (result!)
        }.resume()
        
        
        
        
        
        
    }
}



struct MyResult: Codable {
    //    let userId: Int
    //    let id: Int
    //    let title: String
    //    let body: String
    let status: String
}

struct MyPostResult: Codable {
    let name: String
    let job: String
    let id: String
    let createdAt: Date
}



struct MySampleResponse: Codable {
    let name: String
    let job: String
    let id: String
    let createdAt: String
}

struct UploadResponse: Codable {
    let status: String
    let path: String
}

