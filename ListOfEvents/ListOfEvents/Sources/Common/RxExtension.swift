//
//  RxExtension.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 08.02.2023.
//

import RxSwift

extension ObservableType {

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
