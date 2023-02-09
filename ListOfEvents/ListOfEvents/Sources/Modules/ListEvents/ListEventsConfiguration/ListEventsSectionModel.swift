//
//  ListEventsSectionModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import RxDataSources

enum ListEventsSectionModel: AnimatableSectionModelType {
    case main(items: [ListEventsItemModel])

    var identity: Int {
        switch self {
        case .main(let items):
            return items.count.hashValue
        }
    }

    var items: [ListEventsItemModel] {
        switch self {
        case .main(let items):
            return items
        }
    }

    init(original: ListEventsSectionModel, items: [ListEventsItemModel]) {
        switch original {
        case .main:
            self = .main(items: items)
        }
    }
}

enum ListEventsItemModel: IdentifiableType, Equatable {
    case event(EventModel)

    var identity: String {
        switch self {
        case .event(let model):
            return model.id
        }
    }

    var eventItem: EventModel {
        switch self {
        case .event(let model):
            return model
        }
    }

    static func == (lhs: ListEventsItemModel, rhs: ListEventsItemModel) -> Bool {
        switch (lhs, rhs) {
        case (.event(let left), .event(let right)):
            return left == right
        }
    }
}
