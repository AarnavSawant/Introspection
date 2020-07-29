//
//  UserFeedbackViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/28/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class UserFeedbackViewController: UIViewController {
    @IBOutlet weak var UserTextLabel: UILabel!
    var inputText:String?
    @IBOutlet weak var sadnessButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var fearButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!
    override func viewDidLoad() {
        UserTextLabel.text = inputText
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickSadButton(_ sender: Any) {
    }
    @IBAction func didClickNeutralButton(_ sender: Any) {
    }
    @IBAction func didClickHappyButton(_ sender: Any) {
    }
    @IBAction func didClickFearButton(_ sender: Any) {
    }
    
    @IBAction func didClickAngerButton(_ sender: Any) {
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
