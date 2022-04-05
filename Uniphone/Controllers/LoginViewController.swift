//
//  LoginViewController.swift
//  Uniphone
//
//  Created by Julia Komorowska on 21/03/2022.
import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorsays: UILabel!
    @IBOutlet weak var emailText: UITextField!
    @IBAction func login(_ sender: UIButton) {
        if let email=emailText.text, let password=passwordText.text{
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e=error{
                print(e)
                self.errorsays.text = e.localizedDescription
            }else{
                self.performSegue(withIdentifier: "LoginToSee", sender: self)
            }
        }}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
