//
//  ReflectViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/28/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class ReflectViewController: UINavigationController {
    var emailAddress:String?
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(emailAddress)
//        let navigationBar = self.navigationBar
        navigationBar.barStyle = .default
        navigationBar.frame = CGRect(x: 0, y: 0, width: 375, height: 88)
        navigationBar.backgroundColor = .white

        navigationBar.barTintColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)

        var parent = self.view!
//        parent.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.heightAnchor.constraint(equalToConstant: 88).isActive = true
        navigationBar.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0).isActive = true
        navigationBar.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0).isActive = true
        navigationBar.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0).isActive = true

        navigationBar.topItem?.title = "Introspection"
//        var view = UILabel()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Bold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1)]

//        view.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        view.font = UIFont(name: "SFProDisplay-Heavy", size: 18)
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.02

        // Line height: 22 pt
        // (identical to box height)

//        view.textAlignment = .center
//        view.attributedText = NSMutableAttributedString(string: "Introspection", attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        // Do any additional setup after loading the view.
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
