//
//  DateExtantion.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 20.02.2023.
//

import Foundation

extension Date {

    var stringFromDate: String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM y"
        dateFormatter.locale = Locale(identifier: "en")
        let currentDateInfo = dateFormatter.string(from: self)

        return currentDateInfo
    }
}

extension String {

    var dateFromString: Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en")
        let currentDateInfo = dateFormatter.date(from: self)

        return currentDateInfo
    }
}
