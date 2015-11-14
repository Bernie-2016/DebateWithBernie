class ApplicationController < ActionController::Base
  before_filter :redirect_if_heroku

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def redirect_if_heroku
    redirect_to "http://debatewith.berniesanders.com#{request.fullpath}" if request.host == 'debate-with-bernie.herokuapp.com'
  end
end
