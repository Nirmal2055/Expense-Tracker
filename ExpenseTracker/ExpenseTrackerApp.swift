//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Nirmal Koirala on 02/09/2022.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
     
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
