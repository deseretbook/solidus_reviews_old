module Spree
  module Api
    class ReviewsController < Spree::Api::BaseController
      rescue_from ActiveRecord::RecordNotFound, with: :render_404
      before_action :load_product, :find_review_user
      before_action :load_review, only: [:update, :destroy]
      before_action :sanitize_rating, only: [:create, :update]
      before_action :prevent_multiple_reviews, only: [:create]

      def index
        @approved_reviews = Spree::Review.approved.where(product: @product)
        render json: { data: @approved_reviews }, status: 202
      end

      def create
        @review = Spree::Review.new(review_params)
        @review.product = @product
        @review.user = @current_review_user
        @review.ip_address = request.remote_ip
        @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]

        authorize! :create, @review
        if @review.save
          respond_with_success(status: 201)
        else
          respond_with_fail
        end
      end

      def update
        authorize! :update, @review

        attributes = review_params.merge(ip_address: request.remote_ip, approved: false)

        if @review.update(attributes)
          respond_with_success
        else
          respond_with_fail
        end
      end

      def destroy
        authorize! :destroy, @review
        if @review.destroy
          respond_with_success
        else
          respond_with_fail
        end
      end

      private

      def permitted_review_attributes
        [:rating, :title, :review, :name, :show_identifier]
      end

      def review_params
        params.require(:review).permit(permitted_review_attributes)
      end

      # Loads product from product id.
      def load_product
        @product = Spree::Product.friendly.find(params[:product_id])
      end

      # Finds user based on api_key or by user_id if api_key belongs to an admin.
      def find_review_user
        if params[:user_id] && @current_user_roles.include?('admin')
          @current_review_user = Spree.user_class.find(params[:user_id])
        else
          @current_review_user = current_api_user
        end
      end

      # Loads any review that is shared between the user and product
      def load_review
        @review = Spree::Review.find(params[:id])
      end

      # Ensures that a user can't create more than 1 review per product
      def prevent_multiple_reviews
        @review = @current_review_user.reviews.find_by(product: @product)
        if @review.present?
          respond_with_fail(message: "Reviews are limited to 1 per user per product.")
        end
      end

      # Converts rating strings like "5 units" to "5"
      # Operates on params
      def sanitize_rating
        params[:review][:rating].sub!(/\s*[^0-9]*\z/, '') unless params[:review][:rating].blank?
      end

      def respond_with_success(status: 200)
        render json:
          {
            status: 'success',
            data: {
              review: @review,
            },
          },
          status: status
      end

      def respond_with_fail(message: nil, status: 422)
        render json:
          {
            status: 'fail',
            data: {
              title: message || @review.errors.full_messages.to_sentence,
            },
          },
          status: status
      end
    end
  end
end
