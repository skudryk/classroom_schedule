class AuthorizeRequestWithToken
  prepend SimpleCommand

  attr_reader :token, :jwt

  def initialize(headers = {})
    header = headers['Authorization'] || headers['X-Authorization']
    Rails.logger.info "-- auth. header: #{header&.last(16)}"
    @token = header.split(' ').last if header
    Rails.logger.info "-- token in header :  #{@token&.first(16)}..#{@token&.last(16)}" if @token
  end

  def call
    User.find_by(email: jwt['email']) if jwt.present?
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