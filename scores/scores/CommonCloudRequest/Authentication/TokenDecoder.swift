import Foundation

// MARK: - TokenDecoderError
public enum TokenDecoderError: Error {
    case decodeBase64UrlFailure
    case decodeJWTPayloadFailure(String)
    case invalidJWT
}

// MARK: - TokenDecoder
enum TokenDecoder {
    static func makeCloudIdentity(from carrier: TokenCarrier) throws -> CloudIdentity {
        let sessionCloudToken = try decode(carrier.accessToken)
        
        return CloudIdentity(sessionToken: sessionCloudToken)
    }
    
    private static func decode(_ jwt: String) throws -> CloudToken {
        let jwtSegments = jwt.components(separatedBy: ".")
        
        guard jwtSegments.count == 3 else {
            throw TokenDecoderError.invalidJWT
        }
        
        let payload = jwtSegments[1]
        let tokenDetails = try decodeJWTPayload(payload)
        
        return CloudToken(raw: jwt,
                          identifier: tokenDetails.identifier,
                          timeOfExpiration: tokenDetails.timeOfExpiration)
    }
    
    private static func decodeBase64Url(_ value: String) throws -> Data {
        // https://stackoverflow.com/questions/40915607/how-can-i-decode-jwt-json-web-token-token-in-swift
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 += padding
        }
        
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else {
            throw TokenDecoderError.decodeBase64UrlFailure
        }
        
        return data
    }
    
    private static func decodeJWTPayload(_ payload: String) throws -> TokenDetails {
        let data = try decodeBase64Url(payload)
        
        do {
            let decoded = try JSONDecoder().decode(TokenDetails.self, from: data)
            return decoded
        } catch {
            throw TokenDecoderError.decodeJWTPayloadFailure("failed to decode payloadData")
        }
    }
}
