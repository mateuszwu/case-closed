require 'rails_helper'

describe ServiceXWrapper do
  describe '.all_reservation_ids' do
    it 'calls ServiceX all_reservations endpoint and returns array of reservation ids' do
      expect(ServiceX)
        .to(receive(:all_reservations))
        .and_return({ data: 
          [
            {
              reservationId: '123',
              checkinDate: '2018-06-11',
              checkoutDate: '2018-06-16',
              guestName: 'Tony Start',
              roomId: '887'
            },
            {
              reservationId: '124',
              checkinDate: '2018-05-11',
              checkoutDate: '2018-05-17',
              guestName: 'Peter Parker',
              roomId: '889'
            }
          ]
      }.to_json)

      expect(ServiceXWrapper.all_reservation_ids).to eq ['123', '124']
    end
  end

  describe '.reservation' do
    it 'calls ServiceX with a given id and returns parsed reservation' do
      expect(ServiceX)
        .to(receive(:reservation))
        .with('123')
        .and_return({
          reservationId: '123',
          checkinDate: '2018-06-11',
          checkoutDate: '2018-06-16',
          guestName: 'Tony Start',
          roomId: '887',
          rates: {
            '2018-06-11' => 100,
            '2018-06-12' => 200,
            '2018-06-13' => 250,
            '2018-06-14' => 250,
            '2018-06-15' => 100,
          },
          total: 900
        }.to_json)


      expect(ServiceXWrapper.reservation('123')).to eq({
        reservationId: '123',
        checkinDate: '2018-06-11',
        checkoutDate: '2018-06-16',
        guestName: 'Tony Start',
        roomId: '887',
        rates: {
          '2018-06-11' => 100,
          '2018-06-12' => 200,
          '2018-06-13' => 250,
          '2018-06-14' => 250,
          '2018-06-15' => 100,
        },
        total: 900
      })
    end
  end
end
