class SubscriptionsController < ApplicationController
  def index
   @packages = Package.includes(:pricings)
  end
end
