//
//  DownloadImageEndpoint.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import Foundation

enum DownloadImageEndpoint {
    case downloadFromUrl(url: String)
}

extension DownloadImageEndpoint: Endpoint {
    var path: String {
        switch self {
        case .downloadFromUrl(let url):
            return url
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .downloadFromUrl:
            return .get
        }
    }
    
    var header: [String: String]? {
        return nil
    }
    
    var body: [String: String]? {
        return nil
    }
}
