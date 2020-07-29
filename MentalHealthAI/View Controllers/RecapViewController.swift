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
    var emotion_dict = [Date: Emotion]()
    @IBOutlet weak var emotionLabel: UILabel!
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
        setupCalendarView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        date_to_sentiment_dict.removeAll()
        date_to_text_dict.removeAll()
        calendarView.reloadData()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let dateString = formatter.string(from: Date())
        let date = formatter.date(from: dateString)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            for data in result {
                if (data.value(forKey: "emotionDict") != nil) {
                    emotion_dict = (data.value(forKey: "emotionDict") as! [Date : Emotion])
//                    if emotion_dict != nil {
//                        for i in emotion_dict {
////                        print(data, i, i.text)
//                    }
//                    }
                }
            }
        } catch {
            print("Failed")
        }
//        if emotion_dict != nil {
//            for emotion in emotion_list {
////                print(emotion.date, emotion.emotion, emotion.text)
//                date_to_sentiment_dict[emotion.date] = emotion.emotion
//                date_to_text_dict[emotion.date] = emotion.text
//            }
//        }
//        print("Seahawks", date_to_sentiment_dict)
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollToDate(Date())
        calendarView.selectDates([Date()])
    
    }
    
    func setupCalendarView() {
        let visibleDates = calendarView.visibleDates{ (visibleDate) in
            self.setupCalendarMonthYear(from: visibleDate)
        }
        
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
//        let
        let response = db.collection("users").document(email!).collection("user_sentiment").whereField("year", isEqualTo: current_year).whereField("month", isEqualTo: current_month).whereField("day", isEqualTo: current_day).getDocuments { (querySelector, error) in
            if error != nil {
                print("There was an error retrieving data")
            } else if (querySelector != nil && !querySelector!.isEmpty) {
                let document = querySelector!.documents
                let data = document.last!.data()
                let emotion = data["emotion"] as! String
                let text = data["text"] as! String
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
        if cellState.date == Date() {
            cell.backgroundColor = .yellow
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
        textForTheDayView.text = newcell.textForTheDay
        emotionLabel.text = newcell.emotionForTheDay
        if newcell.emotionForTheDay == "joy" {
            emotionLabel.textColor = .yellow
        } else if newcell.emotionForTheDay == "anger" {
            emotionLabel.textColor = .red
        } else if newcell.emotionForTheDay == "fear" {
            emotionLabel.textColor = .purple
        } else {
            emotionLabel.textColor = .blue
        }
        
//        print(emotionForTheDay)
//        print(newcell.selectedView.isHidden)
        newcell.colorSelectedView.isHidden = false
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
