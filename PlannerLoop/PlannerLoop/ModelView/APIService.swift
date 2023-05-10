//
//  APIService.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    /// API Call to get user data, confirm user data, sign in
    /// - Parameters:
    ///   - email: String, containing user email for which to get user data
    ///   - completion: value describing result of completed operation, contains void on success, error on fail
    func getUserData(email: String, completion: @escaping (Result<DBUser,ErrorDescription>) -> Void){
        let loginResponse = DBUser(userID: UUID().uuidString, password: "sdads", appKey: "WSyV2Dgg5POLeUu7wm1EAtZpbYwsN1RB", email: email, vip: 1, status: 1, tokens: 1)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            completion(.success(loginResponse))
            return
        }
    }
    
    /// API Call to get users tasks
    /// - Parameter completion: value describing result of completed operation, contains void on success, error on fail
    func getUserOperations(completion: @escaping (Result<[DBTask]?,ErrorDescription>) -> Void){
        guard var appKey = UserDefaults.standard.string(forKey: UserDefaults.Keys.appKey.rawValue) else {
            completion(.failure(.invalidUserData))
            return
        }
        appKey.append(":")
        appKey = appKey.toBase64()
        
        guard let url = URL(string: "http://mhafan.eu:8090/user/tasklist") else {
            completion(.failure(.noConnection))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Basic \(appKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else {
                //print(error.debugDescription)
                completion(.failure(.noConnection))
                return
            }
            guard let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: data) else{
                completion(.failure(.invalidServerResponse))
                return
            }
            guard let tasksArray = apiResponse.dbtasks else {
                completion(.failure(.invalidServerResponse))
                return
            }
            completion(.success(tasksArray))
        }.resume()
    }
    
    /// API Call to get users tasks
    /// - Parameter completion: value describing result of completed operation, contains void on success, error on fail
    func ping(completion: @escaping (Result<Bool,ErrorDescription>) -> Void){
        guard var appKey = UserDefaults.standard.string(forKey: UserDefaults.Keys.appKey.rawValue) else {
            completion(.failure(.invalidUserData))
            return
        }
        appKey.append(":")
        appKey = appKey.toBase64()
        
        guard let url = URL(string: "http://mhafan.eu:8090/user/ping") else {
            completion(.failure(.noConnection))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Basic \(appKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else {
                //print(error.debugDescription)
                completion(.failure(.invalidServerResponse))
                return
            }
            let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Ping could not be printed"
            print(string1)
        }.resume()
    }
    
    /// API Call to submit AJobs
    /// - Parameters:
    ///   - encodedDB: String containing base64 encoded database file
    ///   - completion: value describing result of completed operation, contains void on success, error on fail
    func submitSA(encodedDB: String, completion: @escaping (Result<String,ErrorDescription>) -> Void){
        guard var appKey = UserDefaults.standard.string(forKey: UserDefaults.Keys.appKey.rawValue) else {
            completion(.failure(.invalidUserData))
            return
        }
        appKey.append(":")
        appKey = appKey.toBase64()
        
        guard let url = URL(string: "http://mhafan.eu:8090/user/submitSA") else {
            completion(.failure(.noConnection))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(appKey)", forHTTPHeaderField: "Authorization")
        

        let body = HGSubmitBody(AttachmentEncoded: encodedDB, TaskClass: "A0", OrigFileName: SQLiteDatabase.dbFilename, SourceOfOrigin: "httpGate")
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(.invalidDBFile))
            return
        }
        
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.invalidServerResponse))
                return
            }
            
            guard let apiResponse = try? JSONDecoder().decode(HGTaskStatus.self, from: data) else{
                
                guard let hgError = try? JSONDecoder().decode(HGError.self, from: data) else{
                    completion(.failure(.invalidServerResponse))
                    return
                }
                completion(.failure(APIError.init(rawValue: hgError.ErrorCode)?.bindToDescrptn() ?? .invalidServerResponse))
                return
            }
            if apiResponse.Status > TaskStatus.scheduled.rawValue { //Error if status is canceled, failed or closed
                completion(.failure(.invalidServerResponse))
                return
            }
            completion(.success(apiResponse.TaskID))
        }.resume()
    }

    /// API Call to submit AJobs
    /// - Parameters:
    ///   - taskID: String containing identifier of task to get status of
    ///   - completion: value describing result of completed operation, contains void on success, error on fail
    func getTaskStatus(taskID: String, completion: @escaping (Result<TaskStatus,ErrorDescription>) -> Void){
        guard var appKey = UserDefaults.standard.string(forKey: UserDefaults.Keys.appKey.rawValue) else {
            completion(.failure(.invalidUserData))
            return
        }
        appKey.append(":")
        appKey = appKey.toBase64()
        
        guard let url = URL(string: "http://mhafan.eu:8090/user/status/\(taskID)") else {
            completion(.failure(.noConnection))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(appKey)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.invalidServerResponse))
                return
            }
            
            guard let apiResponse = try? JSONDecoder().decode(HGTaskStatus.self, from: data) else{
                
                guard let hgError = try? JSONDecoder().decode(HGError.self, from: data) else{
                    completion(.failure(.invalidServerResponse))
                    return
                }
                completion(.failure(APIError.init(rawValue: hgError.ErrorCode)?.bindToDescrptn() ?? .invalidServerResponse))
                return
            }
            
            completion(.success(TaskStatus.init(rawValue: apiResponse.Status) ?? .failed))
        }.resume()
    }
    
    /// API Call to submit AJobs
    /// - Parameters:
    ///   - taskID: String containing identifier of task to download
    ///   - completion: value describing result of completed operation, contains void on success, error on fail
    func downloadTask(taskID: String, completion: @escaping (Result<String,ErrorDescription>) -> Void){
        guard var appKey = UserDefaults.standard.string(forKey: UserDefaults.Keys.appKey.rawValue) else {
            completion(.failure(.invalidUserData))
            return
        }
        appKey.append(":")
        appKey = appKey.toBase64()
        
        guard let url = URL(string: "http://mhafan.eu:8090/user/download/\(taskID)") else {
            completion(.failure(.noConnection))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(appKey)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.invalidServerResponse))
                return
            }
            
            guard let apiResponse = try? JSONDecoder().decode(HGTaskStatus.self, from: data) else{
                
                guard let hgError = try? JSONDecoder().decode(HGError.self, from: data) else{
                    completion(.failure(.invalidServerResponse))
                    return
                }
                completion(.failure(APIError.init(rawValue: hgError.ErrorCode)?.bindToDescrptn() ?? .invalidServerResponse))
                return
            }
            
            completion(.success(apiResponse.FileEncoded))
        }.resume()
    }
    
    
    /// API Call to submit AJobs
    /// - Parameters:
    ///   - taskID: String containing identifier of task to close
    ///   - completion: value describing result of completed operation, contains void on success, error on fail
    func closeOperation(taskID: String, completion: @escaping (ErrorDescription?) -> Void) {

        guard var appKey = UserDefaults.standard.string(forKey: UserDefaults.Keys.appKey.rawValue) else {
            completion(.invalidUserData)
            return
        }
        
        appKey.append(":")
        appKey = appKey.toBase64()
        
        guard let url = URL(string: "http://mhafan.eu:8090/user/close/\(taskID)") else {
            completion(.noConnection)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic \(appKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data, error == nil else {
                completion(.invalidServerResponse)
                return
            }
            guard let apiResponse = try? JSONDecoder().decode(HGTaskStatus.self, from: data) else{
                guard let _ = try? JSONDecoder().decode(HGError.self, from: data) else{
                    completion(.cannotClose)
                    return
                }
                completion(.cannotClose)
                return
            }
            if apiResponse.Status != TaskStatus.closed.rawValue {
                completion(.cannotClose)
                return
            }
            completion(nil)
        }.resume()
    }
    
}
