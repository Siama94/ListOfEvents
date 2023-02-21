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
    var commands: ListEventsViewModel.Commands { get }

}

extension ListEventsViewModel {

    struct Bindings {
        let listEventsSection = BehaviorRelay<[ListEventsSectionModel]>(value: [])
        let listEventsItems = BehaviorRelay<[EventModelWithDate]>(value: [])
    }

    struct Commands {
        let sortListEvents = BehaviorRelay<KindSorting>(value: .none)
        let filterListEvents = BehaviorRelay<FilterOfList>(value: .allEvents)
        let openEventDetails = BehaviorRelay<String?>(value: nil)
    }

    struct ModuleOutput {
        let openEventDetails = BehaviorRelay<String?>(value: nil)
    }
}

class ListEventsViewModel: ListEventsViewModelProtocol {

    var disposeBag = DisposeBag()
    var bindings = Bindings()
    var commands = Commands()
    let moduleOutput = ModuleOutput()
    let networkManager: NetworkManagerProtocol?

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        networkManager.getListEvents()
        configure(commands: commands)
    }

    private func configure(commands: Commands) {
        
        networkManager?.listEventsItems
            .filterNil()
            .subscribe(onNext: { [weak self] events in
                let eventsWithData = events.map { EventModelWithDate(from: $0) }
                self?.bindings.listEventsSection.accept(eventsWithData.mapToListEventsSections())
                self?.bindings.listEventsItems.accept(eventsWithData)
            }).disposed(by: disposeBag)

        commands.sortListEvents
            .bind(to: Binder<KindSorting>(self) { [weak self] viewModel, kindSort in
                self?.filterAndSortListEvents(by: .init(sort: kindSort, filter: commands.filterListEvents.value))
            }).disposed(by: disposeBag)

        commands.filterListEvents
            .bind(to: Binder<FilterOfList>(self) { [weak self] viewModel, kindFilter in
                self?.filterAndSortListEvents(by: .init(sort: commands.sortListEvents.value, filter: kindFilter))
            }).disposed(by: disposeBag)
        
        commands.openEventDetails
            .bind(to: moduleOutput.openEventDetails)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods

    // TODO: - переписать, чтоб было читаемо
    func filterAndSortListEvents(by state: StateOfList) {

        let deafultEvents = bindings.listEventsItems.value
        var events = [EventModelWithDate]()

        switch state {

        case .init(sort: .none, filter: .allEvents):
            events = deafultEvents
        case .init(sort: .none, filter: .upcomingEvents):
            events = deafultEvents.filter({ $0.date ?? Date() >= Date() })

        case .init(sort: .priceMax, filter: .allEvents):
            events = deafultEvents.sorted(by: {$0.ticketPrice ?? 0 > $1.ticketPrice ?? 0})
        case .init(sort: .priceMax, filter: .upcomingEvents):
            events = deafultEvents.filter({ $0.date ?? Date() >= Date() }).sorted(by: {$0.ticketPrice ?? 0 > $1.ticketPrice ?? 0})

        case .init(sort: .priceMin, filter: .allEvents):
            events = deafultEvents.sorted(by: {$0.ticketPrice ?? 0 < $1.ticketPrice ?? 0})
        case .init(sort: .priceMin, filter: .upcomingEvents):
            events = deafultEvents.filter({ $0.date ?? Date() >= Date() }).sorted(by: {$0.ticketPrice ?? 0 < $1.ticketPrice ?? 0})

        case .init(sort: .date, filter: .allEvents):
            events = deafultEvents.sorted(by: {$0.date ?? Date() > $1.date ?? Date() })
        case .init(sort: .date, filter: .upcomingEvents):
            events = deafultEvents.filter({ $0.date ?? Date() >= Date() }).sorted(by: {$0.date ?? Date() > $1.date ?? Date() })

        default:
            break
        }

        let eventsSection = events.mapToListEventsSections()
        bindings.listEventsSection.accept(eventsSection)
    }

}
