//
//  MapView.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/25.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var store: Store
    @State private var showPop = false
    
    @available(iOS 15.0, *)
    var body: some View {
        ZStack {
            Map(
                coordinateRegion: $store.appState.map.region,
                showsUserLocation: true,
                //            userTrackingMode: .constant(.follow),
                annotationItems: $store.appState.map.wildPokemon ){ item in
                    MapAnnotation(coordinate: item.coordinate.wrappedValue){
                        //                    WildPokemonMarker()
                        Button(action: {
                            if (item.coordinate.wrappedValue.distance(from: (store.appState.map.locationManager?.location)!)) < 10000000{
                                self.showPop = true
                                print("Pokemon, Get★Daze!")
                            }else{
                                print("Too far")
                            }
                        }){
                            Image("pokeball")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .shadow(radius: 4)
                        }
                    }
                }
                .ignoresSafeArea()
                .onAppear {
                    store.appState.map.checkIfLocationServiceIsEnabled()
                }
                .blur(radius: self.showPop ? 5:0)
            //            if $showPopUp.wrappedValue {
            catchPokemonPopView()
                .scaleEffect(self.showPop ? 1 : 0.1)
                .offset(x: 0, y: self.showPop ? 0: 500)
                .animation(.spring(response: 0.5, dampingFraction: 0.825, blendDuration: 0), value: self.showPop)
            //            }
        }
    }
    
    private func  catchPokemonPopView() -> some View {
        let id = Int(arc4random_uniform(10) + 1)
        return VStack(alignment: .center, spacing: 80){
            Image("Pokemon-\(id)")
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
            Button(action: {
                self.showPop = false
                store.dispatch(.addPokemon(pokemonID: id))
            }){
                Text("Pokemon, Get★Daze!")
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

extension CLLocationCoordinate2D{
    func distance(from origin: CLLocation) -> CLLocationDistance{
        return CLLocation(latitude: self.latitude, longitude: self.longitude).distance(from: origin)
    }
}
