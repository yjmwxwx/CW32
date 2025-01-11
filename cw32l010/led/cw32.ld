
SECTIONS
{
        /* interrupt vectors start at zero */
        . = 0x0;  /* start of flash */

        .text :  {  *(.text)   }

        /* constant data follows code but still in flash */
        .data :
        {
          *(.data)
          *(.rom)
        }

        /* internal RAM starts at 0x20000000 */
        . = 0x20000000;
        .ram : { *(.ram) }

        .bss :
        {
          *(.bss)
          *(.ram)
        }
}
