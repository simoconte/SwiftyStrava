//
//  StravaClient+OAuth.swift
//  Strava
//
//  Created by Oleksandr Glagoliev on 29/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

public extension StravaClient {
    public func oAuthURL() throws -> URL {
        guard let clientId = clientId else {
            throw OAuthError.parameterMissing(paramterName: "clientId")
        }
        
        var scope: String = ""
        if let accessScope = self.accessScope {
            scope = "&scope =" + accessScope.rawValue
        }
        
        guard let url = URL(string: "https://www.strava.com/oauth/authorize?client_id=\(clientId)&response_type=code&redirect_uri=\(callbackURL)\(scope)&approval_prompt=force") else {
            throw OAuthError.urlMalformed
        }
        
        return url
    }
    
    
    public func extractAccessCredentials(from url: URL) throws -> AccessCredentials {
        guard let comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw OAuthError.notAuthorized(reason: "Cannot resolve URL components for URL: \(url)")
        }
        
        guard let clientId = self.clientId else {
            throw OAuthError.parameterMissing(paramterName: "clientId")
        }
        
        guard let clientSecret = self.clientSecret else {
            throw OAuthError.parameterMissing(paramterName: "clientSecret")
        }
        
        guard let code = (comps.queryItems?.filter { $0.name == "code" })?.first?.value else {
            throw OAuthError.notAuthorized(reason: "Cannot retrieve `code` value from URL: \(url)")
        }
        
        return AccessCredentials(clientId: clientId, clientSecret: clientSecret, code: code)
    }
}
