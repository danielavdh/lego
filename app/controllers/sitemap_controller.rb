class SitemapController < ApplicationController

  def index
    #puts request.format
    #puts request.headers
    @welcome = %w[index]
    @teaching = %w[index courses classes recordings students studentzone contact]
    @playing = %w[index bio reviews photos chambermusic recordings contact]
    updates = Lesson.find(:all, :order => "updated_at DESC")#.collect{|l| l.updated_at}.sort[-1]
    headers["Content-Type"] = "text/xml"
    headers["Last-Modified"] = updates[0].updated_at.httpdate
    #puts request.headers==headers
    #puts headers
    @update = updates[0].updated_at.to_date
    if @update.blank?
      @update = Time.now.to_date #(1+rand(60))*(1+rand(60))*(1+rand(24))
    end
    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { render :layout => false }
      #format.xml  #{ render :xml => @teaching_pages }
    end
    #lang=["en","de","fr"]
    #  yml_data[i] = YAML.load_file('./config/locales/'+lang[i]+'.yml')
    #headers["Last-Modified" ] = @team[0].updated_at.httpdate if @team[0]
    #render :layout => false
  end
  
end
