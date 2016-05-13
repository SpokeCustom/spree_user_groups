class Spree::UserGroup < ActiveRecord::Base
  has_many :users, :dependent => :nullify
  validates :name, :presence => true
  has_many :user_groups_variants

  include Spree::CalculatedAdjustments
  
  def calculator_description
    return Spree.t(:none) if calculator.nil?
    calculator.description
  end

  def price_for_variant variant
    calculator.try(:compute_item, variant)
  end
  
  def price_for_variant_quantity variant, quantity
    calculator.try(:compute_item, variant, quantity)
  end
  
  def has_pricing_tiers_for_variant? variant
    tiers = pricing_tiers_for_variant(variant)
    return false if tiers == null || tiers.count == 0
    
    tiers.count > 1 || tiers.first.minimum_quantity > 1
  end
  
  def pricing_tiers_for_variant variant
    tiers = calculator.try(:compute_tiers, self, variant)
    tiers ||= []
  end
end
