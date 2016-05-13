class AddTiersUserGroups < ActiveRecord::Migration
  def self.up
    add_column :spree_user_groups_variants, :minimum_quantity, :int, :null => false, :default => 1
    add_column :spree_user_groups_variants, :maximum_quantity, :int, :null => true
  end

  def self.down
	  remove_column :spree_user_groups_variants, :minimum_quantity
	  remove_column :spree_user_groups_variants, :maximum_quantity
  end
end
