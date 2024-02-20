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
        if let imageUrl = decoded.data.children.first?.data.preview?.images.first?.source.url {
            self.image = imageUrl.replacingOccurrences(of: "&amp;", with: "&")
        } else {self.image = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/1280px-Placeholder_view_vector.svg.png"} //default image, no image in post
    }
    
    init(from child: Child) throws {
        self.authorFullname = child.data.authorFullname
        self.saved = child.data.saved
        self.title = child.data.title
        self.downs = child.data.downs
        self.ups = child.data.ups
        self.domain = child.data.domain
        self.numComments = child.data.numComments
        if let imageUrl = child.data.preview?.images.first?.source.url {
            self.image = imageUrl.replacingOccurrences(of: "&amp;", with: "&")
        } else {self.image = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/1280px-Placeholder_view_vector.svg.png"} //default image, no image in post
        
    }
}
struct DecodedPost: Codable {
    let data: DecodedPostData
}

struct DecodedPostData: Codable {
    let after: String?
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
    let preview: Preview?
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

