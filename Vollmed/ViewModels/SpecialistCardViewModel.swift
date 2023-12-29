//
//  SpecialistCardViewModel.swift
//  Vollmed
//
//  Created by Arthur Gabriel Gomes on 28/12/23.
//

import UIKit

struct SpecialistCardViewModel {
    let service: DownloadImageServiceable
    
    init(service: DownloadImageServiceable) {
        self.service = service
    }
    
    func dowloadImage(from imageURL: String) async -> UIImage? {
        let result = await service.downloadImage(from: imageURL)
        
        switch result {
        case let .success(image):
            return image
        case let .failure(error):
            print(error.localizedDescription)
            return nil
        }
    }
    
}
