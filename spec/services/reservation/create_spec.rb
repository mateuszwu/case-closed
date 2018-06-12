require 'rails_helper'

describe Reservation::Create do
  describe '.call' do
    context 'when room exists' do
      it 'creates a reservation with rates for an existing room' do
        room = create(:room)
        expect(ServiceXWrapper)
          .to(receive(:reservation))
          .with('123')
          .and_return({
          reservationId: '123',
          checkinDate: '2018-06-11',
          checkoutDate: '2018-06-16',
          guestName: 'Tony Start',
          roomId: room.id.to_s,
          rates: {
            '2018-06-11' => 100,
            '2018-06-12' => 200,
            '2018-06-13' => 250,
            '2018-06-14' => 250,
            '2018-06-15' => 100,
          },
          total: 900
        })

        expect { Reservation::Create.call }
          .to change { room.reload.reservation.count }
          .from(0).to(1)
          .and change { room.reservation.first.reservation_rates.count }
          .from(0).to(5)
          .and not_change { Room.count }

        expect(Reservation.last).to have_attributes(
          reservationId: '123',
          checkinDate: '2018-06-11',
          checkoutDate: '2018-06-16',
          guestName: 'Tony Start',
          roomId: '887',
          total: 900
        )
        expect(Reservation.last.rates).to match_array(
          have_attributes(date: '2018-06-11', amount: 100),
          have_attributes(date: '2018-06-12', amount: 200),
          have_attributes(date: '2018-06-13', amount: 250),
          have_attributes(date: '2018-06-14', amount: 250),
          have_attributes(date: '2018-06-15', amount: 100)
        )
      end
    end

    context 'when room does not exist' do
      it 'creates a new room with reservation and rates' do
        expect(ServiceXWrapper)
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
        })

        expect { Reservation::Create.call }
          .to change { Reservation.count }.from(0).to(1)
          .and change { ReservationRates.count }.from(0).to(5)
          .and change { Room.count }.from(0).to(1)

        expect(Reservation.last).to have_attributes(
          reservationId: '123',
          checkinDate: '2018-06-11',
          checkoutDate: '2018-06-16',
          guestName: 'Tony Start',
          roomId: '887',
          total: 900
        )
        expect(Reservation.last.rates).to match_array(
          have_attributes(date: '2018-06-11', amount: 100),
          have_attributes(date: '2018-06-12', amount: 200),
          have_attributes(date: '2018-06-13', amount: 250),
          have_attributes(date: '2018-06-14', amount: 250),
          have_attributes(date: '2018-06-15', amount: 100)
        )
      end
    end
  end
end
