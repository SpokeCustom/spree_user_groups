Spree::Variant.class_eval do
  include ActionView::Helpers

  def price_for_user(user)
    user_group_price(user) || price_in('USD')
  end

  def price_in_with_user_group_pricing(currency)
    if variant_price = user_group_price
      Spree::Price.new(:amount => variant_price, :currency => "USD")
    else
      price_in_without_user_group_pricing(currency)
    end
  end
  alias_method_chain :price_in, :user_group_pricing

  private

    def user_group_price(user = Spree::User.current)
      user.try(:user_group).try(:price_for_variant, self)
    end
end
