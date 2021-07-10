//
//  MobiquityTestTests.swift
//  MobiquityTestTests
//
//  Created by Christopher Nassar on 08/07/2021.
//

import XCTest
@testable import MobiquityTest

class MobiquityTestTests: XCTestCase {
    
    // Test the image cache per session if already empty
    func test_imageCache_beforeImageCall_dataEmpty(){
        CachingHelper.emptyImageCache()
        let googleImgPath = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"
        let dataCached = CachingHelper.cachedData(key: googleImgPath)
        XCTAssertNil(dataCached)
    }
    
    // Test the image cache per session if exists after fetching its data
    func test_imageAsyncCache_afterImageCall_dataValid(){
        CachingHelper.emptyImageCache()
        let googleImgPath = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png"
        UIHelper.setImageAsync(urlStr: googleImgPath, imageView: UIImageView())
        let exp = expectation(description: "Test after 5 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 5.0)
        let dataCached = CachingHelper.cachedData(key: googleImgPath)
        XCTAssertNotNil(dataCached)
    }

}
