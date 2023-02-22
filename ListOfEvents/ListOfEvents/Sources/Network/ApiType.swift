//
//  ApiType.swift
//  ListOfEvents
//
//  Created by Anastasiia iOS on 22.02.2023.
//

import Foundation

enum ApiType {
    case getListEvents
    case getEventDetails(eventId: String)
    case buyEventTicket(eventId: String)

    var baseURL: URL {
        return URL(string: "https://technical-interview.excels.io/")!
    }

    var headers: [String: String] {
        ["key": "value",
         "secret": Constants.secretValue]
    }
    
    var path: String {
        switch self {
        case .getListEvents:
            return "events"
        case .getEventDetails(let eventId):
            return "event/\(eventId)"
        case .buyEventTicket(let eventId):
            return "event/\(eventId)/buy"
        }
    }

    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        switch self {
        case .getListEvents:
            request.httpMethod = "GET"
            return request
        case .getEventDetails:
            request.httpMethod = "GET"
            return request
        case .buyEventTicket:
            request.httpMethod = "POST"
            return request
        }
    }
}

extension ApiType {
    enum Constants {
        static let secretValue: String = "c8242f09751a2a5e9968a5e66b9259ca2ede3d92b0742a0ecfcab6b45adbb16ac9ebb2ebd073f3bd17d09538d97582cf7ea7c1dbbb9e1e8bf80db7262dc0923c205a0f9e626c5e37bc4e4ae99fa2e18434679631a72a497b89385095ea1e68031f543644ca579bf4f1473c71ad5dce50581e125637c72406fe5bfb437843225a847e644e3026f68764127397e86fe4ccaf33836cbbe2f46d32061388b33d18bc"
    }
}
