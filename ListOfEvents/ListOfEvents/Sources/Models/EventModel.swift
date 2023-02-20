//
//  EventModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import Foundation

struct EventModel: Decodable, Hashable {
    let guid: String?
    let event: String?
    let ticketPrice: Double?
    let date: String?
}

struct EventModelWithDate: Hashable {
    let guid: String?
    let event: String?
    let ticketPrice: Double?
    var date: Date?

    init(from event: EventModel) {
        self.guid = event.guid
        self.event = event.event
        self.ticketPrice = event.ticketPrice
        self.date = event.date?.dateFromString

    }
}

extension Array where Element == EventModelWithDate {

    func mapToListEventsSections() -> [ListEventsSectionModel] {
        guard !isEmpty else { return [] }
        return [.main(items: map(ListEventsItemModel.event))]
    }
}
