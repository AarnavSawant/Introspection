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
import FirebaseAuth
class YearlyViewController: UIViewController {
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var captionImage: UIImageView!
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    var dictionary: [String : [String : Any]]?
   
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!

    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = .white
        let navView = UIView()
                  let label = UILabel()
                  label.text = "This Year"
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
        pieChartView.legend.enabled = false
        calendarButton.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        calendarButton.layer.cornerRadius = 15
        calendarButton.setTitleColor(.white, for: .normal)
        bottomBackgroundView.layer.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1).cgColor
        bottomBackgroundView.layer.cornerRadius = 15
//        let components = Calendar.current.dateComponents([.year], from: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
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
        let uid = Auth.auth().currentUser?.uid
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
                        }
                        self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [emotionCount["joy"] ?? 0, emotionCount["sadness"] ?? 0, emotionCount["neutral"] ?? 0, emotionCount["anger"]  ?? 0, emotionCount["fear"] ?? 0])
                        let grammarDict = ["sadness" : "sad", "joy" : "happy", "fear" : "afraid", "anger" : "angry", "neutral" : "neutral"]
                        let maxEmotionValue = emotionCount.values.max()
                        var maxEmotionKeys = [String]()
                        if maxEmotionValue != nil {
                            if maxEmotionValue != 0 {
                                for key in emotionCount.keys {
                                    if emotionCount[key] == maxEmotionValue {
                                        maxEmotionKeys.append(key)
                                    }
                                }
                                self.captionLabel.text = "This year, you typically seem to be \(grammarDict[maxEmotionKeys[0]]!)"
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
                            } else {
//                                self.captionLabel.text = "No Data Available for This Year"
                            }
                        } else {
                            self.captionLabel.text = "No Data Available for This Year"
                        }
                    } else {
                        self.captionLabel.text = "No Data Available for This Year"
                    }
                }
            }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func didClickCalendarButton(_ sender: Any) {
        let vc = self.tabBarController as! MainTabBarController
        vc.selectedIndex = 0
    }
    override func viewDidAppear(_ animated: Bool) {
            
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
//                            dataEntry.label = emotionLabels[i]
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
