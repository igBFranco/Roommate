//
//  EntityExtensions.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 08/07/25.
//

import Foundation
import CoreData

extension RoomEntity {
    func toRoom() -> Room {
        Room(id: self.id ?? UUID(), name: self.name ?? "Sem nome")
    }
}

extension ReservationEntity {
    func toReservation() -> Reservation {
        Reservation(
            id: self.id ?? UUID(),
            room: room?.toRoom() ?? Room(id: UUID(), name: "Sala não encontrada"),
            startTime: self.startTime ?? Date(),
            endTime: self.endTime ?? Date(),
            description: self.reservationDescription ?? ""
        )
    }
}
