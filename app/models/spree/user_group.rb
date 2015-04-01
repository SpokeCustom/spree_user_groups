class Spree::UserGroup < ActiveRecord::Base
  has_many :users, :dependent => :nullify
  validates :name, :presence => true
  has_many :user_groups_variants
  has_many :variants, :through => :user_groups_variants

  include Spree::CalculatedAdjustments
  
  def calculator_description
    return Spree.t(:none) if calculator.nil?
    calculator.description
  end

  def price_for_variant variant
    calculator.try(:compute_item, variant)
  end
end
