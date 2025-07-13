//
//  Persistence.swift
//  Roommate
//
//  Created by Igor Bueno Franco on 11/06/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        let room = RoomEntity(context: viewContext)
        room.id = UUID()
        room.name = "Sala Preview"

        let reservation = ReservationEntity(context: viewContext)
        reservation.id = UUID()
        reservation.startTime = Date()
        reservation.endTime = Date().addingTimeInterval(3600)
        reservation.reservationDescription = "Reunião de teste"
        reservation.room = room

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Erro ao salvar preview \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Roommate")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Erro ao carregar persistência: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}
