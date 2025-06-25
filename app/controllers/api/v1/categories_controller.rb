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
        category = Category.new(name: params[:name])
        if category.save
          render json: { success: true, category: category }, status: :created
        else
          render json: { success: false, errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
