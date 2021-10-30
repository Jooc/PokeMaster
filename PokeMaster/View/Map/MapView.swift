//
//  MapView.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import MapKit
import KingfisherSwiftUI

struct MapView: View {
    @EnvironmentObject var store: Store
    @State private var showPop = false
    @State private var rotateIndex = -1
//    @State private var rotationDisabled = false
    
    @State var chosenPokeID: Int = -1
    @State var showTooFarAlert: Bool = false
    
    var manager: MapManager{
        store.appState.mapState.manager
    }
    
    @available(iOS 15.0, *)
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $store.appState.mapState.manager.region,
                showsUserLocation: true,
//                userTrackingMode: .constant(.follow),
                annotationItems: $store.appState.mapState.wildPokemon){ item in
                    MapAnnotation(coordinate: item.coordinate.wrappedValue){
                        Button(action: {
                            if (item.coordinate.wrappedValue.distance(from: (manager.locationManager?.location)!)) < 5000{
                                self.showPop = true
                                self.chosenPokeID = item.pokemonID.wrappedValue
                            }else{
                                print("Too far")
                                self.showTooFarAlert = true
                            }
                        }){
                            Image("pokeball")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .shadow(radius: 4)
                                .rotationEffect(Angle(degrees: self.rotateIndex != 0 ? 20 : -20), anchor: UnitPoint(x: 0.5, y: 1))
                                .animation(.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.2))
                        }.alert(isPresented: $showTooFarAlert){
                            Alert(title: Text("抓捕失败"), message: Text("宝可梦超出抓捕距离"), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .onAppear {
                    store.appState.mapState.manager.checkIfLocationServiceIsEnabled()
                }
                .blur(radius: self.showPop ? 5:0)
            
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        self.store.dispatch(.addWildPokemon)
                    }){
                        VStack {
                            Image(systemName: "plus.viewfinder")
                                .font(.system(size: 15, weight: .light))
                                .foregroundColor(Color.black)
                        }
                        .frame(width: 30, height: 30)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5, x: 5, y: 5)
                        .padding()
                        .blur(radius: self.showPop ? 5:0)
                    }
                }
                Spacer()
            }
            
            catchPokemonPopView(id: self.chosenPokeID)
                .scaleEffect(self.showPop ? 1 : 0.1)
                .offset(x: 0, y: self.showPop ? 0: 500)
                .animation(.spring(response: 0.5, dampingFraction: 0.825, blendDuration: 0), value: self.showPop)
        }
        .onAppear {
            if self.rotateIndex == -1{
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    self.rotateIndex = (self.rotateIndex + 1) % 2
                }
            }
        }
    }
    
    private func  catchPokemonPopView(id: Int) -> some View {
        return
        ZStack {
            VStack(alignment: .center, spacing: 80){
                KFImage(URL(string: "https://jooc-pokemon-go.oss-cn-shenzhen.aliyuncs.com/pokemon-images/Pokemon-\(id).png")!)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                Button(action: {
                    self.showPop = false
                    store.dispatch(.catchWildPokemon(pokemonID: id))
                }){
                    Text("Pokemon, Get★Daze!")
                }
            }
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        //                        self.store.dispatch(.addWildPokemon(5))
                        self.showPop = false
                    }){
                        VStack {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 15, weight: .light))
                                .foregroundColor(Color.black)
                        }
                        .frame(width: 30, height: 30)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding()
                    }
                }
                Spacer()
            }
        }
        .frame(width: 200, height: 300)
        .background(BlurView(style: .systemMaterial))
        .background(Color.orange)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(radius: 20)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}


