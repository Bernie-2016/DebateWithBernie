class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_filter :redirect_if_heroku!

  private

  def redirect_if_heroku!
    return unless Rails.env.production?
    redirect_to "https://debatewith.berniesanders.com#{request.fullpath}" if request.host == 'debate-with-bernie.herokuapp.com' || request.protocol == 'http://'
  end
end
