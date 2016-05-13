class Spree::UserGroupsVariant < ActiveRecord::Base
  belongs_to :variant
  belongs_to :user_group
  
  def range
    return_string = "#{minimum_quantity}"
    return_string += maximum_quantity.nil? ? "+" : " - #{maximum_quantity}"
    return_string
  end
  
  def display_price currency
    Spree::Price.new(:amount => price, :currency => currency).display_price
  end
end
