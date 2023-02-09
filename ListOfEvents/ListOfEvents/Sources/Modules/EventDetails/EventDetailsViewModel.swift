//
//  EventDetailsViewModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import RxSwift
import RxCocoa

protocol EventDetailsViewModelProtocol {
    var bindings: EventDetailsViewModel.Bindings { get }
    var commands: EventDetailsViewModel.Commands { get }

}

extension EventDetailsViewModel {

    struct Bindings {
        let eventDetails = BehaviorRelay<EventDetailsModel?>(value: nil)
    }

    struct Commands {
        let getTicket = PublishSubject<EventDetailsModel>()
    }

    struct ModuleOutput {
        let getTicket = BehaviorRelay<EventDetailsModel?>(value: nil)
    }
}

class EventDetailsViewModel: EventDetailsViewModelProtocol {

    var disposeBag = DisposeBag()
    var bindings = Bindings()
    var commands = Commands()
    var moduleOutput = ModuleOutput()

    init(with eventId: String) {
        loadEventDetails(for: eventId)
        configure(commands: commands)
    }

    private func configure(commands: Commands) {

        commands.getTicket
            .bind(to: Binder<EventDetailsModel>(self) { viewModel, event in
                viewModel.getTicket(for: event)
            }).disposed(by: disposeBag)

//        commands.openEventDetails
//            .bind(to: moduleOutput.openEventDetails)
//            .disposed(by: disposeBag)
    }

    func loadEventDetails(for eventId: String) {
        var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/event/\(eventId)")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["key": "secret",
                                       "value": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc",
                                       "type": "text"]

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(decoding: data!, as: UTF8.self))

            let eventDetail = EventDetailsModel(id: eventId,
                                                title: eventId,
                                                description: "description",
                                                date: "date",
                                                address: "address",
                                                phone: "phone",
                                                price: 100,
                                                paymentStatus: .paid)

            self.bindings.eventDetails.accept(eventDetail)
        }

        task.resume()
    }

    func getTicket(for event: EventDetailsModel) {
        switch event.paymentStatus {
        case .paid:
            self.moduleOutput.getTicket.accept(event)
        case .notPaid:

            func buyTicket(for eventId: String) {
                var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/event/\(eventId)/buy")!)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = ["key": "secret",
                                               "value": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc",
                                               "type": "text"]

                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    print(String(decoding: data!, as: UTF8.self))

                    self.moduleOutput.getTicket.accept(event)
                }

                task.resume()
            }
        }
    }
}
