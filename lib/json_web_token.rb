class JsonWebToken
 class << self
  EXPIRATION_PERIOD =  1.year.from_now

   def encode(payload, exp = EXPIRATION_PERIOD)
     payload[:exp] = exp.to_i
     JWT.encode(payload, Rails.application.secrets.secret_key_base)
   end

   def decode(token)
     body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
     HashWithIndifferentAccess.new body
   rescue
     nil
   end
 end
end