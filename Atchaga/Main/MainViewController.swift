//
//  MainViewController.swift
//  Atchaga
//
//  Created by Clpak on 29/04/2019.
//  Copyright © 2019 Atchaga. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    weak var floatingButton: UIButton?
    
    private let disposeBag = DisposeBag()
    
    var viewModel: MainViewModel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let viewController = segue.destination
        if segue.identifier == Segue.mainToCamera.rawValue {
            print("Segue to Camera vc")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingButton()
        
        fetchMainInfo { success in
            if success {
                setupTableView()
                showFloatingButton()
            } else {
                showReloadView()
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    private func setupFloatingButton() {
        let floatingButton = UIButton()
        floatingButton.setImage(UIImage(named: "btn_camera"), for: .normal)
        floatingButton.contentMode = .scaleAspectFit
        floatingButton.contentHorizontalAlignment = .fill
        floatingButton.contentVerticalAlignment = .fill
        
        floatingButton.rx.tap
            .debounce(0.2, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.performSegue(withIdentifier: Segue.mainToCamera.rawValue, sender: nil)
            }).disposed(by: disposeBag)
        
        view.insertSubview(floatingButton, aboveSubview: tableView)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        self.floatingButton = floatingButton
        
        floatingButton.isHidden = true
    }
    
    private func fetchMainInfo(complete: ((_ success: Bool) -> ())) {
        // Request api
        viewModel = MainViewModel.mock()
        complete(true)
    }
    
    private func showReloadView() {
        // Show reload view
    }
    
    private func showFloatingButton() {
        self.floatingButton?.isHidden = false
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainInfoCell.identifier, for: indexPath) as? MainInfoCell,
            let viewModel = viewModel,
            let cellModel = viewModel.cellModels[safe: indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: cellModel)
        subscribeEvent(cell: cell, viewModel: cellModel)
        
        return cell
    }
    
    private func subscribeEvent(cell: MainInfoCell, viewModel: MainInfoViewModel) {
        cell.leftButton.rx.tap.subscribe(onNext: { [weak self] in
            switch viewModel.type {
            case .blocker:
                // Alarm
                print("Alarm event")
                break
            case .victim:
                // Cancel
                print("Cancel event")
                break
            }
        }).disposed(by: disposeBag)
        
        cell.rightButton.rx.tap.subscribe(onNext: { [weak self] in
            switch viewModel.type {
            case .blocker:
                // Done
                print("Done event")
                break
            case .victim:
                // Push
                print("Push event")
                break
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
