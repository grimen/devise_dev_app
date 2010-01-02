class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.facebook_connectable
      
      t.authenticatable # OK, works when using FBC - but not tested the other way around.
      t.confirmable # OK, sort of - blank email passes. Should not be confirmed for FBC?
      t.recoverable
      t.rememberable
      t.trackable # OK
      
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
