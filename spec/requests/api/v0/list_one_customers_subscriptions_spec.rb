require "rails_helper"

RSpec.describe "GET /api/v0/customers/:customer_id/subscriptions" do
  let!(:customer) { Customer.create(first_name: "John", last_name: "Doe", email: "email@email.com", address: "123 4th Ave, Indianapolis, IN, 46259") }
  let!(:tea_1) { Tea.create(title: "Earl Grey", description: "great in the morning", temperature: 195, brew_time: 3.5) }
  let!(:tea_2) { Tea.create(title: "Green Tea", description: "soothing", temperature: 165, brew_time: 2) }
  let!(:tea_3) { Tea.create(title: "Chai Tea", description: "yes", temperature: 175, brew_time: 4) }

  before do
    @headers = {"Content_Type": "application/json", "Accept": "application/json"}
    @add_subscription_1 = { "teas": [tea_1.id, tea_2.id], "title": "Tea for Two", "price": 15, "frequency": "weekly", "status": "active" }
    @add_subscription_2 = { "teas": [tea_3.id], "title": "Par-tea!", "price": 10, "frequency": "monthly", "status": "active" }
    @cancel_subscription_2 = { "status": "cancelled" }
    post "/api/v0/customers/#{customer.id}/subscriptions", params: @add_subscription_1, headers: @headers
    post "/api/v0/customers/#{customer.id}/subscriptions", params: @add_subscription_2, headers: @headers
    patch "/api/v0/customers/#{customer.id}/subscriptions/#{Subscription.last.id}", params: @cancel_subscription_2, headers: @headers
  end

  it "lists all customer's subscriptions" do
    get "/api/v0/customers/#{customer.id}/subscriptions", headers: @headers
    expect(response.status).to eq 200

    subscriptions = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(subscriptions).to be_an Array
    expect(subscriptions.size).to eq 2
    expect(subscriptions).to all(include("type": "subscription"))
    expect(subscriptions[0][:attributes][:status]).to eq "active"
    expect(subscriptions[1][:attributes][:status]).to eq "cancelled"
  end

  it "requires valid customer id" do
    cancel_subscription_body = { "status": "cancelled" }
    patch "/api/v0/customers/0/subscriptions/#{Subscription.last.id}", params: cancel_subscription_body, headers: @headers
    expect(response.status).to eq 404
  end
end