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

    let viewModel = ListEventsViewModel()

    var sortPublisher = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(model: viewModel)

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

    private func configure(model: ListEventsViewModelProtocol) {

        model.bindings.listEventsSection
            .bind(to: contentView.tableView.rx.items(dataSource: contentView.dataSource))
            .disposed(by: disposeBag)

        sortPublisher
            .mapToVoid()
            .bind(to: Binder<Void>(self) { viewController, _ in
                viewController.sortConfirmation()
            }).disposed(by: disposeBag)
    }

    func sortConfirmation() {
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

        alert.addAction(priceMinAction)
        alert.addAction(priceMaxAction)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
