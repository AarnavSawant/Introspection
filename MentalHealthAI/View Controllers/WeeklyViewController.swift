//
//  WeeklyViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/21/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import StarWarsTextView
import Charts
import CoreData
import Firebase
import FirebaseAuth
import FirebaseFirestore
class WeeklyViewController: UIViewController {
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var captionImage: UIImageView!
    var dictionary: [String : [String : Any]]?
    @IBOutlet weak var captionLabel: UILabel!
//    let email = UserDefaults.standard.string(forKey: "emailAddress")
    @IBOutlet weak var pieView: PieChartView!
    var date_to_sentiment_dict = [Date : String] ()
    override func viewDidLoad() {
        numberOfDaysLabel.isHidden = true
        self.navigationController?.navigationBar.tintColor = .white
        
        let navView = UIView()
                  let label = UILabel()
                  label.text = "This Week"
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
        calendarButton.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        calendarButton.layer.cornerRadius = 15
        calendarButton.setTitleColor(.white, for: .normal)
        bottomBackgroundView.layer.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1).cgColor
        bottomBackgroundView.layer.cornerRadius = 15
        super.viewDidLoad()
        pieView.isHidden = true
        view.backgroundColor = .white

        
        pieView.legend.enabled = false
                activityView.isHidden = false
                activityView.startAnimating()
                var lastSundayDate = Calendar.current.date(byAdding: .day, value: -Calendar.current.component(.weekday, from: Date()) + 1, to: Date())
                //        for key in date_to_sentiment_dict.keys {
                //            if key > lastSundayDate! {
                //                print(date_to_sentiment_dict[key])
                //            }
                //        }
                var components = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: lastSundayDate!)
                components.hour = 0
                components.minute = 0
                components.second = 0
                var todaycomponents = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: Date())
                todaycomponents.hour = 0
                todaycomponents.minute = 0
                todaycomponents.second = 0
                let df = DateFormatter()
                df.dateFormat = "yyyy MM dd"
                let calendar = Calendar.current
                lastSundayDate = calendar.date(from: components)
                
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickCalendarButton(_ sender: Any) {
        let vc = self.tabBarController as! MainTabBarController
        vc.selectedIndex = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent("entered_Weekly_Screen", parameters: nil)
        self.dictionary?.removeAll()
        var lastSundayDate = Calendar.current.date(byAdding: .day, value: -Calendar.current.component(.weekday, from: Date()) + 1, to: Date())
        //        for key in date_to_sentiment_dict.keys {
        //            if key > lastSundayDate! {
        //                print(date_to_sentiment_dict[key])
        //            }
        //        }
        var components = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: lastSundayDate!)
        components.hour = 0
        components.minute = 0
        components.second = 0
        var todaycomponents = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: Date())
        todaycomponents.hour = 0
        todaycomponents.minute = 0
        todaycomponents.second = 0
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        let calendar = Calendar.current
        lastSundayDate = calendar.date(from: components)
        let db = Firestore.firestore()
                        let day_of_week_formatter = DateFormatter()
                        day_of_week_formatter.dateFormat = "EEEE"
                        var emotionList = [String] ()
                        let timeSundayTimeStamp = lastSundayDate?.timeIntervalSince1970 as! Double
                        let uid = Auth.auth().currentUser?.uid
                        var emotionCount = [String : Int]()
                        if todaycomponents.month != components.month {
                            db.collection("users").document(uid!).collection("\(components.year!)").document ("\(todaycomponents.month!)").getDocument { (querySnapshot, err) in
                                    if err != nil {
                                        print("Error retrieving querries")
                                    } else  if querySnapshot != nil {
                                        //                for document in querySnapshot.documents {
                                        let data = querySnapshot!.data()
                                        if data != nil {
                                            self.dictionary = data!["user_sentiment"] as! [String : [String : Any]]
                                        }
                                        //                    print
                                        if self.dictionary != nil && self.dictionary?.count != 0 {
                                            print("KEYS", self.dictionary!.keys)
                                            for key in self.dictionary!.keys {
                                                print(key)
                                                if df.date(from: key)!.timeIntervalSince1970 >= lastSundayDate!.timeIntervalSince1970 && df.date(from: key)!.timeIntervalSince1970 <= Date().timeIntervalSince1970{
                                                    if emotionCount.keys.contains(self.dictionary![key]!["emotion"] as! String) {
                                                        emotionCount[self.dictionary![key]!["emotion"] as! String]! += 1
                                                    } else {
                                                        emotionCount[self.dictionary![key]!["emotion"] as! String] = 1
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                            db.collection("users").document(uid!).collection("\(components.year!)").document ("\(components.month!)").getDocument { (querySnapshot, err) in
                                if err != nil {
                                    print("Error retrieving querries")
                                } else  if querySnapshot != nil {
                                    //                for document in querySnapshot.documents {
                                    let data = querySnapshot!.data()
                                    if data != nil {
                                        self.dictionary = data!["user_sentiment"] as! [String : [String : Any]]
                                    }
                                    //                    print
                                    if self.dictionary != nil {
                                        for key in self.dictionary!.keys {
                                            print(key)
                                            if df.date(from: key)!.timeIntervalSince1970 >= lastSundayDate!.timeIntervalSince1970 && df.date(from: key)!.timeIntervalSince1970 <= Date().timeIntervalSince1970  {
                                                print("date", key)
                                                if emotionCount.keys.contains(self.dictionary![key]!["emotion"] as! String) {
                                                    emotionCount[self.dictionary![key]!["emotion"] as! String]! += 1
                                                    print(emotionCount)
                                                } else {
                                                    emotionCount[self.dictionary![key]!["emotion"] as! String] = 1
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            db.collection("users").document(uid!).collection("\(components.year!)").document ("\(components.month!)").getDocument { (querySnapshot, err) in
                                if err != nil {
                                    print("Error retrieving querries")
                                } else  if querySnapshot != nil {
                                    //                for document in querySnapshot.documents {
                                    let data = querySnapshot!.data()
                                    if data != nil {
                                        self.dictionary = data!["user_sentiment"] as! [String : [String : Any]]
                                    }
                                    if self.dictionary != nil {
                                        for key in self.dictionary!.keys {
                                            print(key)
                                            if df.date(from: key)!.timeIntervalSince1970 >= lastSundayDate!.timeIntervalSince1970 && df.date(from: key)!.timeIntervalSince1970 <= Date().timeIntervalSince1970{
                                                if emotionCount.keys.contains(self.dictionary![key]!["emotion"] as! String) {
                                                    emotionCount[self.dictionary![key]!["emotion"] as! String]! += 1
                                                    print("LION", lastSundayDate!, key)
                                                } else {
                                                    emotionCount[self.dictionary![key]!["emotion"] as! String] = 1
                                                }
                                            }
                                        }
                                        print(emotionCount)
                                    }
                                }
                            }
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                //            let view = UIActivityIndicatorView()
                            self.activityView.isHidden = true
                            self.activityView.stopAnimating()
                            self.pieView.isHidden = false
                            print(emotionCount)
                            self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [emotionCount["joy"] ?? 0, emotionCount["sadness"] ?? 0, emotionCount["neutral"] ?? 0, emotionCount["anger"]  ?? 0, emotionCount["fear"] ?? 0])
                            let grammarDict = ["sadness" : "sad", "joy" : "happy", "fear" : "afraid", "anger" : "angry", "neutral" : "neutral"]
                            let maxEmotionValue = emotionCount.values.max()
                            print("MAX VALUE", maxEmotionValue)
                            var maxEmotionKeys = [String]()
                            if maxEmotionValue != nil {
                                if maxEmotionValue != 0 {
                                    self.numberOfDaysLabel.isHidden = false
                                    for key in emotionCount.keys {
                                        if emotionCount[key] == maxEmotionValue {
                                            maxEmotionKeys.append(key)
                                        }
                                    }
                                    print("Max Emotion Keys", maxEmotionKeys)
                                    if maxEmotionKeys.count != 0 {
                                        self.captionLabel.text = "This week, you typically seem to be \(grammarDict[maxEmotionKeys[0]]!)"
                                        if (maxEmotionKeys[0] == "joy") {
                                            self.captionImage.image = UIImage(named: "JoyResults")
                                        } else if (maxEmotionKeys[0] == "sadness") {
                                            self.captionImage.image = UIImage(named: "SadnessResults")
                                        } else if (maxEmotionKeys[0] == "anger") {
                                            self.captionImage.image = UIImage(named: "AngerResults")
                                        } else if (maxEmotionKeys[0] == "fear") {
                                            self.captionImage.image = UIImage(named: "FearResults")
                                        } else if (maxEmotionKeys[0] == "neutral") {
                                            self.captionImage.image = UIImage(named: "NeutralResults")
                                        }
            //                            }
                                    }
                                } else {
                                    self.captionLabel.text = "No Data For This Week"
                                }
                            } else {
                                self.pieView.isHidden = true
                                self.captionLabel.text = "No Data For This Week"
                                
                            }
        
        }
    }
    
    func setCharts(emotionLabels :[String], emotionCount: [Int]) {
        var numZeroEntries = 0
        var dataEntries: [ChartDataEntry] = []
        var colorList = [UIColor]()
        for i in 0...emotionLabels.count - 1 {
            print(emotionCount[i])
            let dataEntry = PieChartDataEntry()
            if emotionCount[i] != 0 {
                dataEntry.y = Double(emotionCount[i])
                if emotionLabels[i] == "joy" {
                    colorList.append(UIColor.systemYellow)
                } else if emotionLabels[i] == "sadness" {
                    colorList.append(UIColor.systemBlue)
                } else if emotionLabels[i] == "fear" {
                    colorList.append(UIColor.systemPurple)
                } else if emotionLabels[i] == "neutral" {
                    colorList.append(UIColor.systemGray)
                } else {
                    colorList.append(UIColor.systemRed)
                }
                dataEntries.append(dataEntry)
            } else {
                numZeroEntries = numZeroEntries + 1
            }
        }
        //        print(dataEntries[1].data)
        print("PeePoo", emotionCount)
        if numZeroEntries != 5 {
            let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Number of Days")
            let noZeroFormatter = NumberFormatter()
            noZeroFormatter.zeroSymbol = ""
            pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
            pieChartDataSet.colors = colorList
            let pieChartData = PieChartData(dataSet: pieChartDataSet)
            pieView.data = pieChartData
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
    
}

