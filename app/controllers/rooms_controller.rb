class RoomsController < ApplicationController
    before_action :set_room, only: [:show, :update, :destroy]
    # skip_before_action :verify_authenticity_token, except: [:create]
  
    # GET /rooms
    def index
      rooms = Room.all
  
      render json: rooms
    end
  
    # GET /rooms/1
    def show
      render json: @room
    end
  
    # POST /rooms
    def create

        room_id = Room.last.id + 1
        room = Room.create(name: "Game Room #{room_id}")
        game = Game.create(room_id: room.id)
        room.users << current_user


        render json: room 

    end
  
    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /users/1
    def destroy
      @user.destroy
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_room
        @room = Room.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def room_params
        params.require(:room).permit(:id, :name)
      end
  end
  