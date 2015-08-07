Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis5.locum.ru:6379' }
end
Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis5.locum.ru:6379' }
end
