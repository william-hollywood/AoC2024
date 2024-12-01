SECTIONS
{
	. = 0x80000000;
	.text : {
		*(.text)
		*(.lib)
	}
	. = ALIGN (CONSTANT (COMMONPAGESIZE));
	.data : {
		*(.data)
	}
}
