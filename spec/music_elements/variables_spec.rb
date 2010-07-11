require File.dirname(__FILE__) + '/../spec_helper'

describe "stretto variables" do

  context "when parsing them" do
    it "should parse a variable initialization as a music element" do
      pattern = Stretto::Pattern.new("$MY_VAR=1 C D E $OTHER_VAR=2 F G A")
      pattern[0].should be_an_instance_of(Stretto::MusicElements::VariableDefinition)
      pattern[4].should be_an_instance_of(Stretto::MusicElements::VariableDefinition)
    end
  end

  context "when looking up for its value" do
    it "should duck type the method :to_i and return its correct value" do
      var = Stretto::Pattern.new("$MY_VAR=1")[0]
      var.should respond_to(:to_i)
      var.to_i.should be == 1
    end

    it "should duck type the method :to_f and return its correct value" do
      var = Stretto::Pattern.new("$MY_VAR=0.5")[0]
      var.should respond_to(:to_f)
      var.to_f.should be == 0.5
    end

    it "should coerce floats into integers when used in an integer context" do
      Stretto::Pattern.new("$MY_VAR=60.8 [MY_VAR]")[1].pitch.should be == 60
    end

    it "should store its value correctly" do
      Stretto::Pattern.new("$MY_VAR=1")[0].to_i.should be == 1
      Stretto::Pattern.new("$MY_VAR=100")[0].to_i.should be == 100
    end

    it "should store its name correctly" do
      Stretto::Pattern.new("$MY_VAR=1")[0].name.should be == "MY_VAR"
      Stretto::Pattern.new("$OTHER_VAR=1")[0].name.should be == "OTHER_VAR"
    end

    it "should throw an error if a variable has not been defined yet" do
      lambda { Stretto::Pattern.new("$MY_VAR=10 [MY_VAR]") }.should_not raise_error
      lambda { Stretto::Pattern.new("[MY_VAR]") }.should raise_error(Stretto::Exceptions::VariableNotDefinedException, /MY_VAR/)
    end

    it "should allow redefinition of a variable" do
      pattern = Stretto::Pattern.new("$MY_VAR=60 [MY_VAR] $MY_VAR=80 [MY_VAR]")
      pattern[1].pitch.should be == 60
      pattern[3].pitch.should be == 80
    end
  end

end