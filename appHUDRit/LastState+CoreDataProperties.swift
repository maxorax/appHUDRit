//
//  LastState+CoreDataProperties.swift
//  appHUDRit
//
//  Created by Maxorax on 25.03.2021.
//
//

import Foundation
import CoreData


extension LastState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastState> {
        return NSFetchRequest<LastState>(entityName: "LastState")
    }

    @NSManaged public var mSys: String?
    @NSManaged public var distance: Double
    @NSManaged public var koef: Double
    @NSManaged public var isHUDOn: Bool

}

extension LastState : Identifiable {

}
