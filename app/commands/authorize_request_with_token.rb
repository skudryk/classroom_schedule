# to use JWT authentication we should create an account record for API client
class AuthorizeRequestWithToken
  prepend SimpleCommand

  attr_reader :token, :jwt

  def initialize(headers = {})
    header = headers['Authorization'] || headers['X-Authorization']
    @token = header.split(' ').last if header
  end

  def call
    Account.find_by(email: jwt['email']) if jwt.present?
  end

  private

  def expired?
    timestamp = jwt[:exp].to_i
    DateTime.now.to_i > timestamp
  end

  def jwt
    @jwt ||= JsonWebToken.decode(@token)
  end
end