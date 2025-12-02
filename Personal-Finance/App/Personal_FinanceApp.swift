//
//  Personal_FinanceApp.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 19/11/2025.
//

import SwiftUI
import IQKeyboardManagerSwift
import FirebaseCore
import RealmSwift
import Realm

@main
struct Personal_FinanceApp: SwiftUI.App {
    
    @StateObject var flow = SplashFlowViewModel()
    
    init() {
        // MARK: - Keyboard Manager
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        // MARK: - Firebase
        FirebaseApp.configure()
        
        // MARK: - Realm Migration
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: "TransactionModel") { oldObject, newObject in
                        // Handle old 'amount' property if it exists
                        if let oldAmount = oldObject?["amount"] as? Double {
                            newObject?["totalAmount"] = oldAmount
                            newObject?["expenseAmount"] = oldAmount
                            newObject?["incomeAmount"] = 0.0
                        }
                    }
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(flow)
        }
    }
}
