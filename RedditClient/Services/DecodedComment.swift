import Foundation

struct Comment: Codable, Identifiable, Hashable{
    var id: String
    var authorFullname: String
    var permalink: String
    var downs: Int
    var ups: Int
    var created: Int
    var body: String
    
    init(from child: ChildC) throws {
        self.id = child.data.id ?? "none"
        self.authorFullname = child.data.authorFullname ?? "Hidden user"
        self.permalink = "https://www.reddit.com/\(child.data.permalink ?? "")"
        self.downs = child.data.downs ?? 0
        self.ups = child.data.ups ?? 0
        self.created = child.data.created ?? 0
        self.body = child.data.body ?? ""
    }
    
    init(){
        self.id = "0000"
        self.authorFullname = "test name"
        self.permalink = "https://www.reddit.com/"
        self.downs = 0
        self.ups = 0
        self.created = 0
        self.body = "comment text"
    }
}

struct DecodedComment: Codable {
    let data: DecodedCommentData
}

struct DecodedCommentData: Codable {
    let children: [ChildC]
}

struct ChildC: Codable {
    let data: ChildDataC
}

struct ChildDataC: Codable {
    let id: String?
    let authorFullname: String?
    let body: String?
    let downs: Int?
    let permalink: String?
    let created: Int?
    let ups: Int?
}

