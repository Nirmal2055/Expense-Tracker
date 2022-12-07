//
//  RecentTransationList.swift
//  ExpenseTracker
//
//  Created by Nirmal Koirala on 05/09/2022.
//

import SwiftUI

struct RecentTransationList: View {
    @EnvironmentObject var transactionListVM: TransactionListViewModel
      
    var body: some View {
        VStack{
            HStack{
//                MARK: Headaer Title
                Text("Recent Transactions")
                    .bold()
                Spacer()
                
//                 MARK: Header Link
                NavigationLink {
                    TransactionList()
                }
            label: {
                    HStack(spacing: 4) {
                        Text("See All")
                        Image(systemName: "chevron.right")
                        
                    }
                    .foregroundColor(Color.text)
                     
                }

            }
            .padding(.top)
//            MARK: Recent Transaction List
            ForEach(Array(transactionListVM.transactions.prefix(5).enumerated()), id: \.element) {index,  transaction in
                TransactionRow(transaction: transaction)
                
                Divider()
                    .opacity(index == 4 ? 0 : 1)
                
            } 
        }
        .padding()
        .background(Color.systemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .primary.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct RecentTransationList_Previews: PreviewProvider {
    static let transactionlistVM: TransactionListViewModel = {
         let transactionlistVM = TransactionListViewModel()
        transactionlistVM.transactions = transactionListPreviewData
        return transactionlistVM 
    }()
    
    static var previews: some View {
        Group {
            RecentTransationList()
            RecentTransationList()
                .preferredColorScheme(.dark)
                
        }
        .environmentObject(transactionlistVM)
    }
}
 
