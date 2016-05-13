class Spree::Calculator::PerVariantPricing < Spree::Calculator
  def self.description
    Spree.t(:per_variant_pricing)
  end
  
  def description
    Spree.t(:per_variant_pricing)
  end
  
  def has_pricing_config
    true
  end

  def compute(object)

    return unless object.present? and object.line_items.present? and object.user.present? and object.user.user_group.present?

    item_total = object.line_items.map(&:amount).sum
    
    item_cost_price_total = object.line_items.map do |li| 
      (li.variant.price * li.quantity) - ((object.user.user_group.price_for_variant_quantity(li.variant, li.quantity) || li.variant.price) * li.quantity)
    end.sum
    
    0 - item_cost_price_total
  end
  
  def compute_item(variant, quantity = 1)
    ugv = Spree::User.current
        .user_group
        .user_groups_variants
        .where(variant: variant)
        .where("minimum_quantity <= ? AND (maximum_quantity >= ? OR maximum_quantity is null)", quantity, quantity)
        .order(minimum_quantity: :asc)
        .first
    ugv.try(:price) || variant.price_in_without_user_group_pricing('USD').amount
  end
  
  def compute_tiers(user_group, variant)
    user_group.user_groups_variants.where(variant: variant).order(minimum_quantity: :asc)        
  end
end
