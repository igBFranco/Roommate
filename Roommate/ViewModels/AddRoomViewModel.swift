//
//  AddRoomViewModel.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 08/07/25.
//

import Foundation
import CoreData

class AddRoomViewModel: ObservableObject {
    @Published var rooms: [Room] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchRooms()
    }

    func fetchRooms() {
        let request: NSFetchRequest<RoomEntity> = RoomEntity.fetchRequest()

        do {
            let entities = try context.fetch(request)
            self.rooms = entities.map { $0.toRoom() }
        } catch {
            print("Erro ao buscar salas: \(error)")
            self.rooms = []
        }
    }

    func addRoom(name: String) throws {
        let newRoom = RoomEntity(context: context)
        newRoom.id = UUID()
        newRoom.name = name
        try context.save()
        fetchRooms() 
    }

    func deleteRoom(_ room: Room) -> String? {
        let request: NSFetchRequest<RoomEntity> = RoomEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", room.id as CVarArg)

        do {
            if let roomEntity = try context.fetch(request).first {
                if let reservations = roomEntity.reservations, reservations.count > 0 {
                    return "A sala '\(room.name)' possui reservas e não pode ser excluída."
                }
                context.delete(roomEntity)
                try context.save()
                fetchRooms()
            }
        } catch {
            return "Erro ao deletar sala: \(error.localizedDescription)"
        }

        return nil
    }


}
