//
//  DayOfTheWeekService.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/14/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import Foundation

public struct DayOfTheWeekWriter {
    var oldDictionary: [String : [String : Int]]?
    var dayOfTheWeekString: String, timestamp: Double
    var date: Date
    var previousClass: String?
    var predictionClass: String
    
    
    init(oldDictionary: [String : [String : Int]]?, dayOfTheWeekString: String, timestamp: Double, date: Date, previousClass: String?, predictionClass: String) {
        self.oldDictionary = oldDictionary
        self.dayOfTheWeekString = dayOfTheWeekString
        self.timestamp = timestamp
        self.date = date
        self.previousClass = previousClass
        self.predictionClass = predictionClass
    }
    
    public func getNewDayOfTheWeekDictionary() -> [String : [String : Int]]?{
            var dictionary_week = oldDictionary
            let formatter = DateFormatter()
    //         let timestamp = testdate.timeIntervalSince1970 as! Double
            formatter.dateFormat = "yyyy MM dd"
            if dictionary_week != nil {
                if dictionary_week!.keys.contains(dayOfTheWeekString) {
                    if previousClass != nil {
                        if formatter.string(from: Date.init(timeIntervalSince1970: timestamp)) == formatter.string(from: date) {
                            dictionary_week![dayOfTheWeekString]![previousClass!] = dictionary_week![dayOfTheWeekString]![previousClass!]! - 1
                        }
                    }
                    if dictionary_week![dayOfTheWeekString]!.keys.contains(predictionClass)  {
                        dictionary_week![dayOfTheWeekString]![predictionClass] = (dictionary_week![dayOfTheWeekString]![predictionClass]!) + 1
                    } else {
                        dictionary_week![dayOfTheWeekString]![predictionClass] = 1
                    }

                } else {
                    dictionary_week![dayOfTheWeekString] = [predictionClass : 1]
                }
            } else {
                dictionary_week = [dayOfTheWeekString : [predictionClass : 1]]
            }
            return dictionary_week
        }
    
}
