//
//  BTRadar.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//


import UIKit
import TinyConstraints
import CoreBluetooth

class BTRadarViewController: HSCFBaseViewController, UITableViewDelegate {
    enum Section_bt_radar: Int, CaseIterable {
        case devices, peripheralItems, alert
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section_bt_radar, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section_bt_radar, AnyHashable>
    
    // MARK: - UIProperties
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.backgroundColor = .clear
        table.sectionHeaderHeight = 10
        table.sectionFooterHeight = 10
        table.delegate = self
        return table
    }()
    
    // MARK: - Properties
    private lazy var dataSource: DataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, item in
        if let item = item as? String {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScanDetailTextCell", for: indexPath) as? ScanDetailTextCell else { return UITableViewCell() }
            cell.label.text = item
            return cell
        } else if let item = item as? BluModel {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BTRadarPerephiralCell", for: indexPath) as? BTRadarPerephiralCell else { return UITableViewCell() }
            cell.titleLabel.text = item.peripheral.name ?? "Unknown"
            cell.subtitleLabel.text = "Instantly"//item.peripheral.identifier.uuidString
            cell.valueLabel.text = "\(item.rssi) m"
            return cell
        } else if let item = item as? Int {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnimationSliderDevicesCell", for: indexPath) as? AnimationSliderDevicesCell else { return UITableViewCell() }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    public var peripheralItems: [BluModel] = [] {
        didSet { prepareData_HSCF() }
    }
    lazy var bluService = BLUService()
    private var bluState: CBManagerState = .unknown
    
    private var shippedItem: BluModel?
    private var deviceDetailVC: DeviceDetailDistanceViewController?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews_S32HP()
        configureTableView_HSCF()
        checkBluState()
        prepareData_HSCF()
        
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
        startScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        resetDetailVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        stopScan()
    }
    
    // MARK: - Logic
    private func checkBluState() {
        bluService.didUpdateState { [weak self] state in
            self?.bluState = state
            if state == .poweredOn {
                self?.startScan()
            } else {
                self?.showAlertWith_HSCF(state: state)
            }
        }
    }
    
    private func showAlertWith_HSCF(state: CBManagerState) {
        self.showAlert(title: state.alertTitle, message: state.alertSubtitle, style: .alert, okButtonTitle: state.alertActionTitle, cancelButtonTitle: "Cancel", okHandler: { _ in
            state.action()
        }, cancelHandler: { _ in })
    }
    
    private func startScan() {
        bluService.startScan(options: nil)
        discoverPeripherals()
    }
    
    private func stopScan() {
        if deviceDetailVC == nil {
            bluService.stopScan()
        }
    }
    
    private func discoverPeripherals() {
        bluService.didDiscover { [weak self] peripheral, rssi in
            if let shippedItem = self?.shippedItem, shippedItem.peripheral.identifier == peripheral.identifier {
                self?.sendDataToDetailVC(rssi: rssi.toCorrectDistance)
            }
            
            if let name = peripheral.name {
                if let row = self?.peripheralItems.firstIndex(where: { $0.peripheral.name == name }) {
                    self?.peripheralItems[row] = BluModel(peripheral: peripheral, rssi: rssi)
                } else {
                    self?.peripheralItems.append(BluModel(peripheral: peripheral, rssi: rssi))
                }
            }
        }
    }
    
    private func sendDataToDetailVC(rssi: Int) {
        deviceDetailVC?.rssi = rssi
    }
    
    private func resetDetailVC() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        
        deviceDetailVC = nil
        shippedItem = nil
    }
    
    private func setupSubviews_S32HP() {
        view.addSubview(tableView)
        tableView.edgesToSuperview(usingSafeArea: true)
    }
    
    private func configureTableView_HSCF() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        tableView.register(BTRadarPerephiralCell.self, forCellReuseIdentifier: "BTRadarPerephiralCell")
        tableView.register(ScanDetailTextCell.self, forCellReuseIdentifier: "ScanDetailTextCell")
        tableView.register(AnimationSliderDevicesCell.self, forCellReuseIdentifier: "AnimationSliderDevicesCell")
    }
    
    private func prepareData_HSCF() {
        dataSource.apply(makeSnapshot(items: [
            (Section_bt_radar.devices, [0]),
            (Section_bt_radar.peripheralItems, peripheralItems),
            (Section_bt_radar.alert, ["Change your location to find more bluetooth devices"])
        ]), animatingDifferences: false)
    }
    
    private func makeSnapshot(items: [(Section_bt_radar, [AnyHashable])]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections(items.map { $0.0 })
        items.forEach { section, items in
            snapshot.appendItems(items, toSection: section)
        }
        return snapshot
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataSource.itemIdentifier(for: indexPath) as? BluModel {
            let vc = Controller_HSCF.deviceDetailDistance.controller as! DeviceDetailDistanceViewController
            self.deviceDetailVC = vc
            self.shippedItem = item
            vc.rssi = item.rssi
            vc.name = item.peripheral.name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
