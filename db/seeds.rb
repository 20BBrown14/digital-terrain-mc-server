# frozen_string_literal: true

require 'json'
require 'base64'

Rule.delete_all
ServerInformation.delete_all
AboutUs.delete_all
Veterans.delete_all
Image.delete_all

rules_json = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'rules.json')))
Rule.create(rules: rules_json)

server_information_json = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'serverInformation.json')))
ServerInformation.create(serverInformation: server_information_json)

about_us_information_json = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'aboutUsInformation.json')))
AboutUs.create(aboutUsInformation: about_us_information_json)

veterans_json = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'veteransInformation.json')))
Veterans.create(veteransInformation: veterans_json)

images = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'images.json')))
images.each do |image_url|
  title = image_url[54..-5]
  is_featured = title == 'Panda_Brah&DMDF_' || title == 'Community_Guardian_Farm' || title == 'Intimidatings_Nether_Base' || title == 'Spawn' || title == 'Nether_Portal'

  Image.create(address: image_url, title: title, is_featured: is_featured)
end