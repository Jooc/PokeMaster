//
//  SwitchView.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

enum ShowPage{
    case sender, receiver
}

struct SwitchView: View {
//    @State var showPage: ShowPage? = nil
    @State var showSender: Bool = false
    @State var showReceiver: Bool = false
    
    @EnvironmentObject var store: Store
    
    var chosenPokeID: Int{
        self.store.appState.switchPokemon.chosenPokeID
    }
    
    var pokemonList: AppState.PokemonList { store.appState.pokemonList }
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        VStack {
            if let _ = store.appState.settings.loginUser{
                ScrollView{
                    LazyVGrid(columns: columns){
                        ForEach(pokemonList.displayPokemons(with: store.appState.settings)){pokemon in
                            VStack{
                                KFImage(pokemon.iconImageURL )
                                    .resizable()
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .padding()
                            }
                            .frame(width: 80, height: 100, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(chosenPokeID == pokemon.id ? Color.red.opacity(0.8) : Color.white)
                                    .shadow(radius: 5)
                            )
                            .padding()
                            .onTapGesture {
                                self.store.appState.switchPokemon.chosenPokeID = pokemon.id
                            }
                            .animation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0))
                        }
                    }.padding()
                }
            }
            
            // Status goes here
//            if store.appState.switchPokemon.isSwitchedOn{
//                Text("Bluetooth is switched on")
//                    .foregroundColor(.green)
//            }else{
//                Text("Bluetooth is NOT switched on")
//                    .foregroundColor(.red)
//            }
            
            VStack {
                HStack(spacing: 20){
                    Button(action: {
                        showSender = true
                    }){
                        Text("Send 🤝")
                            .modifier(ButtonMoifier())
                    }.sheet(isPresented: $showSender){
                        SenderView().environmentObject(store)
                    }
                    
                    Button(action: {
                        showReceiver = true
                    }){
                        Text("Receive 🤲")
                            .modifier(ButtonMoifier())
                    }.sheet(isPresented: $showReceiver){
                        ReceiverView().environmentObject(store)
                    }
                }.padding(.bottom)
            }
        }
    }
}

struct ButtonMoifier: ViewModifier{
    func body(content: Content) -> some View{
        content
            .frame(width: 150, height: 60, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.orange)
            )
            .foregroundColor(Color.white)
            .shadow(radius: 10)
    }
}

struct SwitchView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchView().environmentObject(Store.sample)
    }
}
