//
//  CoreDataReservationService.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 08/07/25.
//

import CoreData

class CoreDataReservationService: ReservationServiceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getAvailableRooms() -> [Room] {
        let fetchRequest: NSFetchRequest<RoomEntity> = RoomEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { $0.toRoom() }
        } catch {
            print("Erro ao buscar salas: \(error)")
            return []
        }
    }

    func getReservations() -> [Reservation] {
        let fetchRequest: NSFetchRequest<ReservationEntity> = ReservationEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { $0.toReservation() }
        } catch {
            print("Erro ao buscar reservas: \(error)")
            return []
        }
    }

    func addReservation(_ reservation: Reservation) throws {
        let conflicts = getReservations().contains {
            $0.room == reservation.room &&
            $0.startTime < reservation.endTime &&
            reservation.startTime < $0.endTime
        }
        if conflicts {
            throw ReservationError.conflict
        }

        let entity = ReservationEntity(context: context)
        entity.id = reservation.id
        entity.startTime = reservation.startTime
        entity.endTime = reservation.endTime
        entity.reservationDescription = reservation.description

        let roomFetch: NSFetchRequest<RoomEntity> = RoomEntity.fetchRequest()
        roomFetch.predicate = NSPredicate(format: "id == %@", reservation.room.id as CVarArg)
        if let roomEntity = try context.fetch(roomFetch).first {
            entity.room = roomEntity
        } else {
            throw NSError(domain: "RoomNotFound", code: 404, userInfo: nil)
        }

        try context.save()
    }

    func removeReservation(_ reservation: Reservation) throws {
        let fetchRequest: NSFetchRequest<ReservationEntity> = ReservationEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", reservation.id as CVarArg)

        if let entity = try context.fetch(fetchRequest).first {
            context.delete(entity)
            try context.save()
        }
    }
}
