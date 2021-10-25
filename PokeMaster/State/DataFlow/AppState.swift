//
//  AppState.swift
//  PokeMaster
//
//  Created by Wang Wei on 2019/08/21.
//  Copyright © 2019 OneV's Den. All rights reserved.
//
import os.log

import Foundation
import Combine

import MapKit
import CoreLocation
import CoreBluetooth

struct AppState {
    var pokemonList = PokemonList()
    var map = Map()
    var settings = Settings()
    var switchPokemon = SwitchPokemon()
    var mainTab = MainTab()
}

extension AppState {
    struct Settings {

        enum Sorting: CaseIterable {
            case id, name, color, favorite
        }

        enum AccountBehavior: CaseIterable {
            case register, login
        }

        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""

            var isEmailValid: AnyPublisher<Bool, Never> {

                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map { $0 == .login }
                let remoteVerify = $email
                    .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }
                return Publishers.CombineLatest3(
                        emailLocalValid, canSkipRemoteVerify, remoteVerify
                    )
                    .map { $0 && ($1 || $2) }
                    .eraseToAnyPublisher()
            }

            var isValid: AnyPublisher<Bool, Never> {
                isEmailValid
                    .combineLatest($accountBehavior, $password, $verifyPassword)
                    .map { validEmail, accountBehavior, password, verifyPassword -> Bool in
                        guard validEmail && !password.isEmpty else {
                            return false
                        }
                        switch accountBehavior {
                        case .login:
                            return true
                        case .register:
                            return password == verifyPassword
                        }
                    }
                    .eraseToAnyPublisher()
            }
        }

        var checker = AccountChecker()

        var isValid: Bool = false
        var isEmailValid: Bool = false

        var showEnglishName = true
        var showFavoriteOnly = false
        var sorting = Sorting.id

        var registerRequesting = false
        var loginRequesting = false

        var showingAccountBehaviorIndicator: Bool { registerRequesting || loginRequesting }

        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?

        var loginError: AppError?
    }
}

extension AppState {
    struct PokemonList {

        struct SelectionState {
            var expandingIndex: Int? = nil
            var panelIndex: Int? = nil
            var panelPresented = false
            var radarProgress: Double = 0
            var radarShouldAnimate = true

            func isExpanding(_ id: Int) -> Bool {
                expandingIndex == id
            }
        }

//        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        var pokemons: [Int: PokemonViewModel]?

//        @FileStorage(directory: .cachesDirectory, fileName: "abilities.json")
        var abilities: [Int: AbilityViewModel]?

        func abilityViewModels(for pokemon: Pokemon) -> [AbilityViewModel]? {
            guard let abilities = abilities else { return nil }
            return pokemon.abilities.compactMap { abilities[$0.ability.url.extractedID!] }
        }

        var loadingPokemons = false
        var pokemonsLoadingError: AppError?

        var selectionState = SelectionState()
        var favoriteError: AppError?

        var searchText = ""

        var isSFViewActive = false

        func displayPokemons(with settings: Settings) -> [PokemonViewModel] {

            func isFavorite(_ pokemon: PokemonViewModel) -> Bool {
                guard let user = settings.loginUser else { return false }
                return user.isFavoritePokemon(id: pokemon.id)
            }

            func containsSearchText(_ pokemon: PokemonViewModel) -> Bool {
                guard !searchText.isEmpty else {
                    return true
                }
                return pokemon.name.contains(searchText) ||
                       pokemon.nameEN.lowercased().contains(searchText.lowercased())
            }

            guard let pokemons = pokemons else {
                return []
            }

            let sortFunc: (PokemonViewModel, PokemonViewModel) -> Bool
            switch settings.sorting {
            case .id:
                sortFunc = { $0.id < $1.id }
            case .name:
                sortFunc = { $0.nameEN < $1.nameEN }
            case .color:
                sortFunc = {
                    $0.species.color.name.rawValue < $1.species.color.name.rawValue
                }
            case .favorite:
                sortFunc = { p1, p2 in
                    switch (isFavorite(p1), isFavorite(p2)) {
                    case (true, true): return p1.id < p2.id
                    case (false, false): return p1.id < p2.id
                    case (true, false): return true
                    case (false, true): return false
                    }
                }
            }

            var filterFuncs: [(PokemonViewModel) -> Bool] = []
            filterFuncs.append(containsSearchText)
            if settings.showFavoriteOnly {
                filterFuncs.append(isFavorite)
            }

            let filterFunc = filterFuncs.reduce({ _ in true}) { r, next in
                return { pokemon in
                    r(pokemon) && next(pokemon)
                }
            }

            return pokemons.values
                .filter(filterFunc)
                .sorted(by: sortFunc)
        }
    }
}

extension AppState {
    class Map: NSObject, CLLocationManagerDelegate{
        
        struct AnnotatedItem: Identifiable{
            let id = UUID()
            var pokemonID: Int
            var coordinate: CLLocationCoordinate2D
        }
        
        var locationManager: CLLocationManager?
        var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.611883, longitude: 118.315689), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        var wildPokemon = [
            AnnotatedItem(pokemonID: 1, coordinate: .init(latitude: 24.62, longitude: 118.32)),
            AnnotatedItem(pokemonID: 5, coordinate: .init(latitude: 24.59, longitude: 118.29)),
            AnnotatedItem(pokemonID: 9, coordinate: .init(latitude: 24.61, longitude: 118.33)),
            AnnotatedItem(pokemonID: 10, coordinate: .init(latitude: 24.65, longitude: 118.35)),
            AnnotatedItem(pokemonID: 30, coordinate: .init(latitude: 25.65, longitude: 119.35)),
        ]
                
        func checkIfLocationServiceIsEnabled(){
            if CLLocationManager.locationServicesEnabled(){
                locationManager = CLLocationManager()
                locationManager!.delegate = self
                //                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            }else{
                print("Alert location unable")
            }
        }
        
        private func checkLocationAuthorization(){
            guard let locationManager = locationManager else {
                return
            }
            
            switch locationManager.authorizationStatus{
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                print("alert @.restricted")
            case .denied:
                print("alert @.denied")
            case .authorizedAlways, .authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        }
        
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
            checkLocationAuthorization()
        }
    }
}

extension AppState{
    struct SwitchPokemon{
        class Receiver{
            @Published var isSwitchedOn = false
            @Published var switchablePoke: [Int] = []
            
            var centralManager = BLECentralManager()
        }
        
        class Sender{
            @Published var switchablePoke: [Int] = []
            @Published var chosenPokeID = -1

            var peripheralManager = BLEPeripheralManager()
        }
        
        var receiver = Receiver()
        var sender = Sender()
    }
}

extension AppState {
    struct MainTab {
        enum Index: Hashable {
            case list, map, switchPoke, settings
        }
        var selection: Index = .list
    }
}
