class AddActivationToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :in_reply_to, :string
  end
end
