//
//  EventTicketView.swift.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 09.02.2023.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class EventTicketView: RxBaseView {

    // MARK: - Configure

    let eventTicket = BehaviorRelay<EventTicketModel?>(value: nil)

    func configure(from model: EventTicketModel) {
        let date = model.date?.dateFromString
        dateTitle.text = "Date of payment: " + (date?.stringFromDate ?? "")
    }

    // MARK: - Views

    private lazy var dateTitle = UILabel().then {
        $0.textColor = .black
    }

    // MARK: - Settings

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(dateTitle)
    }


    override func setupLayout() {
        super.setupLayout()

        dateTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    override func setupBinding() {
        super.setupBinding()
        
        eventTicket.filterNil()
            .bind(to: Binder<EventTicketModel>(self) { view, eventDetails in
                view.configure(from: eventDetails)
            }).disposed(by: disposeBag)
    }
}
