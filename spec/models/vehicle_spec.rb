require 'spec_helper'

RSpec.describe Vehicle, type: :model do
  it 'reports no parent' do
    expect(Vehicle.mti_parent_classes).to eq []
  end
  it 'car has one parent' do
    expect(Car.mti_parent_classes).to eq [Vehicle]
  end

  it 'deep children report multiple parents' do
    expect(Ford.mti_parent_classes).to match_array [Vehicle,Car]
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
    expect(Vehicle.all.specific.count).to be 3
    expect(Vehicle.first.specific.is_a? Car).to be_truthy
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

  # it "propagates destruction" do
  #   Ford.create(wheels: 4)
  #   Car.create(wheels: 4)
  #   expect(Car.count).to eq 1
  #   Ford.first.destroy
  #   expect(Ford.count).to eq 0
  #   expect(Car.count).to eq 1
  #   Vehicle.first.destroy
  #   expect(Vehicle.count).to eq 0
  #   expect(Car.count).to eq 0
  # end

  # it "allows usage of parent scopes" do
  #   Ford.create(wheels: 5)
  #   Car.create(wheels: 4)
  #   Ford.create(wheels: 4, model: "explorer")
  #   Ford.create(wheels: 8)
  #   Vehicle.send(:scope, :quad, -> { where(wheels: 4) })
  #   expect(Ford.quad.count).to be 1
  #   expect(Ford.all.quad.first.model).to be "explorer"
  # end
end
