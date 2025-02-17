if Rails.env.production?
  Sentry.init do |config|
    config.dsn = "https://3bb363a19fa84e9fb16b7af2e5ef1bf8@glitchtip-k8wwcks4kogokwkgok8k84os.geor.me/1"
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
  end
end
