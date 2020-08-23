# frozen_string_literal: true

require 'json'

# Web Controller
class WebController < ApplicationController

  skip_before_action :verify_authenticity_token

  def show
    render 'authenticated'
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
    return head 401 unless authorize_admin_request
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
    return head 401 unless authorize_admin_request
    filter = params[:applicationFilter]
    filteredApplications = Application.where('status = ?', filter)
    filteredApplications = JSON.parse(filteredApplications.to_json).each { |app| app['appID'] = app.delete('id') }
    render :json => filteredApplications
  end

  def update_app_status
    return head 401 unless authorize_admin_request
    appID = params[:appID]
    newStatus = params[:newStatus]
    app_to_update = Application.find(appID)
    app_to_update.status = newStatus
    app_to_update.save
    head 204
  end

  def delete_app
    return head 401 unless authorize_admin_request
    appID = params[:appID]
    app_to_delete = Application.find(appID)
    app_to_delete.destroy
    head 204
  end

  def get_images
    isFeatured = params[:isFeatured]

    found_images = []
    Image.find_each do |image|
      found_images.push(image)
    end

    found_images.select! { |image| image.isFeatured } if ActiveModel::Type::Boolean.new.cast(isFeatured)
    
    signer = Aws::S3::Presigner.new

    found_images.each do |image|
      signed_url = signer.presigned_request(
        :get_object, bucket: ENV['S3_BUCKET'], key: image.key
      )
      image.address = signed_url[0]
    end
    render :json => found_images
  end

  def delete_image
    return head 401 unless authorize_admin_request
    image_id = params[:imageID]
    image_to_delete = Image.find(image_id)
    s3 = Aws::S3::Resource.new
    s3.bucket(ENV['S3_BUCKET']).object(image_to_delete.key).delete()
    image_to_delete.destroy
    head 204
  end

  def toggle_featured_image
    return head 401 unless authorize_admin_request
    image_id = params[:imageID]
    image_to_delete = Image.find(image_id)
    image_to_delete.isFeatured = !image_to_delete.isFeatured
    image_to_delete.save
    head 204
  end

  def upload_image
    return head 401 unless authorize_admin_request
    file = params[:file]
    split_file_name = file.original_filename.split('.')
    extension = split_file_name[split_file_name.length - 1]
    image_title = file.original_filename[0..(-(extension.length + 2))]
    s3 = Aws::S3::Resource.new
    obj = s3.bucket(ENV['S3_BUCKET']).object(file.original_filename)
    file.open()
    obj.upload_file(file.path) do |response|
      file.close()
    end
    Image.create(address: '',
                 title: image_title,
                 isFeatured: false,
                 key: file.original_filename
     
    )
    head 204
  end

  def logged_in
    client_id = URI.encode_www_form([['client_id', '693123471210709072']])
    client_secret = URI.encode_www_form([['client_secret', ENV['DISCORD_CLIENT_SECRET']]])
    grant_type = URI.encode_www_form([['grant_type', 'authorization_code']])
    code = URI.encode_www_form([['code', params[:code]]])
    redirect_uri = URI.encode_www_form([['redirect_uri', "#{ENV['DISCORD_AUTH_CALLBACK_DOMAIN']}/loggedin"]])
    scope = URI.encode_www_form([['scope', 'identify guilds']])
    response = HTTParty.post("https://discord.com/api/v6/oauth2/token", {
      headers: {"Content-Type" => "application/x-www-form-urlencoded"},
      body: "#{client_id}&#{client_secret}&#{grant_type}&#{code}&#{redirect_uri}&#{scope}"
    })

    user_guilds_response = HTTParty.get('https://discord.com/api/users/@me/guilds', {
      headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{JSON.parse(response.body)["access_token"]}" }
    })
    user_guilds = JSON.parse(user_guilds_response.body)

    user_id_response = HTTParty.get('https://discord.com/api/users/@me', {
      headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{JSON.parse(response.body)["access_token"]}" }
    })
    user_id = JSON.parse(user_id_response.body)['id']

    dt_member_response = HTTParty.get("https://discord.com/api/guilds/#{ENV['DT_GUILD_ID']}/members/#{user_id}", {
      headers: {"Content-Type" => "application/json", "Authorization" => "Bot #{ENV['DISCORD_BOT_TOKEN']}" }
    })
    dt_member = JSON.parse(dt_member_response.body) if dt_member_response.body

    if(dt_member.key?('code'))
      # member does not exist
      render 'authenticated'
      return
    end
    @discord_nick = dt_member['nick'] || dt_member['user']['username']
    if(dt_member['roles'].include?(ENV['DISCORD_WEB_ADMIN_ROLE']))
      @is_admin = true
    else
      @is_admin = false
    end
    user = User.find_by(discord_id: user_id)
    if !user
      new_user = User.create(is_admin: @is_admin, discord_id: user_id)
      new_user.save
    end
    @token = JsonWebToken.encode(user_id: user_id)
    # @exp_time = Time.now + 24.hours.to_i
    render 'authenticated'
  end

  def authorize_admin_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(header)
      current_user = User.find_by(discord_id: decoded[:user_id])
      return current_user.is_admin
    rescue ActiveRecord::RecordNotFound => e
      return false
    rescue JWT::DecodeError => e
      return false
    end
  end
end
