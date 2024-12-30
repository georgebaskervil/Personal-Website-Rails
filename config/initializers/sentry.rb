Sentry.init do |config|
  config.dsn = "https://4d221d9051394eb28a0fb18f90954319@glitchtip-cs40w800ggw0gs0k804skcc0.geor.me/1"
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
end
