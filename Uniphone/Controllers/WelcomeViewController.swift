//
//  ViewController.swift
//  Uniphone
//
//  Created by Julia Komorowska on 11/03/2022.
//

import UIKit
import AVFoundation

class WelcomeViewController: UIViewController {
    var player: AVAudioPlayer!
    @IBOutlet weak var titleLabel: UILabel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let letterText="niphone"
        var indexchar=0.0
        playmusic(soundname: "pisanie1sek")
        for letter in letterText{
            Timer.scheduledTimer(withTimeInterval: 0.2 * indexchar, repeats: false){
                (timer) in self.titleLabel.text?.append(letter)
            }
            indexchar += 1
        }}
    
    

func playmusic(soundname: String){
    let url = Bundle.main.url(forResource: soundname, withExtension: ".m4a")
    player = try! AVAudioPlayer(contentsOf: url!)
    player.play()
    
}


}

