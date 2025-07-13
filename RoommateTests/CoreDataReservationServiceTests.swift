//
//  CoreDataReservationServiceTests.swift
//  RoommateTests
//
//  Created by Igor Bueno Franco on 13/07/25.
//
import XCTest
import CoreData
@testable import Roommate

class CoreDataReservationServiceTests: XCTestCase {

    var service: CoreDataReservationService!
    var context: NSManagedObjectContext!
    var testRoom: Room!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let persistenceController = PersistenceController(inMemory: true)
        context = persistenceController.container.viewContext
        service = CoreDataReservationService(context: context)

        let roomEntity = RoomEntity(context: context)
        roomEntity.id = UUID()
        roomEntity.name = "Sala Teste CoreData"
        testRoom = roomEntity.toRoom()
        try context.save()
    }

    override func tearDown() {
        service = nil
        context = nil
        super.tearDown()
    }

    // TESTE 5: Garante que o serviço impede reservas conflitantes.
    func testAddReservation_WhenConflictExists_ShouldThrowError() throws {
        let now = Date()
        let reservation1 = Reservation(
            id: UUID(),
            room: testRoom,
            startTime: now,
            endTime: now.addingTimeInterval(3600),
            description: "Primeira Reserva"
        )
        
        let conflictingReservation = Reservation(
            id: UUID(),
            room: testRoom,
            startTime: now.addingTimeInterval(1800),
            endTime: now.addingTimeInterval(5400),
            description: "Reserva Conflitante"
        )

        try service.addReservation(reservation1)

        // Verifica se adicionar a segunda (conflitante) lança o erro esperado
        XCTAssertThrowsError(try service.addReservation(conflictingReservation)) { error in
            XCTAssertEqual(error as? ReservationError, ReservationError.conflict, "O erro lançado deveria ser .conflict")
        }
    }
}
