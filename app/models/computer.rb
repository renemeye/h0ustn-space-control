class Computer < ActiveRecord::Base

	#attr_accessible :screen_name, :description, :hostname, :mac, :broadcast_address, :ssh_username, :password, :ssh_shutdown_command, :location

	def online
		return true
	end

end