//
//  CoreDataProvider.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 15.11.2023.
//

import Foundation
import CoreData

enum EntityNames: String, CaseIterable {
    case lanHistory = "LanHistory"
    case foundLanDevice = "FoundLanDevice"
    case `operator` = "OperatorEntety"
}

class HSCFCoreDataManager: NSObject {
    
    private override init() {}
    
    static let shared = HSCFCoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Hidden_Spy_Camera_Finder")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext_HSCF() {
        
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func getNewEntityby(name: EntityNames) -> NSManagedObject? {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: name.rawValue, in: context) else { return nil }
        let newOrder = NSManagedObject(entity: entity, insertInto: context)
        return newOrder
    }
    
    func getEntitiesListby(name: EntityNames) -> [NSManagedObject]? {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name.rawValue)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            guard let orders = result as? [NSManagedObject] else { return nil }
            return orders
        } catch {
            return nil
        }
    }
    
    func delete_S32HP(_ entity: NSManagedObject) {
        let context = persistentContainer.viewContext
        context.delete(entity)
        saveContext_HSCF()
    }
    
    func saveOperator(name: String) {
        guard let op = self.getNewEntityby(name: .operator) as? OperatorEntety else { return }
        op.id = "ID_OPERATOR"
        op.operatorName = name
        saveContext_HSCF()
    }
    
    func getOperatorName() -> String? {
        guard let h = getEntitiesListby(name: .operator) as? [OperatorEntety] else { return nil }
        return h.first(where: { $0.id == "ID_OPERATOR" })?.operatorName
    }
    
    func save_HSCF(wifiName: String, wifiIP: String, wifiInterface: String, foundDate: Date = Date(), devices: [LanModel]) {
        guard let lanHistory = self.getNewEntityby(name: .lanHistory) as? LanHistory else { return }
        lanHistory.wifiIP = wifiIP
        lanHistory.foundDate = foundDate
        lanHistory.wifiName = wifiName
        lanHistory.wifiInterface = wifiInterface
        devices.forEach { lanModel in
            guard let foundLanDevice = self.getNewEntityby(name: .foundLanDevice) as? FoundLanDevice else { return }
            foundLanDevice.name = lanModel.name
            foundLanDevice.macAddress = lanModel.mac
            foundLanDevice.brand = lanModel.brand
            foundLanDevice.ipAddress = lanModel.ipAddress
            lanHistory.addToDevices(foundLanDevice)
        }
        self.saveContext_HSCF()
    }
    
    func getHistory_HSCF() -> [LanHistory]? {
        guard let h = getEntitiesListby(name: .lanHistory) as? [LanHistory] else { return nil }
        return h
    }
    
    func remove_HSCF(id: ObjectIdentifier, entity: EntityNames) {
        switch entity {
        case .lanHistory:
            guard let bookmarks = getEntitiesListby(name: .lanHistory) as? [LanHistory] else { return }
            if let v = bookmarks.first(where: {$0.id == id}) {
                delete_S32HP(v)
            }
        case .foundLanDevice:
            break
        case .operator:
            break
        }
    }
}
