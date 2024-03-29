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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    var dictionary: [String : [String : Any]]?
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var feelingsLabel: UILabel!
    @IBOutlet weak var greyBar: UIView!
    var currentMonthShown: String?
    //    var emotion_dict = [Date: Emotion]()
    @IBOutlet weak var textForTheDayBackgroundView: UIView!
    @IBOutlet weak var textForTheDayView: UITextView!
    let formatter = DateFormatter()
    var date_to_sentiment_dict = [Date : String]()
    var date_to_text_dict =  [Date : String]()
//    @IBOutlet weak var yearLabel: UILabel!
//    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: JTACMonthView!
    override func viewDidLoad() {
        self.tabBarController?.selectedIndex = 1
        calendarView.scrollDirection = .horizontal
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textForTheDayView.isEditable = false
        textForTheDayView.isSelectable = false
        Analytics.logEvent("entered_Calendar_Screen", parameters: nil)
//        calendarView.isUserInteractionEnabled = false
        let navView = UIView()
        let label = UILabel()
        label.text = "introspection"
        label.sizeToFit()
        label.center = navView.frame.origin

        let image = UIImageView()
        image.image = UIImage(named: "Infinity")
        label.frame.size.width = 150
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Heavy", size: 18)

        image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
        view.backgroundColor = .white
        image.contentMode = UIView.ContentMode.scaleAspectFit

        navView.addSubview(label)
        navView.addSubview(image)
                
        //        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        self.navigationItem.titleView = navView
        self.navigationItem.titleView!.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)

        navView.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(barButtonPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        feelingsLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        greyBar.backgroundColor = .gray
        dateLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
//        dateLabel.font = UIFont(name: "SFProDisplay-Bold", size: 18)
//        var view = UILabel()
//        view.frame = CGRect(x: 0, y: 0, width: 321, height: 84)
//        textForTheDayView.backgroundColor = .white
        textForTheDayView.layer.cornerRadius = 10
        textForTheDayView.backgroundColor = .none
        textForTheDayView.alpha = 0.6
        textForTheDayView.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        textForTheDayBackgroundView.alpha = 0.05
        textForTheDayBackgroundView.backgroundColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        textForTheDayBackgroundView.layer.cornerRadius = 10
//        textForTheDayView.alpha = 0.6
//        textForTheDayView.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 0.6)
        greyBar.alpha = 0.2
        dictionary =  UserDefaults.standard.dictionary(forKey: "calendar_dictionary") as? [String : [String : Any]]
        textForTheDayView.text = ""
        feelingsLabel.text = ""
        setupCalendarView()
        calendarView.reloadData()
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollToDate(Date())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.calendarView.selectDates(from: Date(), to: Date())
        }
        print("Calendar", calendarView.selectedDates)
    
    }
    
    @objc func barButtonPressed() {
//         var shareURL:NSURL = NSURL(string: self.gifShareURL!)!
//        var shareData:NSData = NSData(contentsOf: shareURL as URL)!
        let shareData = try! NSData(contentsOf: Bundle.main.url(forResource: "tenor", withExtension: "gif")!)
        let appURL: URL = URL(string: "https://apps.apple.com/us/app/id1534465066")!
        let vc = UIActivityViewController(activityItems: [shareData as Any, "Check out Introspection in the App Store", appURL], applicationActivities: nil)
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = self.view
//            vc.popoverPresentationController?.sourceRect = self.view.bounds
        vc.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
        self.present(vc, animated: true, completion: nil)
    }
    
    func setupCalendarView() {
        let visibleDates = calendarView.visibleDates{ (visibleDate) in
            self.setupCalendarMonthYear(from: visibleDate)
        }
    }
    
    func setupCalendarMonthYear(from visibleDate: DateSegmentInfo) {
        let date = visibleDate.monthDates.first?.date
        self.formatter.dateFormat = "yyyy"
//        self.yearLabel.text = self.formatter.string(from: date!)
        self.formatter.dateFormat = "MMMM"
//        self.monthLabel.text = self.formatter.string(from: date!)
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
        cell.dateLabel.font =  UIFont(name: "HelveticaNeue", size: 18)
        cell.colorSelectedView.isHidden = false
        cell.backgroundColor = .none
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
        } else {
            cell.colorSelectedView.isHidden = true
            cell.dateLabel.textColor = .gray
        }
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: cellState.date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = Calendar.current.date(from: components)
            print("\(cellState.date)", self.dictionary)
            let df = DateFormatter()
            df.dateFormat = "yyyy MM dd"
            if date! == formatter.date(from: formatter.string(from: Date())) {
                print("TODAY CONFIGURED")
                cell.dateLabel.font =  UIFont(name: "HelveticaNeue-Bold", size: 18)
            } else {
                cell.dateLabel.font =  UIFont(name: "HelveticaNeue", size: 18)
            }
            if cellState.dateBelongsTo == .thisMonth {
            if self.dictionary != nil {
                if self.dictionary!.keys.contains("\(df.string(from: date!))") {
                    cell.emotionForTheDay = self.dictionary![df.string(from: date!)]!["emotion"] as! String
                    print(cell.emotionForTheDay)
                    cell.backgroundColor = .none
                    if cell.emotionForTheDay == "joy" {
                        cell.colorSelectedView.backgroundColor = .systemYellow
                    } else if cell.emotionForTheDay == "sadness" {
                         cell.colorSelectedView.backgroundColor = .systemBlue
                    } else if cell.emotionForTheDay == "anger" {
                         cell.colorSelectedView.backgroundColor = .systemRed
                    } else if cell.emotionForTheDay == "neutral" {
                        print("CELL", cellState.date)
                         cell.colorSelectedView.backgroundColor = .systemGray
                    } else if cell.emotionForTheDay == "fear" {
                         cell.colorSelectedView.backgroundColor = .systemPurple
                    } else {
                        cell.colorSelectedView.backgroundColor = .none
                    }
                } else {
                    cell.colorSelectedView.backgroundColor = .none
                }
            } else {
                cell.colorSelectedView.backgroundColor = .none
            }
        }
        cell.colorSelectedView.layer.cornerRadius = 0.5 * cell.colorSelectedView.frame.width

        
        
    }
    @IBAction func didClickRightButton(_ sender: Any) {
        calendarView.scrollToSegment(.next, triggerScrollToDateDelegate: true, animateScroll: true)
    }
    @IBAction func didClickLeftButton(_ sender: Any) {
        calendarView.scrollToSegment(.previous, triggerScrollToDateDelegate: true, animateScroll: true)
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
//        var view = UILabel()
//        view.frame = CGRect(x: 0, y: 0, width: 42, height: 53)
//        view.backgroundColor = .white

        cell!.backgroundColor = UIColor(red: 0.929, green: 0.925, blue: 0.925, alpha: 1)
        cell!.layer.cornerRadius = 7
        print("Cell Date", cellState.date)
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: cellState.date)
        components.hour = 0
        components.minute = 0
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        if df.string(from: cellState.date) == df.string(from: Date()) {
            newcell.dateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        }
        components.second = 0
        let date = Calendar.current.date(from: components)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            if self.dictionary != nil {
                
                self.textForTheDayView.text = self.dictionary![df.string(from: date!)]?["text"] as? String ?? "No introspection was logged for this day"
                self.feelingsLabel.text = ""
                if !newcell.colorSelectedView.isHidden && self.dictionary!.keys.contains(df.string(from: date!)){
//                    print("JAMES", date!, newcell.emotionForTheDay)
                    if newcell.emotionForTheDay == "joy" {
                        self.feelingsLabel.text =  "You were happy on this day"
                    } else if newcell.emotionForTheDay == "anger" {
                        self.feelingsLabel.text =  "You were angry on this day"
                    } else if newcell.emotionForTheDay == "fear" {
                        self.feelingsLabel.text =  "You were scared on this day"
                    } else if newcell.emotionForTheDay == "sadness" {
                        self.feelingsLabel.text =  "You were sad on this day"
                    } else if newcell.emotionForTheDay == "neutral" {
                        self.feelingsLabel.text =  "You were neutral on this day"
                    } else {
                        self.feelingsLabel.text =  ""
                    }
                }
            } else {
                self.textForTheDayView.text = "No introspection was logged for this day"
                self.feelingsLabel.text = ""
            }
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let newcell = cell as? DayCell else {
            return
        }
        cell!.backgroundColor = .none
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date!)
        let todayYear = formatter.string(from: Date())
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: date!)
        let todayMonth = formatter.string(from: Date())
        if todayMonth == month && todayYear == year {
            calendarView.selectDates(from: Date(), to: Date())
        } else {
            calendarView.selectDates(from: date!, to: date!)
        }
        
        let formatter = DateFormatter()
//        textForTheDayView.text! = ""
//        feelingsLabel.text! = ""
//        formatter.dateFormat = "yyyy MM dd"
        
        dateLabel.text = "\(month) \(year)"
        currentMonthShown = month

    }
    
    
}
