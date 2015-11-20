class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :redirect_if_heroku!

  private

  def redirect_if_heroku!
    if request.host == 'debate-with-bernie.herokuapp.com' || request.protocol == 'http'
      redirect_to "https://debatewith.berniesanders.com#{request.fullpath}"
    end
  end
end
