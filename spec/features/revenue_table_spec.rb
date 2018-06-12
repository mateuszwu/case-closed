require 'rails_helper'

describe 'revenue table' do
  it 'shows revenue table for each day for the last month' do
    travel_to Date.new(2018, 7, 1) do
      create(:reservation_rate, date: Date.new(2018, 5, 28), amount: 100)
      create(:reservation_rate, date: Date.new(2018, 6, 3), amount: 200)
      create(:reservation_rate, date: Date.new(2018, 6, 3), amount: 200)

      expect(page).to have_table_row_containing(
        day: '2018-06-03',
        sum: 400
      )

      expect(page).not_to have_table_row_containing(
        day: '2018-05-28',
        sum: 100
      )
    end
  end
end
