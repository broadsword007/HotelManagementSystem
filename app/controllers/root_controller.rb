class RootController < ApplicationController
  def index
    @categories = RoomCategory.all
    @comments = Comment.all
    @rooms = Room.all
  end
end
