class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
    	t.string :screen_name
		t.string :description
		t.string :hostname, :index
		t.string :mac_adress
		t.string :broadcast_address
		t.string :ssh_username
		t.string :ssh_password
		t.string :ssh_shutdown_command
		t.integer :location_x
		t.integer :location_y

      t.timestamps
    end
  end
end
