# Strange as it may seem this is the order that gets the html minifier
# to run before the deflater and brotli because middlewares are,
# unintuitively, run as a stack from the bottom up.
Rails.application.config.middleware.use Rack::Deflater, include: %w[text/html application/javascript text/css], sync: false
Rails.application.config.middleware.use Rack::Brotli, quality: 11, include: %w[text/html application/javascript text/css], deflater: { lgwin: 22, lgblock: 0, mode: :text }, sync: false

# this option set is from the default readme of htmlcompressor
Rails.application.config.middleware.use HtmlCompressor::Rack,
  enabled: true,
  remove_spaces_inside_tags: true,
  remove_multi_spaces: true,
  remove_comments: true,
  remove_intertag_spaces: false,
  remove_quotes: false,
  compress_css: false,
  compress_javascript: false,
  simple_doctype: false,
  remove_script_attributes: false,
  remove_style_attributes: false,
  remove_link_attributes: false,
  remove_form_attributes: false,
  remove_input_attributes: false,
  remove_javascript_protocol: false,
  remove_http_protocol: false,
  remove_https_protocol: false,
  preserve_line_breaks: false,
  simple_boolean_attributes: false,
  compress_js_templates: false

# We insert the emoji middleware here so that it precedes
# the html minifier but still avoids unnecessary work
Rails.application.config.middleware.use EmojiReplacer
