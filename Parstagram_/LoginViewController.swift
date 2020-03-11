//
//  LoginViewController.swift
//  Parstagram_
//
//  Created by Athena Raya on 3/3/20.
//  Copyright © 2020 Athena Raya. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func OnsignIn(_ sender: Any) {
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) {
            (user,error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                 print("Error: \(error?.localizedDescription)")
            }
        }
    }
    

    @IBAction func OnsignUp(_ sender: Any) {
        
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        

        user.signUpInBackground { (success, error) in
            if success{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }else{
                print("Error: \(error?.localizedDescription)")
            }
        }
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
