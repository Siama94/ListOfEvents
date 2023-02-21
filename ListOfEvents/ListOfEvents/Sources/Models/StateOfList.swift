//
//  StateOfList.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 08.02.2023.
//


struct StateOfList: Equatable {
    var sort: KindSorting
    var filter: FilterOfList
}

enum KindSorting {
    case priceMin
    case priceMax
    case date
    case none
}

enum FilterOfList {
    case allEvents
    case upcomingEvents
}
