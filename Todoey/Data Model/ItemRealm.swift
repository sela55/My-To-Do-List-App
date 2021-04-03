//
//  ItemRealm.swift
//  Todoey
//
//  Created by Sela Shabtai on 24/12/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation;
import RealmSwift;
import Realm

class ItemRealm : Object  {
    @objc dynamic var title : String = "";
    @objc dynamic var done : Bool = false;
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: CategoryRealm.self, property: "items");
}
