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
        game =@room.game
        player = game.player(current_user)
        opponent = game.opponent(current_user)
        

        if (game.player?(current_user))
    
            render json: {room: @room, game: {playerHand: game.send("#{game.player(current_user)}_hand"), 
                                              opponentHand: game.send("#{game.opponent(current_user)}_hand").length,
                                              status: game.status,
                                              turn: game.turn},
                                              players: {player1: game.player1.username, player2: game.player2.username}}
        else
  
            if (game.player1 && game.player2)
              render json: {room: @room, game: game, players: {player1: game.player1.username, player2: game.player2.username}}
            elsif (@room.game.player1)
              render json: {room: @room, game: game, players: {player1: game.player1.username, player2: ""}}
            elsif (@room.game.player2)
              render json: {room: @room, game: game, players: {player1: "", player2: @room.game.player2.username}}
            else
              render json: {room: @room, game: game, players: {player1: "", player2: ""}}
            end
        end
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
  