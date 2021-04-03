//
//  CategoryRealm.swift
//  Todoey
//
//  Created by Sela Shabtai on 24/12/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRealm : Object {
    @objc dynamic var name : String = "";
    @objc dynamic var age : Int = 0;
    @objc dynamic var cellColor : String = "#FFFFFF"
    let items = List<ItemRealm>();
}
 
