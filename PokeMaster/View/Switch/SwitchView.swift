//
//  SwitchView.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

enum ShowPage{
    case sender, receiver
}

struct SwitchView: View {
    @State var showPage: ShowPage? = nil
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        VStack {
            if let user = store.appState.settings.loginUser{
                ScrollView{
                    LazyHStack{
                        ForEach((user.generatePokemonIDs())){id in
                            VStack {
                                Text(String(id.id))
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .background(Color.white)
                                    .shadow(radius: 10)
                            }
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
                HStack(spacing: 50){
                    Button(action: {
                        showPage = .sender
                    }){
                        Text("Send 🤝")
                            .modifier(ButtonMoifier())
                    }
                    Button(action: {
                        showPage = .receiver
                    }){
                        Text("Receive 🤲")
                            .modifier(ButtonMoifier())
                    }
                }.padding(.bottom)
            }
        }
    }
    
    struct ButtonMoifier: ViewModifier{
        func body(content: Content) -> some View{
            content
                .frame(width: 150, height: 40, alignment: .center)
                .foregroundColor(Color.white)
                .background(Color.orange)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
        }
    }
}

struct SwitchView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchView().environmentObject(Store.sample)
    }
}
