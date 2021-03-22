# Ideas

## Notes
- Need xtal for clock (issue 14) 8MHZ for Z80A
- display and tape (issue 15 page 47)
- single stepper (issue 15 page 51)
- Z80B can do 6MHz
- Add clock generation to cpld (2/4/6MHz)
- Mux keyboard and ft2232 through cpld for keyboard emulation

## Memory Map
| Address Range | Purpose | Notes | 
|:-------------:|:-------------:|:-------------|
| 0000-07FF     | 2k ROM | Bank select from 27C040 (512k!) |
| 0800-27FF     | 8k RAM | Use 27C64 (8k) |
| 1800-1FFF     | 2k ROM | Printer ROM |


## IO Map
