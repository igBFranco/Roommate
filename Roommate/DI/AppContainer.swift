//
//  AppContainer.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import Foundation

final class AppContainer {
    static let shared = AppContainer()

    let persistenceController = PersistenceController.shared

    let reservationService: ReservationServiceProtocol

    private init() {
        reservationService = CoreDataReservationService(context: persistenceController.viewContext)
    }
}
