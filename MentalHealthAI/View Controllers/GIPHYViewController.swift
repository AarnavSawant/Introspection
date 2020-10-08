//
//  GIPHYViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/1/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import SwiftGifOrigin
import FirebaseAuth
import FirebaseAnalytics
class GIPHYViewController: UIViewController {
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var dictionary: [String : [String : Any]]?
    var gifShareURL: String?
    @IBOutlet weak var cheerLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var emotionLabel: UILabel!
    var gifs  = [Gif]()
    var network = GifNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cheerLabel.backgroundColor = .white

        cheerLabel.alpha = 0.6
        cheerLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        shareButton.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        shareButton.layer.cornerRadius = 11
        shareButton.setTitleColor(.white, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent("entered_GIPHY_Screen", parameters: nil)
        activityView.startAnimating()
        activityView.isHidden = false
        activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        calendarButton.setTitleColor(UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1), for: .normal)
        calendarButton.layer.cornerRadius = 11
        calendarButton.backgroundColor = .white
        let navView = UIView()
        //            mainImageView.backgroundColor = .white
        //
        //           mainImageView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
                      let label = UILabel()
                      label.text = "introspection"
                      label.sizeToFit()
                      label.center = navView.frame.origin

                      let image = UIImageView()
                      image.image = UIImage(named: "Infinity")
                      label.frame.size.width = 150
                      label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                      label.font = UIFont(name: "SFProDisplay-Heavy", size: 18)

                      image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
                      view.backgroundColor = .white
                      image.contentMode = UIView.ContentMode.scaleAspectFit

                      navView.addSubview(label)
                      navView.addSubview(image)

                      self.navigationItem.titleView = navView
                self.navigationItem.titleView?.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
//        reloadInputViews()
//        let shouldSearch = UserDefaults.standard.bool(forKey: "shouldSearch")
//        let lastEmotion = UserDefaults.standard.object(forKey: "lastEmotion") as? String
//        print(lastEmotion)
//        let lastDate = UserDefaults.standard.object(forKey: "lastDate") as? Date
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        var maxTimestamp = 0.0
        var maxURL: String?
        var maxTerm: String?
        var maxEmotion: String?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
//               let db = Firestore.firestore()
        let calendar = Calendar.current
        let current_year = calendar.component(.year, from: Date())
        let current_month = calendar.component(.month, from: Date())
        let current_day = calendar.component(.day, from: Date())
        let currentMonthString = calendar.monthSymbols[current_month - 1]
        print("DAY", current_day)
        print("MONTH", current_month)
        print("YEAR", current_year)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            let uid = Auth.auth().currentUser?.uid
            let cal = Calendar.current
            let current_year = cal.component(.year, from: Date())
            let should_query = UserDefaults.standard.bool(forKey: "should_query")
            print("SHOULD QUERY GIPHY", should_query)
            if should_query != nil {
                if should_query {
                    for year in current_year-1...current_year {
                        db.collection("users").document(uid!).collection("\(year)").getDocuments { (querySelector, error) in
                                if error != nil {
                                    print("There was an error retrieving data")
                                } else if (querySelector != nil) {
                                    let documents = querySelector!.documents
                                    for document in documents {
                                        print(document)
                                        let data = document.data()
                                        if data != nil {
                                            if self.dictionary == nil {
                                                self.dictionary = data["user_sentiment"] as! [String : [String : Any]]
                                            } else {
                                                self.dictionary = self.dictionary!.merging(data["user_sentiment"] as! [String : [String : Any]], uniquingKeysWith: { $1 })
                                            }
                                        }
                                    }
                                }
                                UserDefaults.standard.set(self.dictionary, forKey: "calendar_dictionary")
                                UserDefaults.standard.set(false, forKey: "should_query")
                                print("SHAQ", UserDefaults.standard.object(forKey: "calendar_dictionary"))
                            }
                    }
                }
            }
            db.collection("users").document(uid!).collection("day_of_the_week").document("day_of_the_week").getDocument { (querySelector, err) in
                if err != nil {
                    print("There was an error retrieving data")
                } else if (querySelector != nil) {
                    print("REAL MADRID")
                    let data = querySelector?.data()
                    if data != nil {
                        if data!["last_gif_url"] != nil {
                            maxURL = data!["last_gif_url"] as! String
                        }
                        if data!["last_gif_term"] != nil {
                            maxTerm = data!["last_gif_term"] as! String
                        }
                        if data!["last class"] != nil {
                            maxEmotion = data!["last class"] as! String
                        }
                        if data!["timestamp"] != nil {
                            maxTimestamp = data!["timestamp"] as! Double
                        }
                    }
                }
                    //                cell.gifURL = url as! String
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
            print("Max Term", maxTerm)
//        if maxTimestamp != 0.0 {
            let lastDate = Date.init(timeIntervalSince1970: maxTimestamp)
            if maxEmotion != nil && maxTerm != nil && maxURL != nil {
                let lastEmotion = maxEmotion!
                let term = maxTerm!
                let gifURL = maxURL!
                self.gifShareURL = gifURL
                let calendar = Calendar.current
                if lastDate != nil {
                    let day = calendar.component(.day, from: lastDate)
                    let month = calendar.monthSymbols[calendar.component(.month, from: lastDate) - 1]
                    let year = calendar.component(.year, from: lastDate)
                    self.dayLabel.text = "\(month) \(day), \(year)"
                }
                self.activityView.stopAnimating()
                self.activityView.isHidden = true
                self.gifView.image = UIImage.gif(url: gifURL)
                print(lastEmotion)
                if lastEmotion != nil {
        //            let term = UserDefaults.standard.string(forKey: "Last Term")
                        if lastEmotion == "joy" {
                //            searchGifs(for: "pandas")
                            self.emotionLabel.text = "You seem to be feeling happy today!"
                            self.cheerLabel.text = "So let's keep that going with a \(term) GIF!"
                            print("Wizards", self.cheerLabel.text!)
                        } else if lastEmotion == "sadness" {
    //                        searchGifs(for: "dogs")
                            self.emotionLabel.text = "You seem to be feeling sad today."
                            self.cheerLabel.text = "So let's cheer you up with a \(term) GIF!"
                        } else if lastEmotion == "anger" {
                //            searchGifs(for: "nature")
                            self.emotionLabel.text = "You seem to be feeling angry today."
                            self.cheerLabel.text = "So let's calm you down with a \(term) GIF!"
                        } else if lastEmotion == "fear" {
                //            searchGifs(for: "ocean")
                            self.emotionLabel.text = "You seem to be feeling afraid today!"
                            self.cheerLabel.text = "So let's calm your apprehensions with a \(term) GIF!"
                        } else {
                //            searchGifs(for: "Packers")
                            
                            self.emotionLabel.text = "You seem to be feeling neutral today!"
                            self.cheerLabel.text = "So let's see if you can crack a smile with this  \(term) GIF!"
                        }
                }
    //            }
            } else {
                self.emotionLabel.text = "We hope you are having a great day!"
                let terms = ["cute_dog", "doggy", "tenor"]
                let num = Int.random(in: 0...2)
                let term = terms[num]
                self.gifView.image = UIImage.gif(name: term)
                let dateFormatter = DateFormatter()
                let day = calendar.component(.day, from: Date())
                let month = calendar.monthSymbols[calendar.component(.month, from: lastDate) - 1]
                let year = calendar.component(.year, from: Date())
                self.dayLabel.text = "\(currentMonthString) \(day), \(year)"
                self.cheerLabel.text = "Keep Introspecting to get more personalized GIFS."
                self.activityView.isHidden = true
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
    @IBAction func didClickShareButton(_ sender: Any) {
        if self.gifShareURL != nil {
            print("Halleleujah")
            var shareURL:NSURL = NSURL(string: self.gifShareURL!)!
            var shareData:NSData = NSData(contentsOf: shareURL as URL)!
            let appURL: URL = URL(string: "https://apps.apple.com/us/app/id1534465066")!
            let vc = UIActivityViewController(activityItems: [shareData as Any, "Check out Introspection in the App Store", appURL], applicationActivities: nil)
            vc.popoverPresentationController?.sourceView = self.view
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true, completion: nil)
        } else {
            let shareData = try! NSData(contentsOf: Bundle.main.url(forResource: "tenor", withExtension: "gif")!)
//            print(shareData)
            let appURL: URL = URL(string: "https://apps.apple.com/us/app/id1534465066")!
            let vc = UIActivityViewController(activityItems: [shareData as Any, "Check out Introspection in the App Store", appURL], applicationActivities: nil)
            vc.popoverPresentationController?.sourceView = self.view
//            vc.popoverPresentationController?.sourceRect = self.view.bounds
            vc.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            
//            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true, completion: nil)
        }
    }
    @IBAction func didClickCalendarButton(_ sender: Any) {
        let vc = self.tabBarController as! MainTabBarController
        vc.selectedIndex = 0
    }
//    Thread 1: EXC_BREAKPOINT (code=1, subcode=0x1048cd8e4)
    
}
