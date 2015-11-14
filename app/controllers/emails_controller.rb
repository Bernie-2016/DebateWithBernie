class EmailsController < ApplicationController
  def create
    if params[:email] =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      RestClient.post 'https://sanders-api.herokuapp.com/api/v1/signups/only_email', { secret: ENV['SIGNUP_SECRET'], email: params[:email] }
    end

    render nothing: true, status: 200
  end
end
