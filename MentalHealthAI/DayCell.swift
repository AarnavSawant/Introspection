//
//  DayCell.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/14/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import JTAppleCalendar
class DayCell: JTACDayCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorSelectedView: UIView!
    @IBOutlet weak var selectedView: UIView!
    public var textForTheDay = String()
    public var emotionForTheDay = String()
    
}
