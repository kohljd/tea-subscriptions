require "rails_helper"

RSpec.describe "POST /api/v0/customers/:customer_id/subscriptions" do
  let!(:customer) { Customer.create(first_name: "John", last_name: "Doe", email: "email@email.com", address: "123 4th Ave, Indianapolis, IN, 46259") }
  let!(:tea_1) { Tea.create(title: "Earl Grey", description: "great in the morning", temperature: 195, brew_time: 3.5) }
  let!(:tea_2) { Tea.create(title: "Green Tea", description: "soothing", temperature: 165, brew_time: 2) }

  it "creates new customer subscription" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "teas": [tea_1.id, tea_2.id],
      "title": "Tea for Two",
      "price": 15,
      "frequency": "weekly",
      "status": "active"
    }

    post "/api/v0/customers/#{customer.id}/subscriptions", params: body, headers: headers
    expect(response.status).to eq 201
    
    subscription = JSON.parse(response.body, symbolize_names: true)[:data]
    teas = JSON.parse(response.body, symbolize_names: true)[:data][:relationships][:teas][:data]
    expect(subscription[:type]).to eq "subscription"
    expect(teas).to be_an Array
    expect(teas.size).to eq 2
    expect(teas).to all(include("type": "tea"))

    attributes = subscription[:attributes]
    expect(attributes[:title]).to eq "Tea for Two"
    expect(attributes[:price]).to eq 15.0
    expect(attributes[:frequency]).to eq "weekly"
    expect(attributes[:status]).to eq "active"
  end

  xit "requires valid customer id" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "teas": [tea_1.id, tea_2.id],
      "title": "Tea for Two",
      "price": 15,
      "frequency": "weekly",
      "status": "active"
    }

    post "/api/v0/customers/0/subscriptions", params: body, headers: headers
    expect(response.status).to eq 404
  end

  xit "requires valid tea id's" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "teas": [0],
      "title": "Tea for Two",
      "price": 15,
      "frequency": "weekly",
      "status": "active"
    }

    post "/api/v0/customers/#{customer.id}/subscriptions", params: body, headers: headers
    expect(response.status).to eq 404
  end

  xit "customer can't have duplicate subscription" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "teas": [tea_1.id, tea_2.id],
      "title": "Tea for Two",
      "price": 15,
      "frequency": "weekly",
      "status": "active"
    }

    post "/api/v0/customers/#{customer.id}/subscriptions", params: body, headers: headers
    expect(response.status).to eq 201

    post "/api/v0/customers/#{customer.id}/subscriptions", params: body, headers: headers
    expect(response.status).to eq 422
  end

  xit "requires valid subscription data" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "teas": [tea_1.id, tea_2.id],
      "title": "",
      "price": "",
      "frequency": "",
      "status": ""
    }

    post "/api/v0/customers/#{customer.id}/subscriptions", params: body, headers: headers
    expect(response.status).to eq 400
  end

  xit "requires at least 1 tea to be given" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "teas": [],
      "title": "Tea for Two",
      "price": 15,
      "frequency": "weekly",
      "status": "active"
    }

    post "/api/v0/customers/#{customer.id}/subscriptions", params: body, headers: headers
    expect(response.status).to eq 400
  end
end