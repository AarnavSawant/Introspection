//
//  RecapViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/14/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData
import Firebase
import FirebaseFirestore
class RecapViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var gifView: UIImageView!
    @IBOutlet weak var feelingsLabel: UILabel!
//    var emotion_dict = [Date: Emotion]()
    @IBOutlet weak var textForTheDayView: UITextView!
    let formatter = DateFormatter()
    var date_to_sentiment_dict = [Date : String]()
    var date_to_text_dict =  [Date : String]()
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: JTACMonthView!
    override func viewDidLoad() {
        self.tabBarController?.selectedIndex = 1
        calendarView.scrollDirection = .horizontal
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if emotion_dict != nil {
//            for emotion in emotion_list {
////                print(emotion.date, emotion.emotion, emotion.text)
//                date_to_sentiment_dict[emotion.date] = emotion.emotion
//                date_to_text_dict[emotion.date] = emotion.text
//            }
//        }
//        print("Seahawks", date_to_sentiment_dict)
        textForTheDayView.text = ""
        feelingsLabel.text = ""
        gifView.image = UIImage()
        setupCalendarView()
        calendarView.reloadData()
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollToDate(Date())
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.calendarView.selectDates(from: Date(), to: Date())
        }
//        calendarView.selectDates([Date()])
        print("Calendar", calendarView.selectedDates)
    
    }
    
    @IBAction func didClickShareButton(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: ["Check out Introspection in the App Store"], applicationActivities: nil)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
        
    }
    func setupCalendarView() {
        let visibleDates = calendarView.visibleDates{ (visibleDate) in
            self.setupCalendarMonthYear(from: visibleDate)
        }
//        calendarView.selectedDates.
        
    }
    
    func setupCalendarMonthYear(from visibleDate: DateSegmentInfo) {
        let date = visibleDate.monthDates.first?.date
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = self.formatter.string(from: date!)
        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = self.formatter.string(from: date!)
    }
    func configureCells(cell: DayCell, cellState: CellState, date: Date) {
        guard let currentCell = cell as? DayCell else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DayCell, cellState: CellState) {
        let email = UserDefaults.standard.string(forKey: "emailAddress")
        cell.colorSelectedView.isHidden = true
        cell.backgroundColor = .none
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
        } else {
            cell.colorSelectedView.isHidden = true
            cell.dateLabel.textColor = .gray
        }
//        cell.gifImage = UIImage.gif(url: url as! String)!
        let newformatter = DateFormatter()
        newformatter.dateFormat = "yyyy MM dd"
        let db = Firestore.firestore()
        let calendar = Calendar.current
        let current_year = calendar.component(.year, from: cellState.date)
        let current_month = calendar.component(.month, from: cellState.date)
        let current_day = calendar.component(.day, from: cellState.date)
        let day_of_week_formatter = DateFormatter()
        day_of_week_formatter.dateFormat = "EEEE"
        let dayOfTheWeekString = day_of_week_formatter.string(from: cellState.date)
        let uid = UserDefaults.standard.string(forKey: "uid")
        if cellState.dateBelongsTo == .thisMonth {
        db.collection("users").document(uid!).collection("user_sentiment").whereField("year", isEqualTo: current_year).whereField("month", isEqualTo: current_month).whereField("day", isEqualTo: current_day).getDocuments { (querySelector, error) in
            if error != nil {
                print("There was an error retrieving data")
            } else if (querySelector != nil && !querySelector!.isEmpty) {
                let document = querySelector!.documents
                let data = document.last!.data()
                let emotion = data["emotion"] as! String
                let text = data["text"] as! String
                let url = data["gifURL"]
//                cell.gifURL = url as! String
                cell.emotionForTheDay = emotion
                cell.textForTheDay = text
                if emotion != nil {
                            if emotion == "sadness" {
                                cell.backgroundColor = .blue
                            } else if emotion == "joy" {
                                cell.backgroundColor = .yellow
                            } else if emotion == "anger" {
                                cell.backgroundColor = .red
                            } else if emotion == "fear" {
                                cell.backgroundColor = .purple
                            } else {
                                cell.backgroundColor = .gray
                            }
                //            cell.textForTheDay = emotion_dict[cellDate!]!.text
                //            cell.emotionForTheDay = emotion_dict[cellDate!]!.emotion
                        } else {
                            cell.backgroundColor = .none
                        }
                  
            }
            }
        }
//        print(emotion ?? "Nope")
        cell.colorSelectedView.layer.cornerRadius = 0.5 * cell.colorSelectedView.frame.width
//        if date_to_sentiment_dict != nil {
//        print(emotion_dict.keys)
//        for x in emotion_dict.keys {
//            print(x, emotion_dict[x]!.text, emotion_dict[x]!.emotion)
//        }
//        if (emotion_dict.keys.contains(cellDate!)) {
//
//            var emotion = emotion_dict[cellDate!]!.emotion
//            print(emotion)
        }
        
        
    }

extension RecapViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2020 01 01")!
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}
extension RecapViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DayCell
        if cellState.isSelected {
            cell.colorSelectedView.isHidden = false
        } else {
            cell.colorSelectedView.isHidden = true
        }
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCells(cell: cell as! DayCell, cellState: cellState, date: date)
    }
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let newcell = cell as? DayCell else {
            return
        }
         newcell.colorSelectedView.isHidden = false
        print("Lala", cellState.date)
        textForTheDayView.text = newcell.textForTheDay
        feelingsLabel.text = newcell.emotionForTheDay
        gifView.image = UIImage()
//        feelingsLabel.isHidden = false
        if newcell.emotionForTheDay == "joy" {
            feelingsLabel.textColor = .yellow
            feelingsLabel.text =  "You were happy on this day"
        } else if newcell.emotionForTheDay == "anger" {
           feelingsLabel.textColor = .red
            feelingsLabel.text =  "You were angry on this day"
        } else if newcell.emotionForTheDay == "fear" {
            feelingsLabel.textColor = .purple
            feelingsLabel.text =  "You were scared on this day"
        } else if newcell.emotionForTheDay == "sadness" {
            feelingsLabel.textColor = .blue
            feelingsLabel.text =  "You were sad on this day"
        } else if newcell.emotionForTheDay == "neutral" {
            feelingsLabel.textColor = .gray
            feelingsLabel.text =  "You were okay on this day"
        }
//        let queue = DispatchQueue(label: "gif-queue")
//        DispatchQueue.main.async {
//            self.gifView.image = UIImage.gif(url: newcell.gifURL)
//        }
        
//        print(emotionForTheDay)
//        print(newcell.selectedView.isHidden)
//        newcell.selectedView.backgroundColor = .orange
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let newcell = cell as? DayCell else {
            return
        }
        newcell.colorSelectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date!)
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date!)

    }
    
    
}
