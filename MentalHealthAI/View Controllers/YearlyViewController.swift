//
//  YearlyViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/30/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Charts
import FirebaseFirestore
import Firebase
class YearlyViewController: UIViewController {
    var dictionary: [String : [String : Any]]?
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    let email = UserDefaults.standard.string(forKey: "emailAddress")
    
    override func viewDidLoad() {
        let components = Calendar.current.dateComponents([.year], from: Date())
        yearLabel.text = "A Breakdown of your Emotion in \(components.year!)"
        yearLabel.isHidden = false
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
             let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy MM dd"
            //        let components = Calendar.current.dateComponents([.year, .month], from: Date())
            //        let startOfYear = "\(components.year!) \(components.month!) 01"
            //        print(startOfYear)
            //        let startTimeStamp = dateFormatter.date(from: startOfYear)!.timeIntervalSince1970
            //        print(startTimeStamp)
                        let db = Firestore.firestore()
                        var components = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: Date())
                        components.hour = 0
                        components.minute = 0
                        components.second = 0
                        let df = DateFormatter()
                        df.dateFormat = "yyyy MM dd"
                        let calendar = Calendar.current
                        let day_of_week_formatter = DateFormatter()
                        day_of_week_formatter.dateFormat = "EEEE"
                        var emotionList = [String] ()
                        let uid = UserDefaults.standard.string(forKey: "uid")
                    db.collection("users").document(uid!).collection("\(components.year!)").getDocuments { (querySnapshot, error) in
                            if error != nil {
                                print("Error retrieving querries")
                            } else {
                                let documents = querySnapshot?.documents
                                if documents != nil {
                                    var emotionCount = [String : Int]()
                                    for document in documents! {
                                        let data = document.data()
                                        if data != nil {
                                            print("PIZZA")
                                            self.dictionary = data["user_sentiment"] as! [String : [String : Any]]
                                            print("Dictionary", self.dictionary)
                                            for key in self.dictionary!.keys {
                                                print(key)
                                                if emotionCount.keys.contains(self.dictionary![key]!["emotion"] as! String) {
                                                    emotionCount[self.dictionary![key]!["emotion"] as! String]! += 1
                                                } else {
                                                    emotionCount[self.dictionary![key]!["emotion"] as! String] = 1
                                                }
                                            }
                                        }
                                self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [emotionCount["joy"] ?? 0, emotionCount["sadness"] ?? 0, emotionCount["neutral"] ?? 0, emotionCount["anger"]  ?? 0, emotionCount["fear"] ?? 0])
                                let grammarDict = ["sadness" : "sad", "joy" : "happy", "fear" : "afraid", "anger" : "angry", "neutral" : "okay"]
                                let maxEmotionValue = emotionCount.values.max()
                                var maxEmotionKeys = [String]()
                                if maxEmotionValue != 0 {
                                for key in emotionCount.keys {
                                    if emotionCount[key] == maxEmotionValue {
                                        maxEmotionKeys.append(key)
                                    }
                                }
                                if maxEmotionKeys.count > 2 {
                                     self.captionLabel.text = "This month, you have been feeling mix of emotions."
                                } else if maxEmotionKeys.count == 2 {
                                    self.captionLabel.text = "This month, you typically seem to be \(grammarDict[maxEmotionKeys[0]]!) and \(grammarDict[maxEmotionKeys[1]]!) "
                                } else {
                                    self.captionLabel.text = "This month, you typically seem to be \(grammarDict[maxEmotionKeys[0]]!)"
                                }
                                } else {
                                    self.captionLabel.text = ""
                                }

                            }
                                }
                        }
                    }
    //        print("CheeseHead", emotionList)
        }
        
        func setCharts(emotionLabels :[String], emotionCount: [Int]) {
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
                    pieChartView.data = pieChartData
            
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
