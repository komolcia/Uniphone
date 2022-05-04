//
//  ProfileViewController.swift
//  Uniphone
//
import UIKit
import Firebase
class ProfileViewController: UIViewController {
  
    @IBOutlet weak var email: UITextField!
    @IBAction func Zmienhaslo(_ sender: UIButton) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: email.text!){
            (error) in
            if let error = error {
                let alert = UIAlertController(title: "Error",message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert,animated: true, completion: nil)
                return
            }
            let alert = UIAlertController(title: "udało się" ,message: "Na podany email został wysłany reset hasła", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert,animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
