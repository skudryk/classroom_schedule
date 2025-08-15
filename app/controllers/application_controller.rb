class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  
  before_action :authenticate_account!
  
  private
  
  def authenticate_account!
      unless current_account
        error = 'Not Authorized' 
        render json: {status: 401,  error:}, status: :unauthorized
      end
  end
  
  def generate_auth_token(hash)
    JsonWebToken.encode(hash)
  end

  def current_account
    @current_account = AuthorizeRequestWithToken.call(request.headers).result
  end
end
