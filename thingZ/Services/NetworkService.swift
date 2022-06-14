//
//  NetworkService.swift
//  thingZ
//
//  Created by Hovhannes Mikayelyan on 6/13/22.
//  Copyright © 2022 Hovhannes Mikayelyan. All rights reserved.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func getTodos(_ onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void) {
        let process = fetchData(type: "get")
        process.work(todo: nil, onSuccess: onSuccess, onError: onError)
    }
    
    func addTodo(todo: Todo, onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void) {
        let process = fetchData(type: "add")
        process.work(todo: todo, onSuccess: onSuccess, onError: onError)
    }
}

extension NetworkService {
    struct fetchData {
        
        let type: String
        let URL_BASE = "http://localhost:3003"
        let URL_ADD_TOTO = "/add"
        
        let session = URLSession(configuration: .default)
        
        init(type:  String) {
            self.type = type
        }
        
        func work(todo: Todo?, onSuccess: @escaping (Todos) -> Void, onError: @escaping (String) -> Void){
            
            var request: URLRequest
            
            if type == "add"
            {
                let url = URL(string: "\(URL_BASE)\(URL_ADD_TOTO)")!
                request = URLRequest(url : url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                do {
                    let body = try JSONEncoder().encode(todo!)
                    request.httpBody = body
                } catch {
                    onError(error.localizedDescription)
                }
            }
            else
            {
                let url = URL(string: "\(URL_BASE)")!
                request = URLRequest(url: url)
                request.httpMethod = "GET"
            }
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    if let error = error {
                        onError(error.localizedDescription)
                        return
                    }
                    
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        onError("Invalid data or response. Failed to get data from server.")
                        return
                    }
                    
                    do{
                        if response.statusCode == 200 {
                            let items = try JSONDecoder().decode(Todos.self, from: data)
                            onSuccess(items)
                        }
                        else {
                            let err = try JSONDecoder().decode(APIError.self, from: data)
                            onError(err.message)
                        }
                    } catch {
                        onError(error.localizedDescription)
                    }
                }
            }
            task.resume()
            
        }
    }
}

