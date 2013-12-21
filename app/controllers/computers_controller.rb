require 'json'

class ComputersController < ApplicationController
  	def index
		respond_to do |format|
			 # format.html
			format.xml { render :xml => Computer.all.to_xml }
			format.json { render :json => Computer.all.to_json }
		end
  	end

	def show
		response = Computer.find(params[:id])
		#response[:status] = {:open => true}
		
		respond_to do |format|
			format.html { render :text => response.as_json(:methods => :permalink) }
			format.xml { render :xml => response.to_xml }
			format.json { render :json => response.to_json }
		end
	end

	def update
		#Change State of a Computer
	end

  def create
    respond_with Entry.create(params[:entry])
  end

  def update
    respond_with Entry.update(params[:id], params[:entry])
  end

  def destroy
    respond_with Entry.destroy(params[:id])
  end
end
