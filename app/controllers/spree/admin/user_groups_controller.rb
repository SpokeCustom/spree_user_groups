class Spree::Admin::UserGroupsController < Spree::Admin::ResourceController
  :resource_controller
  before_filter :load_data

  update do
    redirect_to edit_object_url
    wants.html
  end

  create do
    redirect_to edit_object_url
    wants.html
  end

  destroy do
    success do
      render_js_for_destroy
      wants.js
    end
  end

  def pricing
    if params[:tier]
      Spree::UserGroupsVariant.delete_all(:user_group_id => params[:id])
      params[:tier].each do |key, value|
        value.each do |tier|
          next if tier["price"] == '' || tier["minimum_quantity"].to_i <= 0 || tier["maximum_quantity"].to_i < 0
          Spree::UserGroupsVariant.create!(
            :user_group_id => params[:id],
            :variant_id => key,
            :price => tier["price"],
            :minimum_quantity => tier["minimum_quantity"],
            :maximum_quantity => tier["maximum_quantity"].to_i == 0 ? nil : tier["maximum_quantity"]
          )
        end
        flash.notice = Spree.t(:variant_pricing_updated_successfully)
      end
    end
  end
  
  private
  def build_object
    @object ||= end_of_association_chain.send((parent? ? :build : :new), object_params)
    @object.calculator = params[:user_group][:calculator_type].constantize.new if params[:user_group]
  end

  def load_data
    @calculators = Spree::UserGroup.calculators
  end
end
