//
//  Sample.swift
//  UIKit+URLSession
//
//  Created by taekkim on 2022/10/18.
//

import Foundation

struct SampleItem {
    let id: Int
    let matPrice: Int
    let matName: String
    let samplePrice: Int
    let material, imageName: String
    let size: CGSize
    let thickness: Int
    let maker: String
}


// MARK: - Sample
struct NotionSample: Decodable {
    let results: [Result]
}


// MARK: - Result
struct Result: Codable {
    let properties: Properties
}

// MARK: - Properties
struct Properties: Codable {
    let matPrice: MatPrice
    let matName: ImageName
    let samplePrice: MatPrice
    let material, imageName, size: ImageName
    let thickness: MatPrice
    let maker: ImageName
    let id: IDClass

    enum CodingKeys: String, CodingKey {
        case matPrice = "mat_price"
        case matName = "mat_name"
        case samplePrice = "sample_price"
        case material, size
        case imageName = "image_name"
        case thickness, maker, id
    }
}

// MARK: - IDClass
struct IDClass: Codable {
    let title: [Title]
}

// MARK: - Title
struct Title: Codable {
    let plainText: String

    enum CodingKeys: String, CodingKey {
        case plainText = "plain_text"
    }
}
// MARK: - ImageName
struct ImageName: Codable {
    let richText: [Title]

    enum CodingKeys: String, CodingKey {
        case richText = "rich_text"
    }
}

// MARK: - MatPrice
struct MatPrice: Codable {
    let number: Double
}


