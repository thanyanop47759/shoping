module Api
  module V1
    class CategoriesController < ApplicationController
      # ดูทุกหมวดหมู่
      def index
        categories = Category.all
        render json: categories
      end

      # สร้างหมวดหมู่
      def create
        result = Category.create_with_name(params[:name])

        if result[:success]
          render json: result, status: :created
        else
          render json: { success: false, errors: result[:errors] }, status: :unprocessable_entity
        end
      end
    end
  end
end
