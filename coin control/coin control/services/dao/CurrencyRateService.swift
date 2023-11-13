//
//  CurrencyRateService.swift
//  coin control
//
//  Created by Stepan Konashenko on 08.11.2023.
//

import Foundation

public protocol CurrencyRateServiceProtocol {
    
    func findLast(for tileEntity: CurrencyRateTileSettingsEntity) -> CurrencyRateProtocol?
    func updateCurrencyRate(for tileEntity: CurrencyRateTileSettingsEntity, onlyIfNeeded: Bool)
}

public final class CurrencyRateService: CurrencyRateServiceProtocol {
    
    private let pivotCurrencyType = CurrencyType.eur
    private let currencyKey = "currency-key"
    private let lastUpdateKey = "last-update-key"
    
    private let userDefaults = UserDefaults.standard
    private let currencyRateParser: CurrencyRateParserProtocol = CurrencyRateParser(converter: CurrencyRateResponseConverter(), requestSender: HttpRequestSender())
    
    public func findLast(for tileEntity: CurrencyRateTileSettingsEntity) -> CurrencyRateProtocol? {
        
        guard let currencyRatesByPivot = userDefaults.getPivotCurrencyRates(by: currencyKey) else {
            return nil
        }
        
        let target = tileEntity.targetCurrencyType
        let ratioCurrencies: [RatioCurrency] = tileEntity.selectedCurrencies
            .toRatioCurrencies(by: target, pivot: pivotCurrencyType, with: currencyRatesByPivot)
        
        return CurrencyRate(date: Date(), targetCurrencyType: target, ratioCurrencies: ratioCurrencies)
    }
    
    public func updateCurrencyRate(for tileEntity: CurrencyRateTileSettingsEntity, onlyIfNeeded: Bool) {
        
        if (!onlyIfNeeded || currencyRateIsShouldUpdate()) {
            
            Task.init(priority: .utility) {
                let target = tileEntity.targetCurrencyType
                var ratioCurrencyTypes = tileEntity.selectedCurrencies.filter { $0 != pivotCurrencyType }
                
                if target != pivotCurrencyType {
                    ratioCurrencyTypes.append(tileEntity.targetCurrencyType)
                }
                
                await currencyRateParser.tryParse(target: pivotCurrencyType, ratioCurrencyTypes: ratioCurrencyTypes) { [weak self] currencyRate in
                    
                    guard let self else {
                        print ("DEBUG: bad try parser currencyRateService is nil")
                        return
                    }
                    
                    print(currencyRate)
                    userDefaults.addAllCurrencyRates(currencyRate.ratioCurrencies, for: self.currencyKey)
                    userDefaults.setLastUpdateDate(Date.now, for: self.lastUpdateKey)
                    
                    NotificationCenter.default.post(name: .didUpdateCurrencyRates, object: ratioCurrencyTypes)
                }
            }
        }
    }
    
    private func currencyRateIsShouldUpdate() -> Bool {
        
        guard let lastUpdateDate = userDefaults.getLastUpdateDate(by: lastUpdateKey) else {
            return true
        }
        
        let lastUpdateComponents = Calendar.current.dateComponents([.day, .year, .month], from: lastUpdateDate)
        let currentComponents = Calendar.current.dateComponents([.day, .year, .month], from: Date.now)
        
        return lastUpdateComponents != currentComponents
    }
}

// MARK: - UserDefaults

fileprivate extension UserDefaults {
    
    func getLastUpdateDate(by key: String) -> Date? {
        return object(forKey: key) as? Date
    }
    
    func setLastUpdateDate(_ date: Date, for key: String) {
        set(date, forKey: key)
    }
    
    func getPivotCurrencyRates(by key: String) -> [CurrencyType: Decimal]? {
        
        guard let data = value(forKey: key) as? Data else {
            return nil
        }
        
        return try? PropertyListDecoder().decode([CurrencyType: Decimal].self, from: data)
    }
    
    func addAllCurrencyRates(_ ratioCurrencies: [RatioCurrency], for key: String) {
        
        var existCurrencyRates = getPivotCurrencyRates(by: key) ?? [:]
        ratioCurrencies.forEach { existCurrencyRates[$0.type] = $0.value }
        
        if let data = try? PropertyListEncoder().encode(existCurrencyRates) {
            set(data, forKey: key)
        }
    }
}

fileprivate extension Array where Element == CurrencyType {
    
    /**
        adjustment currency rates by target
     
     ```
      if  target != pivot {
         // adjustment currency rates by target and then mapping
      } else { // ~ target == pivot
         // simple mapping
      }
     ```
    */
    func toRatioCurrencies(
        by target: CurrencyType,
        pivot: CurrencyType,
        with currencyRatesByPivot: [CurrencyType: Decimal]
    ) -> [RatioCurrency] {
        
        if  target != pivot,
           let divider = currencyRatesByPivot[target] {
            
            return compactMap { type in
                
                guard let value = currencyRatesByPivot[type] else { return nil }
                
                return type == pivot
                    ? RatioCurrency(type: type, value: 1 / divider)
                    : RatioCurrency(type: type, value: value / divider)
            }
        } else {
            
            return compactMap { type in
                
                guard let value = currencyRatesByPivot[type] else { return nil}
                
                return RatioCurrency(type: type, value: value)
            }
        }
    }
}
