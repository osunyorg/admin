class ChangeExtranetSsoTargetUrlKind < ActiveRecord::Migration[6.1]
  def change
    change_column :communication_extranets, :sso_target_url, :string, default: nil
  end
end
