//
//  Assessment
//
//  Created by Christopher Nassar on 07/08/20.
//

import Foundation

struct Photo : Codable {
	let id : String?
	let owner : String?
	let secret : String?
	let server : String?
	let farm : Int?
	let title : String?
	let ispublic : Int?
	let isfriend : Int?
	let isfamily : Int?
    
    var photoURL: String? {
        guard let farm = farm,
              let server = server,
              let id = id,
              let secret = secret else { return nil}
        return  "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
