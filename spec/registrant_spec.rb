require './lib/registrant'

RSpec.describe Registrant do

  before(:each) do
    @registrant_1 = Registrant.new('Bruce', 18, true )
    @registrant_2 = Registrant.new('Penny', 15 )
  end
    describe '#initialize' do
    it 'can initialize' do

      expect(@registrant_1).to be_a(Registrant)
      expect(@registrant_2).to be_a(Registrant)
    end
  end
    describe '#name' do
    it 'has a name' do

      expect(@registrant_1.name).to eq('Bruce')
      expect(@registrant_2.name).to eq('Penny')
    end
  end
    describe '#age' do
    it 'has an age' do

      expect(@registrant_1.age).to eq(18)
      expect(@registrant_2.age).to eq(15)
    end
  end 
    describe '#permit' do
    it 'does not have a permit by default' do
  
      expect(@registrant_1.permit?).to be true
      expect(@registrant_2.permit?).to be false
    end
  end
    describe '#earn_permit' do
    it 'can change permit to true' do

    @registrant_2.earn_permit
    @registrant_2.permit?
    
      expect(@registrant_2.permit?).to be true
    end
  end
    describe '#license_data' do
      it 'can recognise license data' do

            expect(@registrant_1.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
        expect(@registrant_2.license_data).to eq({:written=>false, :license=>false, :renewed=>false})
      end
    end
end
