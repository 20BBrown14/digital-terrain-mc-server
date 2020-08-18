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
    Application.create(inGameName: application[:inGameName],
                       discordUsername: application[:discordUsername],
                       age: application[:age],
                       location: application[:location],
                       joinReason: application[:joinReason],
                       playStyle: application[:playStyle],
                       freeTime: application[:freeTime],
                       source: application[:source],
                       status: 'submitted'               
    )
    head 204
  end

  def load_apps
    filter = params[:applicationFilter]
    filteredApplications = Application.where('status = ?', filter)
    filteredApplications = JSON.parse(filteredApplications.to_json).each { |app| app['appID'] = app.delete('id') }
    render :json => filteredApplications
  end

  def update_app_status
    appID = params[:appID]
    newStatus = params[:newStatus]
    app_to_update = Application.find(appID)
    app_to_update.status = newStatus
    app_to_update.save
    head 204
  end

  def delete_app
    appID = params[:appID]
    app_to_delete = Application.find(appID)
    app_to_delete.destroy
    head 204
  end

  def get_images
    is_featured = params[:isFeatured]
    found_images = []
    Image.find_each do |image|
      found_images.push(image)
    end

    found_images.select! { |image| image.is_featured } if ActiveModel::Type::Boolean.new.cast(is_featured)
    
    signer = Aws::S3::Presigner.new

    found_images.each do |image|
      signed_url = signer.presigned_request(
        :get_object, bucket: ENV['S3_BUCKET'], key: "#{image.title}.png"
      )
      image.address = signed_url[0]
    end
    puts(found_images)
    render :json => found_images
  end
end
