//
//  DateExtantion.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 20.02.2023.
//

import Foundation

extension Date {

    var dateInfo: String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd  MMMM  y"
        dateFormatter.locale = Locale(identifier: "en")
        let currentDateInfo = dateFormatter.string(from: self)

        return currentDateInfo
    }
}
