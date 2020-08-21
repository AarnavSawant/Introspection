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
    var dictionary: [String : [String : Any]]?
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
        dictionary =  UserDefaults.standard.dictionary(forKey: "calendar_dictionary") as? [String : [String : Any]]
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
        cell.colorSelectedView.isHidden = true
        cell.backgroundColor = .none
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
        } else {
            cell.colorSelectedView.isHidden = true
            cell.dateLabel.textColor = .gray
        }
//        cell.gifImage = UIImage.gif(url: url as! String)!
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: cellState.date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = Calendar.current.date(from: components)
            print("\(cellState.date)", self.dictionary)
            let df = DateFormatter()
            df.dateFormat = "yyyy MM dd"
            if cellState.dateBelongsTo == .thisMonth {
            if self.dictionary != nil {
                if self.dictionary!.keys.contains("\(df.string(from: date!))") {
                print("DATE", date!)
                    cell.emotionForTheDay = self.dictionary![df.string(from: date!)]!["emotion"] as! String
                    print(cell.emotionForTheDay)
                cell.backgroundColor = .none
                if cell.emotionForTheDay == "joy" {
                     cell.backgroundColor = .systemYellow
                } else if cell.emotionForTheDay == "sadness" {
                     cell.backgroundColor = .systemBlue
                } else if cell.emotionForTheDay == "anger" {
                     cell.backgroundColor = .systemRed
                } else if cell.emotionForTheDay == "neutral" {
                    print("CELL", cellState.date)
                     cell.backgroundColor = .systemGray
                } else if cell.emotionForTheDay == "fear" {
                     cell.backgroundColor = .systemPurple
                } else {
                    cell.backgroundColor = .none
                }
            } else {
                cell.backgroundColor = .none
            }
            }
        }
        cell.colorSelectedView.layer.cornerRadius = 0.5 * cell.colorSelectedView.frame.width

        
        
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
        print("LYON", cellState.date)
        configureCells(cell: cell as! DayCell, cellState: cellState, date: date)
    }
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let newcell = cell as? DayCell else {
            return
        }
         newcell.colorSelectedView.isHidden = false
        print("Lala", cellState.date)
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: cellState.date)
        components.hour = 0
        components.minute = 0
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        components.second = 0
        let date = Calendar.current.date(from: components)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            if self.dictionary != nil {
                
                self.textForTheDayView.text = self.dictionary![df.string(from: date!)]?["text"] as? String
                self.feelingsLabel.text = ""
//                newcell.backgroundColor = .none
                if !newcell.colorSelectedView.isHidden && self.dictionary!.keys.contains(df.string(from: date!)){
                    print("JAMES", date!, newcell.emotionForTheDay)
                    if newcell.emotionForTheDay == "joy" {
                        self.feelingsLabel.textColor = .yellow
                        self.feelingsLabel.text =  "You were happy on this day"
                    } else if newcell.emotionForTheDay == "anger" {
                        self.feelingsLabel.textColor = .red
                        self.feelingsLabel.text =  "You were angry on this day"
                    } else if newcell.emotionForTheDay == "fear" {
                        self.feelingsLabel.textColor = .purple
                        self.feelingsLabel.text =  "You were scared on this day"
                    } else if newcell.emotionForTheDay == "sadness" {
                        self.feelingsLabel.textColor = .blue
                        self.feelingsLabel.text =  "You were sad on this day"
                    } else if newcell.emotionForTheDay == "neutral" {
                        self.feelingsLabel.textColor = .gray
                        self.feelingsLabel.text =  "You were okay on this day"
                    } else {
                        self.feelingsLabel.textColor = .gray
                        self.feelingsLabel.text =  ""
                    }
                }
            } else {
                self.feelingsLabel.text = ""
            }
//        }
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let newcell = cell as? DayCell else {
            return
        }
        newcell.colorSelectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        let formatter = DateFormatter()
        textForTheDayView.text! = ""
        feelingsLabel.text! = ""
        formatter.dateFormat = "yyyy MM dd"
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date!)
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date!)

    }
    
    
}
