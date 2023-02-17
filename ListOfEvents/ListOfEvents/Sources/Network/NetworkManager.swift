//
//  NetworkManager.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 10.02.2023.
//

import RxSwift
import RxCocoa

protocol NetworkManagerProtocol {

    var listEventsItems: BehaviorRelay<[EventModel]?> { get }
    var eventDetails: BehaviorRelay<EventDetailsModel?> { get }
    var getTicket: BehaviorRelay<EventDetailsModel?> { get }


    func getListEvents()
    func getEventDetails(for event: EventModel)
    func buyEventTicket(for event: EventDetailsModel)
}

class NetworkManager: NetworkManagerProtocol {

    var listEventsItems = BehaviorRelay<[EventModel]?>(value: nil)
    var eventDetails = BehaviorRelay<EventDetailsModel?>(value: nil)
    var getTicket = BehaviorRelay<EventDetailsModel?>(value: nil)


    func getListEvents() {
        var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/events")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["key": "secret",
                                       "value": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc",
                                       "type": "text"]

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(decoding: data!, as: UTF8.self))

            self.listEventsItems.accept(EventStorage.storageEventModel)

        }

        task.resume()
    }

    func getEventDetails(for event: EventModel) {
        var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/event/\(event.id)")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["key": "secret",
                                       "value": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc",
                                       "type": "text"]

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(decoding: data!, as: UTF8.self))

            let eventD = EventDetailsModel(from: event)

            self.eventDetails.accept(eventD)
        }

        task.resume()
    }

    func buyEventTicket(for event: EventDetailsModel) {
        var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/event/\(event.id)/buy")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["key": "secret",
                                       "value": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc",
                                       "type": "text"]



        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(decoding: data!, as: UTF8.self))
            print("vvvvvvvvvvvvvvvvvvvvvvvvvv")

            DispatchQueue.main.async {
                let ind = EventStorage.storageEventModel.firstIndex(where: { $0.id == event.id }) ?? 0
                EventStorage.storageEventModel[ind].paymentStatus = .paid
                EventStorage.storageEventDetailsModel[ind].paymentStatus = .paid

                self.getTicket.accept(EventStorage.storageEventDetailsModel[ind])
                sleep(1)
                self.getTicket.accept(nil)

            }
        }
        task.resume()
    }
}

class EventStorage {
     static var storageEventModel: [EventModel] = [
        EventModel(id: "0001", title: "Event 1", date: "05 August 2023", price: 100, paymentStatus: .notPaid),
        EventModel(id: "0002", title: "Event 2", date: "23 May 2023", price: 200, paymentStatus: .notPaid),
        EventModel(id: "0003", title: "Event 3", date: "12 May 2023", price: 300, paymentStatus: .notPaid),
        EventModel(id: "0004", title: "Event 4", date: "13 May 2023", price: 400, paymentStatus: .notPaid),
        EventModel(id: "0005", title: "Event 5", date: "23 May 2023", price: 500, paymentStatus: .notPaid),
        EventModel(id: "0006", title: "Event 6", date: "23 May 2023", price: 600, paymentStatus: .notPaid),
        EventModel(id: "0007", title: "Event 7", date: "23 May 2023", price: 700, paymentStatus: .notPaid),
        EventModel(id: "0008", title: "Event 8", date: "23 May 2023", price: 800, paymentStatus: .notPaid),
        EventModel(id: "0009", title: "Event 9", date: "23 May 2023", price: 900, paymentStatus: .notPaid),
        EventModel(id: "0010", title: "Event 10", date: "23 May 2023", price: 1000, paymentStatus: .notPaid),
        EventModel(id: "0011", title: "Event 11", date: "23 May 2023", price: 1100, paymentStatus: .notPaid),
        EventModel(id: "0012", title: "Event 12", date: "23 May 2023", price: 1200, paymentStatus: .notPaid),
        EventModel(id: "0013", title: "Event 13", date: "23 May 2023", price: 1300, paymentStatus: .notPaid),
        EventModel(id: "0014", title: "Event 14", date: "23 May 2023", price: 1400, paymentStatus: .notPaid),
        EventModel(id: "0015", title: "Event 15", date: "23 May 2023", price: 1500, paymentStatus: .notPaid),
        EventModel(id: "0016", title: "Event 16", date: "23 May 2023", price: 1600, paymentStatus: .notPaid),
        EventModel(id: "0017", title: "Event 17", date: "23 May 2023", price: 1700, paymentStatus: .notPaid),
        EventModel(id: "0018", title: "Event 18", date: "23 May 2023", price: 1800, paymentStatus: .notPaid),
        EventModel(id: "0019", title: "Event 19", date: "23 May 2023", price: 1900, paymentStatus: .notPaid)
    ]

    static var storageEventDetailsModel: [EventDetailsModel] {

        get { var storage = [EventDetailsModel]()

            for i in storageEventModel {
                let a = EventDetailsModel(from: i)
                storage.append(a)
            }
            return storage
        }
        set { print("new status") }

    }
}
