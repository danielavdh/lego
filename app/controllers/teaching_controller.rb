require 'icalendar'

class TeachingController < ApplicationController
  include TeachingHelper
  before_filter :authorize, :except => [:courses, :classes, :directions, :studentzone, :contact]
  before_filter :generate_key
  
  def index
  end
  
  def courses
  end
  
  def classes
    @map = '18_4_10'
  end
  
  def directions
    @map = params[:class]
  end
  
  def students
    @students = Student.find(:all, :conditions => "displayed = 'block'", :order => "lastname ASC")
    @error_version = false
    if session[:user_id] || session[:sudo_id]
      @admin = true
      if session[:sudo_id]
        @superuser = true
      end
    end
    if session[:student_id]
      @logged_in_student = @students.detect{|s| s.id == session[:student_id]}
    end
  end

  def recordings
  end
  
  def contact
  end

  def blog
  end

  def studentzone
    if session[:user_id]
      @msg_to_leonid = "Hi Leonid, click on a day number to set lessons for that day"
    end
    if request.post?
      student = Student.authenticate(params[:firstname], params[:lastname], params[:password])
      if student
        session[:student_id] = student.id
      else
        @focus = "leonid.admin.focus('user_name');"
        flash.now[:notice] = I18n.t("messages.flash_login")
      end
    else # any gets, be it with or without session (see in view)
      @focus = "leonid.admin.focus('user_name');"
    end
    if session[:student_id]
      after_school = Student.find_by_id(session[:student_id]).after_school
    end
    calendar_variables(after_school)
  end
  
  def hide_student
    student = Student.find(params[:id])
    student.update_attributes(params[:student])
    if Admin.find_by_id(session[:user_id])
       @admin = true
     end
    @students = Student.find(:all, :conditions => "displayed = 'block'", :order => "lastname ASC")
    render :update do |page|
      page.replace_html 'student_table' , :partial => 'displayed_students'
    end
  end
################################### AUDIO ####################################  
  def play_audio
    @student = Student.find(params[:id])
    audio_data = write_xml(@student)
    render :update do |page|
      page.replace_html 'audio_area', :partial => 'student_audio', :locals => {:student => @student}
      #page.call 'leonid.movies.movie.call_audio', audio_data
      #page.call 'leonid.movies.loadswf';
      page.assign 'leonid.movies.flashvars.xmlData', audio_data
      page.call 'leonid.movies.mediaShow'
      page.call 'setTimeout', 'leonid.movies.loadAudioPlayer()', 0
    end
  end
  def stop_audio
    @student = Student.find(params[:id])
    render :update do |page|
      page.call 'leonid.movies.unloadAudioPlayer'
      page.replace_html 'audio_area' , :partial => nil
    end
  end
  def upload_audio
    @student = Student.find(params[:id])
    render :update do |page|
      page.replace_html 'audio_area' , :partial => 'upload_audio'#, :locals => {student => student}
      page.call 'leonid.movies.mediaShow'
    end
  end
  def upload_mp3
    @student = Student.find(params[:id])
    old_audios = Dir.glob("public/audio/students/*").collect{|f| f =~ /#{@student.assetsPath}/}.compact.length
    recDate = [params[:student]['recording_date(1i)'], params[:student]['recording_date(2i)'], params[:student]['recording_date(3i)']]
    audioInfo = [params[:student][:composer], params[:student][:piece], params[:student][:audio]]
    student_attr = {:recording_date => recDate, :audio => audioInfo} #:composer => params[:student][:composer], :piece => params[:student][:piece], :audio => params[:student][:audio]}
    if @student.update_attributes(student_attr)
      new_audios = Dir.glob("public/audio/students/*").collect{|f| f =~ /#{@student.assetsPath}/}.compact.length
      if new_audios > old_audios
        flash[:notice] = "mp3 file uploaded"
      else
        flash[:notice] = "no audio files added"
      end
      redirect_to(:action => :students)
    else
      @students = Student.find(:all, :conditions => "displayed = 'block'", :order => "lastname ASC")
      @admin = true if Admin.find_by_id(session[:user_id])
      if session[:student_id]
        @logged_in_student = @students.detect{|s| s.id == session[:student_id]}
      end
      @error_version = true
      render :action => :students#, :id => @student.id, :err => true
    end
  end
  def remove_audio
    @student = Student.find(params[:id])
    @titles = @student.findTitles
    render :update do |page|
      page.replace_html 'audio_area' , :partial => 'remove_audio'#, :locals => {student => @student}
      page.call 'leonid.movies.mediaShow'
    end
  end
  def delete_mp3
    @student = Student.find(params[:id])
    dir_path = File.join(Rails.root, "/public/audio/students/")
    audio_path = @student.assetsPath+(params[:mp3_nr].to_i+1).to_s+".mp3"
    file_path = File.join(dir_path, audio_path)
    File.delete(file_path)
    audio_paths = Dir.glob("**/#{@student.assetsPath}*").sort  #collect paths to left audios of this student
    for i in 0..audio_paths.length-1
      new_path = @student.assetsPath + (i+1).to_s + ".mp3"
      File.rename(audio_paths[i], File.join(dir_path, new_path))  #rename audio files from 1
    end
    @student.changeTitlesAndDates(params[:mp3_nr])
    @titles = @student.findTitles
    render :update do |page|
      page.replace_html 'audio_area' , :partial => 'remove_audio'
    end
  end
  def close_window
    render :update do |page|
      page.replace_html params[:div_id] , :partial => nil
      page.call 'leonid.movies.unloadBlanket'
    end
  end
################################### VIDEO ####################################  
  def play_video
    student = Student.find(params[:id])
    size = params[:size]
    size=="small" ? video_data = (student.assetsPath + ".3gp") : (video_data = student.assetsPath + ".m4v")
    video_info = {student.assetsPath.to_sym => find_video_info(student.vid_descr)}
    @video_title =  video_info[student.assetsPath.to_sym][:title]
    screenRatio = video_info[student.assetsPath.to_sym][:screenRatio]
    with = video_info[student.assetsPath.to_sym][:with]
    with.blank? ? with = "" : with = " - " + with
    piece = video_info[student.assetsPath.to_sym][:piece] + with
    render :update do |page|
      if params[:swf]
        page.call 'leonid.movies.unloadVideoPlayer'
      end
      page.replace_html 'video_area', :partial => 'student_video', 
                                      :locals => {:size => size, :student => student} #important to leave params[:video], so it's always .m4v for the reloads and changes
      page.assign 'leonid.movies.flashvars.fileName', ("/movies/" + size + "_" + video_data)
      page.assign 'leonid.movies.flashvars.videoInfoData', piece
      page.assign 'leonid.movies.flashvars.fileType', "video"
      page.assign 'leonid.movies.flashvars.movieSize', size
      page.assign 'leonid.movies.flashvars.screenRatio', screenRatio
      page.call 'leonid.movies.mediaShow'
      page.call 'setTimeout', 'leonid.movies.loadVideoPlayer()', 0
    end
  end
  def stop_video
    render :update do |page|
      page.call 'leonid.movies.unloadVideoPlayer'
      page.replace_html 'video_area' , :partial => nil
    end
  end
    
  private
  
  def generate_key
    if request.host.split('.')[-1]=="com"
      @key="ABQIAAAA8_riwuEK-oBLsNYAy0OPERQHfB-bd-dw6m1nw-8tkTAhRqVdehQrKPPlLvvILpKXcZ4Gccmt7F7xyQ"
    elsif request.host.split('.')[-1]=="eu"
      @key="ABQIAAAA8_riwuEK-oBLsNYAy0OPERSoSY2Aus7PGPhc2nDz92qDlEAOjBSwxxLVVlD0xchXtVlai7oqJGRPiw"
    elsif request.host.split('.')[-1]=="uk"
      @key="ABQIAAAA8_riwuEK-oBLsNYAy0OPERSPCxLXIOVlbh6FMK_xjTUHwKn9iRQjvXmeYpahAPnQuPpBJaZdR2YuFg"
    elsif request.host.split('.')[-1]=="de"
      @key="ABQIAAAA8_riwuEK-oBLsNYAy0OPERR2GJW_sxfdD5orBsyM8B48w2KgpBTgcIf1gRRmhYh8N2y83kaae3vZgA"
    else
      @key = "ABQIAAAA8_riwuEK-oBLsNYAy0OPERSoSY2Aus7PGPhc2nDz92qDlEAOjBSwxxLVVlD0xchXtVlai7oqJGRPiw"
    end
  end
  
  def calendar_variables(after_school)
     @month = params[:month].to_i
     @year = params[:year].to_i
     @shown_month = Date.civil(@year, @month)
     #@event_strips = Event.event_strips_for_month(@shown_month)
     @event_strips = Lesson.event_strips_for_month(@shown_month, 0, after_school)
  end

  def write_xml(student)
    url = "students/"+student.assetsPath
    titles = student.aud_titles.split(/###/)
    recDates = student.aud_recDate.split(/###/)
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
