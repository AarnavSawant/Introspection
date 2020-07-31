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
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    let email = UserDefaults.standard.string(forKey: "emailAddress")
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        noDataLabel.isHidden = false
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didChangeValue(_ sender: UISegmentedControl) {
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let index = sender.selectedSegmentIndex
        let day = days[index]
        let db = Firestore.firestore()
        var emotionList = [String] ()
        let response = db.collection("users").document(email!).collection("user_sentiment").whereField("day_of_the_week", isEqualTo: day).getDocuments { (querySnapshot, error) in
            if error != nil {
                print("Error retrieving querries")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()

                    let emotion = data["emotion"] as! String
                    print(emotion)
                    emotionList.append(emotion)
                    print(emotionList)
                }
                var emotionCount = ["joy" : 0, "sadness" : 0, "neutral" : 0, "anger" : 0, "fear" : 0]
                print("CheeseHead", emotionList)
                for emotion in emotionList {
                    emotionCount[emotion] = emotionCount[emotion]! + 1
                }
                self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [emotionCount["joy"] ?? 0, emotionCount["sadness"] ?? 0, emotionCount["neutral"] ?? 0, emotionCount["anger"]  ?? 0, emotionCount["fear"] ?? 0], day: day)
                let maxEmotionValue = emotionCount.values.max()
                var maxEmotionKeys = [String]()
                for key in emotionCount.keys {
                    if emotionCount[key] == maxEmotionValue {
                        maxEmotionKeys.append(key)
                    }
                }
                self.noDataLabel.isHidden = true
                self.captionLabel.text = "On \(day)s, you typically seem \(maxEmotionKeys.joined(separator: ", "))"
                }
    
        }
                
        
    }
    
    func setCharts(emotionLabels :[String], emotionCount: [Int], day: String) {
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
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Number of \(day)s")
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
