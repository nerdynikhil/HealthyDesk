import Foundation
import CoreData

@objc(WaterEntry)
public class WaterEntry: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var amount: Double // in ml
    @NSManaged public var timestamp: Date
    @NSManaged public var type: String // glass, bottle, custom
}

extension WaterEntry {
    static func create(in context: NSManagedObjectContext, amount: Double, type: String) {
        let entry = WaterEntry(context: context)
        entry.id = UUID()
        entry.amount = amount
        entry.timestamp = Date()
        entry.type = type
        try? context.save()
    }
} 