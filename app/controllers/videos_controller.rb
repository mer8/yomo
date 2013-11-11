class VideosController < ApplicationController
	def index
		@videos = Video.all
		@analytics = Video.fuck()
	end

	def new
		@video = Video.new
	end

	def create
		Video.create(params[:video].permit(:title, :link, :length))
		redirect_to videos_url	
	end

	def show
		if params[:id].is_a?(integer)
			@video = Video.find(params[:id].to_i)
		else
			@video = Video.where(title:params[:id]).first
		end
	end

end
