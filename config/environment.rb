# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
# and I hope this is what I have achieved when rake rails:update after setting it here
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
############################# needs to be uncommented for lesson booking #############################
   config.gem "ri_cal", :version => ">= 0.8.5" #that's all that is needed, and then rake gems:unpack to freeze it into the app!
   config.gem "icalendar", :version => ">= 1.1.5" #that's all that is needed, and then rake gems:unpack to freeze it into the app!
######################################################################################################
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
   config.plugins = [ :event_calendar ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end
########## NOT RESOLVED, SO IF FREEZING GEMS INTO APP, THERE MAY BE A PROBLEM ##############
########## WHEN UPDATING TO 2.3.8, THE LATEST VERSION OF GEMSONRAILS WAS STILL 0.7.2 #######
#  updated to 2.3.8:
#  DEPRECATION WARNING: 
#  Rake tasks in vendor/plugins/event_calendar/tasks, 
#                vendor/plugins/gemsonrails/tasks, 
#                vendor/plugins/gemsonrails/tasks, 
#                vendor/plugins/gemsonrails/tasks, 
#             and vendor/plugins/gemsonrails/tasks are deprecated. 
#  Use lib/tasks instead. (called from /usr/local/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/rails.rb:10)
######## AS FAR AS I CAN SEE 2.3.8. NEEDS NEWER RUBY PATCH THAN AVAILABLE ON JOYENT  ####