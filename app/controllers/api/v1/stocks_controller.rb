class Api::V1::StocksController < ApplicationController
  def price_all
    begin
      response = LatestStockPrice.price_all
      render json: { status: 'success', data: response }, status: :ok
    rescue => e
      render json: { status: 'error', message: e.message }, status: :unprocessable_entity
    end
  end
end
