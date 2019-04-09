//
//  ResourceService.swift
//  ImageManager2000
//
//  Created by Paul Nadolynskyi on 4/1/19.
//  Copyright © 2019 yourcompany. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ResourceService {
    private var cachedItems: [Resource]?
    let disposeBag = DisposeBag()

    
    func fetchAll(completion: @escaping ([Resource]?, Error?) -> ()) {
        if let items = cachedItems {
            return completion(items, nil)
        }
        if let items = loadItemsFromStore() {
            cachedItems = items
            return completion(items, nil)
        }
        downloadInitialData { [unowned self] (items, error) in
            if let items = items {
                self.cachedItems = items
            }
            return completion(items, error)
        }
    }
    
    func fetchRandom(completion: @escaping (Resource?, Error?) -> ()) {
        fetchAll { (resources, error) in
            if let resources = resources, let element = resources.randomElement() {
                completion(element, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func loadLocalImage(for resource: Resource, completion: @escaping (UIImage?) -> ()) {
        guard let url = ResourceService.imageStorageURL(filename: resource.localFilename) else { return }
        DispatchQueue.global(qos: .background).async {
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async(execute: { () -> Void in
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    func updateResource(_ resource: Resource) {
        if let index = cachedItems?.firstIndex(where: { $0.remoteLink == resource.remoteLink}) {
            cachedItems?.remove(at: index)
            cachedItems?.insert(resource, at: index)
        }
    }
    
    func saveChanges() {
        if let items = cachedItems {
            saveItemsToStore(items)
        }
    }
}

private extension ResourceService {
    
    func downloadInitialData(_ completion: @escaping (_ resources: [Resource]?, _ error: Error?) -> ()) {
        let url = URL(string: Constants.imagesLink)!
        
        let background = ConcurrentDispatchQueueScheduler(qos: .background)
        downloadResourceLinksObservable(url: url)
            .subscribeOn(background)
            .map({ imageLinks in imageLinks.map({ Resource(remoteLink: $0) }) })
            .map({ resources in
                Observable.zip(resources.map({ self.downloadImageObservable($0) }))
            })
            .merge()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (downloadedResources) in
                completion(downloadedResources, nil)
            })
            .disposed(by: disposeBag)
    }
    
    func downloadResourceLinksObservable(url: URL) -> Observable<[String]> {
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let imageLinks = try decoder.decode([String].self, from: data)
                    observer.on(.next(imageLinks))
                } catch {
                    observer.on(.error(RxCocoaURLError.deserializationError(error: error)))
                }
                
                observer.on(.completed)
            }
            
            task.resume()
            
            return Disposables.create(with: task.cancel)
        }
    }
    
    func downloadImageObservable(_ resource: Resource) -> Observable<Resource> {
        let downloadURL = URL(string: resource.remoteLink)!
        let saveURL = ResourceService.imageStorageURL(filename: resource.localFilename)!
        
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                guard let data = data else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }
                
                do {
                    try data.write(to: saveURL)
                    observer.on(.next(resource))
                } catch {
                    observer.on(.error(error))
                }
                
                observer.on(.completed)
            }
            
            task.resume()
            
            return Disposables.create(with: task.cancel)
        }
    }
}

private extension ResourceService {
    var storageURL: URL? {
        guard let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return URL(fileURLWithPath: "storage.json", relativeTo: documentsPathURL)
    }
    
    static func imageStorageURL(filename: String) -> URL? {
        guard let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return URL(fileURLWithPath: filename, relativeTo: documentsPathURL)
    }
    
    func loadItemsFromStore() -> [Resource]? {
        guard
            let storageURL = storageURL,
            let storageContent = try? String(contentsOf: storageURL, encoding: .utf8),
            let storageData = storageContent.data(using: .utf8) else {
                return nil
        }
        
        let decoder = JSONDecoder()
        return try? decoder.decode([Resource].self, from: storageData)
    }
    
    func saveItemsToStore(_ items: [Resource]) {
        guard let storageURL = storageURL else {
            return
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(items) {
            try? encodedData.write(to: storageURL)
        }
    }
}
