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

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(viewModel: viewModel)

        title = "List of Events"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: .actions,
            style: .plain, target: nil, action: nil
        )
        navigationItem
            .rightBarButtonItem?.rx.tap
            .mapToVoid()
            .bind(to: sortPublisher)
            .disposed(by: disposeBag)
    }

    private func configure(viewModel: ListEventsViewModelProtocol?) {

        guard let viewModel = viewModel else { return }


        viewModel.bindings.listEventsSection
            .bind(to: contentView.tableView.rx.items(dataSource: contentView.dataSource))
            .disposed(by: disposeBag)

        sortPublisher
            .mapToVoid()
            .bind(to: Binder<Void>(self) { viewController, _ in
                viewController.sortConfirmation()
            }).disposed(by: disposeBag)

        contentView.tableView.rx.modelSelected(ListEventsItemModel.self)
            .subscribe(onNext: { model in
                viewModel.commands.openEventDetails.accept(model.eventItem.guid)
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
}
