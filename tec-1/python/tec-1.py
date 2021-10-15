import time,sys,logging
from pyftdi.gpio import Ftdi, GpioAsyncController, GpioSyncController
from pyftdi.eeprom import FtdiEeprom

c_plus  = 0b0001_0000
c_minus = 0b0001_0001
c_go    = 0b0001_0010
c_ad    = 0b0001_0011

def write_byte(gpio, data):
    # nmi low & upper nibble
    gpio.exchange(0b1100_0000 | ((data >> 4) & 0b0000_1111))
    gpio.exchange(0b0100_0000 | ((data >> 4) & 0b0000_1111))
    # nmi low & lower nibble
    gpio.exchange(0b1100_0000 | ((data >> 0) & 0b0000_1111))
    gpio.exchange(0b0100_0000 | ((data >> 0) & 0b0000_1111))
    # nmi low & plus key
    gpio.exchange(0b1100_0000 | c_plus)
    gpio.exchange(0b0100_0000 | c_plus)
    
def enable(gpio):
    gpio.exchange(0b0100_0000)
    
def disable(gpio):
    gpio.exchange(0b0000_0000)


if len(sys.argv) < 4:
    print("{} <ftdi_type> <ftdi_serialnumber> <ftdi_instance>\n".format(sys.argv[0]))
    sys.exit(-1)

ftdi_type = sys.argv[1]    
ftdi_serial = sys.argv[2]
ftdi_instance = sys.argv[3]

url = "ftdi://ftdi:{}:{}/{}".format(ftdi_type, ftdi_serial, ftdi_instance)

gpio = GpioSyncController()
gpio.configure(url, direction=0b1111_1111)
gpio.set_frequency(2_000_000)

enable(gpio)

write_byte(gpio, 0x23)

disable(gpio)

gpio.close()
