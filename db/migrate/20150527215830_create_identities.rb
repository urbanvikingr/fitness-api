class CreateIdentities < ActiveRecord::Migration
  def change
    create_table   :identities do |t|
      t.string     :email
      t.string     :password_digest
      t.timestamps
    end

    add_index :identities, :email, unique: true
  end
end
