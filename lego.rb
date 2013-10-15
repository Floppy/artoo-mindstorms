#!/usr/bin/env ruby

require 'rubygems'
require 'serialport'
require 'usb'

$:.unshift File.dirname(__FILE__) + '/nxt/lib'

require 'nxt'

$DEBUG = true

@nxt = NXT.new("/dev/tty.NXT-DevB")

def left
  command = Commands::Move.new(@nxt)
  command.ports = :b, :c
  command.turn_ratio = :spin_left
  command.direction = :forward
  command.duration = :unlimited
  command.start
end

def right
  command = Commands::Move.new(@nxt)
  command.ports = :b, :c
  command.turn_ratio = :spin_right
  command.direction = :forward
  command.duration = :unlimited
  command.start
end

def forward
  command = Commands::Move.new(@nxt)
  command.ports = :b, :c
  command.turn_ratio = :straight
  command.direction = :forward
  command.duration = :unlimited
  command.start
end

def reverse
  command = Commands::Move.new(@nxt)
  command.ports = :b, :c
  command.turn_ratio = :straight
  command.direction = :backward
  command.duration = :unlimited
  command.start
end

def spin(degrees)
  motor = NXT::MOTOR_A
  @nxt.set_output_state(motor,25,NXT::MOTORON | NXT::BRAKE | NXT::REGULATED,
    NXT::REGULATION_MODE_MOTOR_SPEED,0,NXT::MOTOR_RUN_STATE_RUNNING,degrees)
  until @nxt.get_output_state(motor)[:run_state] == NXT::MOTOR_RUN_STATE_IDLE
    puts @nxt.get_output_state(motor).inspect
    sleep(0.5)
  end
end

def sound
  command = Commands::Sound.new(@nxt)
  command.start
end

def stop
  command = Commands::Move.new(@nxt)
  command.ports = :b, :c
  command.turn_ratio = :straight
  command.direction = :stop
  command.start
end

def done
  @nxt.close
end