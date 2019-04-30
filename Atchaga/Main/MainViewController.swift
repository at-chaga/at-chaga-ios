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
    private let disposeBag = DisposeBag()
    
    var viewModel: MainViewModel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMainInfo { success in
            if success {
                setupTableView()
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
    
    private func fetchMainInfo(complete: ((_ success: Bool) -> ())) {
        // Request api
        viewModel = MainViewModel.mock()
        complete(true)
    }
    
    private func showReloadView() {
        // Show reload view
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
