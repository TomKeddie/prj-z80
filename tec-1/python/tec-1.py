#!/usr/bin/env python3

import time,sys,logging,argparse,signal
from pyftdi.gpio import Ftdi, GpioAsyncController, GpioSyncController
from pyftdi.eeprom import FtdiEeprom

c_noshift = 0b0010_0000
c_plus    = 0b0011_0000
c_minus   = 0b0011_0001
c_go      = 0b0011_0010
c_ad      = 0b0011_0011

def write_byte(gpio, data):
     # nmi low & upper nibble
    gpio.exchange(0b1000_0000 | ((data >> 4) & 0b0000_1111) | c_noshift)
    gpio.exchange(0b0000_0000 | ((data >> 4) & 0b0000_1111) | c_noshift)
    time.sleep(0.25)
    # nmi low & lower nibble
    gpio.exchange(0b1000_0000 | ((data >> 0) & 0b0000_1111) | c_noshift)
    gpio.exchange(0b0000_0000 | ((data >> 0) & 0b0000_1111) | c_noshift)
    time.sleep(0.25)
    # nmi low & plus key
    gpio.exchange(0b1000_0000 | c_plus | c_noshift)
    gpio.exchange(0b0000_0000 | c_plus | c_noshift)
    time.sleep(0.25)
   
def enable(gpio):
    gpio.exchange(0b0000_0000)
    
def disable(gpio):
    gpio.exchange(0b0100_0000)


parser = argparse.ArgumentParser(description='TEC-1 controller.')
parser.add_argument("serial", type=str, nargs=1)
parser.add_argument("-t", "--type", type=str, required=False, default="232")
parser.add_argument("-i", "--instance", type=str, required=False, default="1")
parser.add_argument("-l", "--load", type=str, nargs=1, required=False)
args = parser.parse_args()

url = "ftdi://ftdi:{}:{}/{}".format(args.type, args.serial[0], args.instance)

gpio = GpioSyncController()
gpio.configure(url, direction=0b1111_1111)
gpio.set_frequency(200)

def signal_handler(sig, frame):
    print('You pressed Ctrl+C!')
    disable(gpio)
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

enable(gpio)

if "load" in args:
    with open(args.load[0], "rb") as fh:
        data = fh.read(1)
        while data:
            data_value = int.from_bytes(data, byteorder='big', signed=False)
            write_byte(gpio, data_value)
            data = fh.read(1)

disable(gpio)

gpio.close()
