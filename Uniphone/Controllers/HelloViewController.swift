//
//  HelloViewController.swift
//  Uniphone
//
import UIKit

class HelloViewController: UIViewController {
    @IBOutlet weak var leading1: NSLayoutConstraint!
    @IBOutlet weak var trailing1: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var traling: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [ UIColor.orange.cgColor,UIColor.systemPink.cgColor, UIColor.magenta.cgColor,UIColor.purple.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
var menuOut = false
    @IBAction func menuTapped(_ sender: Any) {
        if menuOut == false {
            leading.constant = 150
            trailing1.constant = -150
            menuOut=true
        }
     else{
        leading1.constant=0
        trailing1.constant=0
        menuOut=false
    }
        UIView.animate(withDuration: 0.2, delay: 0.0,options: .curveEaseIn, animations : {
            self.view.layoutIfNeeded()}){(animationComplete) in print("The animation is completed")
        }
    }

  
    
}
