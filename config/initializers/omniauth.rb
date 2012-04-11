Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "", "",:scope => 'email,offline_access,read_stream', :display => 'popup'
  #provider :twitter, "tm22skFBlwk9wPZDSwQdA", "uFo7qpeiTNECsDPxW0nIgqa4Gt4iC6G0it6AYyvamw4",:scope => 'email,offline_access,read_stream', :display => 'popup'
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
end
