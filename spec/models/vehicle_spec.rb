require 'spec_helper'

RSpec.describe Vehicle, type: :model do
  it 'reports no parent' do
    expect(Vehicle.mti_parent_classes).to eq []
  end
  it 'car has one parent' do
    expect(Car.mti_parent_classes).to eq [Vehicle]
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
    expect(Vehicle.all.count).to be 2
    expect(Vehicle.first.is_a? Car).to be_truthy
    expect(Vehicle.last.is_a? Train).to be_truthy
  end

  it 'allows initialization of parent values during create' do
    Car.delegate :wheels=, to: :vehicle
    Car.delegate :wheels, to: :vehicle
    car = Car.create(wheels: 4, model: "tapley")
    expect(car.model).to eq "tapley"
    expect(car.wheels).to eq 4
    expect(car.vehicle.wheels).to eq 4
  end
end
