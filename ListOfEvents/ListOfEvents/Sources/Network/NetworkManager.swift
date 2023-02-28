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

    func getListEvents() -> Observable<[EventModel]>
    func getEventDetails(for eventId: String) -> Observable<EventDetailsModel>
    func buyEventTicket(for eventId: String) -> Observable<EventTicketModel>
}

class NetworkManager: NetworkManagerProtocol {

    func getListEvents() -> Observable<[EventModel]> {
        let request = ApiType.getListEvents.request

        return Observable.create { observer in

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    guard let data = data else { return }
                    let listEvents = try JSONDecoder().decode([EventModel].self, from: data)
                    observer.onNext(listEvents)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }

            task.resume()
            return Disposables.create()
        }
    }

    func getEventDetails(for eventId: String) -> Observable<EventDetailsModel> {
        let request = ApiType.getEventDetails(eventId: eventId).request

        return Observable.create { observer in

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    guard let data = data else { return }
                    let eventDetails = try JSONDecoder().decode(EventDetailsModel.self, from: data)
                    observer.onNext(eventDetails)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }

            task.resume()
            return Disposables.create()
        }
    }

    func buyEventTicket(for eventId: String) -> Observable<EventTicketModel> {
        let request = ApiType.buyEventTicket(eventId: eventId).request

        return Observable.create { observer in

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    guard let data = data else { return }
                    let eventTicket = try JSONDecoder().decode(EventTicketModel.self, from: data)
                    DispatchQueue.main.async {
                        observer.onNext(eventTicket)
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(error)
                }
            }

            task.resume()
            return Disposables.create()
        }
    }
}
