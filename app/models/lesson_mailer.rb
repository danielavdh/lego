class LessonMailer < ActionMailer::Base
  

  def leonid_confirm(student, date, time, sent_at = Time.now)
    @student = student
    @date = date
    @time = time
    subject    'Lesson booked by ' + student.name.first
    if RAILS_ENV=="development"
      recipients 'webmaster@gorokhov.eu'
    elsif RAILS_ENV=="production"
      #recipients 'webmaster@gorokhov.eu'
      recipients 'leonid.gorokhov@gmail.com'
    end
    from       'webmaster@gorokhov.eu'
    sent_on    sent_at
    
    body       :greeting => 'Dear Leonid,'
    
    attachment :content_type => "text/calendar",
               :body => File.read("./lib/lessons/lessons.ics")
  end

  def leonid_cancel(student, date, time, sent_at = Time.now)
    @student = student
    @date = date
    @time = time
    subject    'Lesson cancelled by ' + student.name.first
    if RAILS_ENV=="development"
      recipients 'webmaster@gorokhov.eu'
    elsif RAILS_ENV=="production"
      #recipients 'webmaster@gorokhov.eu'
      recipients 'leonid.gorokhov@gmail.com'
    end
    from       'webmaster@gorokhov.eu'
    sent_on    sent_at
    
    body       :greeting => 'Dear Leonid,'
    
    attachment :content_type => "text/calendar",
               :body => File.read("./lib/lessons/lessons.ics")
  end

  def student_confirm(student, date, time, sent_at = Time.now)
    @student = student
    @date = date
    @time = time
    subject    I18n.t("lessons.email.subject.student_booked") + " " + date
    recipients student.email
    from       'webmaster@gorokhov.eu'
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def student_cancel(student, date, time, sent_at = Time.now)
    @student = student
    @date = date
    @time = time
    #I18n.locale = lang
    subject    I18n.t("lessons.email.subject.leonid_cancelled") + " " + date
    recipients  student.email
    from        'leonid.gorokhov@gmail.com'
    sent_on     sent_at
    
    body        :greeting => 'Hi,'
  end
  
  def student_added(student, password, sent_at = Time.now)
    @student = student
    @password = password
    subject    I18n.t("lessons.email.subject.student_added", {:name => student.name.first})
    recipients  student.email
    from       'webmaster@gorokhov.eu'
    sent_on     sent_at
    
    body        :greeting => 'Hi,'
  end
  
  def after_school_lesson_added(student, sent_at = Time.now)
    @student = student
    subject    'Unterrichtsstunden für Schulpflichtige'
    recipients  student.email
    from       'webmaster@gorokhov.eu'
    sent_on     sent_at
    
    body        :greeting => 'Hi,'
  end

end
