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
import FirebaseAuth
import FirebaseFirestore
class BreakdownViewController: UIViewController {
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    @IBOutlet weak var bottomBackgroundView: UIView!
    var currentDayDictionary: [String : Int]?
    var totalDictionary: [String : [String : Int]]?
//    @IBOutlet weak var noDataLabel: UILabel!

    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var captionImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    //    let email = UserDefaults.standard.string(forKey: "emailAddress")
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        numberOfDaysLabel.isHidden = true
        pieChartView.legend.enabled = false
        self.navigationController?.navigationBar.tintColor = .white
        let navView = UIView()
                  let label = UILabel()
                  label.text = "Advanced Insights"
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
        segmentedControl.isEnabled = false
        //        noDataLabel.isHidden = false
        //        noDataLabel.textColor = .black
                super.viewDidLoad()
                segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .normal)
                getTotalDictionaryFromFirebase { (err, dict) in
                    if err == nil {
                        self.segmentedControl.isEnabled = true
                        self.totalDictionary = dict
                        print("dict", dict)
                        if self.totalDictionary != nil {
                            if self.totalDictionary!.keys.contains("Monday") {
                                self.numberOfDaysLabel.isHidden = false
                                self.currentDayDictionary = self.totalDictionary!["Monday"]
                                if self.currentDayDictionary != nil {
                                    for emotion in ["joy", "sadness", "anger", "fear", "neutral"] {
                                        if !(self.currentDayDictionary?.keys.contains(emotion))! {
                                            self.currentDayDictionary![emotion] = 0
                                        }
                                    }
                                    self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [self.currentDayDictionary!["joy"] ?? 0, self.currentDayDictionary!["sadness"] ?? 0, self.currentDayDictionary!["neutral"] ?? 0, self.currentDayDictionary!["anger"]  ?? 0, self.currentDayDictionary!["fear"] ?? 0], day: "Monday")
                                } else {
                                    self.captionLabel.text = "No Data for this Day!"
                                }
                            } else {
                                self.pieChartView.isHidden = true
                                self.captionLabel.text = "No Data for this Day!"
                                
                            }
                        } else {
                            self.numberOfDaysLabel.isHidden = true
                            self.pieChartView.isHidden = true
                            self.captionLabel.text = "No Data for this Day!"
                        }
                    }
                }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent("entered_AdvancedInsights_Screen", parameters: nil)
        
        
    }
    
    func getTotalDictionaryFromFirebase(dictionaryCompletionHandler: @escaping (Error?, [String : [String : Int]]?) -> Void){
        let db = Firestore.firestore()
        var returnDict: [String : [String : Int]]?
        let uid = Auth.auth().currentUser?.uid
        db.collection("users").document(uid!).collection("day_of_the_week").document("day_of_the_week").getDocument { (querySnapshot, err) in
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
        self.captionImage.image = UIImage()
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let index = sender.selectedSegmentIndex
        let day = days[index]
        if totalDictionary != nil {
            if (totalDictionary!.keys.contains(day)) {
                numberOfDaysLabel.isHidden = false
                self.currentDayDictionary = totalDictionary![day]
                for emotion in ["joy", "sadness", "anger", "fear", "neutral"] {
                    if !(self.currentDayDictionary?.keys.contains(emotion))! {
                        currentDayDictionary![emotion] = 0
                    }
                }
                self.setCharts(emotionLabels: ["joy", "sadness", "neutral", "anger", "fear"], emotionCount: [currentDayDictionary!["joy"] ?? 0, currentDayDictionary!["sadness"] ?? 0, currentDayDictionary!["neutral"] ?? 0, currentDayDictionary!["anger"]  ?? 0, currentDayDictionary!["fear"] ?? 0], day: day)
            } else {
                numberOfDaysLabel.isHidden = true
//                noDataLabel.isHidden = false
                pieChartView.isHidden = true
                self.captionLabel.text = "No Data for this Day!"
//                captionLabel.isHidden = true
                
            }
        }
    
    }
                
        
    
    func setCharts(emotionLabels :[String], emotionCount: [Int], day: String) {
//        self.
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
//                dataEntry.label = emotionLabels[i]
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
        let grammarDict =  ["joy" : "happy", "sadness" : "sad", "anger" : "angry", "fear" : "scared", "neutral" : "neutral"]
        if maxEmotions.count != 0 {
            self.captionLabel.text = "On \(day)s, you typically feel \(grammarDict[maxEmotions[0]]!)"
            if (maxEmotions[0] == "joy") {
                self.captionImage.image = UIImage(named: "JoyResults")
            } else if (maxEmotions[0] == "sadness") {
                self.captionImage.image = UIImage(named: "SadnessResults")
            } else if (maxEmotions[0] == "anger") {
                self.captionImage.image = UIImage(named: "AngerResults")
            } else if (maxEmotions[0] == "fear") {
                self.captionImage.image = UIImage(named: "FearResults")
            } else if (maxEmotions[0] == "neutral") {
                self.captionImage.image = UIImage(named: "NeutralResults")
            }
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
//        noDataLabel.isHidden = true
        captionLabel.isHidden = false
        
    }
    @IBAction func didClickCalendarButton(_ sender: Any) {
        let vc = self.tabBarController as! MainTabBarController
        vc.selectedIndex = 0
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
