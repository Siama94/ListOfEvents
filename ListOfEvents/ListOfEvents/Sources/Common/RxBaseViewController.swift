//
//  RxBaseViewController.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 07.02.2023.
//

import RxSwift
import UIKit

class RxBaseViewController<View>: UIViewController where View: UIView {

    // MARK: - Reactive

    var disposeBag = DisposeBag()

    // MARK: - UI components

    let contentView = View()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = contentView
    }

    // MARK: - Settings

    func setupBinding() { }
}
