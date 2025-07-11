if Rails.env.production?
  Sentry.init do |config|
    config.dsn = "https://9037f39780e6400bac586d00e38790dc@app.glitchtip.com/12062"
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
  end
end
