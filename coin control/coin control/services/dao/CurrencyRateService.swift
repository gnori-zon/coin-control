//
//  CurrencyRateService.swift
//  coin control
//
//  Created by Stepan Konashenko on 08.11.2023.
//

import Foundation

public protocol CurrencyRateServiceProtocol {
    
    func updateAndFindLast(for tileEntity: CurrencyRateTileSettingsEntity) -> CurrencyRateProtocol?
}

public struct CurrencyRateService: CurrencyRateServiceProtocol {
    
    private let pivotCurrencyType = CurrencyType.eur
    private let key = "currency-key"
    
    private let userDefaults = UserDefaults.standard
    private let currencyRateParser: CurrencyRateParserProtocol = CurrencyRateParser(converter: CurrencyRateResponseConverter(), requestSender: HttpRequestSender())

    public func updateAndFindLast(for tileEntity: CurrencyRateTileSettingsEntity) -> CurrencyRateProtocol? {
    
        guard var pivotCurrencyRates = userDefaults.getPivotCurrencyRates(by: key) else {
            updateCurrencyRate(for: tileEntity)
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
    
    
    private func updateCurrencyRate(for tileEntity: CurrencyRateTileSettingsEntity) {
        
        Task.init(priority: .utility) {
            let target = tileEntity.targetCurrencyType
            var ratioCurrencyTypes = tileEntity.selectedCurrencies.filter { $0 != pivotCurrencyType }
            
            if target != pivotCurrencyType {
                ratioCurrencyTypes.append(tileEntity.targetCurrencyType)
            }
            
            await currencyRateParser.tryParse(target: pivotCurrencyType, ratioCurrencyTypes: ratioCurrencyTypes) { currencyRate in
                // TODO: - (1) notify success by tile id and save to userDefaults (2) added temporal data from userDefaults
                print(currencyRate)
                userDefaults.addAll(currencyRate.ratioCurrencies, for: key)
            }
        }
    }
}

// MARK: - UserDefaults

fileprivate extension UserDefaults {
    
    func getPivotCurrencyRates(by key: String) -> [CurrencyType: Decimal]? {
        
        guard let data = self.value(forKey: key) as? Data else {
            return nil
        }
        
        return try? PropertyListDecoder().decode([CurrencyType: Decimal].self, from: data)
    }
    
    func addAll(_ ratioCurrencies: [RatioCurrency], for key: String) {
        
        var existCurrencyRates = getPivotCurrencyRates(by: key) ?? [:]
        ratioCurrencies.forEach { existCurrencyRates[$0.type] = $0.value }
        
        if let data = try? PropertyListEncoder().encode(existCurrencyRates) {
            self.set(data, forKey: key)
        }
    }
}
