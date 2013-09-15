class SocialMediaProfile < Struct.new(:name, :url, :catchphrase,:short_name)

  FACEBOOK    = self.new("Facebook", "http://www.facebook.com/transresourceus", "Find us on Facebook", "fb")
  TUMBLR      = self.new("Tumblr", "http://transresourceusa.tumblr.com", "Follow us on Tumblr", "tr" )
  TWITTER     = self.new("Twitter", "http://www.twitter.com/transresourceus", "Follow us on Twitter", "tw")
  GOOGLE_PLUS = self.new("Google+", "https://plus.google.com/111551895686856199646", "Follow us on Google+", "gp")
  YOUTUBE     = self.new("Youtube", "http://www.youtube.com/channel/UCJ_b34rhJHyNjcsogVzeQaA", "Watch our videos on YouTube", "yt")
  FLICKR      = self.new("Flickr", "http://www.flickr.com/photos/101741545@N05/", "Find us on Flickr", "fl")
  INSTAGRAM   = self.new("Instagram", "http://instagram.com/transresourceusa#", "Find us on Instagram", "in")

  def self.all
    [
        FACEBOOK,
        TUMBLR,
        TWITTER,
        GOOGLE_PLUS,
        YOUTUBE,
        FLICKR,
        INSTAGRAM
    ]
  end

end