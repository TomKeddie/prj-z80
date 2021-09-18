import sys,logging
from pyftdi.gpio import Ftdi, GpioAsyncController
from pyftdi.eeprom import FtdiEeprom

if len(sys.argv) < 4:
    print("{} <ftdi_type> <ftdi_serialnumber> <ftdi_instance>\n".format(sys.argv[0]))
    sys.exit(-1)

ftdi_type = sys.argv[1]    
ftdi_serial = sys.argv[2]
ftdi_instance = sys.argv[3]

url = "ftdi://ftdi:{}:{}/{}".format(ftdi_type, ftdi_serial, ftdi_instance)

gpio = GpioAsyncController()
gpio.configure(url, direction=0b1111_1111)
for ix in range(0, 100):
    gpio.write(ix)

sys.exit(0)
ftdi = Ftdi()
#ftdi.open_from_url(url)
ftdi.open_bitbang_from_url(url, 0b1111_1111)

# eeprom = FtdiEeprom()
# eeprom.connect(ftdi)
# print("cbus mask {}".format(eeprom.cbus_mask))

# ftdi.set_bitmode(0b1111_1111, Ftdi.BitMode.BITBANG)# Ftdi.BitMode.CBUS)
# ftdi.set_cbus_direction(0b1111, 0b1111)

ftdi.write_data(bytes(0b1100_0000))
#ftdi.set_cbus_gpio(0b0000)
#ftdi.set_cbus_gpio(0b0001)
#ftdi.set_cbus_gpio(0b0000)

ftdi.close()
