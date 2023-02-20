//
//  ListEventsCell.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import UIKit
import RxSwift

final class ListEventsCell: UITableViewCell {

    // MARK: - Reactive

    var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Views

    private lazy var eventTitle = UILabel().then {
        $0.textColor = .black
    }

    private lazy var dateTitle = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14)
    }

    private lazy var priceTitle = UILabel().then {
        $0.textColor = .black
    }

    // MARK: - ConfigureCell

    static func cellHeight() -> CGFloat {
        let cellHeight: CGFloat = 50
        return cellHeight
    }

    func configureCell(from model: EventModelWithDate) {
        eventTitle.text = model.event
        dateTitle.text = model.date?.stringFromDate
        guard let ticketPrice = model.ticketPrice else { return }
        priceTitle.text = String(ticketPrice) + " $"
    }

    // MARK: - Settings

    func commonInit() {
        setupHierarchy()
        setupLayout()
        setupBinding()
    }

    func setupHierarchy() {
        contentView.addSubview(eventTitle)
        contentView.addSubview(dateTitle)
        contentView.addSubview(priceTitle)
    }

    func setupLayout() {
        eventTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(30)
        }

        dateTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(eventTitle.snp.bottom)
        }

        priceTitle.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
    }

    func setupBinding() { }
}

// MARK: - Constants

extension ListEventsCell {

    enum Metric {
    }
}
