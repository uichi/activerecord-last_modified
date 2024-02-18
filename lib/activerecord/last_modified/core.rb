# frozen_string_literal: true

module ActiveRecord
  module LastModified
    extend ActiveSupport::Concern

    class_methods do
      def last_modified(*klasses)
        subqueries = []
        Array.wrap(klasses.presence || self).each do |klass|
          klass.timestamp_attributes_for_update_in_model.map do |attr|
            subqueries << klass.arel_table.project(klass.arel_table[attr].maximum.as("last_modified"))
          end
        end

        return if subqueries.count.zero?

        query = <<~SQL
          SELECT
            MAX(last_modified)
          FROM (
            #{subqueries.reduce { |first, second| Arel::Nodes::Union.new(first, second) }.to_sql}
          ) AS _union_table
        SQL

        ActiveRecord::Base.connection.select_value(query)&.in_time_zone
      end
    end
  end
end
