//
//  FirstViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/18/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import CoreML
import NaturalLanguage
class FirstViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
//        print("I am happy")
//        let entities = ["negations" : ["not", "never", "no"]]
//        let tagger = NLTagger(tagSchemes: [.lexicalClass])
////        let gazetter = try! NLGazetteer(dictionary: entities, language: .english)
////        tagger.setGazetteers([gazetter], for: .nameTypeOrLexicalClass)
//        tagger.string = "As I was leaving, I ate food"
//        
//        tagger.enumerateTags(in: tagger.string!.startIndex..<tagger.string!.endIndex, unit: .word, scheme: .lexicalClass, options: [.omitWhitespace, .omitPunctuation]) { (tag, range) -> Bool in
//            if tag != nil {
//                print("Tag", tag)
//            }
//            return true
//        }
            
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "signed_in") {
            print("JUICE WRLD")
            transitionToHomeScreen()
        }
    }
    
    func transitionToHomeScreen() {
        let vc = storyboard?.instantiateViewController(identifier: "tabbar") as? MainTabBarController
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
        
        
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
