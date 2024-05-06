class Api::V0::SubscriptionsController < ApplicationController
  def create
    subscription = Subscription.new(subscription_params)
    if subscription.save!
      params[:teas].each do |tea_id|
        TeaSubscription.create!(tea_id: tea_id, subscription_id: subscription.id)
      end
      render json: SubscriptionSerializer.new(subscription), status: :created
    end
  end

  private
  def subscription_params
    params.permit(:title, :price, :frequency, :status, :customer_id)
  end
end