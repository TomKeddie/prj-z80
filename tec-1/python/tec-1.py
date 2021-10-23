#!/usr/bin/env python3

import time,sys,logging,argparse
from pyftdi.gpio import Ftdi, GpioAsyncController, GpioSyncController
from pyftdi.eeprom import FtdiEeprom

c_plus  = 0b0001_0000
c_minus = 0b0001_0001
c_go    = 0b0001_0010
c_ad    = 0b0001_0011

def write_byte(gpio, data):
    # nmi low & upper nibble
    gpio.exchange(0b1000_0000 | ((data >> 4) & 0b0000_1111))
    gpio.exchange(0b0000_0000 | ((data >> 4) & 0b0000_1111))
    time.sleep(0.5)
    # nmi low & lower nibble
    gpio.exchange(0b1000_0000 | ((data >> 0) & 0b0000_1111))
    gpio.exchange(0b0000_0000 | ((data >> 0) & 0b0000_1111))
    time.sleep(0.5)
    # nmi low & plus key
    gpio.exchange(0b1000_0000 | c_plus)
    gpio.exchange(0b0000_0000 | c_plus)
    time.sleep(0.5)
    
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

print(args)
url = "ftdi://ftdi:{}:{}/{}".format(args.type, args.serial[0], args.instance)

gpio = GpioSyncController()
gpio.configure(url, direction=0b1111_1111)
gpio.set_frequency(200)

enable(gpio)

if "load" in args:
    with open(args.load[0], "rb") as fh:
        data = fh.read(1)
        while data:
            data_value = int.from_bytes(data, byteorder='big', signed=False)
            print("{:02x}".format(data_value))
            write_byte(gpio, data_value)
            data = fh.read(1)

disable(gpio)

gpio.close()
