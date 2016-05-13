Spree::Variant.class_eval do
  include ActionView::Helpers

  def price_for_user(user)
    user_group_price(user) || price_in('USD')
  end

  def price_in_with_user_group_pricing(currency)
    if variant_price = user_group_price
      Spree::Price.new(:amount => variant_price, :currency => currency)
    else
      price_in_without_user_group_pricing(currency)
    end
  end
  alias_method_chain :price_in, :user_group_pricing
  
  def tier_price quantity, user = Spree::User.current
    user.try(:user_group).try(:price_for_variant_quantity, self, quantity)
  end
  
  def has_pricing_tiers?(user = Spree::User.current)
    user.try(:user_group).try(:has_pricing_tiers_for_variant?, self) || false
  end
  
  def pricing_tiers(user = Spree::User.current)
    user.try(:user_group).try(:pricing_tiers_for_variant, self) || []
  end

  private

    def user_group_price(user = Spree::User.current)
      user.try(:user_group).try(:price_for_variant, self)
    end
end
