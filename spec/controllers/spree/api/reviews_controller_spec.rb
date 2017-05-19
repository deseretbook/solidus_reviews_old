require 'spec_helper'

describe Spree::Api::ReviewsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:review) { create(:review) }
  let!(:product) { review.product }

  before do
    user.generate_spree_api_key!
    Array.new(3).each do
      create(:review)
    end
  end

  describe '#index' do
    subject do
      api_get :index, product_id: product, token: user.spree_api_key
      JSON.parse(response.body)
    end

    context 'there are no reviews for a product' do
      it 'should return an empty array' do
        expect(Spree::Review.count).to be >= 0
        expect(subject["data"]).to be_empty
      end
    end

    context 'there are reviews for the product and other products' do
      it 'returns all approved reviews for the product' do
        review.update(approved: true)
        expect(Spree::Review.count).to be >= 2
        expect(subject["data"].size).to eq(1)
        expect(subject["data"][0]["id"]).to eq(product.id)
      end
    end
  end

  describe '#create' do
    let(:review_params) do
      {
        "user_id": "1055037",
        "review": {
          "rating": "3 stars",
          "title": "My title 2",
          "name": "dgr",
          "review": "My review updated",
        },
      }
    end
    subject do
      params = { product_id: product, token: user.spree_api_key }.merge(review_params)
      api_get :create, params
      JSON.parse(response.body)
    end

    context 'when user has already reviewed this product' do
      before do
        review.update(user_id: user.id)
      end

      it 'should return with a fail' do
        expect(subject["status"]).to eq("fail")
        expect(subject["data"]["title"]).to include("Reviews are limited to 1 per user per product")
      end
    end

    context 'when it is a users first review for the product' do
      it 'should return success with review' do
        expect(subject["status"]).to eq("success")
        expect(subject["data"]["review"]).not_to be_empty
        expect(subject["data"]["review"]["product_id"]).to eq(product.id)
        expect(subject["data"]["review"]["name"]).to eq(review_params[:review][:name])
        expect(subject["data"]["review"]["review"]).to eq(review_params[:review][:review])
        expect(subject["data"]["review"]["title"]).to eq(review_params[:review][:title])
      end
    end
  end

  describe '#update' do
  end

  describe '#destroy' do
  end
end
