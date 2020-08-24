//
//  BreakdownViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/30/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseFirestore
class BreakdownViewController: UIViewController {
    var currentDayDictionary: [String : Int]?
    var totalDictionary: [String : [String : Int]]?
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
//    let email = UserDefaults.standard.string(forKey: "emailAddress")
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        segmentedControl.isEnabled = false
        noDataLabel.isHidden = false
        noDataLabel.textColor = .black
        super.viewDidLoad()
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
        getTotalDictionaryFromFirebase { (err, dict) in
            if err == nil {
                self.segmentedControl.isEnabled = true
                self.totalDictionary = dict
                print("dict", dict)
                if self.totalDictionary != nil {
                    if self.totalDictionary!.keys.contains("Monday") {
                        self.currentDayDictionary = self.totalDictionary!["Monday"]
                        for emotion in ["joy", "sadness", "anger", "fear", "neutral"] {
                            if !(self.currentDayDictionary?.keys.contains(emotion))! {
                                self.currentDayDictionary![emotion] = 0
                            }
                        }
                        self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [self.currentDayDictionary!["joy"] ?? 0, self.currentDayDictionary!["sadness"] ?? 0, self.currentDayDictionary!["neutral"] ?? 0, self.currentDayDictionary!["anger"]  ?? 0, self.currentDayDictionary!["fear"] ?? 0], day: "Monday")
                    }
                }
            }
        }
    }
    
    func getTotalDictionaryFromFirebase(dictionaryCompletionHandler: @escaping (Error?, [String : [String : Int]]?) -> Void){
        let db = Firestore.firestore()
        var returnDict: [String : [String : Int]]?
        let uid = UserDefaults.standard.string(forKey: "uid")
        db.collection("users").document(uid!).getDocument { (querySnapshot, err) in
            if err != nil {
                print("ERROR LOADINg BREAKDOWN QUERY")
            }
            print("QUERY SNAPSHOT", querySnapshot?.data())
            if querySnapshot?["day_of_the_week_dict"] != nil {
                returnDict = querySnapshot!["day_of_the_week_dict"] as! [String : [String : Int]]
            }

            print("RD", returnDict)
            dictionaryCompletionHandler(nil, returnDict)
        }
    }
    
    @IBAction func didChangeValue(_ sender: UISegmentedControl) {
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let index = sender.selectedSegmentIndex
        let day = days[index]
        if totalDictionary != nil {
            if (totalDictionary!.keys.contains(day)) {
                self.currentDayDictionary = totalDictionary![day]
                for emotion in ["joy", "sadness", "anger", "fear", "neutral"] {
                    if !(self.currentDayDictionary?.keys.contains(emotion))! {
                        currentDayDictionary![emotion] = 0
                    }
                }
                self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [currentDayDictionary!["joy"] ?? 0, currentDayDictionary!["sadness"] ?? 0, currentDayDictionary!["neutral"] ?? 0, currentDayDictionary!["anger"]  ?? 0, currentDayDictionary!["fear"] ?? 0], day: day)
            } else {
                noDataLabel.isHidden = false
                pieChartView.isHidden = true
                captionLabel.isHidden = true
                
            }
        }
    
    }
                
        
    
    func setCharts(emotionLabels :[String], emotionCount: [Int], day: String) {
        var dataEntries: [ChartDataEntry] = []
        var colorList = [UIColor]()
        var maxEmotions =  [String]()
        let maxCount =  emotionCount.max()
        for i in 0...emotionLabels.count - 1 {
            print(emotionCount[i])
            if emotionCount[i] == maxCount {
                maxEmotions.append(emotionLabels[i])
            }
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
        let grammarDict =  ["joy" : "happy", "sadness" : "sad", "anger" : "angry", "fear" : "scared", "neutral" : "normal"]
        if maxEmotions.count == 2 {
            captionLabel.text = "On \(day)s, you typically seem to be \(grammarDict[maxEmotions[0]]!) and \(grammarDict[maxEmotions[1]]!)"
        } else if maxEmotions.count == 1 {
            captionLabel.text = "On \(day)s, you typically seem to be \(grammarDict[maxEmotions[0]]!)"
        } else {
            captionLabel.text = "On \(day)s, you typically seem to have a mix of emotions"
        }
        print(dataEntries)
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Number of \(day)s")
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        pieChartDataSet.colors = colorList
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        pieChartView.isHidden = false
        noDataLabel.isHidden = true
        captionLabel.isHidden = false
        
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
