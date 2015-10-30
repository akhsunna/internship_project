class UsersController < ApplicationController

  def show
    if current_user.moderator?
      redirect_to moderator_path(current_user)
    end
    @user = User.find(params[:id])
  end

  def index
    @users = User.users
  end








  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to user_path(current_user), notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  private

  def user_params
    accessible = [ :name, :email ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

end
