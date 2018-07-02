//
//  Wrapper.swift
//  TwitterApp
//
//  Created by Karthikeyan A. on 25/06/18.
//  Copyright © 2018 Karthikeyan A. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

/*
class Wrapper: NSObject {
    static let sharedInstance = Wrapper()
  //  var getSwiffter = Swifter(consumerKey: TWKeys.TW_ConsumerKey, consumerSecret: TWKeys.TW_ConsumerKey, appOnly: true)
    func POSTCall(urlFrom: String,params: [String: Any],  onSuccess: @escaping(Data) -> Void){ //, onFailure: @escaping(Error) -> Void
        
        // Reachability check
        if !Reachability.connetcedToNetwork(){
             Utility.showErrorAlert(message: "Internet connection is off")
            return
        }
        
        let todosEndpoint = TWKeys.twitterBaseURL + urlFrom
        guard let todosURL = URL(string: todosEndpoint) else {
          //  print("Error: cannot create URL")
            return
        }
    
        let request = NSMutableURLRequest(url:todosURL)
        if !urlFrom.containsIgnoringCase(find: "timeline"){
            request.httpMethod = "POST"
            let jsonTodo: Data
            do {
                jsonTodo = try JSONSerialization.data(withJSONObject: params, options: [])
                request.httpBody = jsonTodo
            } catch {
                // print("Error: cannot create JSON from todo")
                return
            }
        }else{
             request.httpMethod = "GET"
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                Utility.showErrorAlert(message: (error?.localizedDescription)!)
            } else{
                guard let responseData = data else {
                 //   print("Error: did not receive data")
                    return
                }
                
                onSuccess(responseData)
            }
        })
        task.resume()
    }
   
     func handlePOSTCall(urlFrom: String,params: [String: Any],  onSuccess: @escaping(Data) -> Void,  onFailure: @escaping(Error) -> Void){
        // Reachability check
        if !Reachability.connetcedToNetwork(){
            Utility.showErrorAlert(message: "Internet connection is off")
            return
        }
         let todosEndpoint = TWKeys.twitterBaseURL + urlFrom
        print(todosEndpoint)
         print(params)
        var getHTTPType = "POST"
        if urlFrom.containsIgnoringCase(find: "timeline"){
           // request.httpMethod = "POST"
            getHTTPType = "GET"
        }
        let client = TWTRAPIClient()
        var clientError : NSError?
        let request = client.urlRequest(withMethod: getHTTPType, urlString:todosEndpoint , parameters: params, error: &clientError)
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                onFailure(connectionError!)
                 Utility.showErrorAlert(message: (connectionError?.localizedDescription)!)
            }else{
                guard let responseData = data else {
                    //   print("Error: did not receive data")
                    return
                }
                
                onSuccess(responseData)
            }
            
//            do {
//                onSuccess(responseData)
////                let json = try JSONSerialization.jsonObject(with: data!, options: [])
////                print("json: \(json)")
//            } catch let jsonError as NSError {
//                Utility.showErrorAlert(message: (jsonError.localizedDescription))
//            }
        }
    }
    
    func getTweetsFromFile(callback: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if let path = Bundle.main.path(forResource: "Tweets.min", ofType: "json") {
                let url = URL(fileURLWithPath: path)
                
                do {
                    let jsonFile = try Data(contentsOf: url, options: .mappedIfSafe)
                    
                    let tweetsJson = try JSONSerialization.jsonObject(with: jsonFile, options: .allowFragments) as! [JSON]
                    
                    for tweetJson in tweetsJson {
                      
                        if let tweet = Tweet.load(fromJson: tweetJson) {
                            tweets.append(tweet)
                        }
                    }
                     
                    DispatchQueue.main.async {
                                        callback(tweets)
                                    }
                } catch {
                    dump(error)
                }
            }
            
//
        }
    }
 
 
  
}
*/

internal enum GETTweetSource {
    case homeTL
    case mentionsTL
    case userTL
}

internal class Wrapper: BDBOAuth1SessionManager {
    
    // MARK: Singleton
    internal static let shared = Wrapper(baseURL: URL(string: TWKeys.twitterBaseURL)!, consumerKey: TWKeys.TW_ConsumerKey, consumerSecret: TWKeys.TW_ConsumerSecret)!
    
    internal typealias Failure = (Error?) -> Void
    fileprivate var loginSuccess: (() -> Void)?
    fileprivate var loginFailure: (Failure)?
    
    
    // MARK: URL Handler
    internal func handle(open url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(
            withPath: RequestURL.accessToken,
            method: Method.post,
            requestToken: requestToken,
            success: {
                _ in
                self.initlizeAccount {
                    user, error in
                    if let user = user {
                        User.setCurrentUser(user: user)
                        self.loginSuccess?()
                    } else {
                        self.loginFailure?(error!)
                    }
                }
        },
            failure: {
                error in
                self.loginFailure?(error)
        })
    }
    
}

extension Wrapper {
     func initlizeAccount(completion: @escaping (_ response: User?, _ error: Error?) -> Void) {
        if !Reachability.connetcedToNetwork(){
            Utility.showErrorAlert(message: "Internet connection is off")
            return
        }
        getRequest(RequestURL.accountVerifyCredentials, with: nil) {
            response, error in
            if let response = response {
                let user = User(dictionary: response as! [String : Any])
                completion(user, nil)
            } else {
                completion(nil, error)
            }
        }
}
    // MARK: Get
     func getRequest(_ urlString: String, with parameters: Any?, completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        if !Reachability.connetcedToNetwork(){
            Utility.showErrorAlert(message: "Internet connection is off")
            return
        }
        get(
            urlString,
            parameters: parameters,
            progress: nil,
            success: {
                task, response in
                completion(response, nil)
        },
            failure: {
                task, error in
                completion(nil, error)
        })
    }
    // MARK: Post
     func postRequest(_ urlString: String, with parameters: Any?, completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        if !Reachability.connetcedToNetwork(){
            Utility.showErrorAlert(message: "Internet connection is off")
            return
        }
        post(
            urlString,
            parameters: parameters,
            progress: nil,
            success: { task, response in
                completion(response, nil)
        },
            failure: { task, error in
                completion(nil, error)
        })
    }
    
    
}

 

// MARK: - Conveniences
extension Wrapper {
    
    // MARK: Login
    func loginCall(success: @escaping () -> Void, failure: @escaping Failure) {
        if !Reachability.connetcedToNetwork(){
            Utility.showErrorAlert(message: "Internet connection is off")
            return
        }
        deauthorize()
        loginSuccess = success
        loginFailure = failure
        fetchRequestToken(
            withPath: RequestURL.requestToken,
            method: Method.get,
            callbackURL: URL(string: "twitterDemo1://oauth"),
            scope: nil,
            success: {
                requestToken in
                guard let requestToken = requestToken, let token = requestToken.token else {
                    print("TwitterClient: no request token!")
                    return
                }
                let url = URL(string: RequestURL.authentication(token: token))!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        },
            failure: {
                error in
                self.loginFailure?(error)
        })
    }
    
    // Mark: Logout
    internal func logout() {
        NotificationCenter.default.post(name: NSNotification.Name.UserDidLogout, object: nil)
        User.removeCurrentUser()
        deauthorize()
    }
    
    internal func getTweets(from source: GETTweetSource, for screenName: String?, shouldGetNextPage: Bool, completion: @escaping (_ response: [Tweet]?, _ error: Error?) -> Void) {
        
        var requestURLString = ""
        
        switch source {
        case .homeTL:
            requestURLString = RequestURL.homeTimeline
        case .mentionsTL:
            requestURLString = RequestURL.mentionsTimeline
        case .userTL:
            requestURLString = RequestURL.userTimeline
        }
        
        var parameters: [String : Any] = ["include_entities" : true]
        if let screenName = screenName {
            parameters["screen_name"] = screenName
        }
        if shouldGetNextPage {
            parameters["max_id"] = Pagination.maxID
            parameters["count"] = Pagination.count + 1
        } else {
            parameters["count"] = Pagination.count
        }
        
        getRequest(requestURLString, with: parameters) {
            response, error in
            if let response = response {
                var timelineTweets = Tweet.tweets(from: response as!  [[String : Any]])
                if shouldGetNextPage && !timelineTweets.isEmpty {
                    _ = timelineTweets.removeFirst()
                }
                if let lastTweet = timelineTweets.last {
                    Pagination.maxID = lastTweet.id! // For pagination
                }
                completion(timelineTweets, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    internal func post(tweet status: String, idForReply id: Int64?, completion: @escaping (_ tweet: Tweet?, _ success: Bool, _ error: Error?) -> Void) {
        
        var parameters = [String : Any]()
        
        parameters["status"] = status
        
        if let id = id {
            parameters["in_reply_to_status_id"] = id
        }
        
        postRequest(RequestURL.update, with: parameters) {
            response, error in
            if response != nil {
                if let responseTweetDict = response as? NSDictionary {
                    completion(Tweet(dictionary: responseTweetDict as! [String : Any]), true, nil)
                } else {
                    completion(nil, true, error)
                }
            } else {
                completion(nil, false, error)
            }
        }
    }
    
    internal func retweet(id: Int64, shouldUntweet: Bool, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let parameters = ["id" : id]
        let requestURLString = shouldUntweet ? RequestURL.untweet(id) : RequestURL.retweet(id)
        postRequest(requestURLString, with: parameters) {
            response, error in
            if response != nil {
                completion(true, error)
            } else {
                completion(false, error)
            }
        }
    }
    
    internal func changeLike(isLiked: Bool, id: Int64, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let parameters = ["id" : id]
        let requestURLString = isLiked ? RequestURL.createFavorites : RequestURL.destroyFavorites
        postRequest(requestURLString, with: parameters) {
            response, error in
            if response != nil {
                completion(true, error)
            } else {
                completion(false, error)
            }
        }
    }
}

