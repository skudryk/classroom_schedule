class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  before_action :authenticate_user!
  
  private
  
  def authenticate_user!
      unless current_user
        error = 'Not Authorized' 
        render json: {status: 401,  error:}, status: :unauthorized
      end
  end
  
  def generate_auth_token(hash)
    JsonWebToken.encode(hash)
  end

  def current_user
    @current_user = AuthorizeRequestWithToken.call(request.headers).result
  end
end
