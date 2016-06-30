Spree::Product.class_eval do
  def price_for_user(user)
    self.master.price_for_user(user)
  end
  
  def has_pricing_tiers?(user = Spree::User.current)
    user.try(:user_group).try(:has_pricing_tiers_for_variant?, self) || false
  end
  
  def pricing_tiers(user = Spree::User.current)
    user.try(:user_group).try(:pricing_tiers_for_variant, self) || []
  end
end
