//
//  Category.swift
//  Todoey
//
//  Created by Francesco Collamati on 12/11/2018.
//  Copyright © 2018 Francesco Collamati. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic	var name : String = ""
	let items = List<Item>()
}
