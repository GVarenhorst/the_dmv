require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    @facility_1 = Facility.new({name: 'Albany DMV Office', address: '2242 Santiam Hwy SE Albany OR 97321', phone: '541-967-2014' })
    @facility_2 = Facility.new({name: 'Ashland DMV Office', address: '600 Tolman Creek Rd Ashland OR 97520', phone: '541-776-6092' })
    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )
    @registrant_1 = Registrant.new('Bruce', 18, true )
    @registrant_2 = Registrant.new('Penny', 16 )
    @registrant_3 = Registrant.new('Tucker', 15 )
  end

  describe '#initialize' do
    it 'can initialize' do

      expect(@facility).to be_an_instance_of(Facility)
      expect(@facility.name).to eq('Albany DMV Office')
      expect(@facility.address).to eq('2242 Santiam Hwy SE Albany OR 97321')
      expect(@facility.phone).to eq('541-967-2014')
      expect(@facility.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do

      expect(@facility.services).to eq([])

      @facility.add_service('New Drivers License')
      @facility.add_service('Renew Drivers License')
      @facility.add_service('Vehicle Registration')

      expect(@facility.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end

  describe '#Iteration2' do
    it 'can add vehicle registration to a facility' do

      @facility_1.add_service('Vehicle Registration')

      expect(@facility_1.services).to eq(['Vehicle Registration'])
      expect(@cruz.registration_date).to eq(nil)
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_1.collected_fees).to eq(0)
    end
  end

  it 'can register a vehicle and collect fees' do

    @facility_1.add_service('Vehicle Registration')
    @facility_1.register_vehicle(@cruz)


    expect(@cruz.registration_date).to eq(Date.today)
    expect(@cruz.plate_type).to eq(:regular)
    expect(@facility_1.registered_vehicles.first).to eq(@cruz)
    expect(@facility_1.collected_fees).to eq(100)

    @facility_1.register_vehicle(@camaro)

    expect(@camaro.registration_date).to eq(Date.today)
    expect(@camaro.plate_type).to eq(:antique)

    @facility_1.register_vehicle(@bolt)

    expect(@bolt.registration_date).to eq(Date.today)
    expect(@bolt.plate_type).to eq(:ev)


    expect(@facility_1.registered_vehicles).to eq([@cruz, @camaro, @bolt])
    expect(@facility_1.collected_fees).to eq(325)
    expect(@facility_2.registered_vehicles).to eq([])
    expect(@facility_2.services).to eq([])
  end

  describe '#written test' do
    it 'can administer a written test to a registrant' do

      expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      expect(@registrant_1.permit?).to eq(true)
      expect(@facility_1.administer_written_test(@registrant_1)).to eq(false)

      @facility_1.add_service('Written Test')

      expect(@facility_1.administer_written_test(@registrant_1)).to eq(true)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>false, :renewed=>false})
      expect(@registrant_2.age).to eq(16)
      expect(@registrant_2.permit?).to eq(false)
      expect(@facility_1.administer_written_test(@registrant_2)).to eq(false)

      @registrant_2.earn_permit

      expect(@facility_1.administer_written_test(@registrant_2)).to eq(true)
      expect(@registrant_3.age).to eq(15)
      expect(@registrant_3.permit?).to eq(false)

      @registrant_3.earn_permit

      expect(@facility_1.administer_written_test(@registrant_3)).to eq(false)
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
    end
  end

  describe '#road test' do
    it 'can administer a road test to a registrant' do

      expect(@facility_1.administer_road_test(@registrant_1)).to eq(false)

      @facility_1.add_service('Written Test')
      @facility_1.add_service('Road Test')

      expect(@facility_1.administer_road_test(@registrant_1)).to eq(true)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>false})

      @registrant_2.earn_permit

      expect(@facility_1.administer_road_test(@registrant_2)).to eq(true)
      expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>false})
    end
  end

  describe '#renew license' do
    it 'can administer a renewed license to a registrant' do

      expect(@facility_1.renew_drivers_license(@registrant_1)).to eq(false)

      @facility_1.add_service('Written Test')
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Renew License')
      @registrant_1.earn_permit
      @registrant_2.earn_permit
      @registrant_3.earn_permit

      expect(@facility_1.renew_drivers_license(@registrant_1)).to eq(true)
      expect(@registrant_1.license_data).to eq({:written=>true, :license=>true, :renewed=>true})
      expect(@registrant_3.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      expect(@facility_1.renew_drivers_license(@registrant_2)).to eq(true)
      expect(@registrant_2.license_data).to eq({:written=>true, :license=>true, :renewed=>true})
    end
  end
end






