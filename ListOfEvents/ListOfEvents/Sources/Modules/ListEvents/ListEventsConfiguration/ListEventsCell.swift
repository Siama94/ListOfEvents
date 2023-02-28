//
//  ListEventsCell.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import UIKit
import RxSwift

final class ListEventsCell: UITableViewCell {

    // MARK: - ConfigureCell

    static func cellHeight() -> CGFloat {
        Metric.cellHeight
    }

    func configureCell(from model: EventModelWithDate) {
        eventTitle.text = model.event
        dateTitle.text = model.date.stringFromDate
        priceTitle.text = String(model.ticketPrice) + " $"
    }

    // MARK: - Views

    private lazy var eventTitle = UILabel().then {
        $0.textColor = .black
    }

    private lazy var dateTitle = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: Metric.dateTitleFontSize)
    }

    private lazy var priceTitle = UILabel().then {
        $0.textColor = .black
    }

    // MARK: - Settings

    private func commonInit() {
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        contentView.addSubview(eventTitle)
        contentView.addSubview(dateTitle)
        contentView.addSubview(priceTitle)
//        addSubviews(...)
    }

    private func setupLayout() {
        eventTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Metric.eventTitleTopOffset)
            $0.leading.equalToSuperview().offset(Metric.viewOffset)
        }

        dateTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Metric.viewOffset)
            $0.top.equalTo(eventTitle.snp.bottom)
        }

        priceTitle.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Metric.viewOffset)
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Reactive

    var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Constants
extension ListEventsCell {
    enum Metric {
        static let cellHeight: CGFloat = 50
        static let dateTitleFontSize: CGFloat = 14
        static let eventTitleTopOffset: CGFloat = 5
        static let viewOffset: CGFloat = 30
    }
}
