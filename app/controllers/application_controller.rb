class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :domain_title, :domain_hashtag, :domain_description, :domain_image, :domain_template, :domain_host, :caucus_request?

  before_filter :redirect_if_heroku!
  before_filter :redirect_to_https!

  def domain_title
    if caucus_request?
      'Caucus for Bernie'
    else
      'Debate with Bernie'
    end
  end

  def domain_hashtag
    if caucus_request?
      '#CaucusForBernie'
    else
      '#DebateWithBernie'
    end
  end

  def domain_description(image)
    if image
      if caucus_request?
        "I created a picture to support Bernie Sanders at the Iowa caucus! Make yours to #CaucusForBernie."
      else
        "I created a picture to support Bernie Sanders at the debate! Make yours to #DebateWithBernie."
      end
    else
      "Make your image to #{domain_hashtag}!"
    end
  end

  def domain_image
    if caucus_request?
      '/images/bernie_caucus.png'
    else
      '/images/bernie_debate.png'
    end
  end

  def domain_template
    if caucus_request?
      '/images/template_caucus.png'
    else
      '/images/template_debate.png'
    end
  end

  def domain_host
    if caucus_request?
      'caucusfor.berniesanders.com'
    else
      'debatewith.berniesanders.com'
    end
  end

  def caucus_request?
    request.subdomain == 'caucusfor'
  end

  private

  def redirect_if_heroku!
    return unless Rails.env.production?
    redirect_to "https://debatewith.berniesanders.com#{request.fullpath}" if request.host == 'debate-with-bernie.herokuapp.com'
  end

  def redirect_to_https!
    redirect_to(protocol: 'https://') unless request.ssl? || request.local?
  end
end
