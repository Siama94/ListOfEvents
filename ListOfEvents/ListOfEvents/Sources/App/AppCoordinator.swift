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

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        guard let window = window else { return }
        rootViewController = UINavigationController(rootViewController: presentListEventsViewController())
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    private func presentListEventsViewController() -> ListEventsViewController {
        let listEventsViewModel = ListEventsViewModel()
        let listEventsViewController = ListEventsViewController(viewModel: listEventsViewModel)

        listEventsViewModel.moduleOutput.openEventDetails
            .filterNil()
            .subscribe(onNext: { [weak self] model in
                self?.presentEventDetails(for: model, from: listEventsViewController)
        }).disposed(by: bag)

        return listEventsViewController
    }

    private func presentEventDetails(for event: EventModel, from viewController: UIViewController) {
        let viewModel = EventDetailsViewModel(with: event.id)
        let eventDetailsViewController = EventDetailsViewController(viewModel: viewModel)
        viewController.show(eventDetailsViewController, sender: nil)
    }
}
