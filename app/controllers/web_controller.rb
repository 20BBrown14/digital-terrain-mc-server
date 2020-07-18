# frozen_string_literal: true

require 'httparty'
require 'uri'
require 'cgi'

# Web Controller
class WebController < ApplicationController
  def loggedin
    client_id = URI.encode_www_form([['client_id', '727970691089170534']])
    client_secret = URI.encode_www_form([['client_secret', 'vMkSAKS3xeI9M5mU9pBTLcPGTvTaJm6U']])
    grant_type = URI.encode_www_form([['grant_type', 'authorization_code']])
    code = URI.encode_www_form([['code', params[:code]]])
    puts(code)
    redirect_uri = URI.encode_www_form([['redirect_uri', 'http://localhost:3000/loggedin']])
    scope = URI.encode_www_form([['scope', 'identify guilds']])
    response = HTTParty.post("https://discord.com/api/v6/oauth2/token", {
      headers: {"Content-Type" => "application/x-www-form-urlencoded"},
      body: "#{client_id}&#{client_secret}&#{grant_type}&#{code}&#{redirect_uri}&#{scope}"
    })
    puts(response)
    puts(JSON.parse(response.body))
    puts(JSON.parse(response.body)["access_token"])

    response = HTTParty.get('https://discord.com/api/users/@me/guilds', {
      headers: {"Content-Type" => "application/json", "Authorization" => "Bearer #{JSON.parse(response.body)["access_token"]}" }
    })
    guilds = JSON.parse(response.body)
    is_dt_member = false;
    guilds.each do |guild|
      if guild["id"] == '682047180072419359'
        is_dt_member = true
      end
    end
    puts(is_dt_member)
    head 200
  end
end
