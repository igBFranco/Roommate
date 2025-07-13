//
//  MockReservationService.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 13/07/25.
//

import Foundation

class MockReservationService: ReservationServiceProtocol {
    var shouldConflict = false
    private(set) var reservations: [Reservation] = []
    
    func getAvailableRooms() -> [Room] { return [] }
    
    func getReservations() -> [Reservation] { return reservations }

    func addReservation(_ reservation: Reservation) throws {
        if shouldConflict {
            throw ReservationError.conflict
        }
        reservations.append(reservation)
    }

    func removeReservation(_ reservation: Reservation) throws {
        reservations.removeAll { $0.id == reservation.id }
    }
}
