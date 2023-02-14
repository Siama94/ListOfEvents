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

    let eventTicket = BehaviorRelay<EventDetailsModel?>(value: nil)

    func configure(from model: EventDetailsModel) {
        eventTitle.text = model.title
    }

    // MARK: - Views

    private lazy var eventTitle = UILabel().then {
        $0.textColor = .black
    }

    // MARK: - Settings

    override func setupHierarchy() {
        super.setupHierarchy()
        addSubview(eventTitle)
    }


    override func setupLayout() {
        super.setupLayout()

        eventTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    override func setupBinding() {
        super.setupBinding()
        
        eventTicket.filterNil()
            .bind(to: Binder<EventDetailsModel>(self) { view, eventDetails in
                view.configure(from: eventDetails)
            }).disposed(by: disposeBag)
    }
}
