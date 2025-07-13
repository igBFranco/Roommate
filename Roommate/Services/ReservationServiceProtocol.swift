//
//  ReservationServiceProtocol.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import Foundation

protocol ReservationServiceProtocol {
    func getAvailableRooms() -> [Room]
    func getReservations() -> [Reservation]
    func addReservation(_ reservation: Reservation) throws
    func removeReservation(_ reservation: Reservation) throws

}
