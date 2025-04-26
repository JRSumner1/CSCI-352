
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 00 11 00       	mov    $0x110000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 00 11 f0       	mov    $0xf0110000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 56 00 00 00       	call   f0100094 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <test_backtrace>:
#include <kern/console.h>

// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 0c             	sub    $0xc,%esp
f0100047:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("entering test_backtrace %d\n", x);
f010004a:	53                   	push   %ebx
f010004b:	68 80 18 10 f0       	push   $0xf0101880
f0100050:	e8 e5 08 00 00       	call   f010093a <cprintf>
	if (x > 0)
f0100055:	83 c4 10             	add    $0x10,%esp
f0100058:	85 db                	test   %ebx,%ebx
f010005a:	7f 27                	jg     f0100083 <test_backtrace+0x43>
		test_backtrace(x-1);
	else
		mon_backtrace(0, 0, 0);
f010005c:	83 ec 04             	sub    $0x4,%esp
f010005f:	6a 00                	push   $0x0
f0100061:	6a 00                	push   $0x0
f0100063:	6a 00                	push   $0x0
f0100065:	e8 12 07 00 00       	call   f010077c <mon_backtrace>
f010006a:	83 c4 10             	add    $0x10,%esp
	cprintf("leaving test_backtrace %d\n", x);
f010006d:	83 ec 08             	sub    $0x8,%esp
f0100070:	53                   	push   %ebx
f0100071:	68 9c 18 10 f0       	push   $0xf010189c
f0100076:	e8 bf 08 00 00       	call   f010093a <cprintf>
}
f010007b:	83 c4 10             	add    $0x10,%esp
f010007e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100081:	c9                   	leave  
f0100082:	c3                   	ret    
		test_backtrace(x-1);
f0100083:	83 ec 0c             	sub    $0xc,%esp
f0100086:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100089:	50                   	push   %eax
f010008a:	e8 b1 ff ff ff       	call   f0100040 <test_backtrace>
f010008f:	83 c4 10             	add    $0x10,%esp
f0100092:	eb d9                	jmp    f010006d <test_backtrace+0x2d>

f0100094 <i386_init>:

void
i386_init(void)
{
f0100094:	55                   	push   %ebp
f0100095:	89 e5                	mov    %esp,%ebp
f0100097:	83 ec 0c             	sub    $0xc,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f010009a:	b8 40 29 11 f0       	mov    $0xf0112940,%eax
f010009f:	2d 00 23 11 f0       	sub    $0xf0112300,%eax
f01000a4:	50                   	push   %eax
f01000a5:	6a 00                	push   $0x0
f01000a7:	68 00 23 11 f0       	push   $0xf0112300
f01000ac:	e8 8e 13 00 00       	call   f010143f <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01000b1:	e8 b5 04 00 00       	call   f010056b <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f01000b6:	83 c4 08             	add    $0x8,%esp
f01000b9:	68 ac 1a 00 00       	push   $0x1aac
f01000be:	68 b7 18 10 f0       	push   $0xf01018b7
f01000c3:	e8 72 08 00 00       	call   f010093a <cprintf>

	// Test the stack backtrace function (lab 1 only)
	test_backtrace(5);
f01000c8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
f01000cf:	e8 6c ff ff ff       	call   f0100040 <test_backtrace>
f01000d4:	83 c4 10             	add    $0x10,%esp

	// Drop into the kernel monitor.
	while (1)
		monitor(NULL);
f01000d7:	83 ec 0c             	sub    $0xc,%esp
f01000da:	6a 00                	push   $0x0
f01000dc:	e8 e3 06 00 00       	call   f01007c4 <monitor>
f01000e1:	83 c4 10             	add    $0x10,%esp
f01000e4:	eb f1                	jmp    f01000d7 <i386_init+0x43>

f01000e6 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f01000e6:	55                   	push   %ebp
f01000e7:	89 e5                	mov    %esp,%ebp
f01000e9:	56                   	push   %esi
f01000ea:	53                   	push   %ebx
f01000eb:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f01000ee:	83 3d 44 29 11 f0 00 	cmpl   $0x0,0xf0112944
f01000f5:	74 0f                	je     f0100106 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000f7:	83 ec 0c             	sub    $0xc,%esp
f01000fa:	6a 00                	push   $0x0
f01000fc:	e8 c3 06 00 00       	call   f01007c4 <monitor>
f0100101:	83 c4 10             	add    $0x10,%esp
f0100104:	eb f1                	jmp    f01000f7 <_panic+0x11>
	panicstr = fmt;
f0100106:	89 35 44 29 11 f0    	mov    %esi,0xf0112944
	asm volatile("cli; cld");
f010010c:	fa                   	cli    
f010010d:	fc                   	cld    
	va_start(ap, fmt);
f010010e:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic at %s:%d: ", file, line);
f0100111:	83 ec 04             	sub    $0x4,%esp
f0100114:	ff 75 0c             	pushl  0xc(%ebp)
f0100117:	ff 75 08             	pushl  0x8(%ebp)
f010011a:	68 d2 18 10 f0       	push   $0xf01018d2
f010011f:	e8 16 08 00 00       	call   f010093a <cprintf>
	vcprintf(fmt, ap);
f0100124:	83 c4 08             	add    $0x8,%esp
f0100127:	53                   	push   %ebx
f0100128:	56                   	push   %esi
f0100129:	e8 e6 07 00 00       	call   f0100914 <vcprintf>
	cprintf("\n");
f010012e:	c7 04 24 0e 19 10 f0 	movl   $0xf010190e,(%esp)
f0100135:	e8 00 08 00 00       	call   f010093a <cprintf>
f010013a:	83 c4 10             	add    $0x10,%esp
f010013d:	eb b8                	jmp    f01000f7 <_panic+0x11>

f010013f <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010013f:	55                   	push   %ebp
f0100140:	89 e5                	mov    %esp,%ebp
f0100142:	53                   	push   %ebx
f0100143:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100146:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100149:	ff 75 0c             	pushl  0xc(%ebp)
f010014c:	ff 75 08             	pushl  0x8(%ebp)
f010014f:	68 ea 18 10 f0       	push   $0xf01018ea
f0100154:	e8 e1 07 00 00       	call   f010093a <cprintf>
	vcprintf(fmt, ap);
f0100159:	83 c4 08             	add    $0x8,%esp
f010015c:	53                   	push   %ebx
f010015d:	ff 75 10             	pushl  0x10(%ebp)
f0100160:	e8 af 07 00 00       	call   f0100914 <vcprintf>
	cprintf("\n");
f0100165:	c7 04 24 0e 19 10 f0 	movl   $0xf010190e,(%esp)
f010016c:	e8 c9 07 00 00       	call   f010093a <cprintf>
	va_end(ap);
}
f0100171:	83 c4 10             	add    $0x10,%esp
f0100174:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100177:	c9                   	leave  
f0100178:	c3                   	ret    

f0100179 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100179:	55                   	push   %ebp
f010017a:	89 e5                	mov    %esp,%ebp

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010017c:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100181:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100182:	a8 01                	test   $0x1,%al
f0100184:	74 0b                	je     f0100191 <serial_proc_data+0x18>
f0100186:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010018b:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f010018c:	0f b6 c0             	movzbl %al,%eax
}
f010018f:	5d                   	pop    %ebp
f0100190:	c3                   	ret    
		return -1;
f0100191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100196:	eb f7                	jmp    f010018f <serial_proc_data+0x16>

f0100198 <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f0100198:	55                   	push   %ebp
f0100199:	89 e5                	mov    %esp,%ebp
f010019b:	53                   	push   %ebx
f010019c:	83 ec 04             	sub    $0x4,%esp
f010019f:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01001a1:	ff d3                	call   *%ebx
f01001a3:	83 f8 ff             	cmp    $0xffffffff,%eax
f01001a6:	74 2d                	je     f01001d5 <cons_intr+0x3d>
		if (c == 0)
f01001a8:	85 c0                	test   %eax,%eax
f01001aa:	74 f5                	je     f01001a1 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f01001ac:	8b 0d 24 25 11 f0    	mov    0xf0112524,%ecx
f01001b2:	8d 51 01             	lea    0x1(%ecx),%edx
f01001b5:	89 15 24 25 11 f0    	mov    %edx,0xf0112524
f01001bb:	88 81 20 23 11 f0    	mov    %al,-0xfeedce0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f01001c1:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01001c7:	75 d8                	jne    f01001a1 <cons_intr+0x9>
			cons.wpos = 0;
f01001c9:	c7 05 24 25 11 f0 00 	movl   $0x0,0xf0112524
f01001d0:	00 00 00 
f01001d3:	eb cc                	jmp    f01001a1 <cons_intr+0x9>
	}
}
f01001d5:	83 c4 04             	add    $0x4,%esp
f01001d8:	5b                   	pop    %ebx
f01001d9:	5d                   	pop    %ebp
f01001da:	c3                   	ret    

f01001db <kbd_proc_data>:
{
f01001db:	55                   	push   %ebp
f01001dc:	89 e5                	mov    %esp,%ebp
f01001de:	53                   	push   %ebx
f01001df:	83 ec 04             	sub    $0x4,%esp
f01001e2:	ba 64 00 00 00       	mov    $0x64,%edx
f01001e7:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01001e8:	a8 01                	test   $0x1,%al
f01001ea:	0f 84 fa 00 00 00    	je     f01002ea <kbd_proc_data+0x10f>
	if (stat & KBS_TERR)
f01001f0:	a8 20                	test   $0x20,%al
f01001f2:	0f 85 f9 00 00 00    	jne    f01002f1 <kbd_proc_data+0x116>
f01001f8:	ba 60 00 00 00       	mov    $0x60,%edx
f01001fd:	ec                   	in     (%dx),%al
f01001fe:	89 c2                	mov    %eax,%edx
	if (data == 0xE0) {
f0100200:	3c e0                	cmp    $0xe0,%al
f0100202:	0f 84 8e 00 00 00    	je     f0100296 <kbd_proc_data+0xbb>
	} else if (data & 0x80) {
f0100208:	84 c0                	test   %al,%al
f010020a:	0f 88 99 00 00 00    	js     f01002a9 <kbd_proc_data+0xce>
	} else if (shift & E0ESC) {
f0100210:	8b 0d 00 23 11 f0    	mov    0xf0112300,%ecx
f0100216:	f6 c1 40             	test   $0x40,%cl
f0100219:	74 0e                	je     f0100229 <kbd_proc_data+0x4e>
		data |= 0x80;
f010021b:	83 c8 80             	or     $0xffffff80,%eax
f010021e:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100220:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100223:	89 0d 00 23 11 f0    	mov    %ecx,0xf0112300
	shift |= shiftcode[data];
f0100229:	0f b6 d2             	movzbl %dl,%edx
f010022c:	0f b6 82 60 1a 10 f0 	movzbl -0xfefe5a0(%edx),%eax
f0100233:	0b 05 00 23 11 f0    	or     0xf0112300,%eax
	shift ^= togglecode[data];
f0100239:	0f b6 8a 60 19 10 f0 	movzbl -0xfefe6a0(%edx),%ecx
f0100240:	31 c8                	xor    %ecx,%eax
f0100242:	a3 00 23 11 f0       	mov    %eax,0xf0112300
	c = charcode[shift & (CTL | SHIFT)][data];
f0100247:	89 c1                	mov    %eax,%ecx
f0100249:	83 e1 03             	and    $0x3,%ecx
f010024c:	8b 0c 8d 40 19 10 f0 	mov    -0xfefe6c0(,%ecx,4),%ecx
f0100253:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100257:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f010025a:	a8 08                	test   $0x8,%al
f010025c:	74 0d                	je     f010026b <kbd_proc_data+0x90>
		if ('a' <= c && c <= 'z')
f010025e:	89 da                	mov    %ebx,%edx
f0100260:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100263:	83 f9 19             	cmp    $0x19,%ecx
f0100266:	77 74                	ja     f01002dc <kbd_proc_data+0x101>
			c += 'A' - 'a';
f0100268:	83 eb 20             	sub    $0x20,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010026b:	f7 d0                	not    %eax
f010026d:	a8 06                	test   $0x6,%al
f010026f:	75 31                	jne    f01002a2 <kbd_proc_data+0xc7>
f0100271:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100277:	75 29                	jne    f01002a2 <kbd_proc_data+0xc7>
		cprintf("Rebooting!\n");
f0100279:	83 ec 0c             	sub    $0xc,%esp
f010027c:	68 04 19 10 f0       	push   $0xf0101904
f0100281:	e8 b4 06 00 00       	call   f010093a <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100286:	b8 03 00 00 00       	mov    $0x3,%eax
f010028b:	ba 92 00 00 00       	mov    $0x92,%edx
f0100290:	ee                   	out    %al,(%dx)
f0100291:	83 c4 10             	add    $0x10,%esp
f0100294:	eb 0c                	jmp    f01002a2 <kbd_proc_data+0xc7>
		shift |= E0ESC;
f0100296:	83 0d 00 23 11 f0 40 	orl    $0x40,0xf0112300
		return 0;
f010029d:	bb 00 00 00 00       	mov    $0x0,%ebx
}
f01002a2:	89 d8                	mov    %ebx,%eax
f01002a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01002a7:	c9                   	leave  
f01002a8:	c3                   	ret    
		data = (shift & E0ESC ? data : data & 0x7F);
f01002a9:	8b 0d 00 23 11 f0    	mov    0xf0112300,%ecx
f01002af:	89 cb                	mov    %ecx,%ebx
f01002b1:	83 e3 40             	and    $0x40,%ebx
f01002b4:	83 e0 7f             	and    $0x7f,%eax
f01002b7:	85 db                	test   %ebx,%ebx
f01002b9:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01002bc:	0f b6 d2             	movzbl %dl,%edx
f01002bf:	0f b6 82 60 1a 10 f0 	movzbl -0xfefe5a0(%edx),%eax
f01002c6:	83 c8 40             	or     $0x40,%eax
f01002c9:	0f b6 c0             	movzbl %al,%eax
f01002cc:	f7 d0                	not    %eax
f01002ce:	21 c8                	and    %ecx,%eax
f01002d0:	a3 00 23 11 f0       	mov    %eax,0xf0112300
		return 0;
f01002d5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01002da:	eb c6                	jmp    f01002a2 <kbd_proc_data+0xc7>
		else if ('A' <= c && c <= 'Z')
f01002dc:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f01002df:	8d 4b 20             	lea    0x20(%ebx),%ecx
f01002e2:	83 fa 1a             	cmp    $0x1a,%edx
f01002e5:	0f 42 d9             	cmovb  %ecx,%ebx
f01002e8:	eb 81                	jmp    f010026b <kbd_proc_data+0x90>
		return -1;
f01002ea:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01002ef:	eb b1                	jmp    f01002a2 <kbd_proc_data+0xc7>
		return -1;
f01002f1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01002f6:	eb aa                	jmp    f01002a2 <kbd_proc_data+0xc7>

f01002f8 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01002f8:	55                   	push   %ebp
f01002f9:	89 e5                	mov    %esp,%ebp
f01002fb:	57                   	push   %edi
f01002fc:	56                   	push   %esi
f01002fd:	53                   	push   %ebx
f01002fe:	83 ec 1c             	sub    $0x1c,%esp
f0100301:	89 c7                	mov    %eax,%edi
	for (i = 0;
f0100303:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100308:	be fd 03 00 00       	mov    $0x3fd,%esi
f010030d:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100312:	eb 09                	jmp    f010031d <cons_putc+0x25>
f0100314:	89 ca                	mov    %ecx,%edx
f0100316:	ec                   	in     (%dx),%al
f0100317:	ec                   	in     (%dx),%al
f0100318:	ec                   	in     (%dx),%al
f0100319:	ec                   	in     (%dx),%al
	     i++)
f010031a:	83 c3 01             	add    $0x1,%ebx
f010031d:	89 f2                	mov    %esi,%edx
f010031f:	ec                   	in     (%dx),%al
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100320:	a8 20                	test   $0x20,%al
f0100322:	75 08                	jne    f010032c <cons_putc+0x34>
f0100324:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010032a:	7e e8                	jle    f0100314 <cons_putc+0x1c>
	outb(COM1 + COM_TX, c);
f010032c:	89 f8                	mov    %edi,%eax
f010032e:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100331:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100336:	ee                   	out    %al,(%dx)
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100337:	bb 00 00 00 00       	mov    $0x0,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010033c:	be 79 03 00 00       	mov    $0x379,%esi
f0100341:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100346:	eb 09                	jmp    f0100351 <cons_putc+0x59>
f0100348:	89 ca                	mov    %ecx,%edx
f010034a:	ec                   	in     (%dx),%al
f010034b:	ec                   	in     (%dx),%al
f010034c:	ec                   	in     (%dx),%al
f010034d:	ec                   	in     (%dx),%al
f010034e:	83 c3 01             	add    $0x1,%ebx
f0100351:	89 f2                	mov    %esi,%edx
f0100353:	ec                   	in     (%dx),%al
f0100354:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010035a:	7f 04                	jg     f0100360 <cons_putc+0x68>
f010035c:	84 c0                	test   %al,%al
f010035e:	79 e8                	jns    f0100348 <cons_putc+0x50>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100360:	ba 78 03 00 00       	mov    $0x378,%edx
f0100365:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100369:	ee                   	out    %al,(%dx)
f010036a:	ba 7a 03 00 00       	mov    $0x37a,%edx
f010036f:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100374:	ee                   	out    %al,(%dx)
f0100375:	b8 08 00 00 00       	mov    $0x8,%eax
f010037a:	ee                   	out    %al,(%dx)
	if (!(c & ~0xFF))
f010037b:	89 fa                	mov    %edi,%edx
f010037d:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100383:	89 f8                	mov    %edi,%eax
f0100385:	80 cc 07             	or     $0x7,%ah
f0100388:	85 d2                	test   %edx,%edx
f010038a:	0f 44 f8             	cmove  %eax,%edi
	switch (c & 0xff) {
f010038d:	89 f8                	mov    %edi,%eax
f010038f:	0f b6 c0             	movzbl %al,%eax
f0100392:	83 f8 09             	cmp    $0x9,%eax
f0100395:	0f 84 b6 00 00 00    	je     f0100451 <cons_putc+0x159>
f010039b:	83 f8 09             	cmp    $0x9,%eax
f010039e:	7e 73                	jle    f0100413 <cons_putc+0x11b>
f01003a0:	83 f8 0a             	cmp    $0xa,%eax
f01003a3:	0f 84 9b 00 00 00    	je     f0100444 <cons_putc+0x14c>
f01003a9:	83 f8 0d             	cmp    $0xd,%eax
f01003ac:	0f 85 d6 00 00 00    	jne    f0100488 <cons_putc+0x190>
		crt_pos -= (crt_pos % CRT_COLS);
f01003b2:	0f b7 05 28 25 11 f0 	movzwl 0xf0112528,%eax
f01003b9:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01003bf:	c1 e8 16             	shr    $0x16,%eax
f01003c2:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01003c5:	c1 e0 04             	shl    $0x4,%eax
f01003c8:	66 a3 28 25 11 f0    	mov    %ax,0xf0112528
	if (crt_pos >= CRT_SIZE) {
f01003ce:	66 81 3d 28 25 11 f0 	cmpw   $0x7cf,0xf0112528
f01003d5:	cf 07 
f01003d7:	0f 87 ce 00 00 00    	ja     f01004ab <cons_putc+0x1b3>
	outb(addr_6845, 14);
f01003dd:	8b 0d 30 25 11 f0    	mov    0xf0112530,%ecx
f01003e3:	b8 0e 00 00 00       	mov    $0xe,%eax
f01003e8:	89 ca                	mov    %ecx,%edx
f01003ea:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f01003eb:	0f b7 1d 28 25 11 f0 	movzwl 0xf0112528,%ebx
f01003f2:	8d 71 01             	lea    0x1(%ecx),%esi
f01003f5:	89 d8                	mov    %ebx,%eax
f01003f7:	66 c1 e8 08          	shr    $0x8,%ax
f01003fb:	89 f2                	mov    %esi,%edx
f01003fd:	ee                   	out    %al,(%dx)
f01003fe:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100403:	89 ca                	mov    %ecx,%edx
f0100405:	ee                   	out    %al,(%dx)
f0100406:	89 d8                	mov    %ebx,%eax
f0100408:	89 f2                	mov    %esi,%edx
f010040a:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010040b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010040e:	5b                   	pop    %ebx
f010040f:	5e                   	pop    %esi
f0100410:	5f                   	pop    %edi
f0100411:	5d                   	pop    %ebp
f0100412:	c3                   	ret    
	switch (c & 0xff) {
f0100413:	83 f8 08             	cmp    $0x8,%eax
f0100416:	75 70                	jne    f0100488 <cons_putc+0x190>
		if (crt_pos > 0) {
f0100418:	0f b7 05 28 25 11 f0 	movzwl 0xf0112528,%eax
f010041f:	66 85 c0             	test   %ax,%ax
f0100422:	74 b9                	je     f01003dd <cons_putc+0xe5>
			crt_pos--;
f0100424:	83 e8 01             	sub    $0x1,%eax
f0100427:	66 a3 28 25 11 f0    	mov    %ax,0xf0112528
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010042d:	0f b7 c0             	movzwl %ax,%eax
f0100430:	66 81 e7 00 ff       	and    $0xff00,%di
f0100435:	83 cf 20             	or     $0x20,%edi
f0100438:	8b 15 2c 25 11 f0    	mov    0xf011252c,%edx
f010043e:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100442:	eb 8a                	jmp    f01003ce <cons_putc+0xd6>
		crt_pos += CRT_COLS;
f0100444:	66 83 05 28 25 11 f0 	addw   $0x50,0xf0112528
f010044b:	50 
f010044c:	e9 61 ff ff ff       	jmp    f01003b2 <cons_putc+0xba>
		cons_putc(' ');
f0100451:	b8 20 00 00 00       	mov    $0x20,%eax
f0100456:	e8 9d fe ff ff       	call   f01002f8 <cons_putc>
		cons_putc(' ');
f010045b:	b8 20 00 00 00       	mov    $0x20,%eax
f0100460:	e8 93 fe ff ff       	call   f01002f8 <cons_putc>
		cons_putc(' ');
f0100465:	b8 20 00 00 00       	mov    $0x20,%eax
f010046a:	e8 89 fe ff ff       	call   f01002f8 <cons_putc>
		cons_putc(' ');
f010046f:	b8 20 00 00 00       	mov    $0x20,%eax
f0100474:	e8 7f fe ff ff       	call   f01002f8 <cons_putc>
		cons_putc(' ');
f0100479:	b8 20 00 00 00       	mov    $0x20,%eax
f010047e:	e8 75 fe ff ff       	call   f01002f8 <cons_putc>
f0100483:	e9 46 ff ff ff       	jmp    f01003ce <cons_putc+0xd6>
		crt_buf[crt_pos++] = c;		/* write the character */
f0100488:	0f b7 05 28 25 11 f0 	movzwl 0xf0112528,%eax
f010048f:	8d 50 01             	lea    0x1(%eax),%edx
f0100492:	66 89 15 28 25 11 f0 	mov    %dx,0xf0112528
f0100499:	0f b7 c0             	movzwl %ax,%eax
f010049c:	8b 15 2c 25 11 f0    	mov    0xf011252c,%edx
f01004a2:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01004a6:	e9 23 ff ff ff       	jmp    f01003ce <cons_putc+0xd6>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01004ab:	a1 2c 25 11 f0       	mov    0xf011252c,%eax
f01004b0:	83 ec 04             	sub    $0x4,%esp
f01004b3:	68 00 0f 00 00       	push   $0xf00
f01004b8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01004be:	52                   	push   %edx
f01004bf:	50                   	push   %eax
f01004c0:	e8 c7 0f 00 00       	call   f010148c <memmove>
			crt_buf[i] = 0x0700 | ' ';
f01004c5:	8b 15 2c 25 11 f0    	mov    0xf011252c,%edx
f01004cb:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f01004d1:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f01004d7:	83 c4 10             	add    $0x10,%esp
f01004da:	66 c7 00 20 07       	movw   $0x720,(%eax)
f01004df:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01004e2:	39 d0                	cmp    %edx,%eax
f01004e4:	75 f4                	jne    f01004da <cons_putc+0x1e2>
		crt_pos -= CRT_COLS;
f01004e6:	66 83 2d 28 25 11 f0 	subw   $0x50,0xf0112528
f01004ed:	50 
f01004ee:	e9 ea fe ff ff       	jmp    f01003dd <cons_putc+0xe5>

f01004f3 <serial_intr>:
	if (serial_exists)
f01004f3:	80 3d 34 25 11 f0 00 	cmpb   $0x0,0xf0112534
f01004fa:	75 02                	jne    f01004fe <serial_intr+0xb>
f01004fc:	f3 c3                	repz ret 
{
f01004fe:	55                   	push   %ebp
f01004ff:	89 e5                	mov    %esp,%ebp
f0100501:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f0100504:	b8 79 01 10 f0       	mov    $0xf0100179,%eax
f0100509:	e8 8a fc ff ff       	call   f0100198 <cons_intr>
}
f010050e:	c9                   	leave  
f010050f:	c3                   	ret    

f0100510 <kbd_intr>:
{
f0100510:	55                   	push   %ebp
f0100511:	89 e5                	mov    %esp,%ebp
f0100513:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100516:	b8 db 01 10 f0       	mov    $0xf01001db,%eax
f010051b:	e8 78 fc ff ff       	call   f0100198 <cons_intr>
}
f0100520:	c9                   	leave  
f0100521:	c3                   	ret    

f0100522 <cons_getc>:
{
f0100522:	55                   	push   %ebp
f0100523:	89 e5                	mov    %esp,%ebp
f0100525:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f0100528:	e8 c6 ff ff ff       	call   f01004f3 <serial_intr>
	kbd_intr();
f010052d:	e8 de ff ff ff       	call   f0100510 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f0100532:	8b 15 20 25 11 f0    	mov    0xf0112520,%edx
	return 0;
f0100538:	b8 00 00 00 00       	mov    $0x0,%eax
	if (cons.rpos != cons.wpos) {
f010053d:	3b 15 24 25 11 f0    	cmp    0xf0112524,%edx
f0100543:	74 18                	je     f010055d <cons_getc+0x3b>
		c = cons.buf[cons.rpos++];
f0100545:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100548:	89 0d 20 25 11 f0    	mov    %ecx,0xf0112520
f010054e:	0f b6 82 20 23 11 f0 	movzbl -0xfeedce0(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
f0100555:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f010055b:	74 02                	je     f010055f <cons_getc+0x3d>
}
f010055d:	c9                   	leave  
f010055e:	c3                   	ret    
			cons.rpos = 0;
f010055f:	c7 05 20 25 11 f0 00 	movl   $0x0,0xf0112520
f0100566:	00 00 00 
f0100569:	eb f2                	jmp    f010055d <cons_getc+0x3b>

f010056b <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010056b:	55                   	push   %ebp
f010056c:	89 e5                	mov    %esp,%ebp
f010056e:	57                   	push   %edi
f010056f:	56                   	push   %esi
f0100570:	53                   	push   %ebx
f0100571:	83 ec 0c             	sub    $0xc,%esp
	was = *cp;
f0100574:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010057b:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100582:	5a a5 
	if (*cp != 0xA55A) {
f0100584:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010058b:	66 3d 5a a5          	cmp    $0xa55a,%ax
f010058f:	0f 84 b7 00 00 00    	je     f010064c <cons_init+0xe1>
		addr_6845 = MONO_BASE;
f0100595:	c7 05 30 25 11 f0 b4 	movl   $0x3b4,0xf0112530
f010059c:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010059f:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
	outb(addr_6845, 14);
f01005a4:	8b 3d 30 25 11 f0    	mov    0xf0112530,%edi
f01005aa:	b8 0e 00 00 00       	mov    $0xe,%eax
f01005af:	89 fa                	mov    %edi,%edx
f01005b1:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01005b2:	8d 4f 01             	lea    0x1(%edi),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01005b5:	89 ca                	mov    %ecx,%edx
f01005b7:	ec                   	in     (%dx),%al
f01005b8:	0f b6 c0             	movzbl %al,%eax
f01005bb:	c1 e0 08             	shl    $0x8,%eax
f01005be:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01005c0:	b8 0f 00 00 00       	mov    $0xf,%eax
f01005c5:	89 fa                	mov    %edi,%edx
f01005c7:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01005c8:	89 ca                	mov    %ecx,%edx
f01005ca:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f01005cb:	89 35 2c 25 11 f0    	mov    %esi,0xf011252c
	pos |= inb(addr_6845 + 1);
f01005d1:	0f b6 c0             	movzbl %al,%eax
f01005d4:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f01005d6:	66 a3 28 25 11 f0    	mov    %ax,0xf0112528
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01005dc:	bb 00 00 00 00       	mov    $0x0,%ebx
f01005e1:	b9 fa 03 00 00       	mov    $0x3fa,%ecx
f01005e6:	89 d8                	mov    %ebx,%eax
f01005e8:	89 ca                	mov    %ecx,%edx
f01005ea:	ee                   	out    %al,(%dx)
f01005eb:	bf fb 03 00 00       	mov    $0x3fb,%edi
f01005f0:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01005f5:	89 fa                	mov    %edi,%edx
f01005f7:	ee                   	out    %al,(%dx)
f01005f8:	b8 0c 00 00 00       	mov    $0xc,%eax
f01005fd:	ba f8 03 00 00       	mov    $0x3f8,%edx
f0100602:	ee                   	out    %al,(%dx)
f0100603:	be f9 03 00 00       	mov    $0x3f9,%esi
f0100608:	89 d8                	mov    %ebx,%eax
f010060a:	89 f2                	mov    %esi,%edx
f010060c:	ee                   	out    %al,(%dx)
f010060d:	b8 03 00 00 00       	mov    $0x3,%eax
f0100612:	89 fa                	mov    %edi,%edx
f0100614:	ee                   	out    %al,(%dx)
f0100615:	ba fc 03 00 00       	mov    $0x3fc,%edx
f010061a:	89 d8                	mov    %ebx,%eax
f010061c:	ee                   	out    %al,(%dx)
f010061d:	b8 01 00 00 00       	mov    $0x1,%eax
f0100622:	89 f2                	mov    %esi,%edx
f0100624:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100625:	ba fd 03 00 00       	mov    $0x3fd,%edx
f010062a:	ec                   	in     (%dx),%al
f010062b:	89 c3                	mov    %eax,%ebx
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f010062d:	3c ff                	cmp    $0xff,%al
f010062f:	0f 95 05 34 25 11 f0 	setne  0xf0112534
f0100636:	89 ca                	mov    %ecx,%edx
f0100638:	ec                   	in     (%dx),%al
f0100639:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010063e:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010063f:	80 fb ff             	cmp    $0xff,%bl
f0100642:	74 23                	je     f0100667 <cons_init+0xfc>
		cprintf("Serial port does not exist!\n");
}
f0100644:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100647:	5b                   	pop    %ebx
f0100648:	5e                   	pop    %esi
f0100649:	5f                   	pop    %edi
f010064a:	5d                   	pop    %ebp
f010064b:	c3                   	ret    
		*cp = was;
f010064c:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f0100653:	c7 05 30 25 11 f0 d4 	movl   $0x3d4,0xf0112530
f010065a:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f010065d:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f0100662:	e9 3d ff ff ff       	jmp    f01005a4 <cons_init+0x39>
		cprintf("Serial port does not exist!\n");
f0100667:	83 ec 0c             	sub    $0xc,%esp
f010066a:	68 10 19 10 f0       	push   $0xf0101910
f010066f:	e8 c6 02 00 00       	call   f010093a <cprintf>
f0100674:	83 c4 10             	add    $0x10,%esp
}
f0100677:	eb cb                	jmp    f0100644 <cons_init+0xd9>

f0100679 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100679:	55                   	push   %ebp
f010067a:	89 e5                	mov    %esp,%ebp
f010067c:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010067f:	8b 45 08             	mov    0x8(%ebp),%eax
f0100682:	e8 71 fc ff ff       	call   f01002f8 <cons_putc>
}
f0100687:	c9                   	leave  
f0100688:	c3                   	ret    

f0100689 <getchar>:

int
getchar(void)
{
f0100689:	55                   	push   %ebp
f010068a:	89 e5                	mov    %esp,%ebp
f010068c:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010068f:	e8 8e fe ff ff       	call   f0100522 <cons_getc>
f0100694:	85 c0                	test   %eax,%eax
f0100696:	74 f7                	je     f010068f <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100698:	c9                   	leave  
f0100699:	c3                   	ret    

f010069a <iscons>:

int
iscons(int fdnum)
{
f010069a:	55                   	push   %ebp
f010069b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f010069d:	b8 01 00 00 00       	mov    $0x1,%eax
f01006a2:	5d                   	pop    %ebp
f01006a3:	c3                   	ret    

f01006a4 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01006a4:	55                   	push   %ebp
f01006a5:	89 e5                	mov    %esp,%ebp
f01006a7:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01006aa:	68 60 1b 10 f0       	push   $0xf0101b60
f01006af:	68 7e 1b 10 f0       	push   $0xf0101b7e
f01006b4:	68 83 1b 10 f0       	push   $0xf0101b83
f01006b9:	e8 7c 02 00 00       	call   f010093a <cprintf>
f01006be:	83 c4 0c             	add    $0xc,%esp
f01006c1:	68 fc 1b 10 f0       	push   $0xf0101bfc
f01006c6:	68 8c 1b 10 f0       	push   $0xf0101b8c
f01006cb:	68 83 1b 10 f0       	push   $0xf0101b83
f01006d0:	e8 65 02 00 00       	call   f010093a <cprintf>
	return 0;
}
f01006d5:	b8 00 00 00 00       	mov    $0x0,%eax
f01006da:	c9                   	leave  
f01006db:	c3                   	ret    

f01006dc <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01006dc:	55                   	push   %ebp
f01006dd:	89 e5                	mov    %esp,%ebp
f01006df:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01006e2:	68 95 1b 10 f0       	push   $0xf0101b95
f01006e7:	e8 4e 02 00 00       	call   f010093a <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01006ec:	83 c4 08             	add    $0x8,%esp
f01006ef:	68 0c 00 10 00       	push   $0x10000c
f01006f4:	68 24 1c 10 f0       	push   $0xf0101c24
f01006f9:	e8 3c 02 00 00       	call   f010093a <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01006fe:	83 c4 0c             	add    $0xc,%esp
f0100701:	68 0c 00 10 00       	push   $0x10000c
f0100706:	68 0c 00 10 f0       	push   $0xf010000c
f010070b:	68 4c 1c 10 f0       	push   $0xf0101c4c
f0100710:	e8 25 02 00 00       	call   f010093a <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100715:	83 c4 0c             	add    $0xc,%esp
f0100718:	68 79 18 10 00       	push   $0x101879
f010071d:	68 79 18 10 f0       	push   $0xf0101879
f0100722:	68 70 1c 10 f0       	push   $0xf0101c70
f0100727:	e8 0e 02 00 00       	call   f010093a <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010072c:	83 c4 0c             	add    $0xc,%esp
f010072f:	68 00 23 11 00       	push   $0x112300
f0100734:	68 00 23 11 f0       	push   $0xf0112300
f0100739:	68 94 1c 10 f0       	push   $0xf0101c94
f010073e:	e8 f7 01 00 00       	call   f010093a <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100743:	83 c4 0c             	add    $0xc,%esp
f0100746:	68 40 29 11 00       	push   $0x112940
f010074b:	68 40 29 11 f0       	push   $0xf0112940
f0100750:	68 b8 1c 10 f0       	push   $0xf0101cb8
f0100755:	e8 e0 01 00 00       	call   f010093a <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f010075a:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f010075d:	b8 3f 2d 11 f0       	mov    $0xf0112d3f,%eax
f0100762:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100767:	c1 f8 0a             	sar    $0xa,%eax
f010076a:	50                   	push   %eax
f010076b:	68 dc 1c 10 f0       	push   $0xf0101cdc
f0100770:	e8 c5 01 00 00       	call   f010093a <cprintf>
	return 0;
}
f0100775:	b8 00 00 00 00       	mov    $0x0,%eax
f010077a:	c9                   	leave  
f010077b:	c3                   	ret    

f010077c <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f010077c:	55                   	push   %ebp
f010077d:	89 e5                	mov    %esp,%ebp
f010077f:	53                   	push   %ebx
f0100780:	83 ec 10             	sub    $0x10,%esp

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100783:	89 eb                	mov    %ebp,%ebx
	// Pointer Variables
	uint32_t *ebp = (uint32_t *)read_ebp(); // Read the current base pointer (ebp)
	uint32_t *eip;
	uint32_t *args;

	cprintf("Stack backtrace:\n");
f0100785:	68 ae 1b 10 f0       	push   $0xf0101bae
f010078a:	e8 ab 01 00 00       	call   f010093a <cprintf>

	// Walk through stack frames
	while (ebp)
f010078f:	83 c4 10             	add    $0x10,%esp
f0100792:	eb 22                	jmp    f01007b6 <mon_backtrace+0x3a>
	{
		eip = ebp + 1; // Return address (eip) is at ebp + 4 bytes
		args = ebp + 2; // Arguments start at ebp + 8 bytes

		// Print current frame with ebp, eip, and args
		cprintf("	ebp %08x  eip %08x  args %08x %08x %08x %08x %08x\n", ebp, *eip, args[0], args[1], args[2], args[3], args[4]);
f0100794:	ff 73 18             	pushl  0x18(%ebx)
f0100797:	ff 73 14             	pushl  0x14(%ebx)
f010079a:	ff 73 10             	pushl  0x10(%ebx)
f010079d:	ff 73 0c             	pushl  0xc(%ebx)
f01007a0:	ff 73 08             	pushl  0x8(%ebx)
f01007a3:	ff 73 04             	pushl  0x4(%ebx)
f01007a6:	53                   	push   %ebx
f01007a7:	68 08 1d 10 f0       	push   $0xf0101d08
f01007ac:	e8 89 01 00 00       	call   f010093a <cprintf>
		
		// Move to previous frame by dereferencing ebp
		ebp = (uint32_t *)*ebp;
f01007b1:	8b 1b                	mov    (%ebx),%ebx
f01007b3:	83 c4 20             	add    $0x20,%esp
	while (ebp)
f01007b6:	85 db                	test   %ebx,%ebx
f01007b8:	75 da                	jne    f0100794 <mon_backtrace+0x18>
	}

	return 0;
}
f01007ba:	b8 00 00 00 00       	mov    $0x0,%eax
f01007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01007c2:	c9                   	leave  
f01007c3:	c3                   	ret    

f01007c4 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01007c4:	55                   	push   %ebp
f01007c5:	89 e5                	mov    %esp,%ebp
f01007c7:	57                   	push   %edi
f01007c8:	56                   	push   %esi
f01007c9:	53                   	push   %ebx
f01007ca:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01007cd:	68 3c 1d 10 f0       	push   $0xf0101d3c
f01007d2:	e8 63 01 00 00       	call   f010093a <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01007d7:	c7 04 24 60 1d 10 f0 	movl   $0xf0101d60,(%esp)
f01007de:	e8 57 01 00 00       	call   f010093a <cprintf>
f01007e3:	83 c4 10             	add    $0x10,%esp
f01007e6:	eb 47                	jmp    f010082f <monitor+0x6b>
		while (*buf && strchr(WHITESPACE, *buf))
f01007e8:	83 ec 08             	sub    $0x8,%esp
f01007eb:	0f be c0             	movsbl %al,%eax
f01007ee:	50                   	push   %eax
f01007ef:	68 c4 1b 10 f0       	push   $0xf0101bc4
f01007f4:	e8 09 0c 00 00       	call   f0101402 <strchr>
f01007f9:	83 c4 10             	add    $0x10,%esp
f01007fc:	85 c0                	test   %eax,%eax
f01007fe:	74 0a                	je     f010080a <monitor+0x46>
			*buf++ = 0;
f0100800:	c6 03 00             	movb   $0x0,(%ebx)
f0100803:	89 f7                	mov    %esi,%edi
f0100805:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100808:	eb 6b                	jmp    f0100875 <monitor+0xb1>
		if (*buf == 0)
f010080a:	80 3b 00             	cmpb   $0x0,(%ebx)
f010080d:	74 73                	je     f0100882 <monitor+0xbe>
		if (argc == MAXARGS-1) {
f010080f:	83 fe 0f             	cmp    $0xf,%esi
f0100812:	74 09                	je     f010081d <monitor+0x59>
		argv[argc++] = buf;
f0100814:	8d 7e 01             	lea    0x1(%esi),%edi
f0100817:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f010081b:	eb 39                	jmp    f0100856 <monitor+0x92>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f010081d:	83 ec 08             	sub    $0x8,%esp
f0100820:	6a 10                	push   $0x10
f0100822:	68 c9 1b 10 f0       	push   $0xf0101bc9
f0100827:	e8 0e 01 00 00       	call   f010093a <cprintf>
f010082c:	83 c4 10             	add    $0x10,%esp


	while (1) {
		buf = readline("K> ");
f010082f:	83 ec 0c             	sub    $0xc,%esp
f0100832:	68 c0 1b 10 f0       	push   $0xf0101bc0
f0100837:	e8 a9 09 00 00       	call   f01011e5 <readline>
f010083c:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f010083e:	83 c4 10             	add    $0x10,%esp
f0100841:	85 c0                	test   %eax,%eax
f0100843:	74 ea                	je     f010082f <monitor+0x6b>
	argv[argc] = 0;
f0100845:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f010084c:	be 00 00 00 00       	mov    $0x0,%esi
f0100851:	eb 24                	jmp    f0100877 <monitor+0xb3>
			buf++;
f0100853:	83 c3 01             	add    $0x1,%ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f0100856:	0f b6 03             	movzbl (%ebx),%eax
f0100859:	84 c0                	test   %al,%al
f010085b:	74 18                	je     f0100875 <monitor+0xb1>
f010085d:	83 ec 08             	sub    $0x8,%esp
f0100860:	0f be c0             	movsbl %al,%eax
f0100863:	50                   	push   %eax
f0100864:	68 c4 1b 10 f0       	push   $0xf0101bc4
f0100869:	e8 94 0b 00 00       	call   f0101402 <strchr>
f010086e:	83 c4 10             	add    $0x10,%esp
f0100871:	85 c0                	test   %eax,%eax
f0100873:	74 de                	je     f0100853 <monitor+0x8f>
			*buf++ = 0;
f0100875:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100877:	0f b6 03             	movzbl (%ebx),%eax
f010087a:	84 c0                	test   %al,%al
f010087c:	0f 85 66 ff ff ff    	jne    f01007e8 <monitor+0x24>
	argv[argc] = 0;
f0100882:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100889:	00 
	if (argc == 0)
f010088a:	85 f6                	test   %esi,%esi
f010088c:	74 a1                	je     f010082f <monitor+0x6b>
		if (strcmp(argv[0], commands[i].name) == 0)
f010088e:	83 ec 08             	sub    $0x8,%esp
f0100891:	68 7e 1b 10 f0       	push   $0xf0101b7e
f0100896:	ff 75 a8             	pushl  -0x58(%ebp)
f0100899:	e8 06 0b 00 00       	call   f01013a4 <strcmp>
f010089e:	83 c4 10             	add    $0x10,%esp
f01008a1:	85 c0                	test   %eax,%eax
f01008a3:	74 34                	je     f01008d9 <monitor+0x115>
f01008a5:	83 ec 08             	sub    $0x8,%esp
f01008a8:	68 8c 1b 10 f0       	push   $0xf0101b8c
f01008ad:	ff 75 a8             	pushl  -0x58(%ebp)
f01008b0:	e8 ef 0a 00 00       	call   f01013a4 <strcmp>
f01008b5:	83 c4 10             	add    $0x10,%esp
f01008b8:	85 c0                	test   %eax,%eax
f01008ba:	74 18                	je     f01008d4 <monitor+0x110>
	cprintf("Unknown command '%s'\n", argv[0]);
f01008bc:	83 ec 08             	sub    $0x8,%esp
f01008bf:	ff 75 a8             	pushl  -0x58(%ebp)
f01008c2:	68 e6 1b 10 f0       	push   $0xf0101be6
f01008c7:	e8 6e 00 00 00       	call   f010093a <cprintf>
f01008cc:	83 c4 10             	add    $0x10,%esp
f01008cf:	e9 5b ff ff ff       	jmp    f010082f <monitor+0x6b>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f01008d4:	b8 01 00 00 00       	mov    $0x1,%eax
			return commands[i].func(argc, argv, tf);
f01008d9:	83 ec 04             	sub    $0x4,%esp
f01008dc:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01008df:	ff 75 08             	pushl  0x8(%ebp)
f01008e2:	8d 55 a8             	lea    -0x58(%ebp),%edx
f01008e5:	52                   	push   %edx
f01008e6:	56                   	push   %esi
f01008e7:	ff 14 85 90 1d 10 f0 	call   *-0xfefe270(,%eax,4)
			if (runcmd(buf, tf) < 0)
f01008ee:	83 c4 10             	add    $0x10,%esp
f01008f1:	85 c0                	test   %eax,%eax
f01008f3:	0f 89 36 ff ff ff    	jns    f010082f <monitor+0x6b>
				break;
	}
}
f01008f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01008fc:	5b                   	pop    %ebx
f01008fd:	5e                   	pop    %esi
f01008fe:	5f                   	pop    %edi
f01008ff:	5d                   	pop    %ebp
f0100900:	c3                   	ret    

f0100901 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0100901:	55                   	push   %ebp
f0100902:	89 e5                	mov    %esp,%ebp
f0100904:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0100907:	ff 75 08             	pushl  0x8(%ebp)
f010090a:	e8 6a fd ff ff       	call   f0100679 <cputchar>
	*cnt++;
}
f010090f:	83 c4 10             	add    $0x10,%esp
f0100912:	c9                   	leave  
f0100913:	c3                   	ret    

f0100914 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0100914:	55                   	push   %ebp
f0100915:	89 e5                	mov    %esp,%ebp
f0100917:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f010091a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0100921:	ff 75 0c             	pushl  0xc(%ebp)
f0100924:	ff 75 08             	pushl  0x8(%ebp)
f0100927:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010092a:	50                   	push   %eax
f010092b:	68 01 09 10 f0       	push   $0xf0100901
f0100930:	e8 c5 03 00 00       	call   f0100cfa <vprintfmt>
	return cnt;
}
f0100935:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100938:	c9                   	leave  
f0100939:	c3                   	ret    

f010093a <cprintf>:

int
cprintf(const char *fmt, ...)
{
f010093a:	55                   	push   %ebp
f010093b:	89 e5                	mov    %esp,%ebp
f010093d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0100940:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0100943:	50                   	push   %eax
f0100944:	ff 75 08             	pushl  0x8(%ebp)
f0100947:	e8 c8 ff ff ff       	call   f0100914 <vcprintf>
	va_end(ap);

	return cnt;
}
f010094c:	c9                   	leave  
f010094d:	c3                   	ret    

f010094e <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010094e:	55                   	push   %ebp
f010094f:	89 e5                	mov    %esp,%ebp
f0100951:	57                   	push   %edi
f0100952:	56                   	push   %esi
f0100953:	53                   	push   %ebx
f0100954:	83 ec 14             	sub    $0x14,%esp
f0100957:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010095a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010095d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100960:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0100963:	8b 32                	mov    (%edx),%esi
f0100965:	8b 01                	mov    (%ecx),%eax
f0100967:	89 45 f0             	mov    %eax,-0x10(%ebp)
f010096a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0100971:	eb 2f                	jmp    f01009a2 <stab_binsearch+0x54>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0100973:	83 e8 01             	sub    $0x1,%eax
		while (m >= l && stabs[m].n_type != type)
f0100976:	39 c6                	cmp    %eax,%esi
f0100978:	7f 49                	jg     f01009c3 <stab_binsearch+0x75>
f010097a:	0f b6 0a             	movzbl (%edx),%ecx
f010097d:	83 ea 0c             	sub    $0xc,%edx
f0100980:	39 f9                	cmp    %edi,%ecx
f0100982:	75 ef                	jne    f0100973 <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0100984:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100987:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f010098a:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f010098e:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0100991:	73 35                	jae    f01009c8 <stab_binsearch+0x7a>
			*region_left = m;
f0100993:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100996:	89 06                	mov    %eax,(%esi)
			l = true_m + 1;
f0100998:	8d 73 01             	lea    0x1(%ebx),%esi
		any_matches = 1;
f010099b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	while (l <= r) {
f01009a2:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f01009a5:	7f 4e                	jg     f01009f5 <stab_binsearch+0xa7>
		int true_m = (l + r) / 2, m = true_m;
f01009a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01009aa:	01 f0                	add    %esi,%eax
f01009ac:	89 c3                	mov    %eax,%ebx
f01009ae:	c1 eb 1f             	shr    $0x1f,%ebx
f01009b1:	01 c3                	add    %eax,%ebx
f01009b3:	d1 fb                	sar    %ebx
f01009b5:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01009b8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f01009bb:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f01009bf:	89 d8                	mov    %ebx,%eax
		while (m >= l && stabs[m].n_type != type)
f01009c1:	eb b3                	jmp    f0100976 <stab_binsearch+0x28>
			l = true_m + 1;
f01009c3:	8d 73 01             	lea    0x1(%ebx),%esi
			continue;
f01009c6:	eb da                	jmp    f01009a2 <stab_binsearch+0x54>
		} else if (stabs[m].n_value > addr) {
f01009c8:	3b 55 0c             	cmp    0xc(%ebp),%edx
f01009cb:	76 14                	jbe    f01009e1 <stab_binsearch+0x93>
			*region_right = m - 1;
f01009cd:	83 e8 01             	sub    $0x1,%eax
f01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01009d3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01009d6:	89 03                	mov    %eax,(%ebx)
		any_matches = 1;
f01009d8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01009df:	eb c1                	jmp    f01009a2 <stab_binsearch+0x54>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f01009e1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01009e4:	89 06                	mov    %eax,(%esi)
			l = m;
			addr++;
f01009e6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f01009ea:	89 c6                	mov    %eax,%esi
		any_matches = 1;
f01009ec:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f01009f3:	eb ad                	jmp    f01009a2 <stab_binsearch+0x54>
		}
	}

	if (!any_matches)
f01009f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f01009f9:	74 16                	je     f0100a11 <stab_binsearch+0xc3>
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01009fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01009fe:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0100a00:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0100a03:	8b 0e                	mov    (%esi),%ecx
f0100a05:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100a08:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0100a0b:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
		for (l = *region_right;
f0100a0f:	eb 12                	jmp    f0100a23 <stab_binsearch+0xd5>
		*region_right = *region_left - 1;
f0100a11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100a14:	8b 00                	mov    (%eax),%eax
f0100a16:	83 e8 01             	sub    $0x1,%eax
f0100a19:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0100a1c:	89 07                	mov    %eax,(%edi)
f0100a1e:	eb 16                	jmp    f0100a36 <stab_binsearch+0xe8>
		     l--)
f0100a20:	83 e8 01             	sub    $0x1,%eax
		for (l = *region_right;
f0100a23:	39 c1                	cmp    %eax,%ecx
f0100a25:	7d 0a                	jge    f0100a31 <stab_binsearch+0xe3>
		     l > *region_left && stabs[l].n_type != type;
f0100a27:	0f b6 1a             	movzbl (%edx),%ebx
f0100a2a:	83 ea 0c             	sub    $0xc,%edx
f0100a2d:	39 fb                	cmp    %edi,%ebx
f0100a2f:	75 ef                	jne    f0100a20 <stab_binsearch+0xd2>
			/* do nothing */;
		*region_left = l;
f0100a31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100a34:	89 07                	mov    %eax,(%edi)
	}
}
f0100a36:	83 c4 14             	add    $0x14,%esp
f0100a39:	5b                   	pop    %ebx
f0100a3a:	5e                   	pop    %esi
f0100a3b:	5f                   	pop    %edi
f0100a3c:	5d                   	pop    %ebp
f0100a3d:	c3                   	ret    

f0100a3e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0100a3e:	55                   	push   %ebp
f0100a3f:	89 e5                	mov    %esp,%ebp
f0100a41:	57                   	push   %edi
f0100a42:	56                   	push   %esi
f0100a43:	53                   	push   %ebx
f0100a44:	83 ec 1c             	sub    $0x1c,%esp
f0100a47:	8b 7d 08             	mov    0x8(%ebp),%edi
f0100a4a:	8b 75 0c             	mov    0xc(%ebp),%esi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0100a4d:	c7 06 a0 1d 10 f0    	movl   $0xf0101da0,(%esi)
	info->eip_line = 0;
f0100a53:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
	info->eip_fn_name = "<unknown>";
f0100a5a:	c7 46 08 a0 1d 10 f0 	movl   $0xf0101da0,0x8(%esi)
	info->eip_fn_namelen = 9;
f0100a61:	c7 46 0c 09 00 00 00 	movl   $0x9,0xc(%esi)
	info->eip_fn_addr = addr;
f0100a68:	89 7e 10             	mov    %edi,0x10(%esi)
	info->eip_fn_narg = 0;
f0100a6b:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0100a72:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0100a78:	0f 86 df 00 00 00    	jbe    f0100b5d <debuginfo_eip+0x11f>
		// Can't search for user-level addresses yet!
  	        panic("User address");
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0100a7e:	b8 39 76 10 f0       	mov    $0xf0107639,%eax
f0100a83:	3d a5 5c 10 f0       	cmp    $0xf0105ca5,%eax
f0100a88:	0f 86 61 01 00 00    	jbe    f0100bef <debuginfo_eip+0x1b1>
f0100a8e:	80 3d 38 76 10 f0 00 	cmpb   $0x0,0xf0107638
f0100a95:	0f 85 5b 01 00 00    	jne    f0100bf6 <debuginfo_eip+0x1b8>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0100a9b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0100aa2:	b8 a4 5c 10 f0       	mov    $0xf0105ca4,%eax
f0100aa7:	2d d8 1f 10 f0       	sub    $0xf0101fd8,%eax
f0100aac:	c1 f8 02             	sar    $0x2,%eax
f0100aaf:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100ab5:	83 e8 01             	sub    $0x1,%eax
f0100ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0100abb:	83 ec 08             	sub    $0x8,%esp
f0100abe:	57                   	push   %edi
f0100abf:	6a 64                	push   $0x64
f0100ac1:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0100ac4:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0100ac7:	b8 d8 1f 10 f0       	mov    $0xf0101fd8,%eax
f0100acc:	e8 7d fe ff ff       	call   f010094e <stab_binsearch>
	if (lfile == 0)
f0100ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100ad4:	83 c4 10             	add    $0x10,%esp
f0100ad7:	85 c0                	test   %eax,%eax
f0100ad9:	0f 84 1e 01 00 00    	je     f0100bfd <debuginfo_eip+0x1bf>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0100adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0100ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ae5:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0100ae8:	83 ec 08             	sub    $0x8,%esp
f0100aeb:	57                   	push   %edi
f0100aec:	6a 24                	push   $0x24
f0100aee:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0100af1:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100af4:	b8 d8 1f 10 f0       	mov    $0xf0101fd8,%eax
f0100af9:	e8 50 fe ff ff       	call   f010094e <stab_binsearch>

	if (lfun <= rfun) {
f0100afe:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100b01:	83 c4 10             	add    $0x10,%esp
f0100b04:	3b 5d d8             	cmp    -0x28(%ebp),%ebx
f0100b07:	7f 68                	jg     f0100b71 <debuginfo_eip+0x133>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0100b09:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100b0c:	c1 e0 02             	shl    $0x2,%eax
f0100b0f:	8d 90 d8 1f 10 f0    	lea    -0xfefe028(%eax),%edx
f0100b15:	8b 88 d8 1f 10 f0    	mov    -0xfefe028(%eax),%ecx
f0100b1b:	b8 39 76 10 f0       	mov    $0xf0107639,%eax
f0100b20:	2d a5 5c 10 f0       	sub    $0xf0105ca5,%eax
f0100b25:	39 c1                	cmp    %eax,%ecx
f0100b27:	73 09                	jae    f0100b32 <debuginfo_eip+0xf4>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0100b29:	81 c1 a5 5c 10 f0    	add    $0xf0105ca5,%ecx
f0100b2f:	89 4e 08             	mov    %ecx,0x8(%esi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0100b32:	8b 42 08             	mov    0x8(%edx),%eax
f0100b35:	89 46 10             	mov    %eax,0x10(%esi)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0100b38:	83 ec 08             	sub    $0x8,%esp
f0100b3b:	6a 3a                	push   $0x3a
f0100b3d:	ff 76 08             	pushl  0x8(%esi)
f0100b40:	e8 de 08 00 00       	call   f0101423 <strfind>
f0100b45:	2b 46 08             	sub    0x8(%esi),%eax
f0100b48:	89 46 0c             	mov    %eax,0xc(%esi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0100b4b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100b4e:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100b51:	8d 04 85 dc 1f 10 f0 	lea    -0xfefe024(,%eax,4),%eax
f0100b58:	83 c4 10             	add    $0x10,%esp
f0100b5b:	eb 22                	jmp    f0100b7f <debuginfo_eip+0x141>
  	        panic("User address");
f0100b5d:	83 ec 04             	sub    $0x4,%esp
f0100b60:	68 aa 1d 10 f0       	push   $0xf0101daa
f0100b65:	6a 7f                	push   $0x7f
f0100b67:	68 b7 1d 10 f0       	push   $0xf0101db7
f0100b6c:	e8 75 f5 ff ff       	call   f01000e6 <_panic>
		info->eip_fn_addr = addr;
f0100b71:	89 7e 10             	mov    %edi,0x10(%esi)
		lline = lfile;
f0100b74:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0100b77:	eb bf                	jmp    f0100b38 <debuginfo_eip+0xfa>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0100b79:	83 eb 01             	sub    $0x1,%ebx
f0100b7c:	83 e8 0c             	sub    $0xc,%eax
	while (lline >= lfile
f0100b7f:	39 df                	cmp    %ebx,%edi
f0100b81:	7f 33                	jg     f0100bb6 <debuginfo_eip+0x178>
	       && stabs[lline].n_type != N_SOL
f0100b83:	0f b6 10             	movzbl (%eax),%edx
f0100b86:	80 fa 84             	cmp    $0x84,%dl
f0100b89:	74 0b                	je     f0100b96 <debuginfo_eip+0x158>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0100b8b:	80 fa 64             	cmp    $0x64,%dl
f0100b8e:	75 e9                	jne    f0100b79 <debuginfo_eip+0x13b>
f0100b90:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f0100b94:	74 e3                	je     f0100b79 <debuginfo_eip+0x13b>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0100b96:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100b99:	8b 14 85 d8 1f 10 f0 	mov    -0xfefe028(,%eax,4),%edx
f0100ba0:	b8 39 76 10 f0       	mov    $0xf0107639,%eax
f0100ba5:	2d a5 5c 10 f0       	sub    $0xf0105ca5,%eax
f0100baa:	39 c2                	cmp    %eax,%edx
f0100bac:	73 08                	jae    f0100bb6 <debuginfo_eip+0x178>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0100bae:	81 c2 a5 5c 10 f0    	add    $0xf0105ca5,%edx
f0100bb4:	89 16                	mov    %edx,(%esi)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0100bb6:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0100bb9:	8b 4d d8             	mov    -0x28(%ebp),%ecx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0100bbc:	b8 00 00 00 00       	mov    $0x0,%eax
	if (lfun < rfun)
f0100bc1:	39 cb                	cmp    %ecx,%ebx
f0100bc3:	7d 44                	jge    f0100c09 <debuginfo_eip+0x1cb>
		for (lline = lfun + 1;
f0100bc5:	8d 53 01             	lea    0x1(%ebx),%edx
f0100bc8:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100bcb:	8d 04 85 e8 1f 10 f0 	lea    -0xfefe018(,%eax,4),%eax
f0100bd2:	eb 07                	jmp    f0100bdb <debuginfo_eip+0x19d>
			info->eip_fn_narg++;
f0100bd4:	83 46 14 01          	addl   $0x1,0x14(%esi)
		     lline++)
f0100bd8:	83 c2 01             	add    $0x1,%edx
		for (lline = lfun + 1;
f0100bdb:	39 d1                	cmp    %edx,%ecx
f0100bdd:	74 25                	je     f0100c04 <debuginfo_eip+0x1c6>
f0100bdf:	83 c0 0c             	add    $0xc,%eax
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0100be2:	80 78 f4 a0          	cmpb   $0xa0,-0xc(%eax)
f0100be6:	74 ec                	je     f0100bd4 <debuginfo_eip+0x196>
	return 0;
f0100be8:	b8 00 00 00 00       	mov    $0x0,%eax
f0100bed:	eb 1a                	jmp    f0100c09 <debuginfo_eip+0x1cb>
		return -1;
f0100bef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100bf4:	eb 13                	jmp    f0100c09 <debuginfo_eip+0x1cb>
f0100bf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100bfb:	eb 0c                	jmp    f0100c09 <debuginfo_eip+0x1cb>
		return -1;
f0100bfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100c02:	eb 05                	jmp    f0100c09 <debuginfo_eip+0x1cb>
	return 0;
f0100c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c0c:	5b                   	pop    %ebx
f0100c0d:	5e                   	pop    %esi
f0100c0e:	5f                   	pop    %edi
f0100c0f:	5d                   	pop    %ebp
f0100c10:	c3                   	ret    

f0100c11 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100c11:	55                   	push   %ebp
f0100c12:	89 e5                	mov    %esp,%ebp
f0100c14:	57                   	push   %edi
f0100c15:	56                   	push   %esi
f0100c16:	53                   	push   %ebx
f0100c17:	83 ec 1c             	sub    $0x1c,%esp
f0100c1a:	89 c7                	mov    %eax,%edi
f0100c1c:	89 d6                	mov    %edx,%esi
f0100c1e:	8b 45 08             	mov    0x8(%ebp),%eax
f0100c21:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100c24:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100c27:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100c2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0100c2d:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100c32:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0100c35:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0100c38:	39 d3                	cmp    %edx,%ebx
f0100c3a:	72 05                	jb     f0100c41 <printnum+0x30>
f0100c3c:	39 45 10             	cmp    %eax,0x10(%ebp)
f0100c3f:	77 7a                	ja     f0100cbb <printnum+0xaa>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0100c41:	83 ec 0c             	sub    $0xc,%esp
f0100c44:	ff 75 18             	pushl  0x18(%ebp)
f0100c47:	8b 45 14             	mov    0x14(%ebp),%eax
f0100c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0100c4d:	53                   	push   %ebx
f0100c4e:	ff 75 10             	pushl  0x10(%ebp)
f0100c51:	83 ec 08             	sub    $0x8,%esp
f0100c54:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100c57:	ff 75 e0             	pushl  -0x20(%ebp)
f0100c5a:	ff 75 dc             	pushl  -0x24(%ebp)
f0100c5d:	ff 75 d8             	pushl  -0x28(%ebp)
f0100c60:	e8 db 09 00 00       	call   f0101640 <__udivdi3>
f0100c65:	83 c4 18             	add    $0x18,%esp
f0100c68:	52                   	push   %edx
f0100c69:	50                   	push   %eax
f0100c6a:	89 f2                	mov    %esi,%edx
f0100c6c:	89 f8                	mov    %edi,%eax
f0100c6e:	e8 9e ff ff ff       	call   f0100c11 <printnum>
f0100c73:	83 c4 20             	add    $0x20,%esp
f0100c76:	eb 13                	jmp    f0100c8b <printnum+0x7a>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0100c78:	83 ec 08             	sub    $0x8,%esp
f0100c7b:	56                   	push   %esi
f0100c7c:	ff 75 18             	pushl  0x18(%ebp)
f0100c7f:	ff d7                	call   *%edi
f0100c81:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f0100c84:	83 eb 01             	sub    $0x1,%ebx
f0100c87:	85 db                	test   %ebx,%ebx
f0100c89:	7f ed                	jg     f0100c78 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0100c8b:	83 ec 08             	sub    $0x8,%esp
f0100c8e:	56                   	push   %esi
f0100c8f:	83 ec 04             	sub    $0x4,%esp
f0100c92:	ff 75 e4             	pushl  -0x1c(%ebp)
f0100c95:	ff 75 e0             	pushl  -0x20(%ebp)
f0100c98:	ff 75 dc             	pushl  -0x24(%ebp)
f0100c9b:	ff 75 d8             	pushl  -0x28(%ebp)
f0100c9e:	e8 bd 0a 00 00       	call   f0101760 <__umoddi3>
f0100ca3:	83 c4 14             	add    $0x14,%esp
f0100ca6:	0f be 80 c5 1d 10 f0 	movsbl -0xfefe23b(%eax),%eax
f0100cad:	50                   	push   %eax
f0100cae:	ff d7                	call   *%edi
}
f0100cb0:	83 c4 10             	add    $0x10,%esp
f0100cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100cb6:	5b                   	pop    %ebx
f0100cb7:	5e                   	pop    %esi
f0100cb8:	5f                   	pop    %edi
f0100cb9:	5d                   	pop    %ebp
f0100cba:	c3                   	ret    
f0100cbb:	8b 5d 14             	mov    0x14(%ebp),%ebx
f0100cbe:	eb c4                	jmp    f0100c84 <printnum+0x73>

f0100cc0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0100cc0:	55                   	push   %ebp
f0100cc1:	89 e5                	mov    %esp,%ebp
f0100cc3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0100cc6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0100cca:	8b 10                	mov    (%eax),%edx
f0100ccc:	3b 50 04             	cmp    0x4(%eax),%edx
f0100ccf:	73 0a                	jae    f0100cdb <sprintputch+0x1b>
		*b->buf++ = ch;
f0100cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
f0100cd4:	89 08                	mov    %ecx,(%eax)
f0100cd6:	8b 45 08             	mov    0x8(%ebp),%eax
f0100cd9:	88 02                	mov    %al,(%edx)
}
f0100cdb:	5d                   	pop    %ebp
f0100cdc:	c3                   	ret    

f0100cdd <printfmt>:
{
f0100cdd:	55                   	push   %ebp
f0100cde:	89 e5                	mov    %esp,%ebp
f0100ce0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f0100ce3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0100ce6:	50                   	push   %eax
f0100ce7:	ff 75 10             	pushl  0x10(%ebp)
f0100cea:	ff 75 0c             	pushl  0xc(%ebp)
f0100ced:	ff 75 08             	pushl  0x8(%ebp)
f0100cf0:	e8 05 00 00 00       	call   f0100cfa <vprintfmt>
}
f0100cf5:	83 c4 10             	add    $0x10,%esp
f0100cf8:	c9                   	leave  
f0100cf9:	c3                   	ret    

f0100cfa <vprintfmt>:
{
f0100cfa:	55                   	push   %ebp
f0100cfb:	89 e5                	mov    %esp,%ebp
f0100cfd:	57                   	push   %edi
f0100cfe:	56                   	push   %esi
f0100cff:	53                   	push   %ebx
f0100d00:	83 ec 2c             	sub    $0x2c,%esp
f0100d03:	8b 75 08             	mov    0x8(%ebp),%esi
f0100d06:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0100d09:	8b 7d 10             	mov    0x10(%ebp),%edi
f0100d0c:	e9 c1 03 00 00       	jmp    f01010d2 <vprintfmt+0x3d8>
		padc = ' ';
f0100d11:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
		altflag = 0;
f0100d15:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		precision = -1;
f0100d1c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
		width = -1;
f0100d23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
f0100d2a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0100d2f:	8d 47 01             	lea    0x1(%edi),%eax
f0100d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0100d35:	0f b6 17             	movzbl (%edi),%edx
f0100d38:	8d 42 dd             	lea    -0x23(%edx),%eax
f0100d3b:	3c 55                	cmp    $0x55,%al
f0100d3d:	0f 87 12 04 00 00    	ja     f0101155 <vprintfmt+0x45b>
f0100d43:	0f b6 c0             	movzbl %al,%eax
f0100d46:	ff 24 85 54 1e 10 f0 	jmp    *-0xfefe1ac(,%eax,4)
f0100d4d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0100d50:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f0100d54:	eb d9                	jmp    f0100d2f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0100d56:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0100d59:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0100d5d:	eb d0                	jmp    f0100d2f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0100d5f:	0f b6 d2             	movzbl %dl,%edx
f0100d62:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
f0100d65:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d6a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f0100d6d:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100d70:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
f0100d74:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0100d77:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0100d7a:	83 f9 09             	cmp    $0x9,%ecx
f0100d7d:	77 55                	ja     f0100dd4 <vprintfmt+0xda>
			for (precision = 0; ; ++fmt) {
f0100d7f:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
f0100d82:	eb e9                	jmp    f0100d6d <vprintfmt+0x73>
			precision = va_arg(ap, int);
f0100d84:	8b 45 14             	mov    0x14(%ebp),%eax
f0100d87:	8b 00                	mov    (%eax),%eax
f0100d89:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100d8c:	8b 45 14             	mov    0x14(%ebp),%eax
f0100d8f:	8d 40 04             	lea    0x4(%eax),%eax
f0100d92:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0100d95:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f0100d98:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0100d9c:	79 91                	jns    f0100d2f <vprintfmt+0x35>
				width = precision, precision = -1;
f0100d9e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100da1:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100da4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f0100dab:	eb 82                	jmp    f0100d2f <vprintfmt+0x35>
f0100dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100db0:	85 c0                	test   %eax,%eax
f0100db2:	ba 00 00 00 00       	mov    $0x0,%edx
f0100db7:	0f 49 d0             	cmovns %eax,%edx
f0100dba:	89 55 e0             	mov    %edx,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f0100dbd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0100dc0:	e9 6a ff ff ff       	jmp    f0100d2f <vprintfmt+0x35>
f0100dc5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f0100dc8:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f0100dcf:	e9 5b ff ff ff       	jmp    f0100d2f <vprintfmt+0x35>
f0100dd4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0100dd7:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100dda:	eb bc                	jmp    f0100d98 <vprintfmt+0x9e>
			lflag++;
f0100ddc:	83 c1 01             	add    $0x1,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0100ddf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f0100de2:	e9 48 ff ff ff       	jmp    f0100d2f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f0100de7:	8b 45 14             	mov    0x14(%ebp),%eax
f0100dea:	8d 78 04             	lea    0x4(%eax),%edi
f0100ded:	83 ec 08             	sub    $0x8,%esp
f0100df0:	53                   	push   %ebx
f0100df1:	ff 30                	pushl  (%eax)
f0100df3:	ff d6                	call   *%esi
			break;
f0100df5:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f0100df8:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f0100dfb:	e9 cf 02 00 00       	jmp    f01010cf <vprintfmt+0x3d5>
			err = va_arg(ap, int);
f0100e00:	8b 45 14             	mov    0x14(%ebp),%eax
f0100e03:	8d 78 04             	lea    0x4(%eax),%edi
f0100e06:	8b 00                	mov    (%eax),%eax
f0100e08:	99                   	cltd   
f0100e09:	31 d0                	xor    %edx,%eax
f0100e0b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0100e0d:	83 f8 06             	cmp    $0x6,%eax
f0100e10:	7f 23                	jg     f0100e35 <vprintfmt+0x13b>
f0100e12:	8b 14 85 ac 1f 10 f0 	mov    -0xfefe054(,%eax,4),%edx
f0100e19:	85 d2                	test   %edx,%edx
f0100e1b:	74 18                	je     f0100e35 <vprintfmt+0x13b>
				printfmt(putch, putdat, "%s", p);
f0100e1d:	52                   	push   %edx
f0100e1e:	68 e6 1d 10 f0       	push   $0xf0101de6
f0100e23:	53                   	push   %ebx
f0100e24:	56                   	push   %esi
f0100e25:	e8 b3 fe ff ff       	call   f0100cdd <printfmt>
f0100e2a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0100e2d:	89 7d 14             	mov    %edi,0x14(%ebp)
f0100e30:	e9 9a 02 00 00       	jmp    f01010cf <vprintfmt+0x3d5>
				printfmt(putch, putdat, "error %d", err);
f0100e35:	50                   	push   %eax
f0100e36:	68 dd 1d 10 f0       	push   $0xf0101ddd
f0100e3b:	53                   	push   %ebx
f0100e3c:	56                   	push   %esi
f0100e3d:	e8 9b fe ff ff       	call   f0100cdd <printfmt>
f0100e42:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0100e45:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0100e48:	e9 82 02 00 00       	jmp    f01010cf <vprintfmt+0x3d5>
			if ((p = va_arg(ap, char *)) == NULL)
f0100e4d:	8b 45 14             	mov    0x14(%ebp),%eax
f0100e50:	83 c0 04             	add    $0x4,%eax
f0100e53:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0100e56:	8b 45 14             	mov    0x14(%ebp),%eax
f0100e59:	8b 38                	mov    (%eax),%edi
				p = "(null)";
f0100e5b:	85 ff                	test   %edi,%edi
f0100e5d:	b8 d6 1d 10 f0       	mov    $0xf0101dd6,%eax
f0100e62:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
f0100e65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0100e69:	0f 8e bd 00 00 00    	jle    f0100f2c <vprintfmt+0x232>
f0100e6f:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f0100e73:	75 0e                	jne    f0100e83 <vprintfmt+0x189>
f0100e75:	89 75 08             	mov    %esi,0x8(%ebp)
f0100e78:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0100e7b:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0100e7e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100e81:	eb 6d                	jmp    f0100ef0 <vprintfmt+0x1f6>
				for (width -= strnlen(p, precision); width > 0; width--)
f0100e83:	83 ec 08             	sub    $0x8,%esp
f0100e86:	ff 75 d0             	pushl  -0x30(%ebp)
f0100e89:	57                   	push   %edi
f0100e8a:	e8 50 04 00 00       	call   f01012df <strnlen>
f0100e8f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0100e92:	29 c1                	sub    %eax,%ecx
f0100e94:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0100e97:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f0100e9a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0100e9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100ea1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0100ea4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f0100ea6:	eb 0f                	jmp    f0100eb7 <vprintfmt+0x1bd>
					putch(padc, putdat);
f0100ea8:	83 ec 08             	sub    $0x8,%esp
f0100eab:	53                   	push   %ebx
f0100eac:	ff 75 e0             	pushl  -0x20(%ebp)
f0100eaf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f0100eb1:	83 ef 01             	sub    $0x1,%edi
f0100eb4:	83 c4 10             	add    $0x10,%esp
f0100eb7:	85 ff                	test   %edi,%edi
f0100eb9:	7f ed                	jg     f0100ea8 <vprintfmt+0x1ae>
f0100ebb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0100ebe:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f0100ec1:	85 c9                	test   %ecx,%ecx
f0100ec3:	b8 00 00 00 00       	mov    $0x0,%eax
f0100ec8:	0f 49 c1             	cmovns %ecx,%eax
f0100ecb:	29 c1                	sub    %eax,%ecx
f0100ecd:	89 75 08             	mov    %esi,0x8(%ebp)
f0100ed0:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0100ed3:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0100ed6:	89 cb                	mov    %ecx,%ebx
f0100ed8:	eb 16                	jmp    f0100ef0 <vprintfmt+0x1f6>
				if (altflag && (ch < ' ' || ch > '~'))
f0100eda:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0100ede:	75 31                	jne    f0100f11 <vprintfmt+0x217>
					putch(ch, putdat);
f0100ee0:	83 ec 08             	sub    $0x8,%esp
f0100ee3:	ff 75 0c             	pushl  0xc(%ebp)
f0100ee6:	50                   	push   %eax
f0100ee7:	ff 55 08             	call   *0x8(%ebp)
f0100eea:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0100eed:	83 eb 01             	sub    $0x1,%ebx
f0100ef0:	83 c7 01             	add    $0x1,%edi
f0100ef3:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
f0100ef7:	0f be c2             	movsbl %dl,%eax
f0100efa:	85 c0                	test   %eax,%eax
f0100efc:	74 59                	je     f0100f57 <vprintfmt+0x25d>
f0100efe:	85 f6                	test   %esi,%esi
f0100f00:	78 d8                	js     f0100eda <vprintfmt+0x1e0>
f0100f02:	83 ee 01             	sub    $0x1,%esi
f0100f05:	79 d3                	jns    f0100eda <vprintfmt+0x1e0>
f0100f07:	89 df                	mov    %ebx,%edi
f0100f09:	8b 75 08             	mov    0x8(%ebp),%esi
f0100f0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0100f0f:	eb 37                	jmp    f0100f48 <vprintfmt+0x24e>
				if (altflag && (ch < ' ' || ch > '~'))
f0100f11:	0f be d2             	movsbl %dl,%edx
f0100f14:	83 ea 20             	sub    $0x20,%edx
f0100f17:	83 fa 5e             	cmp    $0x5e,%edx
f0100f1a:	76 c4                	jbe    f0100ee0 <vprintfmt+0x1e6>
					putch('?', putdat);
f0100f1c:	83 ec 08             	sub    $0x8,%esp
f0100f1f:	ff 75 0c             	pushl  0xc(%ebp)
f0100f22:	6a 3f                	push   $0x3f
f0100f24:	ff 55 08             	call   *0x8(%ebp)
f0100f27:	83 c4 10             	add    $0x10,%esp
f0100f2a:	eb c1                	jmp    f0100eed <vprintfmt+0x1f3>
f0100f2c:	89 75 08             	mov    %esi,0x8(%ebp)
f0100f2f:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0100f32:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0100f35:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0100f38:	eb b6                	jmp    f0100ef0 <vprintfmt+0x1f6>
				putch(' ', putdat);
f0100f3a:	83 ec 08             	sub    $0x8,%esp
f0100f3d:	53                   	push   %ebx
f0100f3e:	6a 20                	push   $0x20
f0100f40:	ff d6                	call   *%esi
			for (; width > 0; width--)
f0100f42:	83 ef 01             	sub    $0x1,%edi
f0100f45:	83 c4 10             	add    $0x10,%esp
f0100f48:	85 ff                	test   %edi,%edi
f0100f4a:	7f ee                	jg     f0100f3a <vprintfmt+0x240>
			if ((p = va_arg(ap, char *)) == NULL)
f0100f4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0100f4f:	89 45 14             	mov    %eax,0x14(%ebp)
f0100f52:	e9 78 01 00 00       	jmp    f01010cf <vprintfmt+0x3d5>
f0100f57:	89 df                	mov    %ebx,%edi
f0100f59:	8b 75 08             	mov    0x8(%ebp),%esi
f0100f5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0100f5f:	eb e7                	jmp    f0100f48 <vprintfmt+0x24e>
	if (lflag >= 2)
f0100f61:	83 f9 01             	cmp    $0x1,%ecx
f0100f64:	7e 3f                	jle    f0100fa5 <vprintfmt+0x2ab>
		return va_arg(*ap, long long);
f0100f66:	8b 45 14             	mov    0x14(%ebp),%eax
f0100f69:	8b 50 04             	mov    0x4(%eax),%edx
f0100f6c:	8b 00                	mov    (%eax),%eax
f0100f6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100f71:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0100f74:	8b 45 14             	mov    0x14(%ebp),%eax
f0100f77:	8d 40 08             	lea    0x8(%eax),%eax
f0100f7a:	89 45 14             	mov    %eax,0x14(%ebp)
			if ((long long) num < 0) {
f0100f7d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0100f81:	79 5c                	jns    f0100fdf <vprintfmt+0x2e5>
				putch('-', putdat);
f0100f83:	83 ec 08             	sub    $0x8,%esp
f0100f86:	53                   	push   %ebx
f0100f87:	6a 2d                	push   $0x2d
f0100f89:	ff d6                	call   *%esi
				num = -(long long) num;
f0100f8b:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0100f8e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0100f91:	f7 da                	neg    %edx
f0100f93:	83 d1 00             	adc    $0x0,%ecx
f0100f96:	f7 d9                	neg    %ecx
f0100f98:	83 c4 10             	add    $0x10,%esp
			base = 10;
f0100f9b:	b8 0a 00 00 00       	mov    $0xa,%eax
f0100fa0:	e9 10 01 00 00       	jmp    f01010b5 <vprintfmt+0x3bb>
	else if (lflag)
f0100fa5:	85 c9                	test   %ecx,%ecx
f0100fa7:	75 1b                	jne    f0100fc4 <vprintfmt+0x2ca>
		return va_arg(*ap, int);
f0100fa9:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fac:	8b 00                	mov    (%eax),%eax
f0100fae:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100fb1:	89 c1                	mov    %eax,%ecx
f0100fb3:	c1 f9 1f             	sar    $0x1f,%ecx
f0100fb6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0100fb9:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fbc:	8d 40 04             	lea    0x4(%eax),%eax
f0100fbf:	89 45 14             	mov    %eax,0x14(%ebp)
f0100fc2:	eb b9                	jmp    f0100f7d <vprintfmt+0x283>
		return va_arg(*ap, long);
f0100fc4:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fc7:	8b 00                	mov    (%eax),%eax
f0100fc9:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100fcc:	89 c1                	mov    %eax,%ecx
f0100fce:	c1 f9 1f             	sar    $0x1f,%ecx
f0100fd1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0100fd4:	8b 45 14             	mov    0x14(%ebp),%eax
f0100fd7:	8d 40 04             	lea    0x4(%eax),%eax
f0100fda:	89 45 14             	mov    %eax,0x14(%ebp)
f0100fdd:	eb 9e                	jmp    f0100f7d <vprintfmt+0x283>
			num = getint(&ap, lflag);
f0100fdf:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0100fe2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			base = 10;
f0100fe5:	b8 0a 00 00 00       	mov    $0xa,%eax
f0100fea:	e9 c6 00 00 00       	jmp    f01010b5 <vprintfmt+0x3bb>
	if (lflag >= 2)
f0100fef:	83 f9 01             	cmp    $0x1,%ecx
f0100ff2:	7e 18                	jle    f010100c <vprintfmt+0x312>
		return va_arg(*ap, unsigned long long);
f0100ff4:	8b 45 14             	mov    0x14(%ebp),%eax
f0100ff7:	8b 10                	mov    (%eax),%edx
f0100ff9:	8b 48 04             	mov    0x4(%eax),%ecx
f0100ffc:	8d 40 08             	lea    0x8(%eax),%eax
f0100fff:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0101002:	b8 0a 00 00 00       	mov    $0xa,%eax
f0101007:	e9 a9 00 00 00       	jmp    f01010b5 <vprintfmt+0x3bb>
	else if (lflag)
f010100c:	85 c9                	test   %ecx,%ecx
f010100e:	75 1a                	jne    f010102a <vprintfmt+0x330>
		return va_arg(*ap, unsigned int);
f0101010:	8b 45 14             	mov    0x14(%ebp),%eax
f0101013:	8b 10                	mov    (%eax),%edx
f0101015:	b9 00 00 00 00       	mov    $0x0,%ecx
f010101a:	8d 40 04             	lea    0x4(%eax),%eax
f010101d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0101020:	b8 0a 00 00 00       	mov    $0xa,%eax
f0101025:	e9 8b 00 00 00       	jmp    f01010b5 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f010102a:	8b 45 14             	mov    0x14(%ebp),%eax
f010102d:	8b 10                	mov    (%eax),%edx
f010102f:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101034:	8d 40 04             	lea    0x4(%eax),%eax
f0101037:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010103a:	b8 0a 00 00 00       	mov    $0xa,%eax
f010103f:	eb 74                	jmp    f01010b5 <vprintfmt+0x3bb>
	if (lflag >= 2)
f0101041:	83 f9 01             	cmp    $0x1,%ecx
f0101044:	7e 15                	jle    f010105b <vprintfmt+0x361>
		return va_arg(*ap, unsigned long long);
f0101046:	8b 45 14             	mov    0x14(%ebp),%eax
f0101049:	8b 10                	mov    (%eax),%edx
f010104b:	8b 48 04             	mov    0x4(%eax),%ecx
f010104e:	8d 40 08             	lea    0x8(%eax),%eax
f0101051:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0101054:	b8 08 00 00 00       	mov    $0x8,%eax
f0101059:	eb 5a                	jmp    f01010b5 <vprintfmt+0x3bb>
	else if (lflag)
f010105b:	85 c9                	test   %ecx,%ecx
f010105d:	75 17                	jne    f0101076 <vprintfmt+0x37c>
		return va_arg(*ap, unsigned int);
f010105f:	8b 45 14             	mov    0x14(%ebp),%eax
f0101062:	8b 10                	mov    (%eax),%edx
f0101064:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101069:	8d 40 04             	lea    0x4(%eax),%eax
f010106c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010106f:	b8 08 00 00 00       	mov    $0x8,%eax
f0101074:	eb 3f                	jmp    f01010b5 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f0101076:	8b 45 14             	mov    0x14(%ebp),%eax
f0101079:	8b 10                	mov    (%eax),%edx
f010107b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101080:	8d 40 04             	lea    0x4(%eax),%eax
f0101083:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0101086:	b8 08 00 00 00       	mov    $0x8,%eax
f010108b:	eb 28                	jmp    f01010b5 <vprintfmt+0x3bb>
			putch('0', putdat);
f010108d:	83 ec 08             	sub    $0x8,%esp
f0101090:	53                   	push   %ebx
f0101091:	6a 30                	push   $0x30
f0101093:	ff d6                	call   *%esi
			putch('x', putdat);
f0101095:	83 c4 08             	add    $0x8,%esp
f0101098:	53                   	push   %ebx
f0101099:	6a 78                	push   $0x78
f010109b:	ff d6                	call   *%esi
			num = (unsigned long long)
f010109d:	8b 45 14             	mov    0x14(%ebp),%eax
f01010a0:	8b 10                	mov    (%eax),%edx
f01010a2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f01010a7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f01010aa:	8d 40 04             	lea    0x4(%eax),%eax
f01010ad:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01010b0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f01010b5:	83 ec 0c             	sub    $0xc,%esp
f01010b8:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f01010bc:	57                   	push   %edi
f01010bd:	ff 75 e0             	pushl  -0x20(%ebp)
f01010c0:	50                   	push   %eax
f01010c1:	51                   	push   %ecx
f01010c2:	52                   	push   %edx
f01010c3:	89 da                	mov    %ebx,%edx
f01010c5:	89 f0                	mov    %esi,%eax
f01010c7:	e8 45 fb ff ff       	call   f0100c11 <printnum>
			break;
f01010cc:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f01010cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01010d2:	83 c7 01             	add    $0x1,%edi
f01010d5:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01010d9:	83 f8 25             	cmp    $0x25,%eax
f01010dc:	0f 84 2f fc ff ff    	je     f0100d11 <vprintfmt+0x17>
			if (ch == '\0')
f01010e2:	85 c0                	test   %eax,%eax
f01010e4:	0f 84 8b 00 00 00    	je     f0101175 <vprintfmt+0x47b>
			putch(ch, putdat);
f01010ea:	83 ec 08             	sub    $0x8,%esp
f01010ed:	53                   	push   %ebx
f01010ee:	50                   	push   %eax
f01010ef:	ff d6                	call   *%esi
f01010f1:	83 c4 10             	add    $0x10,%esp
f01010f4:	eb dc                	jmp    f01010d2 <vprintfmt+0x3d8>
	if (lflag >= 2)
f01010f6:	83 f9 01             	cmp    $0x1,%ecx
f01010f9:	7e 15                	jle    f0101110 <vprintfmt+0x416>
		return va_arg(*ap, unsigned long long);
f01010fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01010fe:	8b 10                	mov    (%eax),%edx
f0101100:	8b 48 04             	mov    0x4(%eax),%ecx
f0101103:	8d 40 08             	lea    0x8(%eax),%eax
f0101106:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101109:	b8 10 00 00 00       	mov    $0x10,%eax
f010110e:	eb a5                	jmp    f01010b5 <vprintfmt+0x3bb>
	else if (lflag)
f0101110:	85 c9                	test   %ecx,%ecx
f0101112:	75 17                	jne    f010112b <vprintfmt+0x431>
		return va_arg(*ap, unsigned int);
f0101114:	8b 45 14             	mov    0x14(%ebp),%eax
f0101117:	8b 10                	mov    (%eax),%edx
f0101119:	b9 00 00 00 00       	mov    $0x0,%ecx
f010111e:	8d 40 04             	lea    0x4(%eax),%eax
f0101121:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0101124:	b8 10 00 00 00       	mov    $0x10,%eax
f0101129:	eb 8a                	jmp    f01010b5 <vprintfmt+0x3bb>
		return va_arg(*ap, unsigned long);
f010112b:	8b 45 14             	mov    0x14(%ebp),%eax
f010112e:	8b 10                	mov    (%eax),%edx
f0101130:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101135:	8d 40 04             	lea    0x4(%eax),%eax
f0101138:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f010113b:	b8 10 00 00 00       	mov    $0x10,%eax
f0101140:	e9 70 ff ff ff       	jmp    f01010b5 <vprintfmt+0x3bb>
			putch(ch, putdat);
f0101145:	83 ec 08             	sub    $0x8,%esp
f0101148:	53                   	push   %ebx
f0101149:	6a 25                	push   $0x25
f010114b:	ff d6                	call   *%esi
			break;
f010114d:	83 c4 10             	add    $0x10,%esp
f0101150:	e9 7a ff ff ff       	jmp    f01010cf <vprintfmt+0x3d5>
			putch('%', putdat);
f0101155:	83 ec 08             	sub    $0x8,%esp
f0101158:	53                   	push   %ebx
f0101159:	6a 25                	push   $0x25
f010115b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f010115d:	83 c4 10             	add    $0x10,%esp
f0101160:	89 f8                	mov    %edi,%eax
f0101162:	eb 03                	jmp    f0101167 <vprintfmt+0x46d>
f0101164:	83 e8 01             	sub    $0x1,%eax
f0101167:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f010116b:	75 f7                	jne    f0101164 <vprintfmt+0x46a>
f010116d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101170:	e9 5a ff ff ff       	jmp    f01010cf <vprintfmt+0x3d5>
}
f0101175:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101178:	5b                   	pop    %ebx
f0101179:	5e                   	pop    %esi
f010117a:	5f                   	pop    %edi
f010117b:	5d                   	pop    %ebp
f010117c:	c3                   	ret    

f010117d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f010117d:	55                   	push   %ebp
f010117e:	89 e5                	mov    %esp,%ebp
f0101180:	83 ec 18             	sub    $0x18,%esp
f0101183:	8b 45 08             	mov    0x8(%ebp),%eax
f0101186:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0101189:	89 45 ec             	mov    %eax,-0x14(%ebp)
f010118c:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0101190:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0101193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f010119a:	85 c0                	test   %eax,%eax
f010119c:	74 26                	je     f01011c4 <vsnprintf+0x47>
f010119e:	85 d2                	test   %edx,%edx
f01011a0:	7e 22                	jle    f01011c4 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01011a2:	ff 75 14             	pushl  0x14(%ebp)
f01011a5:	ff 75 10             	pushl  0x10(%ebp)
f01011a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01011ab:	50                   	push   %eax
f01011ac:	68 c0 0c 10 f0       	push   $0xf0100cc0
f01011b1:	e8 44 fb ff ff       	call   f0100cfa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f01011b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01011b9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f01011bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01011bf:	83 c4 10             	add    $0x10,%esp
}
f01011c2:	c9                   	leave  
f01011c3:	c3                   	ret    
		return -E_INVAL;
f01011c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01011c9:	eb f7                	jmp    f01011c2 <vsnprintf+0x45>

f01011cb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f01011cb:	55                   	push   %ebp
f01011cc:	89 e5                	mov    %esp,%ebp
f01011ce:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f01011d1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f01011d4:	50                   	push   %eax
f01011d5:	ff 75 10             	pushl  0x10(%ebp)
f01011d8:	ff 75 0c             	pushl  0xc(%ebp)
f01011db:	ff 75 08             	pushl  0x8(%ebp)
f01011de:	e8 9a ff ff ff       	call   f010117d <vsnprintf>
	va_end(ap);

	return rc;
}
f01011e3:	c9                   	leave  
f01011e4:	c3                   	ret    

f01011e5 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f01011e5:	55                   	push   %ebp
f01011e6:	89 e5                	mov    %esp,%ebp
f01011e8:	57                   	push   %edi
f01011e9:	56                   	push   %esi
f01011ea:	53                   	push   %ebx
f01011eb:	83 ec 0c             	sub    $0xc,%esp
f01011ee:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

	if (prompt != NULL)
f01011f1:	85 c0                	test   %eax,%eax
f01011f3:	74 11                	je     f0101206 <readline+0x21>
		cprintf("%s", prompt);
f01011f5:	83 ec 08             	sub    $0x8,%esp
f01011f8:	50                   	push   %eax
f01011f9:	68 e6 1d 10 f0       	push   $0xf0101de6
f01011fe:	e8 37 f7 ff ff       	call   f010093a <cprintf>
f0101203:	83 c4 10             	add    $0x10,%esp

	i = 0;
	echoing = iscons(0);
f0101206:	83 ec 0c             	sub    $0xc,%esp
f0101209:	6a 00                	push   $0x0
f010120b:	e8 8a f4 ff ff       	call   f010069a <iscons>
f0101210:	89 c7                	mov    %eax,%edi
f0101212:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0101215:	be 00 00 00 00       	mov    $0x0,%esi
f010121a:	eb 3f                	jmp    f010125b <readline+0x76>
	while (1) {
		c = getchar();
		if (c < 0) {
			cprintf("read error: %e\n", c);
f010121c:	83 ec 08             	sub    $0x8,%esp
f010121f:	50                   	push   %eax
f0101220:	68 c8 1f 10 f0       	push   $0xf0101fc8
f0101225:	e8 10 f7 ff ff       	call   f010093a <cprintf>
			return NULL;
f010122a:	83 c4 10             	add    $0x10,%esp
f010122d:	b8 00 00 00 00       	mov    $0x0,%eax
				cputchar('\n');
			buf[i] = 0;
			return buf;
		}
	}
}
f0101232:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101235:	5b                   	pop    %ebx
f0101236:	5e                   	pop    %esi
f0101237:	5f                   	pop    %edi
f0101238:	5d                   	pop    %ebp
f0101239:	c3                   	ret    
			if (echoing)
f010123a:	85 ff                	test   %edi,%edi
f010123c:	75 05                	jne    f0101243 <readline+0x5e>
			i--;
f010123e:	83 ee 01             	sub    $0x1,%esi
f0101241:	eb 18                	jmp    f010125b <readline+0x76>
				cputchar('\b');
f0101243:	83 ec 0c             	sub    $0xc,%esp
f0101246:	6a 08                	push   $0x8
f0101248:	e8 2c f4 ff ff       	call   f0100679 <cputchar>
f010124d:	83 c4 10             	add    $0x10,%esp
f0101250:	eb ec                	jmp    f010123e <readline+0x59>
			buf[i++] = c;
f0101252:	88 9e 40 25 11 f0    	mov    %bl,-0xfeedac0(%esi)
f0101258:	8d 76 01             	lea    0x1(%esi),%esi
		c = getchar();
f010125b:	e8 29 f4 ff ff       	call   f0100689 <getchar>
f0101260:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0101262:	85 c0                	test   %eax,%eax
f0101264:	78 b6                	js     f010121c <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0101266:	83 f8 08             	cmp    $0x8,%eax
f0101269:	0f 94 c2             	sete   %dl
f010126c:	83 f8 7f             	cmp    $0x7f,%eax
f010126f:	0f 94 c0             	sete   %al
f0101272:	08 c2                	or     %al,%dl
f0101274:	74 04                	je     f010127a <readline+0x95>
f0101276:	85 f6                	test   %esi,%esi
f0101278:	7f c0                	jg     f010123a <readline+0x55>
		} else if (c >= ' ' && i < BUFLEN-1) {
f010127a:	83 fb 1f             	cmp    $0x1f,%ebx
f010127d:	7e 1a                	jle    f0101299 <readline+0xb4>
f010127f:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0101285:	7f 12                	jg     f0101299 <readline+0xb4>
			if (echoing)
f0101287:	85 ff                	test   %edi,%edi
f0101289:	74 c7                	je     f0101252 <readline+0x6d>
				cputchar(c);
f010128b:	83 ec 0c             	sub    $0xc,%esp
f010128e:	53                   	push   %ebx
f010128f:	e8 e5 f3 ff ff       	call   f0100679 <cputchar>
f0101294:	83 c4 10             	add    $0x10,%esp
f0101297:	eb b9                	jmp    f0101252 <readline+0x6d>
		} else if (c == '\n' || c == '\r') {
f0101299:	83 fb 0a             	cmp    $0xa,%ebx
f010129c:	74 05                	je     f01012a3 <readline+0xbe>
f010129e:	83 fb 0d             	cmp    $0xd,%ebx
f01012a1:	75 b8                	jne    f010125b <readline+0x76>
			if (echoing)
f01012a3:	85 ff                	test   %edi,%edi
f01012a5:	75 11                	jne    f01012b8 <readline+0xd3>
			buf[i] = 0;
f01012a7:	c6 86 40 25 11 f0 00 	movb   $0x0,-0xfeedac0(%esi)
			return buf;
f01012ae:	b8 40 25 11 f0       	mov    $0xf0112540,%eax
f01012b3:	e9 7a ff ff ff       	jmp    f0101232 <readline+0x4d>
				cputchar('\n');
f01012b8:	83 ec 0c             	sub    $0xc,%esp
f01012bb:	6a 0a                	push   $0xa
f01012bd:	e8 b7 f3 ff ff       	call   f0100679 <cputchar>
f01012c2:	83 c4 10             	add    $0x10,%esp
f01012c5:	eb e0                	jmp    f01012a7 <readline+0xc2>

f01012c7 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f01012c7:	55                   	push   %ebp
f01012c8:	89 e5                	mov    %esp,%ebp
f01012ca:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f01012cd:	b8 00 00 00 00       	mov    $0x0,%eax
f01012d2:	eb 03                	jmp    f01012d7 <strlen+0x10>
		n++;
f01012d4:	83 c0 01             	add    $0x1,%eax
	for (n = 0; *s != '\0'; s++)
f01012d7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f01012db:	75 f7                	jne    f01012d4 <strlen+0xd>
	return n;
}
f01012dd:	5d                   	pop    %ebp
f01012de:	c3                   	ret    

f01012df <strnlen>:

int
strnlen(const char *s, size_t size)
{
f01012df:	55                   	push   %ebp
f01012e0:	89 e5                	mov    %esp,%ebp
f01012e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01012e5:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01012e8:	b8 00 00 00 00       	mov    $0x0,%eax
f01012ed:	eb 03                	jmp    f01012f2 <strnlen+0x13>
		n++;
f01012ef:	83 c0 01             	add    $0x1,%eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f01012f2:	39 d0                	cmp    %edx,%eax
f01012f4:	74 06                	je     f01012fc <strnlen+0x1d>
f01012f6:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f01012fa:	75 f3                	jne    f01012ef <strnlen+0x10>
	return n;
}
f01012fc:	5d                   	pop    %ebp
f01012fd:	c3                   	ret    

f01012fe <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f01012fe:	55                   	push   %ebp
f01012ff:	89 e5                	mov    %esp,%ebp
f0101301:	53                   	push   %ebx
f0101302:	8b 45 08             	mov    0x8(%ebp),%eax
f0101305:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0101308:	89 c2                	mov    %eax,%edx
f010130a:	83 c1 01             	add    $0x1,%ecx
f010130d:	83 c2 01             	add    $0x1,%edx
f0101310:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0101314:	88 5a ff             	mov    %bl,-0x1(%edx)
f0101317:	84 db                	test   %bl,%bl
f0101319:	75 ef                	jne    f010130a <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f010131b:	5b                   	pop    %ebx
f010131c:	5d                   	pop    %ebp
f010131d:	c3                   	ret    

f010131e <strcat>:

char *
strcat(char *dst, const char *src)
{
f010131e:	55                   	push   %ebp
f010131f:	89 e5                	mov    %esp,%ebp
f0101321:	53                   	push   %ebx
f0101322:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0101325:	53                   	push   %ebx
f0101326:	e8 9c ff ff ff       	call   f01012c7 <strlen>
f010132b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f010132e:	ff 75 0c             	pushl  0xc(%ebp)
f0101331:	01 d8                	add    %ebx,%eax
f0101333:	50                   	push   %eax
f0101334:	e8 c5 ff ff ff       	call   f01012fe <strcpy>
	return dst;
}
f0101339:	89 d8                	mov    %ebx,%eax
f010133b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010133e:	c9                   	leave  
f010133f:	c3                   	ret    

f0101340 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0101340:	55                   	push   %ebp
f0101341:	89 e5                	mov    %esp,%ebp
f0101343:	56                   	push   %esi
f0101344:	53                   	push   %ebx
f0101345:	8b 75 08             	mov    0x8(%ebp),%esi
f0101348:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010134b:	89 f3                	mov    %esi,%ebx
f010134d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0101350:	89 f2                	mov    %esi,%edx
f0101352:	eb 0f                	jmp    f0101363 <strncpy+0x23>
		*dst++ = *src;
f0101354:	83 c2 01             	add    $0x1,%edx
f0101357:	0f b6 01             	movzbl (%ecx),%eax
f010135a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f010135d:	80 39 01             	cmpb   $0x1,(%ecx)
f0101360:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f0101363:	39 da                	cmp    %ebx,%edx
f0101365:	75 ed                	jne    f0101354 <strncpy+0x14>
	}
	return ret;
}
f0101367:	89 f0                	mov    %esi,%eax
f0101369:	5b                   	pop    %ebx
f010136a:	5e                   	pop    %esi
f010136b:	5d                   	pop    %ebp
f010136c:	c3                   	ret    

f010136d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f010136d:	55                   	push   %ebp
f010136e:	89 e5                	mov    %esp,%ebp
f0101370:	56                   	push   %esi
f0101371:	53                   	push   %ebx
f0101372:	8b 75 08             	mov    0x8(%ebp),%esi
f0101375:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101378:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010137b:	89 f0                	mov    %esi,%eax
f010137d:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0101381:	85 c9                	test   %ecx,%ecx
f0101383:	75 0b                	jne    f0101390 <strlcpy+0x23>
f0101385:	eb 17                	jmp    f010139e <strlcpy+0x31>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0101387:	83 c2 01             	add    $0x1,%edx
f010138a:	83 c0 01             	add    $0x1,%eax
f010138d:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0101390:	39 d8                	cmp    %ebx,%eax
f0101392:	74 07                	je     f010139b <strlcpy+0x2e>
f0101394:	0f b6 0a             	movzbl (%edx),%ecx
f0101397:	84 c9                	test   %cl,%cl
f0101399:	75 ec                	jne    f0101387 <strlcpy+0x1a>
		*dst = '\0';
f010139b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f010139e:	29 f0                	sub    %esi,%eax
}
f01013a0:	5b                   	pop    %ebx
f01013a1:	5e                   	pop    %esi
f01013a2:	5d                   	pop    %ebp
f01013a3:	c3                   	ret    

f01013a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01013a4:	55                   	push   %ebp
f01013a5:	89 e5                	mov    %esp,%ebp
f01013a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01013aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01013ad:	eb 06                	jmp    f01013b5 <strcmp+0x11>
		p++, q++;
f01013af:	83 c1 01             	add    $0x1,%ecx
f01013b2:	83 c2 01             	add    $0x1,%edx
	while (*p && *p == *q)
f01013b5:	0f b6 01             	movzbl (%ecx),%eax
f01013b8:	84 c0                	test   %al,%al
f01013ba:	74 04                	je     f01013c0 <strcmp+0x1c>
f01013bc:	3a 02                	cmp    (%edx),%al
f01013be:	74 ef                	je     f01013af <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f01013c0:	0f b6 c0             	movzbl %al,%eax
f01013c3:	0f b6 12             	movzbl (%edx),%edx
f01013c6:	29 d0                	sub    %edx,%eax
}
f01013c8:	5d                   	pop    %ebp
f01013c9:	c3                   	ret    

f01013ca <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01013ca:	55                   	push   %ebp
f01013cb:	89 e5                	mov    %esp,%ebp
f01013cd:	53                   	push   %ebx
f01013ce:	8b 45 08             	mov    0x8(%ebp),%eax
f01013d1:	8b 55 0c             	mov    0xc(%ebp),%edx
f01013d4:	89 c3                	mov    %eax,%ebx
f01013d6:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f01013d9:	eb 06                	jmp    f01013e1 <strncmp+0x17>
		n--, p++, q++;
f01013db:	83 c0 01             	add    $0x1,%eax
f01013de:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
f01013e1:	39 d8                	cmp    %ebx,%eax
f01013e3:	74 16                	je     f01013fb <strncmp+0x31>
f01013e5:	0f b6 08             	movzbl (%eax),%ecx
f01013e8:	84 c9                	test   %cl,%cl
f01013ea:	74 04                	je     f01013f0 <strncmp+0x26>
f01013ec:	3a 0a                	cmp    (%edx),%cl
f01013ee:	74 eb                	je     f01013db <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01013f0:	0f b6 00             	movzbl (%eax),%eax
f01013f3:	0f b6 12             	movzbl (%edx),%edx
f01013f6:	29 d0                	sub    %edx,%eax
}
f01013f8:	5b                   	pop    %ebx
f01013f9:	5d                   	pop    %ebp
f01013fa:	c3                   	ret    
		return 0;
f01013fb:	b8 00 00 00 00       	mov    $0x0,%eax
f0101400:	eb f6                	jmp    f01013f8 <strncmp+0x2e>

f0101402 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0101402:	55                   	push   %ebp
f0101403:	89 e5                	mov    %esp,%ebp
f0101405:	8b 45 08             	mov    0x8(%ebp),%eax
f0101408:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010140c:	0f b6 10             	movzbl (%eax),%edx
f010140f:	84 d2                	test   %dl,%dl
f0101411:	74 09                	je     f010141c <strchr+0x1a>
		if (*s == c)
f0101413:	38 ca                	cmp    %cl,%dl
f0101415:	74 0a                	je     f0101421 <strchr+0x1f>
	for (; *s; s++)
f0101417:	83 c0 01             	add    $0x1,%eax
f010141a:	eb f0                	jmp    f010140c <strchr+0xa>
			return (char *) s;
	return 0;
f010141c:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101421:	5d                   	pop    %ebp
f0101422:	c3                   	ret    

f0101423 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0101423:	55                   	push   %ebp
f0101424:	89 e5                	mov    %esp,%ebp
f0101426:	8b 45 08             	mov    0x8(%ebp),%eax
f0101429:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f010142d:	eb 03                	jmp    f0101432 <strfind+0xf>
f010142f:	83 c0 01             	add    $0x1,%eax
f0101432:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
f0101435:	38 ca                	cmp    %cl,%dl
f0101437:	74 04                	je     f010143d <strfind+0x1a>
f0101439:	84 d2                	test   %dl,%dl
f010143b:	75 f2                	jne    f010142f <strfind+0xc>
			break;
	return (char *) s;
}
f010143d:	5d                   	pop    %ebp
f010143e:	c3                   	ret    

f010143f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f010143f:	55                   	push   %ebp
f0101440:	89 e5                	mov    %esp,%ebp
f0101442:	57                   	push   %edi
f0101443:	56                   	push   %esi
f0101444:	53                   	push   %ebx
f0101445:	8b 7d 08             	mov    0x8(%ebp),%edi
f0101448:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f010144b:	85 c9                	test   %ecx,%ecx
f010144d:	74 13                	je     f0101462 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f010144f:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0101455:	75 05                	jne    f010145c <memset+0x1d>
f0101457:	f6 c1 03             	test   $0x3,%cl
f010145a:	74 0d                	je     f0101469 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010145c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010145f:	fc                   	cld    
f0101460:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0101462:	89 f8                	mov    %edi,%eax
f0101464:	5b                   	pop    %ebx
f0101465:	5e                   	pop    %esi
f0101466:	5f                   	pop    %edi
f0101467:	5d                   	pop    %ebp
f0101468:	c3                   	ret    
		c &= 0xFF;
f0101469:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f010146d:	89 d3                	mov    %edx,%ebx
f010146f:	c1 e3 08             	shl    $0x8,%ebx
f0101472:	89 d0                	mov    %edx,%eax
f0101474:	c1 e0 18             	shl    $0x18,%eax
f0101477:	89 d6                	mov    %edx,%esi
f0101479:	c1 e6 10             	shl    $0x10,%esi
f010147c:	09 f0                	or     %esi,%eax
f010147e:	09 c2                	or     %eax,%edx
f0101480:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f0101482:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0101485:	89 d0                	mov    %edx,%eax
f0101487:	fc                   	cld    
f0101488:	f3 ab                	rep stos %eax,%es:(%edi)
f010148a:	eb d6                	jmp    f0101462 <memset+0x23>

f010148c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010148c:	55                   	push   %ebp
f010148d:	89 e5                	mov    %esp,%ebp
f010148f:	57                   	push   %edi
f0101490:	56                   	push   %esi
f0101491:	8b 45 08             	mov    0x8(%ebp),%eax
f0101494:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101497:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f010149a:	39 c6                	cmp    %eax,%esi
f010149c:	73 35                	jae    f01014d3 <memmove+0x47>
f010149e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f01014a1:	39 c2                	cmp    %eax,%edx
f01014a3:	76 2e                	jbe    f01014d3 <memmove+0x47>
		s += n;
		d += n;
f01014a5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01014a8:	89 d6                	mov    %edx,%esi
f01014aa:	09 fe                	or     %edi,%esi
f01014ac:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01014b2:	74 0c                	je     f01014c0 <memmove+0x34>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f01014b4:	83 ef 01             	sub    $0x1,%edi
f01014b7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f01014ba:	fd                   	std    
f01014bb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f01014bd:	fc                   	cld    
f01014be:	eb 21                	jmp    f01014e1 <memmove+0x55>
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01014c0:	f6 c1 03             	test   $0x3,%cl
f01014c3:	75 ef                	jne    f01014b4 <memmove+0x28>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f01014c5:	83 ef 04             	sub    $0x4,%edi
f01014c8:	8d 72 fc             	lea    -0x4(%edx),%esi
f01014cb:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f01014ce:	fd                   	std    
f01014cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01014d1:	eb ea                	jmp    f01014bd <memmove+0x31>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01014d3:	89 f2                	mov    %esi,%edx
f01014d5:	09 c2                	or     %eax,%edx
f01014d7:	f6 c2 03             	test   $0x3,%dl
f01014da:	74 09                	je     f01014e5 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f01014dc:	89 c7                	mov    %eax,%edi
f01014de:	fc                   	cld    
f01014df:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f01014e1:	5e                   	pop    %esi
f01014e2:	5f                   	pop    %edi
f01014e3:	5d                   	pop    %ebp
f01014e4:	c3                   	ret    
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01014e5:	f6 c1 03             	test   $0x3,%cl
f01014e8:	75 f2                	jne    f01014dc <memmove+0x50>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f01014ea:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f01014ed:	89 c7                	mov    %eax,%edi
f01014ef:	fc                   	cld    
f01014f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01014f2:	eb ed                	jmp    f01014e1 <memmove+0x55>

f01014f4 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01014f4:	55                   	push   %ebp
f01014f5:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f01014f7:	ff 75 10             	pushl  0x10(%ebp)
f01014fa:	ff 75 0c             	pushl  0xc(%ebp)
f01014fd:	ff 75 08             	pushl  0x8(%ebp)
f0101500:	e8 87 ff ff ff       	call   f010148c <memmove>
}
f0101505:	c9                   	leave  
f0101506:	c3                   	ret    

f0101507 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0101507:	55                   	push   %ebp
f0101508:	89 e5                	mov    %esp,%ebp
f010150a:	56                   	push   %esi
f010150b:	53                   	push   %ebx
f010150c:	8b 45 08             	mov    0x8(%ebp),%eax
f010150f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101512:	89 c6                	mov    %eax,%esi
f0101514:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0101517:	39 f0                	cmp    %esi,%eax
f0101519:	74 1c                	je     f0101537 <memcmp+0x30>
		if (*s1 != *s2)
f010151b:	0f b6 08             	movzbl (%eax),%ecx
f010151e:	0f b6 1a             	movzbl (%edx),%ebx
f0101521:	38 d9                	cmp    %bl,%cl
f0101523:	75 08                	jne    f010152d <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0101525:	83 c0 01             	add    $0x1,%eax
f0101528:	83 c2 01             	add    $0x1,%edx
f010152b:	eb ea                	jmp    f0101517 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f010152d:	0f b6 c1             	movzbl %cl,%eax
f0101530:	0f b6 db             	movzbl %bl,%ebx
f0101533:	29 d8                	sub    %ebx,%eax
f0101535:	eb 05                	jmp    f010153c <memcmp+0x35>
	}

	return 0;
f0101537:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010153c:	5b                   	pop    %ebx
f010153d:	5e                   	pop    %esi
f010153e:	5d                   	pop    %ebp
f010153f:	c3                   	ret    

f0101540 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0101540:	55                   	push   %ebp
f0101541:	89 e5                	mov    %esp,%ebp
f0101543:	8b 45 08             	mov    0x8(%ebp),%eax
f0101546:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0101549:	89 c2                	mov    %eax,%edx
f010154b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f010154e:	39 d0                	cmp    %edx,%eax
f0101550:	73 09                	jae    f010155b <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0101552:	38 08                	cmp    %cl,(%eax)
f0101554:	74 05                	je     f010155b <memfind+0x1b>
	for (; s < ends; s++)
f0101556:	83 c0 01             	add    $0x1,%eax
f0101559:	eb f3                	jmp    f010154e <memfind+0xe>
			break;
	return (void *) s;
}
f010155b:	5d                   	pop    %ebp
f010155c:	c3                   	ret    

f010155d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f010155d:	55                   	push   %ebp
f010155e:	89 e5                	mov    %esp,%ebp
f0101560:	57                   	push   %edi
f0101561:	56                   	push   %esi
f0101562:	53                   	push   %ebx
f0101563:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101566:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0101569:	eb 03                	jmp    f010156e <strtol+0x11>
		s++;
f010156b:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
f010156e:	0f b6 01             	movzbl (%ecx),%eax
f0101571:	3c 20                	cmp    $0x20,%al
f0101573:	74 f6                	je     f010156b <strtol+0xe>
f0101575:	3c 09                	cmp    $0x9,%al
f0101577:	74 f2                	je     f010156b <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
f0101579:	3c 2b                	cmp    $0x2b,%al
f010157b:	74 2e                	je     f01015ab <strtol+0x4e>
	int neg = 0;
f010157d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
f0101582:	3c 2d                	cmp    $0x2d,%al
f0101584:	74 2f                	je     f01015b5 <strtol+0x58>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0101586:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
f010158c:	75 05                	jne    f0101593 <strtol+0x36>
f010158e:	80 39 30             	cmpb   $0x30,(%ecx)
f0101591:	74 2c                	je     f01015bf <strtol+0x62>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0101593:	85 db                	test   %ebx,%ebx
f0101595:	75 0a                	jne    f01015a1 <strtol+0x44>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0101597:	bb 0a 00 00 00       	mov    $0xa,%ebx
	else if (base == 0 && s[0] == '0')
f010159c:	80 39 30             	cmpb   $0x30,(%ecx)
f010159f:	74 28                	je     f01015c9 <strtol+0x6c>
		base = 10;
f01015a1:	b8 00 00 00 00       	mov    $0x0,%eax
f01015a6:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01015a9:	eb 50                	jmp    f01015fb <strtol+0x9e>
		s++;
f01015ab:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
f01015ae:	bf 00 00 00 00       	mov    $0x0,%edi
f01015b3:	eb d1                	jmp    f0101586 <strtol+0x29>
		s++, neg = 1;
f01015b5:	83 c1 01             	add    $0x1,%ecx
f01015b8:	bf 01 00 00 00       	mov    $0x1,%edi
f01015bd:	eb c7                	jmp    f0101586 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01015bf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f01015c3:	74 0e                	je     f01015d3 <strtol+0x76>
	else if (base == 0 && s[0] == '0')
f01015c5:	85 db                	test   %ebx,%ebx
f01015c7:	75 d8                	jne    f01015a1 <strtol+0x44>
		s++, base = 8;
f01015c9:	83 c1 01             	add    $0x1,%ecx
f01015cc:	bb 08 00 00 00       	mov    $0x8,%ebx
f01015d1:	eb ce                	jmp    f01015a1 <strtol+0x44>
		s += 2, base = 16;
f01015d3:	83 c1 02             	add    $0x2,%ecx
f01015d6:	bb 10 00 00 00       	mov    $0x10,%ebx
f01015db:	eb c4                	jmp    f01015a1 <strtol+0x44>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f01015dd:	8d 72 9f             	lea    -0x61(%edx),%esi
f01015e0:	89 f3                	mov    %esi,%ebx
f01015e2:	80 fb 19             	cmp    $0x19,%bl
f01015e5:	77 29                	ja     f0101610 <strtol+0xb3>
			dig = *s - 'a' + 10;
f01015e7:	0f be d2             	movsbl %dl,%edx
f01015ea:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f01015ed:	3b 55 10             	cmp    0x10(%ebp),%edx
f01015f0:	7d 30                	jge    f0101622 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
f01015f2:	83 c1 01             	add    $0x1,%ecx
f01015f5:	0f af 45 10          	imul   0x10(%ebp),%eax
f01015f9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f01015fb:	0f b6 11             	movzbl (%ecx),%edx
f01015fe:	8d 72 d0             	lea    -0x30(%edx),%esi
f0101601:	89 f3                	mov    %esi,%ebx
f0101603:	80 fb 09             	cmp    $0x9,%bl
f0101606:	77 d5                	ja     f01015dd <strtol+0x80>
			dig = *s - '0';
f0101608:	0f be d2             	movsbl %dl,%edx
f010160b:	83 ea 30             	sub    $0x30,%edx
f010160e:	eb dd                	jmp    f01015ed <strtol+0x90>
		else if (*s >= 'A' && *s <= 'Z')
f0101610:	8d 72 bf             	lea    -0x41(%edx),%esi
f0101613:	89 f3                	mov    %esi,%ebx
f0101615:	80 fb 19             	cmp    $0x19,%bl
f0101618:	77 08                	ja     f0101622 <strtol+0xc5>
			dig = *s - 'A' + 10;
f010161a:	0f be d2             	movsbl %dl,%edx
f010161d:	83 ea 37             	sub    $0x37,%edx
f0101620:	eb cb                	jmp    f01015ed <strtol+0x90>
		// we don't properly detect overflow!
	}

	if (endptr)
f0101622:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0101626:	74 05                	je     f010162d <strtol+0xd0>
		*endptr = (char *) s;
f0101628:	8b 75 0c             	mov    0xc(%ebp),%esi
f010162b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f010162d:	89 c2                	mov    %eax,%edx
f010162f:	f7 da                	neg    %edx
f0101631:	85 ff                	test   %edi,%edi
f0101633:	0f 45 c2             	cmovne %edx,%eax
}
f0101636:	5b                   	pop    %ebx
f0101637:	5e                   	pop    %esi
f0101638:	5f                   	pop    %edi
f0101639:	5d                   	pop    %ebp
f010163a:	c3                   	ret    
f010163b:	66 90                	xchg   %ax,%ax
f010163d:	66 90                	xchg   %ax,%ax
f010163f:	90                   	nop

f0101640 <__udivdi3>:
f0101640:	55                   	push   %ebp
f0101641:	57                   	push   %edi
f0101642:	56                   	push   %esi
f0101643:	53                   	push   %ebx
f0101644:	83 ec 1c             	sub    $0x1c,%esp
f0101647:	8b 54 24 3c          	mov    0x3c(%esp),%edx
f010164b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f010164f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0101653:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0101657:	85 d2                	test   %edx,%edx
f0101659:	75 35                	jne    f0101690 <__udivdi3+0x50>
f010165b:	39 f3                	cmp    %esi,%ebx
f010165d:	0f 87 bd 00 00 00    	ja     f0101720 <__udivdi3+0xe0>
f0101663:	85 db                	test   %ebx,%ebx
f0101665:	89 d9                	mov    %ebx,%ecx
f0101667:	75 0b                	jne    f0101674 <__udivdi3+0x34>
f0101669:	b8 01 00 00 00       	mov    $0x1,%eax
f010166e:	31 d2                	xor    %edx,%edx
f0101670:	f7 f3                	div    %ebx
f0101672:	89 c1                	mov    %eax,%ecx
f0101674:	31 d2                	xor    %edx,%edx
f0101676:	89 f0                	mov    %esi,%eax
f0101678:	f7 f1                	div    %ecx
f010167a:	89 c6                	mov    %eax,%esi
f010167c:	89 e8                	mov    %ebp,%eax
f010167e:	89 f7                	mov    %esi,%edi
f0101680:	f7 f1                	div    %ecx
f0101682:	89 fa                	mov    %edi,%edx
f0101684:	83 c4 1c             	add    $0x1c,%esp
f0101687:	5b                   	pop    %ebx
f0101688:	5e                   	pop    %esi
f0101689:	5f                   	pop    %edi
f010168a:	5d                   	pop    %ebp
f010168b:	c3                   	ret    
f010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101690:	39 f2                	cmp    %esi,%edx
f0101692:	77 7c                	ja     f0101710 <__udivdi3+0xd0>
f0101694:	0f bd fa             	bsr    %edx,%edi
f0101697:	83 f7 1f             	xor    $0x1f,%edi
f010169a:	0f 84 98 00 00 00    	je     f0101738 <__udivdi3+0xf8>
f01016a0:	89 f9                	mov    %edi,%ecx
f01016a2:	b8 20 00 00 00       	mov    $0x20,%eax
f01016a7:	29 f8                	sub    %edi,%eax
f01016a9:	d3 e2                	shl    %cl,%edx
f01016ab:	89 54 24 08          	mov    %edx,0x8(%esp)
f01016af:	89 c1                	mov    %eax,%ecx
f01016b1:	89 da                	mov    %ebx,%edx
f01016b3:	d3 ea                	shr    %cl,%edx
f01016b5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f01016b9:	09 d1                	or     %edx,%ecx
f01016bb:	89 f2                	mov    %esi,%edx
f01016bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01016c1:	89 f9                	mov    %edi,%ecx
f01016c3:	d3 e3                	shl    %cl,%ebx
f01016c5:	89 c1                	mov    %eax,%ecx
f01016c7:	d3 ea                	shr    %cl,%edx
f01016c9:	89 f9                	mov    %edi,%ecx
f01016cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01016cf:	d3 e6                	shl    %cl,%esi
f01016d1:	89 eb                	mov    %ebp,%ebx
f01016d3:	89 c1                	mov    %eax,%ecx
f01016d5:	d3 eb                	shr    %cl,%ebx
f01016d7:	09 de                	or     %ebx,%esi
f01016d9:	89 f0                	mov    %esi,%eax
f01016db:	f7 74 24 08          	divl   0x8(%esp)
f01016df:	89 d6                	mov    %edx,%esi
f01016e1:	89 c3                	mov    %eax,%ebx
f01016e3:	f7 64 24 0c          	mull   0xc(%esp)
f01016e7:	39 d6                	cmp    %edx,%esi
f01016e9:	72 0c                	jb     f01016f7 <__udivdi3+0xb7>
f01016eb:	89 f9                	mov    %edi,%ecx
f01016ed:	d3 e5                	shl    %cl,%ebp
f01016ef:	39 c5                	cmp    %eax,%ebp
f01016f1:	73 5d                	jae    f0101750 <__udivdi3+0x110>
f01016f3:	39 d6                	cmp    %edx,%esi
f01016f5:	75 59                	jne    f0101750 <__udivdi3+0x110>
f01016f7:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01016fa:	31 ff                	xor    %edi,%edi
f01016fc:	89 fa                	mov    %edi,%edx
f01016fe:	83 c4 1c             	add    $0x1c,%esp
f0101701:	5b                   	pop    %ebx
f0101702:	5e                   	pop    %esi
f0101703:	5f                   	pop    %edi
f0101704:	5d                   	pop    %ebp
f0101705:	c3                   	ret    
f0101706:	8d 76 00             	lea    0x0(%esi),%esi
f0101709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
f0101710:	31 ff                	xor    %edi,%edi
f0101712:	31 c0                	xor    %eax,%eax
f0101714:	89 fa                	mov    %edi,%edx
f0101716:	83 c4 1c             	add    $0x1c,%esp
f0101719:	5b                   	pop    %ebx
f010171a:	5e                   	pop    %esi
f010171b:	5f                   	pop    %edi
f010171c:	5d                   	pop    %ebp
f010171d:	c3                   	ret    
f010171e:	66 90                	xchg   %ax,%ax
f0101720:	31 ff                	xor    %edi,%edi
f0101722:	89 e8                	mov    %ebp,%eax
f0101724:	89 f2                	mov    %esi,%edx
f0101726:	f7 f3                	div    %ebx
f0101728:	89 fa                	mov    %edi,%edx
f010172a:	83 c4 1c             	add    $0x1c,%esp
f010172d:	5b                   	pop    %ebx
f010172e:	5e                   	pop    %esi
f010172f:	5f                   	pop    %edi
f0101730:	5d                   	pop    %ebp
f0101731:	c3                   	ret    
f0101732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101738:	39 f2                	cmp    %esi,%edx
f010173a:	72 06                	jb     f0101742 <__udivdi3+0x102>
f010173c:	31 c0                	xor    %eax,%eax
f010173e:	39 eb                	cmp    %ebp,%ebx
f0101740:	77 d2                	ja     f0101714 <__udivdi3+0xd4>
f0101742:	b8 01 00 00 00       	mov    $0x1,%eax
f0101747:	eb cb                	jmp    f0101714 <__udivdi3+0xd4>
f0101749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101750:	89 d8                	mov    %ebx,%eax
f0101752:	31 ff                	xor    %edi,%edi
f0101754:	eb be                	jmp    f0101714 <__udivdi3+0xd4>
f0101756:	66 90                	xchg   %ax,%ax
f0101758:	66 90                	xchg   %ax,%ax
f010175a:	66 90                	xchg   %ax,%ax
f010175c:	66 90                	xchg   %ax,%ax
f010175e:	66 90                	xchg   %ax,%ax

f0101760 <__umoddi3>:
f0101760:	55                   	push   %ebp
f0101761:	57                   	push   %edi
f0101762:	56                   	push   %esi
f0101763:	53                   	push   %ebx
f0101764:	83 ec 1c             	sub    $0x1c,%esp
f0101767:	8b 6c 24 3c          	mov    0x3c(%esp),%ebp
f010176b:	8b 74 24 30          	mov    0x30(%esp),%esi
f010176f:	8b 5c 24 34          	mov    0x34(%esp),%ebx
f0101773:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0101777:	85 ed                	test   %ebp,%ebp
f0101779:	89 f0                	mov    %esi,%eax
f010177b:	89 da                	mov    %ebx,%edx
f010177d:	75 19                	jne    f0101798 <__umoddi3+0x38>
f010177f:	39 df                	cmp    %ebx,%edi
f0101781:	0f 86 b1 00 00 00    	jbe    f0101838 <__umoddi3+0xd8>
f0101787:	f7 f7                	div    %edi
f0101789:	89 d0                	mov    %edx,%eax
f010178b:	31 d2                	xor    %edx,%edx
f010178d:	83 c4 1c             	add    $0x1c,%esp
f0101790:	5b                   	pop    %ebx
f0101791:	5e                   	pop    %esi
f0101792:	5f                   	pop    %edi
f0101793:	5d                   	pop    %ebp
f0101794:	c3                   	ret    
f0101795:	8d 76 00             	lea    0x0(%esi),%esi
f0101798:	39 dd                	cmp    %ebx,%ebp
f010179a:	77 f1                	ja     f010178d <__umoddi3+0x2d>
f010179c:	0f bd cd             	bsr    %ebp,%ecx
f010179f:	83 f1 1f             	xor    $0x1f,%ecx
f01017a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01017a6:	0f 84 b4 00 00 00    	je     f0101860 <__umoddi3+0x100>
f01017ac:	b8 20 00 00 00       	mov    $0x20,%eax
f01017b1:	89 c2                	mov    %eax,%edx
f01017b3:	8b 44 24 04          	mov    0x4(%esp),%eax
f01017b7:	29 c2                	sub    %eax,%edx
f01017b9:	89 c1                	mov    %eax,%ecx
f01017bb:	89 f8                	mov    %edi,%eax
f01017bd:	d3 e5                	shl    %cl,%ebp
f01017bf:	89 d1                	mov    %edx,%ecx
f01017c1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01017c5:	d3 e8                	shr    %cl,%eax
f01017c7:	09 c5                	or     %eax,%ebp
f01017c9:	8b 44 24 04          	mov    0x4(%esp),%eax
f01017cd:	89 c1                	mov    %eax,%ecx
f01017cf:	d3 e7                	shl    %cl,%edi
f01017d1:	89 d1                	mov    %edx,%ecx
f01017d3:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01017d7:	89 df                	mov    %ebx,%edi
f01017d9:	d3 ef                	shr    %cl,%edi
f01017db:	89 c1                	mov    %eax,%ecx
f01017dd:	89 f0                	mov    %esi,%eax
f01017df:	d3 e3                	shl    %cl,%ebx
f01017e1:	89 d1                	mov    %edx,%ecx
f01017e3:	89 fa                	mov    %edi,%edx
f01017e5:	d3 e8                	shr    %cl,%eax
f01017e7:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
f01017ec:	09 d8                	or     %ebx,%eax
f01017ee:	f7 f5                	div    %ebp
f01017f0:	d3 e6                	shl    %cl,%esi
f01017f2:	89 d1                	mov    %edx,%ecx
f01017f4:	f7 64 24 08          	mull   0x8(%esp)
f01017f8:	39 d1                	cmp    %edx,%ecx
f01017fa:	89 c3                	mov    %eax,%ebx
f01017fc:	89 d7                	mov    %edx,%edi
f01017fe:	72 06                	jb     f0101806 <__umoddi3+0xa6>
f0101800:	75 0e                	jne    f0101810 <__umoddi3+0xb0>
f0101802:	39 c6                	cmp    %eax,%esi
f0101804:	73 0a                	jae    f0101810 <__umoddi3+0xb0>
f0101806:	2b 44 24 08          	sub    0x8(%esp),%eax
f010180a:	19 ea                	sbb    %ebp,%edx
f010180c:	89 d7                	mov    %edx,%edi
f010180e:	89 c3                	mov    %eax,%ebx
f0101810:	89 ca                	mov    %ecx,%edx
f0101812:	0f b6 4c 24 0c       	movzbl 0xc(%esp),%ecx
f0101817:	29 de                	sub    %ebx,%esi
f0101819:	19 fa                	sbb    %edi,%edx
f010181b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f010181f:	89 d0                	mov    %edx,%eax
f0101821:	d3 e0                	shl    %cl,%eax
f0101823:	89 d9                	mov    %ebx,%ecx
f0101825:	d3 ee                	shr    %cl,%esi
f0101827:	d3 ea                	shr    %cl,%edx
f0101829:	09 f0                	or     %esi,%eax
f010182b:	83 c4 1c             	add    $0x1c,%esp
f010182e:	5b                   	pop    %ebx
f010182f:	5e                   	pop    %esi
f0101830:	5f                   	pop    %edi
f0101831:	5d                   	pop    %ebp
f0101832:	c3                   	ret    
f0101833:	90                   	nop
f0101834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101838:	85 ff                	test   %edi,%edi
f010183a:	89 f9                	mov    %edi,%ecx
f010183c:	75 0b                	jne    f0101849 <__umoddi3+0xe9>
f010183e:	b8 01 00 00 00       	mov    $0x1,%eax
f0101843:	31 d2                	xor    %edx,%edx
f0101845:	f7 f7                	div    %edi
f0101847:	89 c1                	mov    %eax,%ecx
f0101849:	89 d8                	mov    %ebx,%eax
f010184b:	31 d2                	xor    %edx,%edx
f010184d:	f7 f1                	div    %ecx
f010184f:	89 f0                	mov    %esi,%eax
f0101851:	f7 f1                	div    %ecx
f0101853:	e9 31 ff ff ff       	jmp    f0101789 <__umoddi3+0x29>
f0101858:	90                   	nop
f0101859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0101860:	39 dd                	cmp    %ebx,%ebp
f0101862:	72 08                	jb     f010186c <__umoddi3+0x10c>
f0101864:	39 f7                	cmp    %esi,%edi
f0101866:	0f 87 21 ff ff ff    	ja     f010178d <__umoddi3+0x2d>
f010186c:	89 da                	mov    %ebx,%edx
f010186e:	89 f0                	mov    %esi,%eax
f0101870:	29 f8                	sub    %edi,%eax
f0101872:	19 ea                	sbb    %ebp,%edx
f0101874:	e9 14 ff ff ff       	jmp    f010178d <__umoddi3+0x2d>
