//
//  Assessment
//
//  Created by Christopher Nassar on 07/08/20.
//

import Foundation

struct Photos : Codable {
	let page : Int?
	let pages : Int?
	let perpage : Int?
	let total : Int?
	let photo : [Photo]?
}
