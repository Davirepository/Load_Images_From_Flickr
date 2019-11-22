//
//  ImageModel.swift
//  UrlSessionLesson
//
//  Created by Константин Богданов on 06/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

struct ImageModel {
	let path: String
	let description: String
}

struct ImageViewModel {
	let description: String
	let image: UIImage
}

final class SaveThreadImageViewModel {
    var data = [ImageViewModel]()
    let queue = DispatchQueue(label: "queue.com", attributes: .concurrent)
    
    func append(new element: ImageViewModel) {
        queue.async(flags: .barrier) {
            self.data.append(element)
        }
    }
    
    func removeAll() {
        queue.async(flags: .barrier) {
            self.data.removeAll()
        }
    }
    
}

final class SaveThreadImageModel {
    let queue = DispatchQueue(label: "queue.com", attributes: .concurrent)
    var data = [ImageModel]()

    func append(new element: ImageModel) {
        queue.async(flags: .barrier) {
            self.data.append(element)
        }
    }

    func removeAll() {
        queue.async(flags: .barrier) {
            self.data.removeAll()
        }
    }

}
