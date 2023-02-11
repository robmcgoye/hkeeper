require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

LISTS = YAML.load(File.read(File.expand_path('../lists.yml', __FILE__)))
LISTS.merge! LISTS.fetch(Rails.env, {})
LISTS.symbolize_keys!
CONFIG = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!

module Hkeeper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Eastern Time (US & Canada)"
    config.active_job.queue_adapter = :resque
    # config.eager_load_paths << Rails.root.join("extras")
    # Remove Rails field_with_errors wrapper *******
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
      html_tag.gsub("form-control", "form-control is-invalid").html_safe      
    end
  end
end
