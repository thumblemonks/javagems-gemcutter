class AddReadmeToRubygems < ActiveRecord::Migration
  def self.up
    add_column :rubygems, :readme, :text
  end

  def self.down
    remove_column :rubygems, :readme
  end
end
