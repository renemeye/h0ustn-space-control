require 'timeout'
require 'timeout'
require 'socket'
require 'Wol'
require 'net/ssh'

class WakeOnLanController < ApplicationController

	def show
		@server = {:hostname => "hegel", :status=>"offline"}

		if WakeOnLanController::ping(@server[:hostname])
			@server[:status] = "online"
		end

		respond_to do |format|
			 # format.html
			format.xml { render :xml => @server.to_xml }
			format.json { render :json => @server.to_json }
		end
	end

	def create
		@server = {:hostname => "hegel", :mac=>"00:30:1b:b2:af:da", :address=>"172.22.163.255", :message=>""}
		@wol = Wol::WakeOnLan.new(:mac => @server[:mac], :address => @server[:address])
		@server[:message] = @wol.wake
		respond_to do |format|
			 # format.html
			format.xml { render :xml => @server.to_xml }
			format.json { render :json => @server.to_json }
		end
	end

  	def destroy
  		@server = {:hostname => "hegel", :mac=>"00:30:1b:b2:af:da", :address=>"172.22.163.255", :message=>"", :username=>"netz39", :password=>"MarvinIsHappy", :output=>""}
		begin
  			Net::SSH.start(@server[:hostname], @server[:username], :password => @server[:password], :timeout => 0.1) do |ssh|
		  		ssh.exec!("yes hegel | sudo shutdown -h now") do |channel, stream, data|
    				@server[:output] << data if stream == :stdout
  				end
		  	end
		rescue Errno::ETIMEDOUT
			#This is normal behavior becaus the ssh connection will be closed be remote host in case of shutdown
			@server[:output] << "\nTimeout!"
		rescue Errno::ECONNREFUSED
			@server[:output] << "\nConnection refused"
		rescue Errno::EHOSTDOWN
			@server[:output] << "\nConnection refused"
		rescue Timeout::Error
			@server[:output] << "\nTimeout Error!"
		rescue Errno::EHOSTUNREACH
			@server[:output] << "\nHost unreachable"
		end

		respond_to do |format|
			 # format.html
			format.xml { render :xml => @server.to_xml }
			format.json { render :json => @server.to_json }
		end
  	end

	def self.ping(host)
	  begin
	    Timeout.timeout(0.1) do 
	      s = TCPSocket.new(host, 'echo')
	      s.close
	      return true
	    end
	  rescue Errno::ECONNREFUSED
	    return true
	  rescue Errno::EHOSTDOWN
	  	return false
	  rescue Errno::EHOSTUNREACH
	  	return false
	  rescue Timeout::Error
	    return false
	  end
	end
end
