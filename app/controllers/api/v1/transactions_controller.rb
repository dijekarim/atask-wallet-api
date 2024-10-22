class Api::V1::TransactionsController < ApplicationController
  before_action :authorized_user

  def all
    render json: { status: 'success', data: @user.wallets }, status: :ok
  end

  def deposit
    begin
      ActiveRecord::Base.transaction do
        if !params[:amount].present? || params[:amount] <= 0
          return render json: { status: 'error', message: 'Deposit amount can not be null or less than or equal 0' }, status: :unprocessable_entity
        end
        credit = @user.credits.create(amount: params[:amount], notes: params[:notes])
        render json: { status: 'success', data: credit.as_json(include: { user: { only: [:id, :username, :name] }}) }, status: :ok
      end
    rescue => exception
      raise exception
      return render json: { status: 'error', message: exception }, status: :unprocessable_entity
    end
  end

  def withdraw
    begin
      ActiveRecord::Base.transaction do
        # VALIDATE BALANCE
        balance = @user.balance
        return render json: { status: 'error', message: 'Withdraw amount can not be null or less than or equal 0' }, status: :unprocessable_entity if !params[:amount].present? || params[:amount] <= 0
        
        if balance < params[:amount]
          return render json: { status: 'error', message: 'Insufficient balance' }, status: :unprocessable_entity
        end

        debit = @user.debits.create(amount: -params[:amount], notes: params[:notes])
        render json: { status: 'success', data: debit.as_json(include: { user: { only: [:id, :username, :name] }}) }, status: :ok
      end
    rescue => exception
      raise exception
      return render json: { status: 'error', message: exception }, status: :unprocessable_entity
    end
  end

  def transfer
    begin
      ActiveRecord::Base.transaction do
        # VALIDATE BALANCE
        balance = @user.balance
        return render json: { status: 'error', message: 'Transfer amount can not be null or less than or equal 0' }, status: :unprocessable_entity if !params[:amount].present? || params[:amount] <= 0

        if balance < params[:amount]
          return render json: { status: 'error', message: 'Insufficient balance' }, status: :unprocessable_entity
        end

        # CHECK TARGET
        unless params[:target]
          return render json: { status: 'error', message: 'Target user can not be null' }, status: :unprocessable_entity
        end
        
        target = User.find_by(username: params[:target])
        unless target.present?
          return render json: { status: 'error', message: 'Transfer Target user not found' }, status: :unprocessable_entity
        end

        # CREATE DEBIT TO CURRENT USER
        debit = @user.debits.create(amount: -params[:amount], notes: params[:notes])

        # CREATE CREDIT TO TARGET
        credit = target.credits.create(amount: params[:amount], notes: params[:notes])
        render json: { status: 'success', data: debit.as_json(include: { user: { only: [:id, :username, :name] }}) }, status: :ok
      end
    rescue => exception
      raise exception
      return render json: { status: 'error', message: exception }, status: :unprocessable_entity
    end
  end
end
