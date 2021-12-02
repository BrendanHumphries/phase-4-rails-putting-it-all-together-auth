class RecipesController < ApplicationController
    # before_action :authorize
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    def index
        return render json: {error: 'Not authorized'}, status: :unauthorized unless session.include? :user_id
        recipes = Recipe.all
        render json: recipes, status: :created
    end

    def create
        recipe = Recipe.create!(recipe_params)
        render json: recipe, status: :created, serializer: RecipesUsersSerializer
    end

    private

    # def authorize
    #     return render json: {error: 'Not authorized'}, status: :unauthorized unless session.include? :user_id
    # end

    def record_invalid(exception)
        render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end
end
