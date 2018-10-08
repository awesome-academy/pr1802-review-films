require "active_support/concern"

module Nested
  extend ActiveSupport::Concern

  included do
    def all_comments
      results = Array.new
      return results if self.comments.empty?
      comments = self.comments.preload(:comments).to_a
      results += comments
      comments.each do |comment|
        results += comment.all_comments
      end
      results
    end
  end
end
