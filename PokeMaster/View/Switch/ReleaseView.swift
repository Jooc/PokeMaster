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

struct ReleaseView: View {
    //    @State var showPage: ShowPage? = nil
    //    @State var showSender: Bool = false
    //    @State var showReceiver: Bool = false
    
    @EnvironmentObject var store: Store
    
    @State var chosenPokeIDs: [Int] = []
    @State var isAlerting: Bool = false
    
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
                                KFImage(pokemon.iconImageURL)
                                    .resizable()
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .padding()
                            }
                            .frame(width: 80, height: 100, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(chosenPokeIDs.contains(pokemon.id) ? Color.red.opacity(0.8) : Color.white)
                                    .shadow(radius: 5)
                            )
                            .padding()
                            .onTapGesture {
                                print("Switch to \(pokemon.id)")
                                if chosenPokeIDs.contains(pokemon.id){
                                    chosenPokeIDs = chosenPokeIDs.filter{
                                        $0 != pokemon.id
                                    }
                                }else{
                                    chosenPokeIDs.append(pokemon.id)
                                }
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
            
            HStack(){
                Button(action: {
                    self.isAlerting = true
                }){
                    Text("放生 🙏")
                        .modifier(ButtonMoifier())
                }.alert(isPresented: $isAlerting){
                    Alert(title: Text("确认放生吗？"),
                          message: Text("选中的宝可梦将不再属于你"),
                          primaryButton: Alert.Button.destructive(Text("确定")) {
                                store.dispatch(.releasePokemon(pokemonIDs: chosenPokeIDs))
                            },
                          secondaryButton: Alert.Button.default(Text("取消")) { //使用相同的方式，创建位于警告窗口底部的另一个选项按钮
                        //        print("No, I'm not a student.")
                            })
                }
            }.padding(.bottom)
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
        ReleaseView().environmentObject(Store.sample)
    }
}
