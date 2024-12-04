SECTIONS
{
	. = 0x80000000;
	.text : {
		*(.text)
		*(.lib)
		*(.libday)
		*(.libtest)
	}
	. = ALIGN (CONSTANT (COMMONPAGESIZE));
	.data : {
		*(.data)
	}
}
