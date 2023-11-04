//
//  TileViewSetupCollectorProtocol.swift
//  coin control
//
//  Created by Stepan Konashenko on 02.11.2023.
//

public protocol TileViewSetupCollectorProtocol {
    associatedtype TileSetting: TileSettingsProtocol
    
    func collect(for tileSetting: TileSetting) -> () -> any TileProtocol
}
