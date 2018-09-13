class AddReviewIdToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :review_id, :int, index: true
  end
end
