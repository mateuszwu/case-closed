require 'rails_helper'

describe Reservation::Import do
  it 'calls Reservation::Create for each id retuned by ServiceXWrapper.all_reservation_ids' do
    expect(ServiceXWrapper)
      .to(receive(:all_reservations_ids))
      .and_return ['1', '2']

    expect(Reservation::Create)
      .to(receive(:call))
      .with('1')

    expect(Reservation::Create)
      .to(receive(:call))
      .with('2')

    Reservation::Import.call
  end
end
