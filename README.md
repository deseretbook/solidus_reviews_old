# Reviews

[![CircleCI](https://circleci.com/gh/deseretbook/solidus_reviews.svg?style=svg)](https://circleci.com/gh/deseretbook/solidus_reviews)

Straightforward review/rating functionality.

---

## Installation

Add the following to your `Gemfile` to install from git:
```ruby
gem 'solidus_reviews', github: 'deseretbook/solidus_reviews'
```
Now bundle up with:

    bundle

Next, run the rake task that copies the necessary migrations and assets to your project:

    bundle exec rails g solidus_reviews:install

And finish with a migrate:

bundle exec rake db:migrate

Now you should be able to boot up your server with:

    bundle exec rails s

That's all!

---

## Usage

Action "submit" in "reviews" controller - goes to review entry form

Users must be logged in to submit a review

Three partials:
 - `app/views/spree/products/_rating.html.erb` -- display number of stars
 - `app/views/spree/products/_shortrating.html.erb` -- shorter version of above
 - `app/views/spree/products/_review.html.erb` -- display a single review

Administrator can edit and/or approve and/or delete reviews.

## Implementation

Reviews table is quite obvious - and note the "approved" flag which is for the
administrator to update.

Ratings table holds current fractional value - avoids frequent recalc...

---

## Discussion

Some points which might need modification in future:

 - I don't track the actual user on a review (just their "screen name" at the
   time), but we may want to use this information to avoid duplicate reviews
   etc. See https://github.com/spree/spree_reviews/issues/18
 - Rating votes are tied to a review, to avoid spam. However: ratings are
   accepted whether or not the review is accepted. Perhaps they should only
   be counted when the review is approved.

---
Copyright (c) 2016 Deseret Book, released under the New BSD License
