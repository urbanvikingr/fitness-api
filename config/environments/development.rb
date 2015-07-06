Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you do not have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Do care if the mailer can not send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Store images on localhost with Paperclip
  Paperclip::Attachment.default_options[:path] = ":rails_root/public/system/:attachment/:class/:id/:style/:basename.:extension"
  Paperclip::Attachment.default_options[:url] = "/system/:attachment/:class/:id/:style/:basename.:extension"

  # Locate ImageMagick
  Paperclip.options[:command_path] = "/opt/local/bin/convert"
end
