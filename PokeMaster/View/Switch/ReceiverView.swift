//
//  ReceiverView.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct ReceiverView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        Text("Hello")
//        Text(store.appState.switchPokemon.receiver.centralManager)
    }
}

struct ReceiverView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverView()
    }
}
