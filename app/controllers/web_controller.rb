# frozen_string_literal: true

require 'json'

# Web Controller
class WebController < ApplicationController

  skip_before_action :verify_authenticity_token

  def show
  end

  def get_server_rules
    rules_json = Rule.first.rules
    render :json => rules_json
  end

  def get_server_information
    server_information_json = ServerInformation.first.serverInformation
    render :json => server_information_json
  end

  def get_about_us_information
    about_us_json = AboutUs.first.aboutUsInformation
    render :json => about_us_json
  end

  def get_veterans_information
    veterans_information = Veterans.first.veteransInformation
    render :json => veterans_information
  end

  def save
    json_type_to_save = params[:JSONTypeToSave]
    json_to_save = params[:JSON]
    case json_type_to_save
    when 'rules'
      rules_json = Rule.first
      rules_json.rules = json_to_save
      rules_json.save
    when 'serverInformation'
      server_information_json = ServerInformation.first
      server_information_json.serverInformation = json_to_save
      server_information_json.save
    when 'aboutUsInformation'
      about_us_information_json = AboutUs.first
      about_us_information_json.aboutUsInformation = json_to_save
      about_us_information_json.save
    when 'veteransInformation'
      veterans_information_json = Veterans.first
      veterans_information_json.veteransInformation = json_to_save
      veterans_information_json.save
    else
      head 400
    end
    render :json => json_to_save
  end

  def submit_application
    application = params[:applicationInformation]
    Application.create(inGameName: params[:inGameName],
                       discordUsername: params[:discordUsername],
                       age: params[:age],
                       location: params[:location],
                       joinReason: params[:joinReason],
                       playStyle: params[:playStyle],
                       freeTime: params[:freeTime],
                       source: params[:source]                    
    )
    head 204
  end
end
