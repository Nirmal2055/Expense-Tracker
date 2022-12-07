//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Nirmal Koirala on 02/09/2022.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionaListVM: TransactionListViewModel
    
//    var demoData: [Double] = [8, 2, 4, 6, 12, 9, 2, 10]
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment: .leading, spacing: 24) {
//                    MARK: Title
                    Text("Overview") 
                        .font(.title2)
                        .bold()
//                     MARK: Charts
                   
                    let data = transactionaListVM.accumulateTransactions()
                    
                    if !data.isEmpty {
                        let totalExpenses =  data.last?.sum ?? 0
                        CardView {
                            VStack(alignment: .leading)   {
                                ChartLabel(totalExpenses.formatted(.currency(code: "USD")), type: .title, format: "$%.02f")
                               


                                BarChart()
                               
                                
                              
                            }
                            .background(Color.systemBackground)
                        }
                        .data(data.map({ $0.sum}))
                                .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                        
                            .frame(height: 300)
                    }
                   
                         
                
                    
//                    MARK: Transaction List
                    RecentTransationList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
//                MARK: Notification Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                    
                }
            }
        }
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}


struct ContentView_Previews: PreviewProvider {
    static let transactionlistVM: TransactionListViewModel = {
         let transactionlistVM = TransactionListViewModel()
        transactionlistVM.transactions = transactionListPreviewData
        return transactionlistVM
    }()
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
        .environmentObject(transactionlistVM)
    }
} 
