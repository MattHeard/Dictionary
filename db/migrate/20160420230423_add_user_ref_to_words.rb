class AddUserRefToWords < ActiveRecord::Migration
  def change
    add_reference :words, :user, index: true, foreign_key: true
  end
end
