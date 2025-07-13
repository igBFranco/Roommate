//
//  RoommateApp.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import SwiftUI

@main
struct RoommateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
                    TabView {
                        NavigationView {
                            CalendarView(viewModel: CalendarViewModel(service: AppContainer.shared.reservationService))
                        }
                        .tabItem {
                            Label("Reservas", systemImage: "calendar")
                        }

                        NavigationView {
                            MyReservationsView(viewModel: CalendarViewModel(service: AppContainer.shared.reservationService))
                        }
                        .tabItem {
                            Label("Minhas Reservas", systemImage: "list.bullet")
                        }
                        NavigationView {
                            AddRoomView(
                                viewModel: AddRoomViewModel(context: persistenceController.viewContext)
                            )
                        }
                        .tabItem {
                            Label("Salas", systemImage: "play.house")
                        }
                    }
                }
    }
}
