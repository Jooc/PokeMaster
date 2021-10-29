//
//  Pokeball.swift
//  PokeMaster
//
//  Created by 齐旭晨 on 2021/10/28.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct Pokeball: View {
    @State var rotateIndex = 0
    @State var disabled = false
    
    var body: some View {
        Button(action: {
            print("Clicked")
        }){
            Image("pokeball")
                .resizable()
                .frame(width: 100, height: 100)
                .shadow(radius: 4)
                .rotationEffect(Angle(degrees: self.rotateIndex != 0 ? 20 : -20), anchor: UnitPoint(x: 0.5, y: 1))
                .animation(.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.2))
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        self.rotateIndex = (self.rotateIndex + 1) % 2
                        if self.disabled {
                            timer.invalidate()
                        }
                    }
                }
                .onDisappear(){
                    self.disabled = true
                }
        }
    }
}

struct Pokeball_Previews: PreviewProvider {
    static var previews: some View {
        Pokeball(rotateIndex: 0, disabled: false)
    }
}
