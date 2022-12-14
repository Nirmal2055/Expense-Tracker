//
//  TransactionListViewModel.swift
//  ExpenseTracker
//
//  Created by Nirmal Koirala on 02/09/2022.
//

import Foundation
import Combine
import Collections 
 
typealias TransactionGroup = OrderedDictionary<String, [Transaction]>

struct TransactionPrefixSum {
    let date: String
    let sum: Double
}
 
 
final class TransactionListViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        getTransactions()
    }
    
    func getTransactions() {
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
             print("Invalid URl")
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap {(data, response) -> Data in 
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion  in
                switch completion {
                case.failure(let error):
                    print("Error fetching Transactions:", error.localizedDescription)
                case.finished:
                    print("Finished fetching transactions")
                }
            } receiveValue: { [weak self] result in
                self?.transactions = result
                
            } 
            .store (in: &cancellables)
    }
    func groupTransactionsByMonth() -> TransactionGroup {
        guard !transactions.isEmpty else { return [:] }
        
       let groupTransactions = TransactionGroup(grouping: transactions) { $0.month }
        return groupTransactions
    }
    func accumulateTransactions () ->  [TransactionPrefixSum] {
        print("Accumulate Transactions")
        guard !transactions.isEmpty else { return [] }
        
        
        let today = "02/03/2022".dateParsed() // Date()
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        var sum: Double = .zero
        var cumulativeSum: [TransactionPrefixSum] = []
         
        
        for date in stride(from: dateInterval.start, to: today, by: 60 * 60 * 24) {
            let dailyExpenses = transactions.filter { $0.dateParsed == date &&  $0.isExpense }
            let dailyTotal = dailyExpenses.reduce(0) {$0 - $1.signedAmount }
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            
            let prefixSum = TransactionPrefixSum(date: date.formatted(), sum: dailyTotal)
            cumulativeSum.append(prefixSum)
            print(date.formatted(), "dailyTotal:", dailyTotal, "sum:", sum )
        } 
        return cumulativeSum
    }
        
}
  
