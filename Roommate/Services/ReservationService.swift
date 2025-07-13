//
//  ReservationService.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import Foundation


enum ReservationError: Error {
    case conflict
}

class ReservationService: ReservationServiceProtocol {
    private var reservations: [Reservation] = []

    func getAvailableRooms() -> [Room] {
        return [
            Room(id: UUID(), name: "Sala 101"),
            Room(id: UUID(), name: "Sala 102")
        ]
    }

    func getReservations() -> [Reservation] {
        reservations
    }

    func addReservation(_ reservation: Reservation) throws {
        let overlapping = reservations.contains {
            $0.room == reservation.room &&
            $0.startTime < reservation.endTime &&
            reservation.startTime < $0.endTime
        }

        if overlapping {
            throw ReservationError.conflict
        }

        reservations.append(reservation)
    }
    
    func removeReservation(_ reservation: Reservation) throws {
        reservations.removeAll { $0.id == reservation.id }
    }

}
