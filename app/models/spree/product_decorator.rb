# Add access to reviews/ratings to the product model
Spree::Product.class_eval do
  include Spree::Reviewable

  def stars
    avg_rating.try(:round) || 0
  end

  def recalculate_rating
    self[:reviews_count] = reviews.reload.approved.count
    if reviews_count.positive?
      self[:avg_rating] = reviews.approved.sum(:rating).to_f / reviews_count
    else
      self[:avg_rating] = 0
    end
    save
  end
end
