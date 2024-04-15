//
//  AntiSpyDetails.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 14.11.2023.
//

import UIKit
import TinyConstraints

class AntiSpyDetailsViewController: HSCFBaseViewController {

    enum SelectType {
        case all
        case obscura
    }
    
    typealias DataSource = UITableViewDiffableDataSource<AnyHashable, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<AnyHashable, AnyHashable>
    
    // MARK: - UIProperties
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.sectionHeaderHeight = 10
        table.sectionFooterHeight = 10
        return table
    }()
    
    // MARK: - Properties
    private lazy var dataSource: DataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
        if
            let cell = tableView.dequeueReusableCell(withIdentifier: "AntiSpyDetailsCell", for: indexPath) as? AntiSpyDetailsCell,
            let item = item as? AntiSpyDetailModel {
            cell.imgView.image = item.image
            cell.titleLabel.text = item.title
            cell.subtitleLabel.text = item.subtitle
            cell.selectionStyle = .none
            return cell
        } else if let cell = tableView.dequeueReusableCell(withIdentifier: "AntiSpyButtonCell", for: indexPath) as? AntiSpyButtonCell, let item = item as? Int {
            cell.actionCompletion = { [weak self] in
                self?.obscuraCompletion?()
                self?.navigationController?.popViewController(animated: false)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    public var obscuraCompletion: (() -> ())?
    public var selectItemsType: SelectType = .all
    
    private var items: [AntiSpyDetailModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = selectItemsType == .all ? AntiSpyDetailModel.items : AntiSpyDetailModel.item
        setupSubviews_S32HP()
        configureTableView_S32HP()
        prepareData_HSCF()
    }
    
    private func setupSubviews_S32HP() {
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
    }
    
    private func configureTableView_S32HP() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        tableView.register(AntiSpyDetailsCell.self, forCellReuseIdentifier: "AntiSpyDetailsCell")
        tableView.register(AntiSpyButtonCell.self, forCellReuseIdentifier: "AntiSpyButtonCell")
    }
    private func prepareData_HSCF() {
        dataSource.apply(makeSnapshot(items: items), animatingDifferences: true)
    }
    
    private func makeSnapshot(items: [AntiSpyDetailModel]) -> Snapshot {
        var snapshot = Snapshot()
        items.forEach { item in
            snapshot.appendSections([item])
            snapshot.appendItems([item], toSection: item)
        }
        if selectItemsType == .obscura {
            snapshot.appendSections([selectItemsType])
            snapshot.appendItems([1])
        }
        return snapshot
    }
    
}
