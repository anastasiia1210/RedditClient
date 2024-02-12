import Foundation

struct Post: Codable{
    let authorFullname: String
    let saved: Bool
    let title: String
    let downs, ups: Int
    let domain: String
    let numComments: Int
    let image: String //url of image
    
    init(from decoded: DecodedPost) throws {
      self.authorFullname = decoded.data.children.first?.data.authorFullname ?? ""
      self.saved = decoded.data.children.first?.data.saved ?? false
      self.title = decoded.data.children.first?.data.title ?? ""
      self.downs = decoded.data.children.first?.data.downs ?? 0
      self.ups = decoded.data.children.first?.data.ups ?? 0
      self.domain = decoded.data.children.first?.data.domain ?? ""
      self.numComments = decoded.data.children.first?.data.numComments ?? 0
        if let imageUrl = decoded.data.children.first?.data.preview.images.first?.source.url {
                    self.image = imageUrl.replacingOccurrences(of: "&amp;", with: "&")
                } else {self.image = ""}
    }
}

struct DecodedPost: Codable {
    let data: DecodedPostData
}

struct DecodedPostData: Codable {
    let children: [Child]
}

struct Child: Codable {
    let data: ChildData
}

struct ChildData: Codable {
    let authorFullname: String
    let saved: Bool
    let title: String
    let downs, ups: Int
    let domain: String
    let preview: Preview
    let numComments: Int
}

struct Preview: Codable {
    let images: [Image]
}

struct Image: Codable {
    let source: Source
}

struct Source: Codable {
    let url: String
}

