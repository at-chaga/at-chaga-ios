//
//  MainInfoViewModel.swift
//  Atchaga
//
//  Created by Clpak on 29/04/2019.
//  Copyright © 2019 Atchaga. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainInfoViewModel: NSObject {
    var type: MainInfoCell.CellType
    var topDescription = Variable<NSAttributedString>(NSAttributedString())
    var mainDescription = Variable<NSAttributedString>(NSAttributedString())
    var bottomDescription = Variable<NSAttributedString>(NSAttributedString())
    
    var leftButtonText = Variable<String>("")
    var rightButtonText = Variable<String>("")
    
    init(type: MainInfoCell.CellType) {
        self.type = type
        super.init()
    }
    
    static func mock(type: MainInfoCell.CellType) -> MainInfoViewModel {
        let viewModel = MainInfoViewModel(type: type)
        viewModel.mockingDescriptions(type: type)
        return viewModel
    }
    
    private func mockingDescriptions(type: MainInfoCell.CellType) {
        switch type {
        case .blocker:
            let topAttributedString = NSAttributedString(string: "4월 30일 오후 12시 30분",
                                                         attributes: [NSAttributedString.Key.kern: -0.2,
                                                                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                                                                      NSAttributedString.Key.foregroundColor: UIColor.darkText])
            topDescription.value = topAttributedString
            
            let mainAttributedString = NSMutableAttributedString()
            mainAttributedString.append(NSAttributedString(string: "3",
                                                           attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 80)]))
            mainAttributedString.append(NSAttributedString(string: " 시간",
                                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]))
            mainAttributedString.append(NSAttributedString(string: "31",
                                                           attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 80)]))
            mainAttributedString.append(NSAttributedString(string: " 분",
                                                           attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
            
            mainDescription.value = mainAttributedString
            
            let bottomAttributedString = NSAttributedString(string: "안에 차를 빼야 합니다.",
                                                            attributes: [NSAttributedString.Key.kern: -0.2,
                                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                                                                         NSAttributedString.Key.foregroundColor: UIColor.darkText])
            
            bottomDescription.value = bottomAttributedString
            
            leftButtonText.value = "Alarm"
            rightButtonText.value = "Done"
            
        case .victim:
            let topAttributedString = NSAttributedString(string: "출차 시간은",
                                                         attributes: [NSAttributedString.Key.kern: -0.2,
                                                                      NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                                                                      NSAttributedString.Key.foregroundColor: UIColor.darkText])
            topDescription.value = topAttributedString
            
            let mainAttributedString = NSMutableAttributedString()
            mainAttributedString.append(NSAttributedString(string: "12",
                                                           attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 80)]))
            mainAttributedString.append(NSAttributedString(string: " 시",
                                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]))
            mainAttributedString.append(NSAttributedString(string: "30",
                                                           attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 80)]))
            mainAttributedString.append(NSAttributedString(string: " 분",
                                                           attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
            
            mainDescription.value = mainAttributedString
            
            let bottomAttributedString = NSAttributedString(string: "입니다.",
                                                            attributes: [NSAttributedString.Key.kern: -0.2,
                                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                                                                         NSAttributedString.Key.foregroundColor: UIColor.darkText])
            
            bottomDescription.value = bottomAttributedString
            
            leftButtonText.value = "Cancel"
            rightButtonText.value = "Push"
        }
    }
}
