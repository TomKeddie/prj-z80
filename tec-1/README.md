# Ideas

## Notes
- Need xtal for clock (issue 14) 8MHZ for Z80A
- display and tape (issue 15 page 47)
- single stepper (issue 15 page 51)
- Z80B can do 6MHz
- Add clock generation to cpld (2/4/6MHz)
- Mux keyboard and ft2232 through cpld for keyboard emulation
- flash A18 is wired to z80 A12 to split the chip in two
- shift button (issue 13 page 10)
- 8x8 display (issue 11 pag 22)
- lcd interface (issue 15 page 49)

## CPLDs
### Address (97%)
- memory address decode and bank select flash
- memory address decode sram x 2
- cpu clock divide
- io address decode for keyboard, led display

### Data0 (100%)
- keyboard mux
- led display column store
- speaker

### Data1 (TBD)
- Data bus {8 pins}
- Address bus {3 pins}
- Control bus {2 pins}
- 8x8 led store (x and y) {16 pins}
- io address decode for 8x8 led {no pins}
- io address decode for lcd display {1 pin}
- single step {3 pins}
- jmon keyboard {1 pin}

## Memory Map
| Address Range | Purpose | Notes | 
|:-------------:|:-------------:|:-------------|
| 0000-07FF     | 2k ROM | Bank select from 27C040 |
| 0800-17FF     | 4k RAM | Use 1/2 2264 (8k) |
| 1800-1FFF     | 2k ROM | Bank select from 27C040 |
| 2000-2FFF     | 4k RAM | Use 1/2 2264 (8k) |

## IO Map
