class ApiSessionsController < ApplicationController

	before_filter :find_user

	respond_to :json
	def sign_in
		respond_to do |format|
			if @user and @user.valid_password?(params[:user_password])
	    		@transactions = @user.find_transactions
				format.json { render :json => {user: @user, transactions: @transactions, status: 200 } }
			else
				format.json { render :json => {error: "Usuario o Password incorrecto", status: 401 } }
			end
		end
	end

	def sign_up
	end

	def sign_out
	end

	private

	def find_user
		@user = User.find_by_email(params[:user_email])
	end
end
