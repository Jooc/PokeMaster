//
//  SenderView.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct SenderView: View {
    @EnvironmentObject var store: Store
    
    var manager: BLEPeripheralManager {
        store.appState.switchPokemon.peripheralManager
    }
    
    let chosenPokeID: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Available Friends")
        
            Button(action: {
                manager.startScanning()
            }){
                Text("Start Scanning")
            }.modifier(ButtonMoifier())
            
            Button(action: {
                print(manager.connectedCentral)
                print("is sending pokemon...")
//                manager.sendPokemon(targetID: store.appState.switchPokemon.chosenPokeID)
            }){
                Text("Send")
            }.modifier(ButtonMoifier())
                .disabled(manager.connectedCentral == nil)
        }
    }
}

struct SenderView_Previews: PreviewProvider {
    static var previews: some View {
        SenderView(chosenPokeID: 1)
    }
}
