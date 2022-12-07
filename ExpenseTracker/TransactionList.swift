//
//  TransactionList.swift
//  ExpenseTracker
//
//  Created by Nirmal Koirala on 05/09/2022.
//

import SwiftUI

struct TransactionList: View {
    @EnvironmentObject var transactionListVm: TransactionListViewModel
     
    var body: some View {
        VStack{
            List {
//                MARK: Transaction Group
                ForEach( Array(transactionListVm.groupTransactionsByMonth()), id: \ .key ) { month, transactions in
                    Section {
//                        MARK: Transaction List
                        ForEach(transactions) { transaction in
                        TransactionRow(transaction: transaction)
                        }
                    } header: {
//                        MARK: Transaction Month
                         Text(month)
                    }
                    . listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

   


struct TransactionList_Previews: PreviewProvider {
    static let transactionlistVM: TransactionListViewModel = {
         let transactionlistVM = TransactionListViewModel()
        transactionlistVM.transactions = transactionListPreviewData
        return transactionlistVM
    }()

    static var previews: some View {
        Group {
            NavigationView {
                TransactionList()
            }
            NavigationView {
                TransactionList()
                    .preferredColorScheme(.dark)
            }
        }
        .environmentObject(transactionlistVM)
    }
} 
