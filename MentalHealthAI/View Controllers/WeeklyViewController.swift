//
//  WeeklyViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/21/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Charts
import CoreData
import Firebase
import FirebaseFirestore
class WeeklyViewController: UIViewController {
    let email = UserDefaults.standard.string(forKey: "emailAddress")
    @IBOutlet weak var pieView: PieChartView!
    var date_to_sentiment_dict = [Date : String] ()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        let lastSundayDate = Calendar.current.date(byAdding: .day, value: -Calendar.current.component(.weekday, from: Date()) + 1, to: Date())
//        for key in date_to_sentiment_dict.keys {
//            if key > lastSundayDate! {
//                print(date_to_sentiment_dict[key])
//            }
//        }
        print(lastSundayDate)
        let db = Firestore.firestore()
        let calendar = Calendar.current
        let current_year = calendar.component(.year, from: lastSundayDate!)
        let current_month = calendar.component(.month, from: lastSundayDate!)
        let current_day = calendar.component(.day, from: lastSundayDate!)
        let day_of_week_formatter = DateFormatter()
        day_of_week_formatter.dateFormat = "EEEE"
        var emotionList = [String] ()
        let dayOfTheWeekString = day_of_week_formatter.string(from: lastSundayDate!)
        let timeSundayTimeStamp = lastSundayDate?.timeIntervalSince1970 as! Double
        let response = db.collection("users").document(email!).collection("user_sentiment").whereField("timestamp", isGreaterThanOrEqualTo: timeSundayTimeStamp).getDocuments { (querySnapshot, error) in
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
                var emotionCount = [String : Int]()
                print("CheeseHead", emotionList)
                for emotion in emotionList {
                    if emotionCount[emotion] != nil {
                        emotionCount[emotion] = emotionCount[emotion]! + 1
                    } else {
                        emotionCount[emotion] = 1
                    }
                }
                self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [emotionCount["joy"] ?? 0, emotionCount["sadness"] ?? 0, emotionCount["neutral"] ?? 0, emotionCount["anger"]  ?? 0, emotionCount["fear"] ?? 0])
            }
        }
//        print("CheeseHead", emotionList)
    }
    
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
