class ApplicationController < ActionController::Base
  include ShopifyApp::LoginProtection
  require 'csv'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  attr_accessor :session_data_all
end
