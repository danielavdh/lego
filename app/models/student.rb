require 'digest/sha1'

class Student < ActiveRecord::Base
  validates_presence_of :firstname, :lastname, :email
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  validate :password_non_blank
  validate :valid_photo_format
  validate :valid_photo_size
  attr_accessor :composer
  attr_accessor :piece
  attr_accessor :audio_type
  attr_accessor :audio_file_extension
  validates_presence_of :composer, :piece, :if => :audioFile
  validate :valid_audio_format
  validate :valid_audio_file_extension
  validate :valid_audio_size
  validate :valid_title_and_composer
  
  composed_of :name,
              :class_name => "Name",
              :mapping => 
                 [ # database       ruby
                   %w[ firstname   first ],
                   %w[ lastname    last ] 
                 ]

  def self.authenticate(firstname, lastname, password)
    student = self.find_by_firstname_and_lastname(firstname, lastname)
    if student
      expected_password = encrypted_password(password, student.salt)
      if student.hashed_password != expected_password
        student = nil
      end
    end
    student
  end
  
  # 'password' is a virtual attribute
  def password
    @password
  end
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = Admin.encrypted_password(self.password, self.salt)
  end
  
  def picture=(picture_field)
    unless picture_field.blank?
      @file_size = File.size(picture_field)
    end
    #self.pic_name = base_part_of(picture_field.original_filename)
    self.pic_type = picture_field.content_type.chomp
    self.pic_data = picture_field.read
  end
  #def base_part_of(file_name)
  #  File.basename(file_name).gsub(/[^\w._-]/, '')
  #end
  
  def audioFile
    @audioFile
  end
  def audioFile=(bool)
    @audioFile = bool
  end
  def audio
  end
  def audio=(aud)
    self.composer = aud[0]
    self.piece = aud[1]
    self.audioFile = true unless aud[2].blank?
    unless aud[0].blank? || aud[1].blank? || aud[2].blank?
      @audio_file_size = File.size(aud[2])
      mp3_name = self.makeAudioFilename
      self.audio_type = aud[2].content_type.chomp #has to be audio/mpeg type file
      self.audio_file_extension = File.basename(aud[2].original_filename).gsub(/[^\w._-]/, '').split(/\./)[-1] #has to be mp3
      if self.valid?
        self.aud_titles += aud[0] + ", " + aud[1] + "###"
        audioData = aud[2].read
        File.open 'public/audio/students/'+ mp3_name +'.mp3', 'wb' do |f|
          f.write audioData
        end
      end
    end
  end
  def recording_date
  end
  def recording_date=(args)
    unless self.audio_type.blank?
      begin 
        recordingDate = Date.new(args[0].to_i, args[1].to_i, args[2].to_i)
      rescue
        recordingDate = Time.now.to_date
      end
      self.aud_recDate +=  recordingDate.to_s(:db) + "###"
    end
  end
  def makeAudioFilename
    number = self.findTitles.length + 1
    mp3_name = self.assetsPath + number.to_s
    mp3_name
  end

  def findTitles
    self.aud_titles.split(/###/)
  end
  def changeTitlesAndDates(nr)
    titles = self.aud_titles.split(/###/)
    titles.delete_at(nr.to_i)
    recDates = self.aud_recDate.split(/###/)
    recDates.delete_at(nr.to_i)
    if titles.length > 0
      self.aud_titles = titles.join("###") + "###"
      self.aud_recDate = recDates.join("###") + "###"
    else
      self.aud_titles = ""
      self.aud_recDate = ""
    end
    self.save
  end
  
  private
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def password_non_blank
    errors.add(:password, "Missing password" ) if hashed_password.blank?
  end

  def valid_photo_format
    unless self.pic_type.blank? || self.pic_type =~ /^image/
      errors.add(:picture, I18n.t("activerecord.errors.messages.only_pics"))
    end
  end
  def valid_photo_size
    if @file_size && @file_size > 15000
      errors.add(:picture, I18n.t("activerecord.errors.messages.pics_max_size"))
    end
  end

  def valid_audio_format
    unless (self.audio_type.blank? && self.piece.blank? && self.composer.blank?) || self.audio_type =~ /^audio\/mpeg/
      if (self.audio_type.blank?)
        errors.add(:audio, I18n.t("activerecord.errors.messages.no_audio"))
      else
        errors.add(:audio, I18n.t("activerecord.errors.messages.only_mp3_audio"))
      end
    end
  end
  def valid_audio_file_extension
    unless self.audio_file_extension.blank? || self.audio_file_extension == "mp3"
      errors.add(:audio, I18n.t("activerecord.errors.messages.only_mp3_audio"))
    end
  end
  def valid_audio_size
    if @file_size && @file_size > 12000000
      errors.add(:audio, I18n.t("activerecord.errors.messages.audio_size"))
    end
  end
  def valid_title_and_composer
    if @composer =~ /[^a-zA-Z0-9\.,\s]/ #/[[:punct:]]/
      errors.add(:composer, I18n.t("activerecord.errors.messages.title_and_composer"))
    end
    if @piece =~ /[^a-zA-Z0-9\.,\s]/ #/[[:punct:]]/
      errors.add(:piece, I18n.t("activerecord.errors.messages.title_and_composer"))
    end
  end

end

class Name
  attr_reader :first, :last

  def initialize(first, last)
    @first = first
    @last = last
  end

  def to_s
    [ @first, @last ].compact.join(" ")
  end
end

