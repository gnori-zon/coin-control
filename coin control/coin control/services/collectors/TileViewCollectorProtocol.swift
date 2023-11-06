//
//  TileViewCollectorProtocol.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public protocol TileViewCollectorProtocol {
    associatedtype TileSetting: TileSettingsEntityProtocol
    
    func collectSetups(for tileSetting: TileSetting) -> () -> any TileProtocol
    func collectReplacer(for tileSetting: TileSetting) -> (any TileProtocol) -> Void
}
