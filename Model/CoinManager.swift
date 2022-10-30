//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(error:Error)
    func didUpdateInfo(price: String, currency: String)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B74C5FC8-3B95-4B2A-AD5A-52ABF6312530"
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PKR","PLN","RON","RUB","SEK","SGD","THB","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(urlString: url)
    }
    
    func performRequest(urlString:String) {
        //        1. Create a URL
        //        2. Create a URLSession
        //        3. Give the session a task
        //        4. Start the task
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
//                    if let weather = self.parseJSON(weatherData: safeData) {
//                        self.delegate?.didUpdateWeather(self, weather)
//                    }
//                    let stringOfData = String(data: safeData, encoding: String.Encoding.utf8)
                    if let coinData = self.parseJSON(safeData) {
                        delegate?.didUpdateInfo(price: coinData.roundedRate, currency: coinData.asset_id_quote)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (_ data: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
