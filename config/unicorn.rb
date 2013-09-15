after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    config = Rails.application.config.database_configuration[Rails.env]
    config['adapter'] = 'postgis'
    ActiveRecord::Base.establish_connection(config)
  end
end