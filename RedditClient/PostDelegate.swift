import Foundation
import UIKit

protocol PostDelegate: AnyObject{
    func changeSaved() -> Void
    func commentsClicked(_ post: Post)
    func refreshTable()
}
