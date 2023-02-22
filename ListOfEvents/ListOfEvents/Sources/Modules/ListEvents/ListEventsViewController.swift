//
//  ViewController.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class ListEventsViewController: RxBaseViewController<ListEventsView> {

    private let sortPublisher = PublishSubject<Void>()
    private let filterPublisher = PublishSubject<Void>()

    // MARK: - Settings

    private let viewModel: ListEventsViewModelProtocol

    init(viewModel: ListEventsViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List of Events"
        configure(viewModel: viewModel)

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

        sortEventsButton.rx.tap
            .mapToVoid()
            .bind(to: filterPublisher)
            .disposed(by: disposeBag)

        filterEventsButton.rx.tap
            .mapToVoid()
            .bind(to: sortPublisher)
            .disposed(by: disposeBag)
    }

    // MARK: - Configure

    private func configure(viewModel: ListEventsViewModelProtocol) {
        
        viewModel.bindings.listEventsSection
            .bind(to: contentView.tableView.rx.items(dataSource: contentView.dataSource))
            .disposed(by: disposeBag)

        //
        contentView.tableView.rx.modelSelected(ListEventsItemModel.self)
            .subscribe(onNext: { [weak self] model in
                self?.viewModel.commands.openEventDetails.accept(model.eventItem.guid)
            }).disposed(by: disposeBag)
        // view(VC) = contentView -> viewModel -> Self
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

        viewModel.bindings.networkIndicatorPublisher
            .bind(to: contentView.networkIndicatorPublisher)
            .disposed(by: disposeBag)

        contentView.startRefreshEvents
            .filterNil()
            .bind(to: viewModel.commands.startRefreshEvents)
            .disposed(by: disposeBag)

        viewModel.bindings.endRefreshEvents
            .bind(to: Binder<Void?>(self) { viewController, _ in
                viewController.contentView.endRefreshEvents.accept(())
            }).disposed(by: disposeBag)
    }

    // MARK: - Methods

    private func sortConfirmation() {
        let alert = UIAlertController(title: "Sort by",
                                      message: nil,
                                      preferredStyle: .actionSheet)

        let priceMinAction = UIAlertAction(
            title: "Price: Low to High",
            style: .default, handler: { [weak self] _ in
                self?.viewModel.commands.sortListEvents.accept(.priceMin)
        })

        let priceMaxAction = UIAlertAction(
            title: "Price: High to Low",
            style: .default, handler: { [weak self] _ in
                self?.viewModel.commands.sortListEvents.accept(.priceMax)
        })

        let dateAction = UIAlertAction(
            title: "Date: Descending",
            style: .default, handler: { [weak self] _ in
                self?.viewModel.commands.sortListEvents.accept(.date)
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
                self?.viewModel.commands.filterListEvents.accept(.allEvents)
        })

        let upcomingEventsAction = UIAlertAction(
            title: "Only Upcoming Events",
            style: .default, handler: { [weak self] _ in
//                self?.viewModel.filterUpcomingEvents()
                self?.viewModel.commands.filterListEvents.accept(.upcomingEvents)
        })

        alert.addAction(allEventsAction)
        alert.addAction(upcomingEventsAction)

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
