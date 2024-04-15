//
//  AntiSpyViewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//

import UIKit
import TinyConstraints

class AntiSpyViewController: HSCFBaseViewController, UITableViewDelegate {
        
    enum Section_anti_spy: Int {
        case menu, detectionHistoryHeader, detectionHistory
    }
    
    enum Action_anti_spy {
        case cameraObscura, infraredCamera, wirelessObscura, wiredObscure, sleepCamera, other
    }
    
    enum ItemValue: Hashable {
        case menu, header, history(_ history: LanHistory)
    }
    
    typealias DataSource = AntiSpyDiffableDataSource
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section_anti_spy, AnyHashable>
    
    // MARK: - UIProperties
    fileprivate lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.sectionHeaderHeight = 10
        table.sectionFooterHeight = 10
        table.delegate = self
        return table
    }()
    
    // MARK: - Properties
    private lazy var dataSource: DataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
        if let item = item as? ItemValue {
            switch item {
            case .menu:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AntiSpyMenuCell", for: indexPath) as? AntiSpyMenuCell else { return UITableViewCell() }
                cell.labels.forEach { $0.font = UIFont.inter(.InterRegular, size: 14) }
                cell.completion = { [weak self] action in
                    let vc = Controller_HSCF.antiSpyDetail.controller as! AntiSpyDetailsViewController
                    if action == .wiredObscure {
                        vc.selectItemsType = .obscura
                        vc.obscuraCompletion = { [weak self] in
                            tabController?.processOpeningScanSceneAndScanning()
                        }
                    }
                    self?.navigationController?.pushViewController(vc, animated: false)
                }
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
                return cell
            case .history(let history):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScanDetailLanDeviceCell", for: indexPath) as? ScanDetailLanDeviceCell else { return UITableViewCell() }
                if let d = history.foundDate {
                    cell.titleLabel.text = self?.getCorrectDate(date: d)
                }
                cell.of_setup_st_ate_RIGHT_image(showCheckMark: history.devices?.count == 0)
                cell.subtitleLabel.text = history.wifiIP
                return cell
            case .header:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else { return UITableViewCell() }
                cell.titleLabel.text = "Detection history"
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews_HSCF()
        configureTableView_HSCF()
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        
        prepareData_HSCF2()
    }
    
    private func setupSubviews_HSCF() {
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
    }
    
    private func configureTableView_HSCF() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        tableView.register(AntiSpyMenuCell.nib, forCellReuseIdentifier: "AntiSpyMenuCell")
        tableView.register(ScanDetailLanDeviceCell.self, forCellReuseIdentifier: "ScanDetailLanDeviceCell")
        tableView.register(HeaderCell.self, forCellReuseIdentifier: "HeaderCell")
    }
    
    private func prepareData_HSCF2() {
        var items: [(Section_anti_spy, [AnyHashable])] = [
            (Section_anti_spy.menu, [ItemValue.menu])
        ]
        
        if let i = HSCFCoreDataManager.shared.getHistory_HSCF() {
            items.append((Section_anti_spy.detectionHistoryHeader, [ItemValue.header]))
            items.append((Section_anti_spy.detectionHistory, i.reversed().map { ItemValue.history($0) }))
        }
        
        dataSource.apply(makeSnapshot(items: items), animatingDifferences: false)
    }
    
    private func makeSnapshot(items: [(Section_anti_spy, [AnyHashable])]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(items.map { $0.0 })
        items.forEach { section, items in
            snapshot.appendItems(items, toSection: section)
        }
        return snapshot
    }
    
    private func getCorrectDate(date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy.MM.dd HH:mm"
        return dateFormatterGet.string(from: date)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) as? ItemValue {
            switch item {
            case .history(let history):
                guard let vc = Controller_HSCF.scanDetails.controller as? ScanDetailsViewController, let objects = history.devices?.allObjects as? [FoundLanDevice] else { return }
                vc.peripheralItems = objects.map { LanModel(name: $0.name ?? .na, ipAddress: $0.ipAddress ?? .na, mac: $0.macAddress, brand: $0.brand) }
                vc.routerInfo = (history.wifiName ?? .na, history.wifiIP ?? .na, history.wifiInterface)
                navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }
    }

    class AntiSpyDiffableDataSource: UITableViewDiffableDataSource<AntiSpyViewController.Section_anti_spy, AnyHashable> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            if let item = itemIdentifier(for: indexPath) as? ItemValue {
                switch item {
                case .history:
                    return true
                case .menu:
                    return false
                case .header:
                    return false
                }
            } else {
                return false
            }
        }

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let item = itemIdentifier(for: indexPath) as? ItemValue {
                    switch item {
                    case .history(let history):
                        HSCFAlertView.instance.showAlert_HSCF(title: "Deleting", message: "Are you sure you want to delete?", leftActionTitle: "Cancel", rightActionTitle: "Delete") { } rightAction: {
                            HSCFCoreDataManager.shared.remove_HSCF(id: history.id, entity: .lanHistory)
                            var snapshot = self.snapshot()
                            snapshot.deleteItems([item])
                            self.apply(snapshot)
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
}
