class PlayingController < ApplicationController
  
  before_filter :authorize, :except => [:index, :bio, :photos, :high_res_photos, :contact]
  
  def index
  end

  def bio
    projects = Project.find(:all, :order => "start_date ASC")
    projects = projects.find_all{|p| (p.start_date > Date.today) || (p.start_date == Date.today)}
    @concerts = projects.find_all{|c| c.event_type == "concert" || c.event_type == "HST-concert"}
    if @concerts.length > 3
      @concerts = @concerts[0..2]
    else
      @concerts
    end
    @concerts.length==1 ? @nextConcert = I18n.t("playing.bio.projects.concert") : @nextConcert = I18n.t("playing.bio.projects.concerts")
    #puts I18n.t("playing.bio.projects.concerts")
    @course =  projects.find_all{|c| c.event_type == "course"}[0]
    @masterclass =  projects.find_all{|c| c.event_type == "masterclass"}[0]
  end
  
  def reviews
    lang = session[:locale]
    @articles = Article.find(:all, :conditions => ["display='yes' and language = ?" , lang], :order => "concert_date DESC")
  end
  def show_article
    @article = Article.find_by_id(params[:articleId])
    render :update do |page|
        page.call 'leonid.movies.mediaShow', 'scrollBlanket'
        page.replace_html 'reviewsContent', :partial => 'article_content', 
                                            :locals => {:article => @article}
    end
  end
  
  def photos
  end
  
  def chambermusic
    projects = Project.find(:all, :order => "start_date ASC")
    projects = projects.find_all{|p| (p.start_date > Date.today) || (p.start_date == Date.today)}
    @concerts = projects.find_all{|c| c.event_type == "HST-concert"}
    @concerts.length==1 ? @nextConcert = I18n.t("playing.chambermusic.concert") : @nextConcert = I18n.t("playing.chambermusic.concerts")
    if @concerts.length > 3
      @concerts = @concerts[0..2]
    else
      @concerts
    end
  end
  
  def recordings
    if session[:user_id] || session[:sudo_id]
      @accessLevel = "user"
    elsif session[:friend_id]
      @accessLevel = "friend"
    else
      @accessLevel = "guest"
    end
    @lg_works = get_video_titles("leonid")
    @hst_works = get_video_titles("hst")
    @sp_works = get_video_titles("special")
    #returns array with composers[0] and pieces[1]
  end
  
  def contact
  end

  def play_video
    unless params[:video].blank?
      size = params[:size]
      size=="small" ? video_data = (params[:video].split('.')[0] + ".3gp") : video_data = params[:video]
      title, screenRatio, composer, piece = get_library_info(video_data.split('.')[0])
      #returns: title, screenRatio, composer, piece
      @video_title = title
      render :update do |page|
        if params[:swf]
          page.call 'leonid.movies.unloadVideoPlayer'
        end
        page.replace_html 'video_area', :partial => 'video', 
                                        :locals => {:size => size, :video => params[:video]} #important to leave params[:video], so it's always .m4v for the reloads and changes
        page.assign 'leonid.movies.flashvars.fileName', ("/movies/" + size + "_" + video_data)
        page.assign 'leonid.movies.flashvars.videoInfoData', (composer + ", " + piece)
        page.assign 'leonid.movies.flashvars.fileType', "video"
        page.assign 'leonid.movies.flashvars.movieSize', size
        page.assign 'leonid.movies.flashvars.screenRatio', screenRatio
        page.call 'leonid.movies.mediaShow'
        page.call 'setTimeout', 'leonid.movies.loadVideoPlayer()', 0
      end
    else
      render :update do |page|
        page.call 'leonid.movies.unloadBlanket'
        page.replace_html 'video_area' , :partial => nil
      end
    end
  end
  
  def stop_video
    render :update do |page|
      page.call 'leonid.movies.unloadVideoPlayer'
      page.replace_html 'video_area' , :partial => nil
    end
  end
  
  def play_audio
    @leonid = Student.find_by_firstname_and_lastname("Leonid", "Gorokhov")
    audio_data = write_xml(@leonid)
    render :update do |page|
      page.replace_html 'audio_area', :partial => 'audio_content', :locals => {:leonid => @leonid}
      #page.call 'leonid.movies.movie.call_audio', audio_data
      #page.call 'leonid.movies.loadswf';
      page.assign 'leonid.movies.flashvars.xmlData', audio_data
      page.call 'leonid.movies.mediaShow'
      page.call 'setTimeout', 'leonid.movies.loadAudioPlayer()', 0
    end
  end
  
  def stop_audio
    @leonid = Student.find_by_firstname_and_lastname("Leonid", "Gorokhov")
    render :update do |page|
      page.call 'leonid.movies.unloadAudioPlayer'
      page.replace_html 'audio_area' , :partial => nil
    end
  end
  
  def high_res_photos
    @photo = params[:photo] || params[:variable]  #params[:variable] at language switch of this page
  end

  def diary
  end
  
  private
  
  def get_library_info(video)
    video_info = video_library
    #puts video_info[:leonid1][:recDate].to_s(:long)
    if video_info[video.to_sym][:with]
      title = video_info[video.to_sym][:title] + ", " + video_info[video.to_sym][:with]
    else
      title =  video_info[video.to_sym][:title]
    end
    screenRatio = video_info[video.to_sym][:screenRatio]
    composer = video_info[video.to_sym][:composer]
    piece = video_info[video.to_sym][:piece]
    return title, screenRatio, composer, piece
  end
  
  def get_video_titles(who)
    videos = video_library
    pieces = Array.new
    composers = Array.new
    nr = videos.keys.collect{|k| k= k.to_s}.grep(/#{who}/).length
    for i in 0..(nr-1)
      composers = composers.push(videos[(who+(i+1).to_s).to_sym][:composer])
      pieces = pieces.push(videos[(who+(i+1).to_s).to_sym][:piece])
    end
    return composers, pieces
  end
  
  def video_library
    leonid = "Leonid Gorokhov"
    hst = "Hermitage String Trio"
    special = "Special Event"
    return {:leonid1 => {:title => leonid, :composer => work('leonid1',0), :piece => work('leonid1',1), :with => "Jupiter Chamber Orchestra", :recDate => Date.new(2009,11,8), :screenRatio => "4:3"},
            :hst1 => {:title => hst, :composer => work('hst1',0), :piece => work('hst1',1), :recDate => Date.new(2010, 03,28), :screenRatio => "16:9"},
            :hst2 => {:title => hst, :composer => work('hst2',0), :piece => work('hst2',1), :recDate => Date.new(2010, 03,28), :screenRatio => "16:9"},
            :special1 => {:title => special, :composer => work('special1',0), :piece => work('special1',1), :recDate => Date.new(2010, 03,28), :screenRatio => "16:9"},
            :special2 => {:title => special, :composer => work('special2',0), :piece => work('special2',1), :recDate => Date.new(2010, 03,28), :screenRatio => "16:9"}}
  end
  def work(artist,part)
    return I18n.t('playing.recordings.' + artist).split(/\+\+\+/)[part]
  end

  def write_xml(leonid)
    url = "leonid/gorokhov"
    titles = leonid.aud_titles.split(/###/)
    recDates = leonid.aud_recDate.split(/###/)
    #titles = ["RPO, Elgar, Cello Concerto (Lento, Allegro molto, Adagio)", "Schubert, Arpeggione (Allegro moderato), with Caroline Palmer"]
    #recDates = ["16 January 2010", "28 January 2010"]
    feeds = Array.new
    for i in 0..titles.length-1 do
    feeds.push %*<feed>
                  <label>#{titles[i]}</label>
                  <url>#{url + [i+1].to_s}</url>
                  <recDate>#{recDates[i]}</recDate>
                </feed>*
    end
    xml = "<config>" + feeds.join(" ") + "</config>"
  end

end
