require 'spec_helper'

RSpec.describe Vehicle, type: :model do
  it 'reports no parent' do
    expect(Vehicle.mti_ancestor_classes).to eq []
  end
  it 'car has one parent' do
    expect(Car.mti_ancestor_classes).to eq [Vehicle]
  end

  it 'deep children report multiple parents' do
    expect(Ford.mti_ancestor_classes).to match_array [Vehicle,Car]
  end
  it 'new children have their parents initialized' do
    expect(Car.new.vehicle.is_a? Vehicle).to be_truthy
  end
  it 'creates parents when children are created' do
    c = Car.create!
    expect(c.id).not_to be_nil
    expect(c.vehicle.id).not_to be_nil
  end

  it 'querying superclasses returns subclasses' do
    Car.create
    Train.create
    Ford.create
    expect(Vehicle.specific.count).to be 3
    expect(Vehicle.specific.first.is_a? Car).to be_truthy
    expect(Vehicle.all[1].specific.is_a? Train).to be_truthy
    expect(Vehicle.last.specific.is_a? Ford).to be_truthy
  end

  it 'Can get exact types as well' do
    Car.create
    Train.create
    Ford.create
    expect(Vehicle.all.count).to be 3
    expect(Vehicle.first.is_a? Vehicle).to be_truthy
    expect(Vehicle.all[1].is_a? Vehicle).to be_truthy
  end

  it 'allows initialization of parent values during create' do
    car = Car.create(wheels: 4, model: "tapley")
    expect(car.model).to eq "tapley"
    expect(car.wheels).to eq 4
    expect(car.vehicle.wheels).to eq 4
  end

  it 'allows children to call functions of the parent classes' do
    c = Car.create(wheels: 4)
    expect(c.respond_to? :wheels).to be_truthy
    expect(c.can_drive?).to be_truthy
    c = Car.create(wheels: 3)
    expect(c.can_drive?).to be_falsey
    expect(c.method_args_test(3,4) {9+9}).to eq 25
    f = Ford.create(wheels: 8)
    expect(f.can_drive?).to be_truthy
  end

  it "doesn't delegate certain methods to parent" do
    expect{Ford.create.mti_child}.to raise_error(NoMethodError)
  end

  #Might remove
  it "properly checks for query delegation" do
    expect(Vehicle.mti_handles_query_param(:wheels)).to be_truthy
    expect(Vehicle.mti_handles_query_param(:other)).to be_falsey
    expect(Vehicle.mti_delegate_query_table(:other)).to be nil
    expect(Car.mti_delegates_query?(:other)).to be_falsey
    expect(Car.mti_delegates_query?(:model)).to be_falsey
    expect(Car.mti_delegate_query_table(:model)).to be :cars
    expect(Car.mti_delegate_query_table(:wheels)).to be :vehicles
    expect(Car.mti_delegates_query?(:wheels)).to be_truthy
  end

  it "allows queries on super class attributes from children" do
    Ford.create(wheels: 4)
    Car.create(wheels: 4)
    Ford.create(wheels: 4, model: "explorer")
    Ford.create(wheels: 8)
    expect(Ford.count).to be 3
    expect(Ford.where(model: nil).count).to be 2
    expect(Ford.where(model: "explorer", wheels: 4).count).to be 1
    expect(Ford.where(wheels: 4).count).to be 2
  end

  it "propagates destruction" do
    Ford.create(wheels: 4)
    Car.create(wheels: 4)
    expect(Car.count).to eq 2
    Ford.first.destroy
    expect(Ford.count).to eq 0
    expect(Car.count).to eq 1
    Vehicle.first.destroy
    expect(Vehicle.count).to eq 0
    expect(Car.count).to eq 0
  end

  it "allows usage of parent scopes" do
    Ford.create(wheels: 5)
    Car.create(wheels: 4)
    Ford.create(wheels: 4, model: "explorer")
    Ford.create(wheels: 4, model: "other")
    Vehicle.send(:scope, :quad, -> { Vehicle.where(wheels: 4) })
    expect(Ford.quad.count).to be 2
    expect(Car.quad.count).to be 3
    expect(Ford.where(model: "explorer").quad.count).to eq 1
  end

  it "correctly handles timestamps" do
    Timecop.freeze
    ford = Ford.create
    Timecop.freeze(Time.now + 5.minutes)
    expect(ford.created_at).to eq(Time.now-5.minutes)
    expect(ford.updated_at).to eq(Time.now-5.minutes)
    # Unsure of desired behavior here
    # ford.save
    # expect(ford.updated_at).to eq(Time.now-5.minutes)
    ford.update(year: 100)
    expect(ford.updated_at).to eq Time.now
    Timecop.return
  end

  it "doesn't break find_or_create" do
    ford = Ford.find_or_create_by(model: "ford", year: 123) do |f|
      f.wheels = 4
    end
    expect(Vehicle.count).to eq 1
    expect(Ford.first.wheels).to eq 4
    expect(Car.find_or_create_by(model: "ford").specific.year).to eq 123
    expect(Vehicle.count).to eq 1
  end

  #Note: Not sure if we actually want this in production
  it "has one id for the entire chain of objects" do
    5.times {Vehicle.create}
    5.times {Ford.create}
    5.times {Train.create}
    expect(Vehicle.count).to be 15
    Vehicle.all.each do |e|
      expect(e.id).to eq e.specific.id
    end
    Vehicle.all.map(&:id).into {|ids| expect(ids.uniq).to match_array ids}
    Ford.all.map(&:id).into {|ids| expect(ids.uniq).to match_array ids}
    Train.all.map(&:id).into {|ids| expect(ids.uniq).to match_array ids}
  end

  #Note this adds the validation for all of the later tests
  #I kind of fucked this up
  it "checks that parents are valid on save" do
    Vehicle.validates :wheels, presence: true
    class Vehicle
      def car_validation
        if self.wheels != 4
          errors.add(:wheels, "must be 4")
        end
      end
    end
    class Ford
      def ford_validation
        if self.model != "ford"
          errors.add(:model, "must be ford")
        end
      end
    end
    Vehicle.validate :car_validation
    Ford.validate :ford_validation
    expect {Ford.create!(wheels: 5,model: "ford")}.to raise_error ActiveRecord::RecordInvalid
    expect {Ford.create!()}.to raise_error ActiveRecord::RecordInvalid
    expect {Car.create!(wheels: 4)}.not_to raise_error
    expect {Ford.create!(wheels: 4,model: "ford")}.not_to raise_error
  end
end
