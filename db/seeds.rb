# frozen_string_literal: true

require 'json'

Rule.delete_all
ServerInformation.delete_all
AboutUs.delete_all
Veterans.delete_all

rules_json = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'rules.json')))
Rule.create(rules: rules_json)

server_information_json = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'serverInformation.json')))
ServerInformation.create(serverInformation: server_information_json)

about_us_information_json = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'aboutUsInformation.json')))
AboutUs.create(aboutUsInformation: about_us_information_json)

veterans_json = JSON.parse(File.read(Rails.root.join('lib', 'seeds', 'veteransInformation.json')))
Veterans.create(veteransInformation: veterans_json)