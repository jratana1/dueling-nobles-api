class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
    # skip_before_action :verify_authenticity_token, except: [:create]
  
    # GET /users
    def index
      users = User.all
  
      render json: users
    end
  
    # GET /users/1
    def show
      render json: @user
    end
  
    # POST /users
    def create

        user = User.find_or_create_by(user_params)
        
        if user
          #save image whenever its a login - since they can expire
          token = encode_token(user_id: user.id)
          render json: { token: token }
  
        else
          render json: { error: 'failed to create/find user' }, status: :not_acceptable
        end
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
      def set_user
        @user = User.find(params[:id])
      end
  
      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:username, :email)
      end
  end
  