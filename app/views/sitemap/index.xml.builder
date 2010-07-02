xml.instruct!
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
    for i in 0..@teaching.length-1
      @teaching[i].each do |action|
          xml.url do
            xml.loc url_for(:controller => :teaching, :action => action, :only_path => false)
            #xml.lastmod(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00"))
            xml.lastmod(@update)
            xml.changefreq('weekly')
          end
      end
    end
    for i in 0..@playing.length-1
      @playing[i].each do |action|
          xml.url do
            xml.loc url_for(:controller => :playing, :action => action, :only_path => false)
            #xml.lastmod(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00"))
            xml.lastmod(@update)
            xml.changefreq('weekly')
          end
      end
    end
end