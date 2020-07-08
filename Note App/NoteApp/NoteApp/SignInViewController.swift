//
//  SignInViewController.swift
//  NoteApp
//
//  Created by Arunkumar Nachimuthu on 2020-06-22.
//  Copyright © 2020 user176097. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var reEnterPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTxt.isSecureTextEntry = true
        reEnterPassword.isSecureTextEntry = true
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    

    @IBAction func SignUp(_ sender: UIButton) {
        let email = emailTxt.text!
               let password = passwordTxt.text!
               let url = "http://alllinks.online/iosproject/addUser.php?email=\(email)&password=\(password)"
               
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
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: LoginViewController.self) {
                                _ =  self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                       }
                   } else {
                       let alert = UIAlertController(title: "Sign Up", message: "User may already exit or creation failed", preferredStyle: .alert)
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
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
