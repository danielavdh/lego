require 'icalendar'
require 'date'
class LessonsController < ApplicationController
before_filter :authorize, :except => [:show, :book_lesson, :cancel_lesson]
include Icalendar


  # GET /lessons
  # GET /lessons.xml
  def index
    @lessons = Lesson.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lessons }
    end
  end

  # GET /lessons/1
  # GET /lessons/1.xml
  def show
    @lesson = Lesson.find(params[:id])
    time = @lesson.start_at.in_time_zone('Europe/Berlin')
    #@date = time.day.to_s + " " + Date::MONTHNAMES[time.month] + " " + time.year.to_s
    @date = time.day.to_s + " " + I18n.t("date.month_names")[time.month] + " " + time.year.to_s
    @time = time.to_s(:time)
    @student = Student.find_by_id(session[:student_id])
    @admin = Admin.find_by_id(session[:user_id])
    @month = time.month
    @year = time.year

    if @student.blank? && @admin.blank?
      redirect_to(:controller => :teaching, :action => :studentzone)
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @lesson }
      end
    end
  end

  # GET /lessons/new
  # GET /lessons/new.xml
  def new
    @day = params[:day].to_i
    @month = params[:month].to_i
    @year = params[:year].to_i
    @date = @day.to_s + " " + Date::MONTHNAMES[@month] + " " + @year.to_s

    #@lesson = Lesson.new

    respond_to do |format|
      format.html # new.html.erb
      #format.xml  { render :xml => @lesson }
    end
  end

  # GET /lessons/1/edit
  def edit
    @lesson = Lesson.find(params[:id])
  end

  def book_lesson
    @student = Student.find_by_id(session[:student_id])
    if @student.blank?
      redirect_to(:controller => :teaching, :action => :studentzone)
    else
      @lesson = Lesson.find(params[:id])
      @lesson.color = "#cc0000"
      @lesson.name = @lesson.start_at.in_time_zone('Europe/Berlin').to_s(:time) + " " + @student.firstname + " " + @student.lastname + " " + session[:locale].to_s
      @lesson.save
      @date = @lesson.start_at.day.to_s + " " + I18n.t("date.month_names")[@lesson.start_at.month.to_i] + " " + @lesson.start_at.year.to_s
      @time = @lesson.start_at.in_time_zone('Europe/Berlin').to_s(:time)
      booking_email_to_leonid(@student, @date, @time, @lesson)
      booking_email_to_student(@student, @date, @time)
      redirect_to(:controller => :teaching, :action => :studentzone, :year => params[:year], :month => params[:month])
    end
  end

  def cancel_lesson
    @student = Student.find_by_id(session[:student_id])
    if @student.blank?
      redirect_to(:controller => :teaching, :action => :studentzone)
    else
      @lesson = Lesson.find(params[:id])
      if @student.name.to_s == @lesson.name.split()[1..-2].join(" ")
        @lesson.color = "#2E8B57"
        @lesson.name = @lesson.start_at.in_time_zone('Europe/Berlin').to_s(:time)
        @lesson.save
        @date = @lesson.start_at.day.to_s + " " + I18n.t("date.month_names")[@lesson.start_at.month.to_i] + " " + @lesson.start_at.year.to_s
        @time = @lesson.start_at.in_time_zone('Europe/Berlin').to_s(:time)
        cancellation_email_to_leonid(@student, @date, @time, @lesson)
      else
        flash[:not_your_lesson] = "You can't cancel somebody else's lesson"
      end
      redirect_to(:controller => :teaching, :action => :studentzone, :year => params[:year], :month => params[:month])
    end
  end

  # POST /lessons
  # POST /lessons.xml
  def create
    @day = params[:day]
    @month = params[:month]
    @year = params[:year]
    @date = @day + " " + Date::MONTHNAMES[@month.to_i] + " " + @year
    lessons = Array.new
    dayandtime = Array.new
    lesson_objects = Array.new
    t = Array.new
    for i in 0..9
      unless params[("hour"+i.to_s).to_sym] == "hrs"
        if params[("min"+i.to_s).to_sym] == "mins"
          params[("min"+i.to_s).to_sym] = "00"
        end
        lessons[i] = {:hour => params[("hour"+i.to_s).to_sym], :min => params[("min"+i.to_s).to_sym]}
        #dayandtime[i] = Time.local_time(@year.to_i, @month.to_i, @day.to_i, (lessons[i][:hour]).to_i, (lessons[i][:min]).to_i)
        t[i] = DateTime.civil(@year.to_i, @month.to_i, @day.to_i, (lessons[i][:hour]).to_i, (lessons[i][:min]).to_i)
        if Time.utc(t[i].year, t[i].month, t[i].day, t[i].hour, t[i].min).in_time_zone("Europe/Berlin").dst?
          t[i] = Time.utc(t[i].year, t[i].month, t[i].day, t[i].hour-2, t[i].min)
        else
          t[i] =Time.utc(t[i].year, t[i].month, t[i].day, t[i].hour-1, t[i].min)
        end
        lesson_objects.push({:name => t[i].in_time_zone("Europe/Berlin").to_s(:time),
                            :start_at => t[i].to_formatted_s(:db),
                            :end_at =>  (t[i] + (60*60)).to_formatted_s(:db),
                            :color => "#2E8B57"})
        #lesson_objects.push({:name => dayandtime[i].to_s(:time),
        #                    :start_at => dayandtime[i].utc.to_formatted_s(:db),
        #                    :end_at =>  (dayandtime[i] + (60*60)).utc.to_formatted_s(:db),
        #                    :color => "#2E8B57"})
      end
    end
    lessons_object = Lesson.create(lesson_objects)
    recently_created_lessons = Lesson.find(:all).find_all{|l| l.created_at.to_datetime >= Time.now-7200}
    recently_created_after_school_lessons = recently_created_lessons.find_all{|t| t.start_at.to_datetime.hour > 14 || (t.start_at.to_datetime.hour > 13 && t.start_at.to_datetime.min > 29)}
    new_lessons_after_1530 = lesson_objects.find_all{|t| t[:start_at].to_datetime.hour > 14 || (t[:start_at].to_datetime.hour > 13 && t[:start_at].to_datetime.min > 29)}
    if new_lessons_after_1530.length > 0 && recently_created_after_school_lessons.length <= new_lessons_after_1530.length
      students = Student.find(:all).find_all{|s| s.after_school==true}
      students.each do |student|
        email_school_children(student)
      end
    end
          
    redirect_to(:controller => "teaching", :action => "studentzone", :year => @year, :month => @month)

  end

  # PUT /lessons/1
  # PUT /lessons/1.xml
  def update
    @lesson = Lesson.find(params[:id])

    respond_to do |format|
      if @lesson.update_attributes(params[:lesson])
        flash[:notice] = 'Lesson was successfully updated.'
        format.html { redirect_to(@lesson) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lesson.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.xml
  def destroy
    @month = params[:month]
    @year = params[:year]
    @lesson = Lesson.find(params[:id])
    I18n.locale = lang = @lesson.name.split()[-1].to_s
    date = @lesson.start_at.day.to_s + " " + I18n.t("date.month_names")[@lesson.start_at.month.to_i].to_s + " " + @lesson.start_at.year.to_s
    #time = @lesson.start_at.localtime.to_s(:time)
    time = @lesson.start_at.in_time_zone("Europe/Berlin").to_s(:time)
    students = Student.find(:all)
    student = students.detect{|i| i.name.to_s == @lesson.name.split()[1..-2].join(" ")}
    if student
      cancellation_email_to_student(student, date, time)
    end
    @lesson.destroy

    respond_to do |format|
      if Admin.find_by_id(session[:user_id]).name == "leonid"
        format.html { redirect_to(:controller => :teaching, :action => :studentzone, :year => @year, :month => @month) }
      else
        format.html { redirect_to(lessons_url) }
        format.xml  { head :ok }
      end
    end
  end
  
  private

  def booking_email_to_leonid(student, date, time, lesson)
    email = LessonMailer.create_leonid_confirm(student, date, time)
    email.set_content_type("text/html" )
    write_single_ics_file(lesson, student)
    LessonMailer.deliver_leonid_confirm(student, date, time)
    #render(:text => "Thank you..." )
  end
  
  def booking_email_to_student(student, date, time)
    email = LessonMailer.create_student_confirm(student, date, time)
    email.set_content_type("text/html" )
    LessonMailer.deliver_student_confirm(student, date, time)
  end

  def cancellation_email_to_student(student, date, time)
    email = LessonMailer.create_student_cancel(student, date, time)
    email.set_content_type("text/html" )
    LessonMailer.deliver_student_cancel(student, date, time)
    #render(:text => "Thank you..." )
  end
  
  def cancellation_email_to_leonid(student, date, time, lesson)
    email = LessonMailer.create_leonid_cancel(student, date, time)
    email.set_content_type("text/html" )
    write_cancellation_ics_file(lesson, student)
    LessonMailer.deliver_leonid_cancel(student, date, time)
    #render(:text => "Thank you..." )
  end
  
  def email_school_children(student)
    email = LessonMailer.create_after_school_lesson_added(student)
    email.set_content_type("text/html" )
    LessonMailer.deliver_after_school_lesson_added(student)
  end
  
  def write_single_ics_file(lesson, student)
    cal = Calendar.new
    cal.ip_method             "ADD"
    #cal.timezone do
    #  timezone_id             "Europe/Berlin"
    #  
    #  daylight do
    #    timezone_offset_from  "+0100"
    #    timezone_offset_to    "+0200"
    #    timezone_name         "GMT+02:00"
    #    dtstart               "19810329T020000"
    #    add_recurrence_rule   "FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU"
    #  end
    #  
    #  standard do
    #    timezone_offset_from  "+0200"
    #    timezone_offset_to    "+0100"
    #    timezone_name         "GMT+01:00"
    #    dtstart               "19961027T030000"
    #    add_recurrence_rule   "FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU"
    #  end
    #end
    cal.event do
      created      Time.now.to_s
      description  lesson.name.split()[0].to_s + " Central European Time, " + lesson.name.split()[1..-2].join(" ")
      dtstamp      Time.now
      dtstart      DateTime.parse(lesson.start_at.in_time_zone("Europe/Berlin").to_s), {:TZID => "Europe/Berlin"}
      dtend        DateTime.parse(lesson.end_at.in_time_zone("Europe/Berlin").to_s), {:TZID => "Europe/Berlin"}
      location     "Hannover"
      organizer    "Leonid Gorokhov"
      priority     0
      summary      student.name.to_s
      uid          student.name.to_s + " uiditem " + lesson.start_at.to_s
      add_attendee student.name.to_s
      url          'http://www.gorokhov.eu/teaching/studentzone'
    end
    cal.publish
    lesson_calendar = cal.to_ical
    puts lesson_calendar
    File.open './lib/lessons/lessons.ics', 'w' do |f|
      f.write lesson_calendar
    end
    #headers['Content-Type'] = "text/calendar; charset=UTF-8"
    #render(:text => cal.to_ical)
  end
  
  def write_cancellation_ics_file(lesson, student)
    cal = Calendar.new
    cal.ip_method       "CANCEL"
    cal.timezone do
      timezone_id       "Europe/Berlin"
    end
    cal.event do
      status            "CANCELLED"
      dtstart           DateTime.parse(lesson.start_at.to_s)
      dtend             DateTime.parse(lesson.end_at.to_s)
      summary           student.name.to_s
      description       lesson.name.split()[0..-2].join(" ")
      location          "Hannover"
      add_attendee      student.name.to_s
      uid               student.name.to_s + " uiditem " + lesson.start_at.to_s
    end
    lesson_calendar = cal.to_ical
    #cal.publish
    File.open './lib/lessons/lessons.ics', 'w' do |f|
      f.write lesson_calendar
    end
  end      

  def write_all_ics_file
    lessons = Event.find(:all)
    lesson_calendar = RiCal.Calendar do |cal|
      for i in 0..lessons.length-1
        cal.event do |event|
          event.description = lessons[i].name
          event.dtstart =  DateTime.parse(lessons[i].start_at.to_s)
          event.dtend = DateTime.parse(lessons[i].end_at.to_s)
          event.location = "Hannover"
          event.add_attendee "name of student"
          event.alarm do
            description "Segment 51"
          end
        end
      end
    end
    File.open './lib/lessons/lessons.ics', 'w' do |f|
      f.write 'X-WR-TIMEZONE:Europe/London\nBEGIN:VTIMEZONE\nTZID:Europe/London\nBEGIN:DAYLIGHT\nTZOFFSETFROM:+0000\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\nDTSTART:19810329T010000\nTZNAME:GMT+01:00\nTZOFFSETTO:+0100\nEND:DAYLIGHT\nBEGIN:STANDARD\nTZOFFSETFROM:+0100\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\nDTSTART:19961027T020000\nTZNAME:GMT\nTZOFFSETTO:+0000\nEND:STANDARD\nEND:VTIMEZONE'+lesson_calendar
    end
  end

end
