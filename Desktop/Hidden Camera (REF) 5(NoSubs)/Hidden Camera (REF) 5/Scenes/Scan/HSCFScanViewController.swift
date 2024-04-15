//
//  ScanViewController.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//
import UIKit
import TinyConstraints
import CoreBluetooth
import Lottie
//import LanScanner
import Network

class HSCFScanViewController: HSCFBaseViewController, LanScannerDelegate2 {
    
    enum ScanningState {
        case startDetection, checking, results
        var title: String {
            switch self {
            case .startDetection: return "Start detection"
            case .checking: return "Checking..."
            case .results: return "Results"
            }
        }
    }
    
    // MARK: - UIProperties
    private lazy var detectionButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = UIFont.inter(.InterMedium, size: 18)
        b.setTitleColor(UIColor.hex("#2C2C68"), for: .normal)
        b.setTitle(ScanningState.startDetection.title, for: .normal)
        b.addTarget(self, action: #selector(scanningTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var reviewButton: UIButton = {
        let b = UIButton()
        b.layer.borderColor = UIColor.white.cgColor
        b.layer.borderWidth = 2
        b.titleLabel?.font = UIFont.inter(.InterMedium, size: 18)
        b.setTitleColor(UIColor.white, for: .normal)
        b.setTitle("Review", for: .normal)
        b.addTarget(self, action: #selector(reviewTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var suspiciousDevicesFound: UILabel = {
        let l = UILabel()
        l.layer.cornerRadius = 60
        l.font = UIFont.inter(.InterMedium, size: 16)
        l.textColor = UIColor.hex("#2C2C68")
        l.textAlignment = .center
        l.text = "Suspicious devices found: 0"
        return l
    }()
    
    private lazy var wifiIPAddress: UILabel = {
        let l = UILabel()
        l.font = UIFont.inter(.InterRegular, size: 14)
        l.textColor = UIColor.buttonGreyText
        l.textAlignment = .center
        l.text = "Wi- Fi IP : \(HSCFDeviceInfo.shared.getWiFiAddress() ?? .na)"
        l.textColor = UIColor.hex("#2C2C68")
        return l
    }()
    
    private lazy var radarView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var radarImageView: UIImageView = UIImageView(image: UIImage(named: "radar"))
    
    // MARK: - Properties
    private lazy var networkPermsissionService = LocalNetworkPermissionService()
    private lazy var scanner = LanScannerService(delegate: self)
    private var connectedDevices = [LanDevice2]() {
        didSet { self.suspiciousDevicesFound.text = "Suspicious devices found: " + String(connectedDevices.count) }
    }
    
    private var animationView: LottieAnimationView!
    private var scanningState = ScanningState.startDetection {
        didSet { detectionButton.setTitle(scanningState.title, for: .normal); isDisableReviewButton(scanningState != .results) }
    }
    private var currentNetworkInfos: Array<NetworkInfo_HSCF>? {
        get { return SSID.fetchNetworkInfo_HSCF() }
    }
    private var locationManager: HSCFLocation_HS_Mnrg?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        internerConntectionHandle()
        prepareUI_S32HP()
        locationManager = HSCFLocation_HS_Mnrg()
        locationManager?.askForAccess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Scanning" // fix
    }
    
    public func tryStartScan() {
        if scanningState == .startDetection {
            startScan()
        }
    }
    
    private func prepareUI_S32HP() {
       
        prepareSubviews()
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }

    private func prepareSubviews() {
        reviewButton.width(80)
        reviewButton.height(47)
        reviewButton.layer.cornerRadius = 25
        detectionButton.height(50)
        detectionButton.layer.cornerRadius = 30
        let stackView = UIView()
        stackView.stack([detectionButton, reviewButton], axis: .vertical, spacing: 20)
        
        view.layer.contents = #imageLiteral(resourceName: "backgroundBlueGradient").cgImage
        view.addSubview(stackView)
        stackView.bottomToSuperview(offset: -20, usingSafeArea: true)
        stackView.leftToSuperview(offset: 20)
        stackView.rightToSuperview(offset: -20)
        stackView.height(121)
        
        let stackViewSecond = UIView()
        let upView = UIView()
        upView.backgroundColor = .white
        upView.layer.cornerRadius = 30
        stackViewSecond.stack([suspiciousDevicesFound, wifiIPAddress], axis: .vertical, spacing: 0)
        upView.addSubview(stackViewSecond)
        view.addSubview(upView)
        stackViewSecond.topToSuperview(offset: 8)
        stackViewSecond.horizontalToSuperview()
        stackViewSecond.height(44)
        upView.height(64)
        upView.bottomToTop(of: stackView, offset: -24)
        upView.leftToSuperview(offset: 20)
        upView.rightToSuperview(offset: -20)
        
        view.addSubview(radarView)
        radarView.topToSuperview(offset: 60, usingSafeArea: true)
        radarView.leftToSuperview(offset: 33, usingSafeArea: true)
        radarView.rightToSuperview(offset: -33, usingSafeArea: true)
        radarView.aspectRatio(1)
        
        radarView.addSubview(radarImageView)
        radarImageView.edgesToSuperview()
    }

    private func animateRadar() {
        if animationView != nil {
            self.animationView.play()
        } else {
            self.animationView?.removeFromSuperview()
            self.animationView = .init(name: "Radar")
            self.animationView.frame = self.radarView.bounds
            self.animationView.contentMode = .scaleAspectFill
            self.animationView.loopMode = .loop
            self.animationView.animationSpeed = 0.5
            self.animationView.layer.cornerRadius = self.radarView.frame.height / 2
            self.radarView.addSubview(self.animationView)
            self.animationView.play()
        }
    }
    
    private func stopAnimateRadar() {
        self.animationView?.stop()
        self.animationView?.removeFromSuperview()
    }
    
    private func showAlertWith_HSCF(state: CBManagerState) {
        self.showAlert(title: state.alertTitle, message: state.alertSubtitle, style: .alert, okButtonTitle: state.alertActionTitle, cancelButtonTitle: "Cancel", okHandler: { _ in
            state.action()
        }, cancelHandler: { _ in })
    }
    
    private func startScan() {
        if HSCFNetworkMonitor.shared.isConnected {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                if HSCFNetworkMonitor.shared.currentConnectionType == .cellular {
                    self?.results()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 20) { [weak self] in
                        if self?.connectedDevices.count == 0 {
                            self?.results()
                        }
                    }
                }
            }
            connectedDevices.removeAll()
            scanner.start()
            
            animateRadar()
            scanningState = .checking
        } else {
            
        }
    }
    
    private func stopScan() {
        self.animationView?.pause()
        scanner.stop()
        scanningState = .startDetection
    }
    
    private func results() {
        self.animationView?.pause()
        scanner.stop()
        scanningState = .results
        let router = currentNetworkInfos?.first
        let devices = getDevcies()
        HSCFCoreDataManager.shared.save_HSCF(wifiName: router?.ssid ?? .na, wifiIP: HSCFDeviceInfo.shared.getWiFiAddress() ?? .na, wifiInterface: router?.interface ?? .na, devices: devices)
    }
    
    private func getDevcies() -> [LanModel] {
        let jsonData = macJsonData() ?? []
        return connectedDevices.map { item in
            let brand = jsonData.first(where: { $0.mac == item.mac } )
            let name: String = item.name.contains(item.ipAddress) ? String.unknown : item.name
            return LanModel(name: name, ipAddress: item.ipAddress, mac: item.mac, brand: item.brand.isEmpty ? brand?.brandName : item.brand)
        }
    }
    
    private func isDisableReviewButton(_ isDisable: Bool) {
        reviewButton.layer.borderColor = isDisable ? UIColor.buttonGreyBorder.cgColor : UIColor.buttonYellowBorder.cgColor
        reviewButton.setTitleColor(isDisable ? UIColor.buttonGreyText : UIColor.buttonYellowText, for: .normal)
    }
    
    // MARK: - Actions
    @objc
    func scanningTapped() {
        networkPermsissionService.triggerDialog()
        switch scanningState {
        case .startDetection:
            startScan()
            detectionButton.bounce(level: .low)
        case .checking:
            break
        case .results:
            detectionButton.bounce(level: .low)
            guard let vc = Controller_HSCF.scanDetails.controller as? ScanDetailsViewController else { return }
            let devices = getDevcies()
            vc.peripheralItems = devices
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc
    func reviewTapped() {
        if scanningState == .results {
            scanningState = .startDetection
            startScan()
            reviewButton.bounce(level: .low)
        }
    }

    func lanScanHasUpdatedProgress(_ progress: CGFloat, address: String) {
        print("Progress: ", progress)
    }

    func lanScanDidFindNewDevice(_ device: LanDevice2) {
        connectedDevices.append(device)
    }

    func lanScanDidFinishScanning(_ lanDevices: [LanDevice2]) {
        connectedDevices = lanDevices
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        self.results()
        func somDogAndwhsdaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
    
    func lanScanDidFinishScanning() {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        self.results()
        func somDogAndwhsdaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
    }
}

extension LanDevice2: Identifiable {
    public var id: UUID { .init() }
}

func getCorrectMacAddress(ip: String, macAddress: String) -> String? {
    if macAddress != "02:00:00:00:00:00" {
        return macAddress
    } else if let mac = GetMACAddressFromIPv6(ip: ip) {
        return mac
    } else if let mac = LanScan2().getMacAddress(ip) {
        return mac
    } else {
        return nil
    }
}

func GetMACAddressFromIPv6(ip: String) -> String? {
    let IPStruct = IPv6Address(ip)
    if IPStruct == nil {
        return nil
    }
    let extractedMAC = [
        (IPStruct?.rawValue[8])! ^ 0b00000010,
        IPStruct?.rawValue[9],
        IPStruct?.rawValue[10],
        IPStruct?.rawValue[13],
        IPStruct?.rawValue[14],
        IPStruct?.rawValue[15]
    ]
    return String(format: "%02x:%02x:%02x:%02x:%02x:%02x",
                  extractedMAC[0] ?? 00,
                  extractedMAC[1] ?? 00,
                  extractedMAC[2] ?? 00,
                  extractedMAC[3] ?? 00,
                  extractedMAC[4] ?? 00,
                  extractedMAC[5] ?? 00)
}
