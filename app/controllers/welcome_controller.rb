class WelcomeController < ApplicationController
  before_filter :authorize, :except => :index
  layout 'welcome'

  def index
    #render :layout => false
  end

  def messages
  end
  
  def index_under_construction
  end

end
