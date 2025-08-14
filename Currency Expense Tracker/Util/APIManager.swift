//
//  APIManager.swift
//  Currency Expense Tracker
//
//  Created by Roshan Karn on 14/08/25.
//

import Foundation

class APIManager: ObservableObject {
    static let shared = APIManager()

    @Published var exchangeRate: Double = 0.0
    @Published var lastFetched: Date?
    
    init(){
        Task {
            await self.fetchExchangeRate()
        }
    }
    
    func fetchExchangeRate() async {
        if let last = lastFetched, last.addingTimeInterval(900) > Date() {
            print("Using cached exchange rate.")
            return
        }
        
        let apiKey = "fd9cf856c8cbfcb0d9899d73492904fd"
        let urlString = "https://api.exchangeratesapi.io/v1/latest?access_key=\(apiKey)&symbols=USD,INR"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            struct Response: Codable {
                let success: Bool
                let rates: [String: Double]?
                let error: ErrorInfo?
                
                struct ErrorInfo: Codable {
                    let code: Int
                    let info: String
                }
            }
            
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            
            if let error = decoded.error {
                print("API Error: \(error.code) – \(error.info)")
                return
            }
            
            guard decoded.success, let rates = decoded.rates,
                  let usdRate = rates["USD"], let inrRate = rates["INR"] else {
                print("Missing rates in response")
                return
            }
            
            let usdToInr = inrRate / usdRate
            
            DispatchQueue.main.async {
                self.exchangeRate = usdToInr
                self.lastFetched = Date()
                print("Fetched USD→INR as \(usdToInr)")
            }
            
        } catch {
            print("Network or decoding error: \(error)")
        }
    }

}
