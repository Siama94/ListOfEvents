//
//  AppCoordinator.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator {

    private let bag = DisposeBag()

    var rootViewController: UINavigationController?
    let window: UIWindow?
    var networkManager: NetworkManagerProtocol!

    init(window: UIWindow?) {
        self.window = window
        self.networkManager = NetworkManager()
    }

    func start() {
        guard let window = window else { return }
        rootViewController = UINavigationController(rootViewController: presentListEventsViewController())
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    private func presentListEventsViewController() -> ListEventsViewController {
        let listEventsViewModel = ListEventsViewModel(networkManager: networkManager)
        let listEventsViewController = ListEventsViewController(viewModel: listEventsViewModel)

        listEventsViewModel.moduleOutput.openEventDetails
            .filterNil()
            .subscribe(onNext: { [weak self] model in
                self?.presentEventDetails(for: model, from: listEventsViewController)
        }).disposed(by: bag)

        return listEventsViewController
    }

    private func presentEventDetails(for event: EventModel, from viewController: UIViewController) {
        let eventDetailsViewModel = EventDetailsViewModel(for: event, with: networkManager)
        let eventDetailsViewController = EventDetailsViewController(viewModel: eventDetailsViewModel)
        viewController.show(eventDetailsViewController, sender: nil)

        eventDetailsViewModel.moduleOutput.getTicket
            .filterNil()
            .subscribe(onNext: { [weak self] model in
                self?.presentEventTicket(for: model, from: eventDetailsViewController)
        }).disposed(by: bag)
    }

    private func presentEventTicket(for event: EventDetailsModel, from viewController: UIViewController) {
        let eventTicketViewModel = EventTicketViewModel(for: event)
        let eventTicketViewController = EventTicketViewController(viewModel: eventTicketViewModel)
        viewController.show(eventTicketViewController, sender: nil)
    }
}
