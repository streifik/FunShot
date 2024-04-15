//
//  ScanDetailsViewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 09.11.2023.
//

import UIKit
import TinyConstraints
import CoreLocation
import Lottie

class ScanDetailsViewController: HSCFBaseViewController, CLLocationManagerDelegate {
    enum Section_scan_detail: Int, CaseIterable {
        case mainInfo, alert, peripheralItems, emptyCell
    }
    
    enum ItemValue {
        case emptyCell, alert
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section_scan_detail, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section_scan_detail, AnyHashable>
    
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
        if let item = item as? TextModel {
            guard let scanCell = tableView.dequeueReusableCell(withIdentifier: "ScanDetailCell", for: indexPath) as? ScanDetailCell else { return UITableViewCell() }
            scanCell.titleTextLabel.text = item.subTitleValue
            scanCell.titleValueButton.setTitle(item.titleValue, for: .normal)
            scanCell.subTitleTextLabel.text = item.subTitle
            scanCell.subTitleValueLabel.text = item.title
            
            scanCell.titleValueButton.setTitleColor(item.title.isEmpty ? UIColor.hex("D8EB04").withAlphaComponent(0.3) : UIColor.hex("D8EB04"), for: .normal)
            scanCell.titleValueButton.isEnabled = item.title.isEmpty ? false : true
            if item.titleValue != "Copy Mac" { scanCell.titleValueButton.setTitleColor(UIColor.hex("D9D9D9"), for: .normal) }
            
            if item.title == .unknown {
                scanCell.titleValueButton.isEnabled = false
            } else {
                scanCell.titleValueButton.isEnabled = true
            }
            
            scanCell.titleValueButton.alpha = item.title == .unknown ? 0.3 : 1
            
            if item.titleValue != "Copy Mac" {
                scanCell.titleTextLabel.text = item.title
                scanCell.subTitleValueLabel.text = item.subTitleValue
            }
            
            scanCell.actionTapped = {
                UIPasteboard.general.string = item.title
                HSCFAlertView.instance.showAlert_HSCF(showImage: true, title: "The copying was successful!")
            }
            return scanCell
        } else if let item = item as? ItemValue {
            switch item {
            case .emptyCell:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyStateCell", for: indexPath) as? EmptyStateCell else { return UITableViewCell() }
                cell.titleLabel.text = "No other devices are found on the current network"
                return cell
            case .alert:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScanDetailTextCell", for: indexPath) as? ScanDetailTextCell else { return UITableViewCell() }
                return cell
            }
        } else {
            return UITableViewCell()
        }
    }
    private var locationManager: HSCFLocation_HS_Mnrg?
    private var currentNetworkInfos: Array<NetworkInfo_HSCF>? {
        get { return SSID.fetchNetworkInfo_HSCF() }
    }
    
    public var peripheralItems: [LanModel] = []
    public var routerInfo: (wifiName: String, wifiIp: String, routerInterface: String?)?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews_S32HP()
        configureTableView_HSCF()
        
        locationManager = HSCFLocation_HS_Mnrg(delegate: self)
        locationManager?.askForAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        asd2_prepareData_HSCF()
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    // MARK: - Logic
    
    private func configureTableView_HSCF() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        tableView.register(ScanDetailCell.nib, forCellReuseIdentifier: "ScanDetailCell")
        tableView.register(ScanDetailTextCell.self, forCellReuseIdentifier: "ScanDetailTextCell")
        tableView.register(EmptyStateCell.self, forCellReuseIdentifier: "EmptyStateCell")
    }
    
    private func asd2_prepareData_HSCF() {
        
        var items: [(Section_scan_detail, [AnyHashable])] = []
        let deviceName = UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        var mainInfo = [ScanDetailsViewController.TextModel(title: deviceName,
                                                            titleValue: "Own",
                                                            subTitle: HSCFDeviceInfo.shared.getWiFiAddress() ?? .na, 
                                                            subTitleValue: "Apple, Inc.")]
        if let routerInfo {
            mainInfo.append(ScanDetailsViewController.TextModel(title: routerInfo.wifiName,
                                                                titleValue: "Router",
                                                                subTitle: routerInfo.wifiIp,
                                                                subTitleValue: routerInfo.routerInterface ?? .na))
        } else if let router = currentNetworkInfos?.first, let ssid = router.ssid {
            mainInfo.append(ScanDetailsViewController.TextModel(title: ssid,
                                                                titleValue: "Router",
                                                                subTitle: HSCFDeviceInfo.shared.getWiFiAddress() ?? .na,
                                                                subTitleValue: router.interface))
        }
        let peripheralItems: [ScanDetailsViewController.TextModel] = peripheralItems.compactMap {
            return TextModel(title: $0.mac ?? .unknown, titleValue: "Copy Mac", subTitle: $0.ipAddress, subTitleValue: $0.name)
        }
        
        items = [
            (Section_scan_detail.mainInfo, mainInfo),
            (Section_scan_detail.alert, [ItemValue.alert]),
        ]
        
        if !peripheralItems.isEmpty {
            items.append((Section_scan_detail.peripheralItems, peripheralItems))
        } else {
            items.append((Section_scan_detail.emptyCell, [ItemValue.emptyCell]))
        }
        
        dataSource.apply(makeSnapshot(items: items))
    }
    
    private func makeSnapshot(items: [(Section_scan_detail, [AnyHashable])]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(items.map { $0.0 })
        items.forEach { section, items in
            snapshot.appendItems(items, toSection: section)
        }
        return snapshot
    }
    
    private func setupSubviews_S32HP() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
    }
    
    private func setupDataSource() {
        
    }
    
    private func updateWiFi_HSCF() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        self.asd2_prepareData_HSCF()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            updateWiFi_HSCF()
        }
    }

    struct TextModel: Hashable {
        let title: String
        let titleValue: String
        
        let subTitle: String
        let subTitleValue: String
    }
}
