//
//  HelloViewController.swift
//  Uniphone
//
import UIKit
import SwiftUI

class HelloViewController: UIViewController {
    @IBOutlet weak var leading1: NSLayoutConstraint!
    @IBOutlet weak var trailing1: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var traling: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0.74, green: 0.41, blue: 0.32, alpha: 1.00).cgColor,UIColor(red: 0.33, green: 0.07, blue: 0.31, alpha: 1.00).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        leading1.constant=0
        trailing1.constant=0    }
    @IBSegueAction func Seque(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: ContentView())
        
    }
    
    @IBSegueAction func Seque1(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: ContentViewNews())
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
