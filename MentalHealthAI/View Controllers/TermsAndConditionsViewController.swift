//
//  TermsAndConditionsViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/31/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import FirebaseAnalytics
class TermsAndConditionsViewController: UIViewController {

    @IBOutlet weak var termsText: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    override func viewDidLoad() {
        Analytics.logEvent("entered_TandC_Screen", parameters: nil)
        termsText.backgroundColor = .white
        termsLabel.backgroundColor = .white

        termsLabel.textColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        termsText.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        let navView = UIView()
                let label = UILabel()
                label.text = "Terms and Conditions"
                label.sizeToFit()
                label.center = navView.frame.origin

        //        let image = UIImageView()
        //        image.image = UIImage(named: "Infinity")
                label.frame.size.width = 300
                label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                label.font = UIFont(name: "SFProDisplay-Heavy", size: 18)
        //        image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
                navView.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        //        navView.tintColor = .green
        //        image.contentMode = UIView.ContentMode.scaleAspectFit

                navView.addSubview(label)
        //        navView.addSubview(image)

                self.navigationItem.titleView = navView
                self.navigationItem.titleView?.tintColor = .white
                self.navigationController?.navigationBar.tintColor = .white
        super.viewDidLoad()
        let myString = "Although all the clauses contained in this agreement are standard clauses about software products, it is advised that you read them entirely."
        let myAttribute = [ NSAttributedString.Key.foregroundColor : UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)]
        let myAttrString = NSMutableAttributedString(string: myString, attributes: myAttribute)
        let myString2 = "\n\nThis End-User License Agreement (\"EULA\") constitutes an agreement between you and Introspection (herein referred to as the \"Owner\") with regard to the Introspection application for Mobile Phones (herein referred to as \"Software Product\" or \"Software\"). By installing the Software, you are agreeing to be bound by the terms of this license agreement.\n\nYour use of the Software (as specified below) is subject to the terms and conditions set forth in this EULA. If you do not accept the terms of this EULA, do not install or use the Software.\n\n1. LICENSE. The Software is licensed, not sold. The Owner grants you a non-exclusive, non-transferable, non-sublicensable, limited right and license to use one copy of the Software for your personal non-commercial use on a single device. The rights granted herein are subject to your compliance with this EULA. The Software is being licensed to you and you hereby acknowledge that no title or ownership in the Software is being transferred or assigned and this EULA is not to be construed as a sale of any rights in the Software.\n\n2. RESTRICTIONS OF USE. Unless the Owner has authorized you to distribute the Software, you shall not make or distribute copies of the Software or transfer the Software from one device to another. You shall not decompile, reverse engineer, disassemble, include in other software, or translate the Software, or use the Software for any commercial purposes. You shall not modify, alter, change or otherwise make any modification to the Software or create derivative works based upon the Software. You shall not rent, lease, resell, sub-license, assign, distribute or otherwise transfer the Software or this license. Any attempt to do so shall be void and of no effect.\n\n3. COPYRIGHT. You acknowledge that no title to the intellectual property in the Software is transferred to you. You further acknowledge that title and full ownership rights to the Software will remain the exclusive property of Introspection, and you will not acquire any rights to the Software. You shall not remove or obscure the Owner's copyright, trademark or other proprietary notices from any of the materials contained in this package or downloaded together with the Software.\n\n4. DISCLAIMER OF WARRANTY. The Software is provided \"AS IS\", without warranty of any kind. We disclaim and make no express or implied warranties and specifically disclaim the warranties of merchantability, fitness for a particular purpose and non-infringement of third-party rights. The entire risk as to the quality and performance of the Software is with you. We do not warrant that the functions contained in the Software will meet your requirements or that the operation of the Software will be error-free.\n\n5. LIMITATION OF LIABILITY. In no event will the Owner be liable for special, incidental or consequential damages resulting from possession, access, use or malfunction of the Software, including but not limited to damages to property, loss of goodwill, computer or mobile device malfunction and, to the extent permitted by law, damages for personal injuries, property damage, lost profits or punitive damages from any causes of action arising out of or related to this EULA or the Software, whether arising in tort (including negligence), contract, strict liability or otherwise and whether or not the Owner has been advised of the possibility of such damages.\n\nBecause some states/countries do not allow certain limitations of liability, this limitation of liability shall apply to the fullest extent permitted by law in the applicable jurisdiction. This limitation of liability shall not be applied solely to the extent that any specific provision of this limitation of liability is prohibited by any federal, state, or municipal law, which cannot be pre-empted. This EULA gives you specific legal rights, and you may have other rights that vary from jurisdiction to jurisdiction. In no event shall the Owner's liability for all damages (except as required by applicable law) exceed the actual price paid by you for use of the Software.\n\n6. PRIVACY AND ADVERTISING. You can find our Privacy Policy on our website or in our application.It is advised that you read them entirely.\n\n7. INDEMNITY. You agree to indemnify, defend and hold the Owner harmless from and against any and all damages, losses, and expenses arising directly or indirectly from: (i) your acts and omissions to act in using the Software pursuant to the terms of the EULA; or (ii) your breach of this EULA.\n\n8. CHANGES. We reserve the right, at our sole discretion, to modify or replace these Terms at any time. Any changes we may make to our privacy policy in the future will be posted on this page. You should check this page from time to time and take note of any changes.\n\n9. MEDICAL DISCLAIMER. The Software is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health providers with any questions you may have regarding a medical condition. Never disregard professional medical advice or delay in seeking it because of something you have seen in this Software. If you think you may have an emergency, call your doctor, go to the emergency department, or call emergency immediately. Reliance on any information provided by Introspection or our employees is solely at your own risk.\n\n10. SUBSCRIPTIONS. Introspection users may access the Software in the following ways:\n\n\u{2022}Free Version. A program gives limited access for an unlimited time.\n\n\u{2022}In the future, Introspection may offer Paid Subscription \"PREMIUM\" offering."
        
        
        let myAttribute2 = [ NSAttributedString.Key.foregroundColor : UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.00)]
        let myAttrString2 = NSMutableAttributedString(string: myString2, attributes: myAttribute)

        myAttrString.append(myAttrString2)
        termsText.attributedText = myAttrString

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
