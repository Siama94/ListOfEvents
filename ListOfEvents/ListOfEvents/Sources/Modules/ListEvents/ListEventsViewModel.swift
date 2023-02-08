//
//  ListEventsViewModel.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import RxSwift
import RxCocoa

protocol ListEventsViewModelProtocol {
    var bindings: ListEventsViewModel.Bindings { get }
}

extension ListEventsViewModel {
    struct Bindings {

        let listEventsSection = BehaviorRelay<[ListEventsSectionModel]>(value: [])
        let listEventsItems = BehaviorRelay<[EventModel]>(value: [])

    }

    struct Commands {
        let sortListEvents = BehaviorRelay<KindSorting>(value: .none)
    }
}

class ListEventsViewModel: ListEventsViewModelProtocol {

    var disposeBag = DisposeBag()
    var bindings = Bindings()
    var commands = Commands()

    init() {
        loadListEvents()
        configure(commands: commands)
    }

    private func configure(commands: Commands) {

        commands.sortListEvents
            .bind(to: Binder<KindSorting>(self) { viewModel, kindSort in
                viewModel.sortListEvents(by: kindSort)
            }).disposed(by: disposeBag)

    }

    
    // MARK: - Requests (temp.)

    func loadListEvents() {
        var request = URLRequest(url: URL(string: "https://technical-interview.excels.io/events")!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["key": "secret",
                                       "value": "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc",
                                       "type": "text"]

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(decoding: data!, as: UTF8.self))
            let listEventsSection = ListEventsViewModel.Events.events.mapToListEventsSections()
            self.bindings.listEventsSection.accept(listEventsSection)
            self.bindings.listEventsItems.accept(ListEventsViewModel.Events.events)
        }
        
        task.resume()
    }

    func sortListEvents(by kindOfSorting: KindSorting) {
        var sortedEvents = [EventModel]()

        switch kindOfSorting {
        case .priceMax:
            sortedEvents = bindings.listEventsItems.value.sorted(by: {$0.amount > $1.amount})
        case .priceMin:
            sortedEvents = bindings.listEventsItems.value.sorted(by: {$0.amount < $1.amount})
        default:
            break
        }

        let sortedEventsSection = sortedEvents.mapToListEventsSections()
        bindings.listEventsSection.accept(sortedEventsSection)
    }

}

// Temp.
extension ListEventsViewModel {
    enum Events {
        static let events: [EventModel] = [
            EventModel(id: "0001", title: "Event 1", date: "05 August 2023", amount: 100, isPaid: false),
            EventModel(id: "0002", title: "Event 2", date: "23 May 2023", amount: 200, isPaid: false),
            EventModel(id: "0003", title: "Event 3", date: "12 May 2023", amount: 300, isPaid: false),
            EventModel(id: "0004", title: "Event 4", date: "13 May 2023", amount: 400, isPaid: false),
            EventModel(id: "0005", title: "Event 5", date: "23 May 2023", amount: 500, isPaid: false),
            EventModel(id: "0006", title: "Event 6", date: "23 May 2023", amount: 600, isPaid: false),
            EventModel(id: "0007", title: "Event 7", date: "23 May 2023", amount: 700, isPaid: false),
            EventModel(id: "0008", title: "Event 8", date: "23 May 2023", amount: 800, isPaid: false),
            EventModel(id: "0009", title: "Event 9", date: "23 May 2023", amount: 900, isPaid: false),
            EventModel(id: "0010", title: "Event 10", date: "23 May 2023", amount: 1000, isPaid: false),
            EventModel(id: "0011", title: "Event 11", date: "23 May 2023", amount: 1100, isPaid: false),
            EventModel(id: "0012", title: "Event 12", date: "23 May 2023", amount: 1200, isPaid: false),
            EventModel(id: "0013", title: "Event 13", date: "23 May 2023", amount: 1300, isPaid: false),
            EventModel(id: "0014", title: "Event 14", date: "23 May 2023", amount: 1400, isPaid: false),
            EventModel(id: "0015", title: "Event 15", date: "23 May 2023", amount: 1500, isPaid: false),
            EventModel(id: "0016", title: "Event 16", date: "23 May 2023", amount: 1600, isPaid: false),
            EventModel(id: "0017", title: "Event 17", date: "23 May 2023", amount: 1700, isPaid: false),
            EventModel(id: "0018", title: "Event 18", date: "23 May 2023", amount: 1800, isPaid: false),
            EventModel(id: "0019", title: "Event 19", date: "23 May 2023", amount: 1900, isPaid: false)
        ]
    }
}

