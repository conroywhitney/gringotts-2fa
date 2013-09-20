require "gringotts/version"

module Gringotts

  @server_url = "https://localhost:3000"
  @private_key = "12345"
  
  def authorization_javascript_url(identifier)
    # incoming identifier should be unique to the application
    # however, don't send it raw over the wire (e.g., if it's an email)
    # this newly-encoded identifier is what the server uses to pair with the user
    encoded_identifier = URI.encode(encrypt(identifier))
        
    # basic request URL for the JS we are going to load
    js_url = "#{@server_url}/auth/#{encoded_identifier}.js?"
    
    # add additional security / informational params to the request
    js_url += {
      :timestamp => Time.now.to_i,
      :nonce => rand(999999999),
    }.to_query
    
    # last but not least, sign the query using our secret key so the server knows it's from us
    js_url += "&sig=" + sign(js_url)
  end
  
private
  
  def encrypt(something)
    return Digest::MD5.hexdigest(identifier)
  end
  
  def sign(something)  
    return Digest::HMAC.hexdigest(js_url, @private_key, Digest::SHA1)
  end
  
end
