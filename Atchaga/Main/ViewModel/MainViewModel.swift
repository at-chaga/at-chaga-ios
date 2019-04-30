//
//  MainViewModel.swift
//  Atchaga
//
//  Created by Clpak on 29/04/2019.
//  Copyright © 2019 Atchaga. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    var cellModels: [MainInfoViewModel] = []
    
    static func mock() -> MainViewModel {
        let mainViewModel = MainViewModel()
        
        let cellModel = MainInfoViewModel.mock(type: .blocker)
        let cellModel2 = MainInfoViewModel.mock(type: .victim)
        
        mainViewModel.cellModels = [cellModel, cellModel2]
        
        return mainViewModel
    }
    
}
