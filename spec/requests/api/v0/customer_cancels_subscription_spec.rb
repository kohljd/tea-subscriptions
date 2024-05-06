require "rails_helper"

RSpec.describe "PATCH /api/v0/customers/:customer_id/subscriptions/:id" do
  let!(:customer) { Customer.create(first_name: "John", last_name: "Doe", email: "email@email.com", address: "123 4th Ave, Indianapolis, IN, 46259") }
  let!(:tea_1) { Tea.create(title: "Earl Grey", description: "great in the morning", temperature: 195, brew_time: 3.5) }
  let!(:tea_2) { Tea.create(title: "Green Tea", description: "soothing", temperature: 165, brew_time: 2) }

  before do
    @headers = {"Content_Type": "application/json", "Accept": "application/json"}
    @add_subscription_body = { "teas": [tea_1.id, tea_2.id], "title": "Tea for Two", "price": 15, "frequency": "weekly", "status": "active" }
    post "/api/v0/customers/#{customer.id}/subscriptions", params: @add_subscription_body, headers: @headers
  end

  it "cancels customer subscription" do
    cancel_subscription_body = { "status": "cancelled" }
    patch "/api/v0/customers/#{customer.id}/subscriptions/#{Subscription.last.id}", params: cancel_subscription_body, headers: @headers
    expect(response.status).to eq 200
    
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
    expect(attributes[:status]).to eq "cancelled"
  end

  it "requires valid customer id" do
    cancel_subscription_body = { "status": "cancelled" }
    patch "/api/v0/customers/0/subscriptions/#{Subscription.last.id}", params: cancel_subscription_body, headers: @headers
    expect(response.status).to eq 404
  end

  it "requires valid subscription id" do
    cancel_subscription_body = { "status": "cancelled" }
    patch "/api/v0/customers/#{customer.id}/subscriptions/#{Subscription.last.id + 1}", params: cancel_subscription_body, headers: @headers
    expect(response.status).to eq 404
  end

  it "requires subscription status" do
    cancel_subscription_body = { "status": "" }
    patch "/api/v0/customers/#{customer.id}/subscriptions/#{Subscription.last.id}", params: cancel_subscription_body, headers: @headers
    expect(response.status).to eq 400
  end
end