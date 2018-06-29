//
//  ImageProcessorConfigurator.swift
//  ImageProcessor
//
//  Created by Maxim Kholmansky on 28/06/2018.
//  Copyright © 2018 Maxim Kholmansky. All rights reserved.
//

import Foundation

class ImageProcessorConfigurator: ImageProcessorConfiguratorProtocol {
    
    func configure(with viewController: ImageProcessorViewController) {
        let presenter = ImageProcessorPresenter(view: viewController)
        let interactor = ImageProcessorInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        
    }
    
    
    
    
}
