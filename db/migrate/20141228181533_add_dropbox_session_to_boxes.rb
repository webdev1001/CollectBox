class AddDropboxSessionToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :dropbox_session, :text
  end
end
