//
//  SettingsViewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//

import UIKit
import TinyConstraints
import CoreLocation
import SafariServices

class HSCFSettingsViewController: HSCFBaseViewController {
    enum Section_settings: CaseIterable {
        case antiPhotographyTechnology, wifiInfo, userAgreements
        
        enum AntiPhotographyTechnology: String, CaseIterable {
            case antiPhotographyTechnology = "Anti-photography technology"
        }
        
        enum WifiInfo: String, CaseIterable {
            case wirelessLocalNetwork = "Wireless local network"
            case wifiIP = "Wi-Fi IP"
            case `operator` = "Operator"
            case broadcastAddressWifi = "Broadcast address Wi-Fi"
            case wifiRouterAddress = "Wi-Fi router address"
        }
        
        enum UserAgreements: String, CaseIterable {
            case privacyPolicy = "Privacy policy"
            case termsOfService = "Terms of service"
        }
        
        var rows: [AnyHashable] {
            switch self {
            case .antiPhotographyTechnology:
                return AntiPhotographyTechnology.allCases
            case .wifiInfo:
                return WifiInfo.allCases
            case .userAgreements:
                return UserAgreements.allCases
            }
        }
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section_settings, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section_settings, AnyHashable>
    
    // MARK: - Properties
    private static let cellIdentifier = "settings.cell.identifier"
    private var locationManager: HSCFLocation_HS_Mnrg?

    private var operatorName: String? = HSCFDeviceInfo.shared.getOperator()
    private var currentNetworkInfos: Array<NetworkInfo_HSCF>? {
         get { return SSID.fetchNetworkInfo_HSCF() }
     }
    
    // MARK: - UIProperties
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.delegate = self
        return table
    }()
    
    private lazy var dataSource: DataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: HSCFSettingsViewController.cellIdentifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        if let item = item as? HSCFSettingsViewController.Section_settings.AntiPhotographyTechnology {
            content.textProperties.color = .white
            content.text = item.rawValue
            let imgView = UIImageView(image: UIImage(systemName: "chevron.right"))
            imgView.tintColor = .white
            cell.accessoryView = imgView
        } else if let item = item as? HSCFSettingsViewController.Section_settings.WifiInfo {
            content.textProperties.color = UIColor.hex("D9D9D9")
            content.text = item.rawValue
            let label = UILabel(frame: CGRect(x:0,y:0,width:100,height:20))
            label.font = UIFont.inter(.InterRegular, size: 14)
            label.textAlignment = .right
            label.textColor = UIColor.hex("898787")
            label.text = item.rightText
            cell.accessoryView = label
            if item == .wirelessLocalNetwork {
                if let ssid = self?.currentNetworkInfos?.first?.ssid {
                    label.text = ssid
                }
            }
            if item == .operator {
                label.text = self?.operatorName
            }
        } else if let item = item as? HSCFSettingsViewController.Section_settings.UserAgreements {
            content.textProperties.color = .white
            content.text = item.rawValue
            let imgView = UIImageView(image: UIImage(systemName: "chevron.right"))
            imgView.tintColor = .white
            cell.accessoryView = imgView
        }
        content.textProperties.font = UIFont.inter(.InterMedium, size: 16)
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor.cellBackground
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView_HSCF()
        prepareData_HSCF()
        
        locationManager = HSCFLocation_HS_Mnrg(delegate: self)
        locationManager?.askForAccess()
        updateOperator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Logic
    
    private func configureTableView_HSCF() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: HSCFSettingsViewController.cellIdentifier)
    }
    
    private func prepareData_HSCF() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        dataSource.apply(makeSnapshot())
    }
    
    private func clearDataSource_HSCF() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        tableView.reloadData()
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(Section_settings.allCases.map { $0 })
        Section_settings.allCases.forEach {
            snapshot.appendItems($0.rows, toSection: $0)
        }
        return snapshot
    }
    
    private func updateWiFi_HSCF_3() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        
        tableView.reloadData()
    }
    
    private func updateOperator() {
        if HSCFNetworkMonitor.shared.isConnected {
            if HSCFNetworkMonitor.shared.currentConnectionType == .cellular {
                HSCFDeviceInfo.shared.getOperatorName { [weak self] operatorModel in
                    DispatchQueue.main.async { [weak self] in
                        if let op = operatorModel?.org {
                            HSCFCoreDataManager.shared.saveOperator(name: op)
                            self?.operatorName = op
                            self?.tableView.reloadData()
                        }
                    }
                }
            } else {
                self.operatorName = "Internet"
                self.tableView.reloadData()
            }
        } else {
            self.operatorName = HSCFCoreDataManager.shared.getOperatorName() ?? .na
            self.tableView.reloadData()
        }
    }
    
    func show(_ urlString: String) {
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}

extension HSCFSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((dataSource.itemIdentifier(for: indexPath) as? HSCFSettingsViewController.Section_settings.AntiPhotographyTechnology) != nil) {
            pushViewControllerHSCF(Controller_HSCF.tutorial, animated: true)
        } else if let item = dataSource.itemIdentifier(for: indexPath) as? HSCFSettingsViewController.Section_settings.UserAgreements {
            switch item {
            case .privacyPolicy:
                show("https://google.com")
            case .termsOfService:
                show("https://google.com")
            }
        }
    }
}

extension HSCFSettingsViewController.Section_settings.WifiInfo {
    var rightText: String {
        switch self {
        case .wirelessLocalNetwork:
            return ""
        case .wifiIP:
            return HSCFDeviceInfo.shared.getWiFiAddress() ?? .na
        case .operator:
            return HSCFDeviceInfo.shared.getOperator() ?? .na
        case .broadcastAddressWifi:
            return HSCFDeviceInfo.shared.broadcastWIFIAddress() ?? .na
        case .wifiRouterAddress:
            return HSCFDeviceInfo.shared.wifiRouterAddress() ?? .na
        }
    }
}

extension HSCFSettingsViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            updateWiFi_HSCF_3()
        }
    }
}
