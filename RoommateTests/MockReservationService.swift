//
//  MockReservationService.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 13/07/25.
//

import Foundation

class MockReservationService: ReservationServiceProtocol {
    var reservations: [Reservation] = []
    var rooms: [Room] = [
        Room(id: UUID(), name: "Sala Mock 1"),
        Room(id: UUID(), name: "Sala Mock 2")
    ]
    var shouldThrowConflictError = false

    func getAvailableRooms() -> [Room] {
        return rooms
    }

    func getReservations() -> [Reservation] {
        return reservations
    }

    func addReservation(_ reservation: Reservation) throws {
        if shouldThrowConflictError {
            throw ReservationError.conflict
        }
        
        let isConflict = reservations.contains {
            $0.room == reservation.room &&
            $0.startTime < reservation.endTime &&
            reservation.startTime < $0.endTime
        }

        if isConflict {
            throw ReservationError.conflict
        }
        
        reservations.append(reservation)
    }

    func removeReservation(_ reservation: Reservation) throws {
        reservations.removeAll { $0.id == reservation.id }
    }
}
