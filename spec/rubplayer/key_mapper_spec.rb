require 'spec_helper'

describe Rubplayer::KeyMapper do
  context :initialization do
    it 'should set `mappings` instance variable if given' do
      mapper = Rubplayer::KeyMapper.new(mappings: { foo: "bar" })
      mapper.instance_variable_get(:@mappings).should eq({foo: "bar"})
    end

    it 'should raise an error if `mappings` is not an array' do
      expect {
        Rubplayer::KeyMapper.new(mappings: [])
      }.to raise_error(ArgumentError)
    end

    it 'should initialize `counter`' do
      mapper = Rubplayer::KeyMapper.new
      mapper.instance_variable_defined?(:@counter).should be_true
      mapper.instance_variable_get(:@counter).should be_nil
    end

    it 'should initialize `counter`' do
      mapper = Rubplayer::KeyMapper.new
      mapper.instance_variable_defined?(:@current_combo).should be_true
      mapper.instance_variable_get(:@current_combo).should be_nil
    end
  end

  context :map do
    let(:mapper) { Rubplayer::KeyMapper.new }

    it 'should raise an error if shortcut contains a number' do
      %w[1 a1b <C-1>].each do |arg|
        expect {
          mapper.map(arg) { puts "foo" }
        }.to raise_error(ArgumentError)
      end
    end

    it 'should raise an error when no block is given' do
      expect {
        mapper.map("q")
      }.to raise_error(ArgumentError)
    end

    it 'should map single character shortcut to given block' do
      mapper.map('q') { :foo }
      mapper.instance_variable_get(:@mappings)['q'].call.should eq(:foo)
    end

    it 'should accept ascii characters 33 - 47 and 58 - 126' do
      ((33..47).to_a + (58..126).to_a).each do |n|
        mapper.map(n.chr) { true }
        mapper.instance_variable_get(:@mappings)[n.chr].call.should be_true
      end
    end
  end
end
