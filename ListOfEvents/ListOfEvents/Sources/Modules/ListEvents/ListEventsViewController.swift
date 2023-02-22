//
//  ViewController.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ListEventsViewController: RxBaseViewController<ListEventsView> {

    private var viewModel: ListEventsViewModelProtocol?

    convenience init(viewModel: ListEventsViewModelProtocol) {
        self.init()
        self.viewModel = viewModel
    }

    var sortPublisher = PublishSubject<Void>()
    var filterPublisher = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(viewModel: viewModel)

        title = "List of Events"

        // TODO: - оформить кнопки нормально

        let sortEventsButton =  UIBarButtonItem(
            image: UIImage(systemName: "slider.horizontal.3"),
            style: .plain, target: nil, action: nil
        )

        let filterEventsButton =  UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down.square"),
            style: .plain, target: nil, action: nil
        )

        navigationItem.rightBarButtonItems = [sortEventsButton, filterEventsButton]

        navigationItem.rightBarButtonItems?[0].rx.tap
            .mapToVoid()
            .bind(to: filterPublisher)
            .disposed(by: disposeBag)

        navigationItem.rightBarButtonItems?[1].rx.tap
            .mapToVoid()
            .bind(to: sortPublisher)
            .disposed(by: disposeBag)
    }

    private func configure(viewModel: ListEventsViewModelProtocol?) {

        guard let viewModel = viewModel else { return }

        viewModel.bindings.listEventsSection
            .bind(to: contentView.tableView.rx.items(dataSource: contentView.dataSource))
            .disposed(by: disposeBag)

        contentView.startRefreshEvents
            .filterNil()
            .bind(to: viewModel.commands.startRefreshEvents)
            .disposed(by: disposeBag)

        sortPublisher
            .mapToVoid()
            .bind(to: Binder<Void>(self) { viewController, _ in
                viewController.sortConfirmation()
            }).disposed(by: disposeBag)

        filterPublisher
            .mapToVoid()
            .bind(to: Binder<Void>(self) { viewController, _ in
                viewController.filterConfirmation()
            }).disposed(by: disposeBag)

        contentView.tableView.rx.modelSelected(ListEventsItemModel.self)
            .subscribe(onNext: { model in
                viewModel.commands.openEventDetails.accept(model.eventItem.guid)
            }).disposed(by: disposeBag)

        viewModel.bindings.endRefreshEvents
            .bind(to: Binder<Void?>(self) { viewController, _ in
                viewController.contentView.endRefreshEvents.accept(())
            }).disposed(by: disposeBag)
    }

    private func sortConfirmation() {
        let alert = UIAlertController(title: "Sort by",
                                      message: nil,
                                      preferredStyle: .actionSheet)

        let priceMinAction = UIAlertAction(
            title: "Price: Low to High",
            style: .default, handler: { [weak self] _ in
                self?.viewModel?.commands.sortListEvents.accept(.priceMin)
        })

        let priceMaxAction = UIAlertAction(
            title: "Price: High to Low",
            style: .default, handler: { [weak self] _ in
                self?.viewModel?.commands.sortListEvents.accept(.priceMax)
        })

        let dateAction = UIAlertAction(
            title: "Date: Descending",
            style: .default, handler: { [weak self] _ in
                self?.viewModel?.commands.sortListEvents.accept(.date)
        })

        alert.addAction(priceMinAction)
        alert.addAction(priceMaxAction)
        alert.addAction(dateAction)
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func filterConfirmation() {
        let alert = UIAlertController(title: "Filter events",
                                      message: nil,
                                      preferredStyle: .actionSheet)

        let allEventsAction = UIAlertAction(
            title: "All Events",
            style: .default, handler: { [weak self] _ in
                self?.viewModel?.commands.filterListEvents.accept(.allEvents)
        })

        let upcomingEventsAction = UIAlertAction(
            title: "Only Upcoming Events",
            style: .default, handler: { [weak self] _ in
                self?.viewModel?.commands.filterListEvents.accept(.upcomingEvents)
        })

        alert.addAction(allEventsAction)
        alert.addAction(upcomingEventsAction)

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
