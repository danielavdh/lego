module TeachingHelper

    #def month_link(month_date)
    #  #link_to(month_date.strftime("%B"), {:month => month_date.month, :year => month_date.year})
    #  link_to(I18n.t('date.month_names')[month_date.month], {:month => month_date.month, :year => month_date.year})
    #end
    #
    ## custom options for this calendar
    #def event_calendar_options
    #  { 
    #    :year => @year,
    #    :month => @month,
    #    #next line is a hack. we always use short form (calendar_helper 108), so this abbrev should be whole length (in original defaults is 0..2)
    #    :abbrev => (0..-1),
    #    :event_strips => @event_strips,
    #    :event_width => 120,
    #    :month_name_text => I18n.t('date.month_names')[@shown_month.month] + ' ' + @shown_month.strftime("%Y"),
    #    #:month_name_text => @shown_month.strftime("%B %Y"),
    #    :previous_month_text => "<< " + month_link(@shown_month.prev_month),
    #    :next_month_text => month_link(@shown_month.next_month) + " >>"
    #  }
    #end
    #
    #def event_calendar
    #  calendar event_calendar_options do |event|
    #    "<a href='/lessons/#{event.id}' title=\"#{h(event.name)}\"><div>#{h(event.name)}</div></a>"
    #  end
    #end
    
    def find_video_info(video)
      video = video.split(/###/).collect{|x| x.strip}
      keys = video.collect{|t| t.split('=>')[0][1..-1]}
      h = Hash.new
      keys.each do |k|
        if k=="recDate"
          v = video.find{|t| t=~/#{k}/}.split('=>')[-1].split(',').collect{|d| d.to_i}
          h[:recDate] = Date.new(v[0], v[1], v[2])
        else
          h[k.to_sym] = video.find{|t| t=~/#{k}/}.split('=>')[-1]
        end
      end
      return h
  end
  
end
