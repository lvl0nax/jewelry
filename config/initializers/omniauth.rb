Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "u6cdMTFy7NlUofAiheP0w", "tWTVh5vLCdNFRrBKYC3xf1TOWdAii688jcBn5RsmEg"
  provider :vkontakte, "2770754", "f0WEYFYhMtXV1QWz1GXJ"
end