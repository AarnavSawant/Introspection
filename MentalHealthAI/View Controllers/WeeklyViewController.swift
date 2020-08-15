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
import FirebaseFirestore
class WeeklyViewController: UIViewController {
    var dictionary: [String : [String : Any]]?
    @IBOutlet weak var captionLabel: UILabel!
//    let email = UserDefaults.standard.string(forKey: "emailAddress")
    @IBOutlet weak var pieView: PieChartView!
    var date_to_sentiment_dict = [Date : String] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        let uid = UserDefaults.standard.string(forKey: "uid")
        var emotionCount = [String : Int]()
        if todaycomponents.month != components.month {
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
                                if emotionCount.keys.contains(self.dictionary![key]!["emotion"] as! String) {
                                    emotionCount[self.dictionary![key]!["emotion"] as! String]! += 1
                                } else {
                                    emotionCount[self.dictionary![key]!["emotion"] as! String] = 1
                                }
                            }
                        }
                        //                print("CheeseHead", emotionList)
                        //                for emotion in emotionList {
                        //                    if emotionCount[emotion] != nil {
                        //                        emotionCount[emotion] = emotionCount[emotion]! + 1
                        //                    } else {
                        //                        emotionCount[emotion] = 1
                        //                    }
                        //                }
//                        self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [emotionCount["joy"] ?? 0, emotionCount["sadness"] ?? 0, emotionCount["neutral"] ?? 0, emotionCount["anger"]  ?? 0, emotionCount["fear"] ?? 0])
                        let grammarDict = ["sadness" : "sad", "joy" : "happy", "fear" : "afraid", "anger" : "angry", "neutral" : "okay"]
                        let maxEmotionValue = emotionCount.values.max()
                        var maxEmotionKeys = [String]()
                        if maxEmotionValue != 0 {
                            for key in emotionCount.keys {
                                if emotionCount[key] == maxEmotionValue {
                                    maxEmotionKeys.append(key)
                                }
                            }
                            //                print("Emotion CemotionCount)
                            print("Max Emotion Keys", maxEmotionKeys)
                            if maxEmotionKeys.count > 2 {
                                self.captionLabel.text = "This week, you have been feeling mix of emotions."
                            } else if maxEmotionKeys.count == 2 {
                                self.captionLabel.text = "This week, you typically seem to be \(grammarDict[maxEmotionKeys[0]]!) and \(grammarDict[maxEmotionKeys[1]]!) "
                            } else {
                                self.captionLabel.text = "This week, you typically seem to be \(grammarDict[maxEmotionKeys[0]]!)"
                            }
                        } else {
                            self.captionLabel.text = ""
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print(emotionCount)
            self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [emotionCount["joy"] ?? 0, emotionCount["sadness"] ?? 0, emotionCount["neutral"] ?? 0, emotionCount["anger"]  ?? 0, emotionCount["fear"] ?? 0])
            let grammarDict = ["sadness" : "sad", "joy" : "happy", "fear" : "afraid", "anger" : "angry", "neutral" : "okay"]
            let maxEmotionValue = emotionCount.values.max()
            print("MAX VALUE", maxEmotionValue)
            var maxEmotionKeys = [String]()
            if maxEmotionValue != 0 {
                for key in emotionCount.keys {
                    if emotionCount[key] == maxEmotionValue {
                        maxEmotionKeys.append(key)
                    }
                }
                print("Max Emotion Keys", maxEmotionKeys)
                if maxEmotionKeys.count > 2 {
                    self.captionLabel.text = "This week, you have been feeling mix of emotions."
                } else if maxEmotionKeys.count == 2 {
                    self.captionLabel.text = "This week, you typically seem to be \(grammarDict[maxEmotionKeys[0]]!) and \(grammarDict[maxEmotionKeys[1]]!) "
                } else {
                    self.captionLabel.text = "This week, you typically seem to be \(grammarDict[maxEmotionKeys[0]]!)"
                }
            } else {
                self.captionLabel.text = ""
            }
        }
    }
    //        print("CheeseHead", emotionList)
    
    func setCharts(emotionLabels :[String], emotionCount: [Int]) {
        //        var dataEntries: [ChartDataEntry] = []
        var dataEntries: [ChartDataEntry] = []
        var colorList = [UIColor]()
        for i in 0...emotionLabels.count - 1 {
            print(emotionCount[i])
            let dataEntry = PieChartDataEntry()
            if emotionCount[i] != 0 {
                dataEntry.y = Double(emotionCount[i])
                dataEntry.label = emotionLabels[i]
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
            }
        }
        //        print(dataEntries[1].data)
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Number of Days")
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        pieChartDataSet.colors = colorList
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieView.data = pieChartData
        
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
