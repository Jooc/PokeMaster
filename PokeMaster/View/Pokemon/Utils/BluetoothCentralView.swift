////
////  BluetoothCentralView.swift
////  PokeMaster
////
////  Created by 齐旭晨 on 2021/10/25.
////  Copyright © 2021 OneV's Den. All rights reserved.
////
//
//import Foundation
//import SwiftUI
//
//import CoreBluetooth
//
//struct BluetoothCentralView: UIViewControllerRepresentable{
//    var switchablePokemonIDs: [Int] = []
//    
//    func makeUIViewController(context: UIViewControllerRepresentableContext<BluetoothCentralView>) -> CentralViewController {
//        let controller = CentralViewController()
//        return controller
//    }
//    
//    func updateUIViewController(_ uiViewController: CentralViewController, context: UIViewControllerRepresentableContext<BluetoothCentralView>) {
//        
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, CBCentralManagerDelegate{
//        func centralManagerDidUpdateState(_ central: CBCentralManager) {
//            <#code#>
//        }
//        
//        let parent: BluetoothCentralView
//        
//        init(_ parent: BluetoothCentralView){
//            self.parent = parent
//        }
//        
//    }
//    
//    
//}
