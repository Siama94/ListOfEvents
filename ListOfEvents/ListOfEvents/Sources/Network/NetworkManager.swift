//
//  NetworkManager.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 10.02.2023.
//

import RxSwift
import RxCocoa
import Combine

protocol NetworkManagerProtocol {

    var listEventsItems: BehaviorRelay<[EventModel]?> { get }
    var eventDetails: BehaviorRelay<EventDetailsModel?> { get }
    var openTicket: BehaviorRelay<EventTicketModel?> { get }

    func getListEvents() //-> AnyPublisher<[EventModel]?, Never>
    func getEventDetails(for eventId: String)
    func buyEventTicket(for event: EventDetailsModel)
}

class NetworkManager: NetworkManagerProtocol {


    // cache - умеет возвращать уже загруженные модели
    
    var listEventsItems = BehaviorRelay<[EventModel]?>(value: nil)
    var eventDetails = BehaviorRelay<EventDetailsModel?>(value: nil)
    var openTicket = BehaviorRelay<EventTicketModel?>(value: nil)
    
    
    func getListEvents() {
        let request = ApiType.getListEvents.request
        //URLSession.shared.dataTaskPublisher(for: <#T##URL#>)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            do {
//                try //
//                catch {
//
//                }
//            }
            if let data = data,
                let listEvents = try? JSONDecoder().decode([EventModel].self, from: data) {
                self.listEventsItems.accept(listEvents)
            } else {
                self.listEventsItems.accept([])
            }
        }
        task.resume()
    }

    func getEventDetails(for eventId: String) {
        let request = ApiType.getEventDetails(eventId: eventId).request

        // [weak self] 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(decoding: data!, as: UTF8.self))
            if let data = data, let eventDetails = try? JSONDecoder().decode(EventDetailsModel.self, from: data) {
                self.eventDetails.accept(eventDetails)
                sleep(1)
                self.eventDetails.accept(nil)
            } else {
                self.eventDetails.accept(nil)
            }
        }
        task.resume()
    }

    func buyEventTicket(for event: EventDetailsModel) {
        guard let eventId = event.guid else { return }
        let request = ApiType.buyEventTicket(eventId: eventId).request

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(decoding: data!, as: UTF8.self))
            if let data = data, let eventTicket = try? JSONDecoder().decode(EventTicketModel.self, from: data) {
                DispatchQueue.main.async {
                    self.openTicket.accept(eventTicket)
                    sleep(1)
                    self.openTicket.accept(nil)
                }
            }
        }
        task.resume()
    }
}
