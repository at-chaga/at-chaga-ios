//
//  MainInfoCell.swift
//  Atchaga
//
//  Created by Clpak on 29/04/2019.
//  Copyright © 2019 Atchaga. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class MainInfoCell: UITableViewCell {
    enum CellType {
        case blocker, victim
    }
    
    static let identifier = "MainInfoCell"
    
    @IBOutlet weak var topDescriptionLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var bottomDescriptionLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var viewModel: MainInfoViewModel?
    var disposeBag: DisposeBag?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainDescriptionLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func prepareForReuse() {
        viewModel = nil
        topDescriptionLabel.text = nil
        mainDescriptionLabel.text = nil
        bottomDescriptionLabel.text = nil
        disposeBag = nil
    }
    
    func configure(with viewModel: MainInfoViewModel) {
        let disposeBag = DisposeBag()
        self.disposeBag = disposeBag
        
        viewModel.topDescription.asObservable().subscribe(onNext: { [weak self] value in
            self?.topDescriptionLabel.attributedText = value
        }).disposed(by: disposeBag)
        
        viewModel.mainDescription.asObservable().subscribe(onNext: { [weak self] value in
            self?.mainDescriptionLabel.attributedText = value
        }).disposed(by: disposeBag)
        
        viewModel.bottomDescription.asObservable().subscribe(onNext: { [weak self] value in
            self?.bottomDescriptionLabel.attributedText = value
        }).disposed(by: disposeBag)
        
        viewModel.leftButtonText.asObservable().subscribe(onNext: { [weak self] value in
            self?.leftButton.setTitle(value, for: .normal)
        })
        
        viewModel.rightButtonText.asObservable().subscribe(onNext: { [weak self] value in
            self?.rightButton.setTitle(value, for: .normal)
        })
    }
}
