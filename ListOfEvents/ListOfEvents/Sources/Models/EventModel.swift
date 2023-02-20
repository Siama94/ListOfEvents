//
//  EventModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import Foundation

struct EventModel: Decodable, Hashable {
    var guid: String?
    var event: String?
    var ticketPrice: Double?
    var date: String?
}

struct EventModelWithDate: Hashable {
    var guid: String?
    var event: String?
    var ticketPrice: Double?
    var date: Date?

    init(from event: EventModel) {
        self.guid = event.guid
        self.event = event.event
        self.ticketPrice = event.ticketPrice

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ"
        self.date = dateFormatter.date(from: event.date ?? "")

    }
}

extension Array where Element == EventModelWithDate {

    func mapToListEventsSections() -> [ListEventsSectionModel] {
        guard !isEmpty else { return [] }
        return [.main(items: map(ListEventsItemModel.event))]
    }
}
