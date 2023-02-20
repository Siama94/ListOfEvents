//
//  NetworkManager.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 10.02.2023.
//

import RxSwift
import RxCocoa
import Foundation

protocol NetworkManagerProtocol {

    var listEventsItems: BehaviorRelay<[EventModel]?> { get }
    var eventDetails: BehaviorRelay<EventDetailsModel?> { get }
    var getTicket: BehaviorRelay<EventDetailsModel?> { get }


    func getListEvents()
    func getEventDetails(for eventId: String)
    func buyEventTicket(for event: EventDetailsModel)
}

class NetworkManager: NetworkManagerProtocol {

    var listEventsItems = BehaviorRelay<[EventModel]?>(value: nil)
    var eventDetails = BehaviorRelay<EventDetailsModel?>(value: nil)
    var getTicket = BehaviorRelay<EventDetailsModel?>(value: nil)


    func getListEvents() {
        var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/events")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["key": "value",
                                       "secret": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc"]


        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // TODO: - Обработать ошибку
            if let data = data, let listEvents = try? JSONDecoder().decode([EventModel].self, from: data) {
                self.listEventsItems.accept(listEvents)
            }
        }
        task.resume()
    }

    func getEventDetails(for eventId: String) {
        var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/event/\(eventId)")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["key": "value",
                                       "secret": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc"]

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(decoding: data!, as: UTF8.self))
            // TODO: - Обработать ошибку
            if let data = data, let eventDetails = try? JSONDecoder().decode(EventDetailsModel.self, from: data) {
                self.eventDetails.accept(eventDetails)
            }
        }

        task.resume()
    }

    func buyEventTicket(for event: EventDetailsModel) {
//        var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/event/\(event.id)/buy")!)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = ["key": "secret",
//                                       "value": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc",
//                                       "type": "text"]
//
//
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            print(String(decoding: data!, as: UTF8.self))
//            print("vvvvvvvvvvvvvvvvvvvvvvvvvv")
//
//            DispatchQueue.main.async {
//                let ind = EventStorage.storageEventModel.firstIndex(where: { $0.id == event.id }) ?? 0
//                EventStorage.storageEventModel[ind].paymentStatus = .paid
//                EventStorage.storageEventDetailsModel[ind].paymentStatus = .paid
//
//                self.getTicket.accept(EventStorage.storageEventDetailsModel[ind])
//                sleep(1)
//                self.getTicket.accept(nil)
//
//            }
//        }
//        task.resume()
    }
}
