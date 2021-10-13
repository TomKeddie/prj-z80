import time,sys,logging
from pyftdi.gpio import Ftdi, GpioAsyncController
from pyftdi.eeprom import FtdiEeprom

c_plus  = 0b0001_0000
c_minus = 0b0001_0001
c_go    = 0b0001_0010
c_ad    = 0b0001_0011

def write_byte(gpio, data):
    print("0x{:02x} -> 0x{:02x}".format(data, 0b0100_0000 | ((data >> 4) & 0b0000_1111)))
    # nmi low & upper nibble
    gpio.write(0b0100_0000 | ((data >> 4) & 0b0000_1111))
    gpio.write(0b0000_0000 | ((data >> 4) & 0b0000_1111))
    # nmi low & lower nibble
    gpio.write(0b0100_0000 | ((data >> 0) & 0b0000_1111))
    gpio.write(0b0000_0000 | ((data >> 0) & 0b0000_1111))
    # nmi low & plus key
    gpio.write(0b0100_0000 | c_plus)
    gpio.write(0b0000_0000 | c_plus)
    



if len(sys.argv) < 4:
    print("{} <ftdi_type> <ftdi_serialnumber> <ftdi_instance>\n".format(sys.argv[0]))
    sys.exit(-1)

ftdi_type = sys.argv[1]    
ftdi_serial = sys.argv[2]
ftdi_instance = sys.argv[3]

url = "ftdi://ftdi:{}:{}/{}".format(ftdi_type, ftdi_serial, ftdi_instance)



# ftdi = Ftdi()
# ftdi.open_from_url(url)
# eeprom = FtdiEeprom()
# eeprom.connect(ftdi)
# print("cbus mask {}".format(eeprom.cbus_mask))
# ftdi.close()
 
gpio = GpioAsyncController()
gpio.configure(url, direction=0b1111_1111)

write_byte(gpio, 0x23)

sys.exit(0)

ftdi = Ftdi()
ftdi.open_from_url(url)
ftdi.open_bitbang_from_url(url, 0b1111_1111)
ftdi.close()
