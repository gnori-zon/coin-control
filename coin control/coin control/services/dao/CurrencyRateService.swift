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
        
        guard let pivotCurrencyRates = userDefaults.getPivotCurrencyRates(by: currencyKey) else {
            return nil
        }

        let target = tileEntity.targetCurrencyType
        
        if target != pivotCurrencyType,
           let targetValue = pivotCurrencyRates[target]
        {
            // TODO: - should do refactored
            let divider = targetValue
            let ratioCurrencies: [RatioCurrency] = tileEntity.selectedCurrencies.compactMap { selectedCurrencyType in
                
                let type = selectedCurrencyType
                if type == pivotCurrencyType {
                    return RatioCurrency(type: type, value: 1 / divider)
                } else {
                    guard let selectedTypeValue = pivotCurrencyRates[type] else {
                        return nil
                    }
                    
                    let value = selectedTypeValue / divider
                    
                    return RatioCurrency(type: type, value: value)
                }
            }
            
            return CurrencyRate(date: Date(), targetCurrencyType: target, ratioCurrencies: ratioCurrencies)
        } else {
            
            let target = tileEntity.targetCurrencyType
            let ratioCurrencies: [RatioCurrency] = tileEntity.selectedCurrencies.compactMap { selectedCurrencyType in
                
                let type = selectedCurrencyType
                
                guard let value = pivotCurrencyRates[type] else {
                    return nil
                }
                
                return RatioCurrency(type: type, value: value)
            }
            
            return CurrencyRate(date: Date(), targetCurrencyType: target, ratioCurrencies: ratioCurrencies)
        }
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
        
        return self.object(forKey: key) as? Date
    }
    
    func setLastUpdateDate(_ date: Date, for key: String) {
        
        self.set(date, forKey: key)
    }
    
    func getPivotCurrencyRates(by key: String) -> [CurrencyType: Decimal]? {
        
        guard let data = self.value(forKey: key) as? Data else {
            return nil
        }
        
        return try? PropertyListDecoder().decode([CurrencyType: Decimal].self, from: data)
    }
    
    func addAllCurrencyRates(_ ratioCurrencies: [RatioCurrency], for key: String) {
        
        var existCurrencyRates = getPivotCurrencyRates(by: key) ?? [:]
        ratioCurrencies.forEach { existCurrencyRates[$0.type] = $0.value }
        
        if let data = try? PropertyListEncoder().encode(existCurrencyRates) {
            self.set(data, forKey: key)
        }
    }
}

// MARK: - Notification.Name

extension Notification.Name {
    static let didUpdateCurrencyRates = Notification.Name("didUpdateCurrencyRates")
}
