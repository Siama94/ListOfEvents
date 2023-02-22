//
//  ListEventsView.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import UIKit
import Then
import SnapKit
import ReusableKit
import RxDataSources
import RxSwift
import RxCocoa

final class ListEventsView: RxBaseView {

    let startRefreshEvents = BehaviorRelay<Void?>(value: nil)
    let endRefreshEvents = BehaviorRelay<Void?>(value: nil)

    lazy var refreshControl = UIRefreshControl()

    lazy var tableView = UITableView(
        frame: .zero, style: .plain
    ).then {
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.register(Reusable.eventCell)
    }

    // MARK: - Data Source

    lazy var dataSource = RxTableViewSectionedReloadDataSource<ListEventsSectionModel>(
        configureCell: { [unowned self] _, tableView, indexPath, item -> UITableViewCell in

            switch item {
            case .event(let model):
                return tableView.dequeue(Reusable.eventCell, for: indexPath).then {

                    $0.configureCell(from: model)
                }
            }
        }
    )

    // MARK: - Settings

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(tableView)
        tableView.addSubview(refreshControl)
    }

    override func setupLayout() {
        super.setupLayout()

        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    override func setupBinding() {
        super.setupBinding()
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: startRefreshEvents)
            .disposed(by: disposeBag)

        endRefreshEvents
            .bind(to: Binder<Void?>(self) { view, _ in
                self.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension ListEventsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath] {
        case .event:
            return Reusable.eventCell.class.cellHeight()
        }
    }
}

// MARK: - Constants

extension ListEventsView {

    enum Reusable {
        static let eventCell = ReusableCell<ListEventsCell>()
    }
}
