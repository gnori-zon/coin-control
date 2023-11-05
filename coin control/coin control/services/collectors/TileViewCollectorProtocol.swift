//
//  TileViewCollectorProtocol.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public protocol TileViewCollectorProtocol {
    associatedtype TileSetting: TileSettingsEntityProtocol
    
    func castedCollectSetups(for tileSetting: TileSetting) -> () -> any TileProtocol
    func castedCollectReplacer(for tileSetting: TileSetting) -> (any TileProtocol) -> Void
    
    func collectSetups(for tileSetting: any TileSettingsEntityProtocol) -> (() -> any TileProtocol)?
    func collectReplacer(for tileSetting: any TileSettingsEntityProtocol) -> ((any TileProtocol) -> Void)?
}

public extension TileViewCollectorProtocol {
    
    func collectSetups(for tileSetting: any TileSettingsEntityProtocol) -> (() -> any TileProtocol)? {
        
        guard let castedTileSetting = tileSetting as? TileSetting else {
            print ("DEBUG: bad try casting tileSetting")
            return nil
        }
        
        return castedCollectSetups(for: castedTileSetting)
    }
    
    func collectReplacer(for tileSetting: any TileSettingsEntityProtocol) -> ((any TileProtocol) -> Void)? {
        
        guard let castedTileSetting = tileSetting as? TileSetting else {
            print ("DEBUG: bad try casting tileSetting")
            return nil
        }
        
        return castedCollectReplacer(for: castedTileSetting)
    }
}
