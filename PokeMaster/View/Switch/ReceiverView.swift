//
//  ReceiverView.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import CoreBluetooth

extension CBPeripheral: Identifiable{ }

struct ReceiverView: View {
    @EnvironmentObject var store: Store
//    @State var c = 0
    
    var manager: BLECentralManager{
        store.appState.switchPokemon.centralManager
    }
    
    var body: some View {
        VStack {
//            Text(manager.discoveredPeripheral?.name ?? "")
//            Text(String(manager.availableDevice.count))
//            Text(String(self.store.appState.switchPokemon.receiver.centralManager.availableDevice.count))
//            Text(String(self.store.appState.switchPokemon.receiver.centralManager.scannerCounter))
//            Text(String(self.store.appState.switchPokemon.receiver.switchablePoke.count))
//            Text(String(self.store.appState.switchPokemon.counter))

//            Text(String(self.c))
//            List{
//                ForEach(self.store.appState.switchPokemon.receiver.centralManager.availableDevice){device in
//                    Text(device.name ?? " ")
//                }
//            }
//            
            Button(action: {
                manager.startScanning()
//                self.store.appState.switchPokemon.receiver.switchablePoke.append(1)
                self.store.appState.switchPokemon.counter+=1
//                c += 1
            }){
                Text("Start Scanning")
                    .modifier(ButtonMoifier())
            }
                .padding(.bottom)
        }
//        Text(store.appState.switchPokemon.receiver.centralManager)
    }
}

struct ReceiverView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverView().environmentObject(Store.sample)
    }
}
