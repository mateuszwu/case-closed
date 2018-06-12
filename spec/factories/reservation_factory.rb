FactoryBot.define do
  factory :reservation do
    checkin_date Date.new(2018, 06, 11)
    checkout_date Date.new(2018, 06, 16)
    guest_name 'Tony Start',
    room
  end
end
