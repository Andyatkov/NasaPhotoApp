//
//  MockData.swift
//  NasaPhotoApp
//
//  Created by ADyatkov on 25.11.2021.
//

import Foundation

class MockData {
    
    static let shared = MockData()
    
    private(set) var model = MarsForecastResponse(photos: [])
    
    func setModel() {
        var photos = [MarsForecastResponse.Photo]()
        for index in 0..<10_000 {
            photos.append(MarsForecastResponse.Photo(
                id: index,
                sol: 0,
                imgageURL: "http://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/01000/opgs/edr/fcam/FLB_486265257EDR_F0481570FHAZ00323M_.JPG",
                earthDate: "11-09-2021"))
        }
        self.model = MarsForecastResponse(photos: photos)
    }
}
