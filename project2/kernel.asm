
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 30 10 80       	mov    $0x801030c0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 20 73 10 80       	push   $0x80107320
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 51 44 00 00       	call   801044b0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 73 10 80       	push   $0x80107327
80100097:	50                   	push   %eax
80100098:	e8 d3 42 00 00       	call   80104370 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 43 45 00 00       	call   80104630 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 89 45 00 00       	call   801046f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 42 00 00       	call   801043b0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 2e 73 10 80       	push   $0x8010732e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 89 42 00 00       	call   80104450 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 73 10 80       	push   $0x8010733f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 48 42 00 00       	call   80104450 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 41 00 00       	call   80104410 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 0c 44 00 00       	call   80104630 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 7b 44 00 00       	jmp    801046f0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 73 10 80       	push   $0x80107346
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 7a 43 00 00       	call   80104630 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 b6 3c 00 00       	call   80103fa0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 e1 36 00 00       	call   801039e0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 dd 43 00 00       	call   801046f0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 86 43 00 00       	call   801046f0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 6e 25 00 00       	call   80102920 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 73 10 80       	push   $0x8010734d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 af 7c 10 80 	movl   $0x80107caf,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 40 00 00       	call   801044d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 73 10 80       	push   $0x80107361
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 f1 5a 00 00       	call   80105f20 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 06 5a 00 00       	call   80105f20 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 fa 59 00 00       	call   80105f20 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ee 59 00 00       	call   80105f20 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 7a 42 00 00       	call   801047e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 41 00 00       	call   80104740 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 73 10 80       	push   $0x80107365
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 90 73 10 80 	movzbl -0x7fef8c70(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 cc 3f 00 00       	call   80104630 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 54 40 00 00       	call   801046f0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 78 73 10 80       	mov    $0x80107378,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 6e 3e 00 00       	call   80104630 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 c3 3e 00 00       	call   801046f0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 73 10 80       	push   $0x8010737f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 b4 3d 00 00       	call   80104630 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 1c 3d 00 00       	call   801046f0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 4c 38 00 00       	jmp    80104250 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 3b 37 00 00       	call   80104160 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 88 73 10 80       	push   $0x80107388
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 67 3a 00 00       	call   801044b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 4b 2f 00 00       	call   801039e0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 10 23 00 00       	call   80102db0 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 38 23 00 00       	call   80102e20 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 7f 65 00 00       	call   80107090 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 38 63 00 00       	call   80106eb0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 32 62 00 00       	call   80106de0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 20 64 00 00       	call   80107010 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 fa 21 00 00       	call   80102e20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 79 62 00 00       	call   80106eb0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 d8 64 00 00       	call   80107130 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 98 3c 00 00       	call   80104940 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 85 3c 00 00       	call   80104940 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 c4 65 00 00       	call   80107290 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 2a 63 00 00       	call   80107010 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 58 65 00 00       	call   80107290 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 8a 3b 00 00       	call   80104900 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 ae 5e 00 00       	call   80106c50 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 66 62 00 00       	call   80107010 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 67 20 00 00       	call   80102e20 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 a1 73 10 80       	push   $0x801073a1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 ad 73 10 80       	push   $0x801073ad
80100def:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df4:	e8 b7 36 00 00       	call   801044b0 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e15:	e8 16 38 00 00       	call   80104630 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 aa 38 00 00       	call   801046f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 91 38 00 00       	call   801046f0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e83:	e8 a8 37 00 00       	call   80104630 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea0:	e8 4b 38 00 00       	call   801046f0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 b4 73 10 80       	push   $0x801073b4
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed5:	e8 56 37 00 00       	call   80104630 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 db 37 00 00       	call   801046f0 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 ad 37 00 00       	jmp    801046f0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 63 1e 00 00       	call   80102db0 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 b9 1e 00 00       	jmp    80102e20 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 02 26 00 00       	call   80103580 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 bc 73 10 80       	push   $0x801073bc
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 b6 26 00 00       	jmp    80103720 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 c6 73 10 80       	push   $0x801073c6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 2a 1d 00 00       	call   80102e20 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 91 1c 00 00       	call   80102db0 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 ca 1c 00 00       	call   80102e20 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 cf 73 10 80       	push   $0x801073cf
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 8a 24 00 00       	jmp    80103620 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 d5 73 10 80       	push   $0x801073d5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 8e 1d 00 00       	call   80102f90 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 df 73 10 80       	push   $0x801073df
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 f2 73 10 80       	push   $0x801073f2
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 9e 1c 00 00       	call   80102f90 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 26 34 00 00       	call   80104740 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 6e 1c 00 00       	call   80102f90 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 09 11 80       	push   $0x801109e0
8010135a:	e8 d1 32 00 00       	call   80104630 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 09 11 80       	push   $0x801109e0
801013c7:	e8 24 33 00 00       	call   801046f0 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 f6 32 00 00       	call   801046f0 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 08 74 10 80       	push   $0x80107408
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 e6 1a 00 00       	call   80102f90 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 18 74 10 80       	push   $0x80107418
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 b6 32 00 00       	call   801047e0 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 2b 74 10 80       	push   $0x8010742b
80101555:	68 e0 09 11 80       	push   $0x801109e0
8010155a:	e8 51 2f 00 00       	call   801044b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 32 74 10 80       	push   $0x80107432
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 f4 2d 00 00       	call   80104370 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 09 11 80       	push   $0x801109c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010159d:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015a3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015a9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015af:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015b5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015bb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015c1:	68 98 74 10 80       	push   $0x80107498
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 dd 30 00 00       	call   80104740 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 1b 19 00 00       	call   80102f90 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 38 74 10 80       	push   $0x80107438
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 d6 30 00 00       	call   801047e0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 7e 18 00 00       	call   80102f90 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 09 11 80       	push   $0x801109e0
80101743:	e8 e8 2e 00 00       	call   80104630 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101753:	e8 98 2f 00 00       	call   801046f0 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 25 2c 00 00       	call   801043b0 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 e3 2f 00 00       	call   801047e0 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 50 74 10 80       	push   $0x80107450
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 4a 74 10 80       	push   $0x8010744a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 f4 2b 00 00       	call   80104450 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 98 2b 00 00       	jmp    80104410 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 5f 74 10 80       	push   $0x8010745f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 07 2b 00 00       	call   801043b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 4d 2b 00 00       	call   80104410 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018ca:	e8 61 2d 00 00       	call   80104630 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 07 2e 00 00       	jmp    801046f0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 09 11 80       	push   $0x801109e0
801018f8:	e8 33 2d 00 00       	call   80104630 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101907:	e8 e4 2d 00 00       	call   801046f0 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 d4 2c 00 00       	call   801047e0 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 d8 2b 00 00       	call   801047e0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 80 13 00 00       	call   80102f90 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 a9 2b 00 00       	call   80104850 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 46 2b 00 00       	call   80104850 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 79 74 10 80       	push   $0x80107479
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 67 74 10 80       	push   $0x80107467
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 51 1c 00 00       	call   801039e0 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 09 11 80       	push   $0x801109e0
80101d9c:	e8 8f 28 00 00       	call   80104630 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dac:	e8 3f 29 00 00       	call   801046f0 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 c4 29 00 00       	call   801047e0 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 38 29 00 00       	call   801047e0 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 c6 28 00 00       	call   801048a0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 88 74 10 80       	push   $0x80107488
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 8a 7a 10 80       	push   $0x80107a8a
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 f4 74 10 80       	push   $0x801074f4
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 eb 74 10 80       	push   $0x801074eb
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 06 75 10 80       	push   $0x80107506
8010215f:	68 80 a5 10 80       	push   $0x8010a580
80102164:	e8 47 23 00 00       	call   801044b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 a5 10 80       	push   $0x8010a580
801021f2:	e8 39 24 00 00       	call   80104630 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 0e 1f 00 00       	call   80104160 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 a5 10 80       	push   $0x8010a580
8010226b:	e8 80 24 00 00       	call   801046f0 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 b9 21 00 00       	call   80104450 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 a5 10 80       	push   $0x8010a580
801022cc:	e8 5f 23 00 00       	call   80104630 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 a5 10 80       	push   $0x8010a580
80102318:	53                   	push   %ebx
80102319:	e8 82 1c 00 00       	call   80103fa0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 b5 23 00 00       	jmp    801046f0 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 35 75 10 80       	push   $0x80107535
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 20 75 10 80       	push   $0x80107520
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 0a 75 10 80       	push   $0x8010750a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 54 75 10 80       	push   $0x80107554
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb f8 55 11 80    	cmp    $0x801155f8,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 95 22 00 00       	call   80104740 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024c4:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 40 26 11 80       	push   $0x80112640
801024e0:	e8 4b 21 00 00       	call   80104630 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 f0 21 00 00       	jmp    801046f0 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 86 75 10 80       	push   $0x80107586
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 8c 75 10 80       	push   $0x8010758c
80102574:	68 40 26 11 80       	push   $0x80112640
80102579:	e8 32 1f 00 00       	call   801044b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 74 26 11 80       	mov    0x80112674,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 40 26 11 80       	push   $0x80112640
80102663:	e8 c8 1f 00 00       	call   80104630 <acquire>
  r = kmem.freelist;
80102668:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010266d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 40 26 11 80       	push   $0x80112640
80102691:	e8 5a 20 00 00       	call   801046f0 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kgetfreemem>:

unsigned int
kgetfreemem(void) {
801026a0:	f3 0f 1e fb          	endbr32 
801026a4:	55                   	push   %ebp
801026a5:	89 e5                	mov    %esp,%ebp
801026a7:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  unsigned int free_pages = 0;

  if (kmem.use_lock)
801026aa:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
801026b0:	85 c9                	test   %ecx,%ecx
801026b2:	75 3c                	jne    801026f0 <kgetfreemem+0x50>
    acquire(&kmem.lock);

  for (r = kmem.freelist; r != 0; r = r->next) {
801026b4:	8b 15 78 26 11 80    	mov    0x80112678,%edx
801026ba:	85 d2                	test   %edx,%edx
801026bc:	74 56                	je     80102714 <kgetfreemem+0x74>
  unsigned int free_pages = 0;
801026be:	31 c0                	xor    %eax,%eax
  for (r = kmem.freelist; r != 0; r = r->next) {
801026c0:	8b 12                	mov    (%edx),%edx
    free_pages++;
801026c2:	83 c0 01             	add    $0x1,%eax
  for (r = kmem.freelist; r != 0; r = r->next) {
801026c5:	85 d2                	test   %edx,%edx
801026c7:	75 f7                	jne    801026c0 <kgetfreemem+0x20>
801026c9:	c1 e0 02             	shl    $0x2,%eax
  }

  if (kmem.use_lock)
801026cc:	85 c9                	test   %ecx,%ecx
801026ce:	75 08                	jne    801026d8 <kgetfreemem+0x38>
    release(&kmem.lock);

  // Each page is 4096 bytes (PGSIZE)
  // Convert to kilobytes (KB)
  return free_pages * (PGSIZE / 1024);
}
801026d0:	c9                   	leave  
801026d1:	c3                   	ret    
801026d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801026d8:	83 ec 0c             	sub    $0xc,%esp
801026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026de:	68 40 26 11 80       	push   $0x80112640
801026e3:	e8 08 20 00 00       	call   801046f0 <release>
  return free_pages * (PGSIZE / 1024);
801026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026eb:	83 c4 10             	add    $0x10,%esp
}
801026ee:	c9                   	leave  
801026ef:	c3                   	ret    
    acquire(&kmem.lock);
801026f0:	83 ec 0c             	sub    $0xc,%esp
801026f3:	68 40 26 11 80       	push   $0x80112640
801026f8:	e8 33 1f 00 00       	call   80104630 <acquire>
  for (r = kmem.freelist; r != 0; r = r->next) {
801026fd:	8b 15 78 26 11 80    	mov    0x80112678,%edx
80102703:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
80102709:	83 c4 10             	add    $0x10,%esp
8010270c:	85 d2                	test   %edx,%edx
8010270e:	75 ae                	jne    801026be <kgetfreemem+0x1e>
80102710:	31 c0                	xor    %eax,%eax
80102712:	eb b8                	jmp    801026cc <kgetfreemem+0x2c>
}
80102714:	c9                   	leave  
  for (r = kmem.freelist; r != 0; r = r->next) {
80102715:	31 c0                	xor    %eax,%eax
}
80102717:	c3                   	ret    
80102718:	66 90                	xchg   %ax,%ax
8010271a:	66 90                	xchg   %ax,%ax
8010271c:	66 90                	xchg   %ax,%ax
8010271e:	66 90                	xchg   %ax,%ax

80102720 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102720:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102724:	ba 64 00 00 00       	mov    $0x64,%edx
80102729:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010272a:	a8 01                	test   $0x1,%al
8010272c:	0f 84 be 00 00 00    	je     801027f0 <kbdgetc+0xd0>
{
80102732:	55                   	push   %ebp
80102733:	ba 60 00 00 00       	mov    $0x60,%edx
80102738:	89 e5                	mov    %esp,%ebp
8010273a:	53                   	push   %ebx
8010273b:	ec                   	in     (%dx),%al
  return data;
8010273c:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102742:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102745:	3c e0                	cmp    $0xe0,%al
80102747:	74 57                	je     801027a0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102749:	89 d9                	mov    %ebx,%ecx
8010274b:	83 e1 40             	and    $0x40,%ecx
8010274e:	84 c0                	test   %al,%al
80102750:	78 5e                	js     801027b0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102752:	85 c9                	test   %ecx,%ecx
80102754:	74 09                	je     8010275f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102756:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102759:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010275c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010275f:	0f b6 8a c0 76 10 80 	movzbl -0x7fef8940(%edx),%ecx
  shift ^= togglecode[data];
80102766:	0f b6 82 c0 75 10 80 	movzbl -0x7fef8a40(%edx),%eax
  shift |= shiftcode[data];
8010276d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010276f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102771:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102773:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102779:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010277c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010277f:	8b 04 85 a0 75 10 80 	mov    -0x7fef8a60(,%eax,4),%eax
80102786:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010278a:	74 0b                	je     80102797 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010278c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010278f:	83 fa 19             	cmp    $0x19,%edx
80102792:	77 44                	ja     801027d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102794:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102797:	5b                   	pop    %ebx
80102798:	5d                   	pop    %ebp
80102799:	c3                   	ret    
8010279a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801027a0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027a3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027a5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801027ab:	5b                   	pop    %ebx
801027ac:	5d                   	pop    %ebp
801027ad:	c3                   	ret    
801027ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801027b0:	83 e0 7f             	and    $0x7f,%eax
801027b3:	85 c9                	test   %ecx,%ecx
801027b5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801027b8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801027ba:	0f b6 8a c0 76 10 80 	movzbl -0x7fef8940(%edx),%ecx
801027c1:	83 c9 40             	or     $0x40,%ecx
801027c4:	0f b6 c9             	movzbl %cl,%ecx
801027c7:	f7 d1                	not    %ecx
801027c9:	21 d9                	and    %ebx,%ecx
}
801027cb:	5b                   	pop    %ebx
801027cc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801027cd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801027d3:	c3                   	ret    
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027db:	8d 50 20             	lea    0x20(%eax),%edx
}
801027de:	5b                   	pop    %ebx
801027df:	5d                   	pop    %ebp
      c += 'a' - 'A';
801027e0:	83 f9 1a             	cmp    $0x1a,%ecx
801027e3:	0f 42 c2             	cmovb  %edx,%eax
}
801027e6:	c3                   	ret    
801027e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ee:	66 90                	xchg   %ax,%ax
    return -1;
801027f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027f5:	c3                   	ret    
801027f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027fd:	8d 76 00             	lea    0x0(%esi),%esi

80102800 <kbdintr>:

void
kbdintr(void)
{
80102800:	f3 0f 1e fb          	endbr32 
80102804:	55                   	push   %ebp
80102805:	89 e5                	mov    %esp,%ebp
80102807:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010280a:	68 20 27 10 80       	push   $0x80102720
8010280f:	e8 4c e0 ff ff       	call   80100860 <consoleintr>
}
80102814:	83 c4 10             	add    $0x10,%esp
80102817:	c9                   	leave  
80102818:	c3                   	ret    
80102819:	66 90                	xchg   %ax,%ax
8010281b:	66 90                	xchg   %ax,%ax
8010281d:	66 90                	xchg   %ax,%ax
8010281f:	90                   	nop

80102820 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102820:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102824:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102829:	85 c0                	test   %eax,%eax
8010282b:	0f 84 c7 00 00 00    	je     801028f8 <lapicinit+0xd8>
  lapic[index] = value;
80102831:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102838:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102845:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102852:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102855:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102858:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010285f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102862:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102865:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010286c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010286f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102872:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102879:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010287c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010287f:	8b 50 30             	mov    0x30(%eax),%edx
80102882:	c1 ea 10             	shr    $0x10,%edx
80102885:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010288b:	75 73                	jne    80102900 <lapicinit+0xe0>
  lapic[index] = value;
8010288d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028a1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ae:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028bb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028c8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ce:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028d5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028d8:	8b 50 20             	mov    0x20(%eax),%edx
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028e6:	80 e6 10             	and    $0x10,%dh
801028e9:	75 f5                	jne    801028e0 <lapicinit+0xc0>
  lapic[index] = value;
801028eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028f8:	c3                   	ret    
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102900:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102907:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010290a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010290d:	e9 7b ff ff ff       	jmp    8010288d <lapicinit+0x6d>
80102912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <lapicid>:

int
lapicid(void)
{
80102920:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102924:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102929:	85 c0                	test   %eax,%eax
8010292b:	74 0b                	je     80102938 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010292d:	8b 40 20             	mov    0x20(%eax),%eax
80102930:	c1 e8 18             	shr    $0x18,%eax
80102933:	c3                   	ret    
80102934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102938:	31 c0                	xor    %eax,%eax
}
8010293a:	c3                   	ret    
8010293b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102940:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102944:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102949:	85 c0                	test   %eax,%eax
8010294b:	74 0d                	je     8010295a <lapiceoi+0x1a>
  lapic[index] = value;
8010294d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102954:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010295a:	c3                   	ret    
8010295b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010295f:	90                   	nop

80102960 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102960:	f3 0f 1e fb          	endbr32 
}
80102964:	c3                   	ret    
80102965:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010296c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102970 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102970:	f3 0f 1e fb          	endbr32 
80102974:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102975:	b8 0f 00 00 00       	mov    $0xf,%eax
8010297a:	ba 70 00 00 00       	mov    $0x70,%edx
8010297f:	89 e5                	mov    %esp,%ebp
80102981:	53                   	push   %ebx
80102982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102985:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102988:	ee                   	out    %al,(%dx)
80102989:	b8 0a 00 00 00       	mov    $0xa,%eax
8010298e:	ba 71 00 00 00       	mov    $0x71,%edx
80102993:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102994:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102996:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102999:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010299f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029a1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801029a4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029a6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029a9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029ac:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029b2:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801029b7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029bd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029c7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ca:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029cd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029d4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029da:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029e9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ec:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801029fb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029fc:	8b 40 20             	mov    0x20(%eax),%eax
}
801029ff:	5d                   	pop    %ebp
80102a00:	c3                   	ret    
80102a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a0f:	90                   	nop

80102a10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a10:	f3 0f 1e fb          	endbr32 
80102a14:	55                   	push   %ebp
80102a15:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a1a:	ba 70 00 00 00       	mov    $0x70,%edx
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
80102a24:	83 ec 4c             	sub    $0x4c,%esp
80102a27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a28:	ba 71 00 00 00       	mov    $0x71,%edx
80102a2d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a2e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a31:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a36:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a40:	31 c0                	xor    %eax,%eax
80102a42:	89 da                	mov    %ebx,%edx
80102a44:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a45:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a4a:	89 ca                	mov    %ecx,%edx
80102a4c:	ec                   	in     (%dx),%al
80102a4d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a50:	89 da                	mov    %ebx,%edx
80102a52:	b8 02 00 00 00       	mov    $0x2,%eax
80102a57:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a58:	89 ca                	mov    %ecx,%edx
80102a5a:	ec                   	in     (%dx),%al
80102a5b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5e:	89 da                	mov    %ebx,%edx
80102a60:	b8 04 00 00 00       	mov    $0x4,%eax
80102a65:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a66:	89 ca                	mov    %ecx,%edx
80102a68:	ec                   	in     (%dx),%al
80102a69:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6c:	89 da                	mov    %ebx,%edx
80102a6e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	89 ca                	mov    %ecx,%edx
80102a76:	ec                   	in     (%dx),%al
80102a77:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7a:	89 da                	mov    %ebx,%edx
80102a7c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a81:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a82:	89 ca                	mov    %ecx,%edx
80102a84:	ec                   	in     (%dx),%al
80102a85:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a87:	89 da                	mov    %ebx,%edx
80102a89:	b8 09 00 00 00       	mov    $0x9,%eax
80102a8e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8f:	89 ca                	mov    %ecx,%edx
80102a91:	ec                   	in     (%dx),%al
80102a92:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a94:	89 da                	mov    %ebx,%edx
80102a96:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a9f:	84 c0                	test   %al,%al
80102aa1:	78 9d                	js     80102a40 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102aa3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102aa7:	89 fa                	mov    %edi,%edx
80102aa9:	0f b6 fa             	movzbl %dl,%edi
80102aac:	89 f2                	mov    %esi,%edx
80102aae:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ab1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ab5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab8:	89 da                	mov    %ebx,%edx
80102aba:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102abd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ac0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102ac4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ac7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aca:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ace:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ad1:	31 c0                	xor    %eax,%eax
80102ad3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad4:	89 ca                	mov    %ecx,%edx
80102ad6:	ec                   	in     (%dx),%al
80102ad7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ada:	89 da                	mov    %ebx,%edx
80102adc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102adf:	b8 02 00 00 00       	mov    $0x2,%eax
80102ae4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae5:	89 ca                	mov    %ecx,%edx
80102ae7:	ec                   	in     (%dx),%al
80102ae8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aeb:	89 da                	mov    %ebx,%edx
80102aed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102af0:	b8 04 00 00 00       	mov    $0x4,%eax
80102af5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af6:	89 ca                	mov    %ecx,%edx
80102af8:	ec                   	in     (%dx),%al
80102af9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afc:	89 da                	mov    %ebx,%edx
80102afe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b01:	b8 07 00 00 00       	mov    $0x7,%eax
80102b06:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b07:	89 ca                	mov    %ecx,%edx
80102b09:	ec                   	in     (%dx),%al
80102b0a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0d:	89 da                	mov    %ebx,%edx
80102b0f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b12:	b8 08 00 00 00       	mov    $0x8,%eax
80102b17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b18:	89 ca                	mov    %ecx,%edx
80102b1a:	ec                   	in     (%dx),%al
80102b1b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1e:	89 da                	mov    %ebx,%edx
80102b20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b23:	b8 09 00 00 00       	mov    $0x9,%eax
80102b28:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b29:	89 ca                	mov    %ecx,%edx
80102b2b:	ec                   	in     (%dx),%al
80102b2c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b2f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b35:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b38:	6a 18                	push   $0x18
80102b3a:	50                   	push   %eax
80102b3b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b3e:	50                   	push   %eax
80102b3f:	e8 4c 1c 00 00       	call   80104790 <memcmp>
80102b44:	83 c4 10             	add    $0x10,%esp
80102b47:	85 c0                	test   %eax,%eax
80102b49:	0f 85 f1 fe ff ff    	jne    80102a40 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b4f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b53:	75 78                	jne    80102bcd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b55:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b58:	89 c2                	mov    %eax,%edx
80102b5a:	83 e0 0f             	and    $0xf,%eax
80102b5d:	c1 ea 04             	shr    $0x4,%edx
80102b60:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b63:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b66:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b69:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b6c:	89 c2                	mov    %eax,%edx
80102b6e:	83 e0 0f             	and    $0xf,%eax
80102b71:	c1 ea 04             	shr    $0x4,%edx
80102b74:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b77:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b7d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b80:	89 c2                	mov    %eax,%edx
80102b82:	83 e0 0f             	and    $0xf,%eax
80102b85:	c1 ea 04             	shr    $0x4,%edx
80102b88:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b91:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b94:	89 c2                	mov    %eax,%edx
80102b96:	83 e0 0f             	and    $0xf,%eax
80102b99:	c1 ea 04             	shr    $0x4,%edx
80102b9c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b9f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ba5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba8:	89 c2                	mov    %eax,%edx
80102baa:	83 e0 0f             	and    $0xf,%eax
80102bad:	c1 ea 04             	shr    $0x4,%edx
80102bb0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bb9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bbc:	89 c2                	mov    %eax,%edx
80102bbe:	83 e0 0f             	and    $0xf,%eax
80102bc1:	c1 ea 04             	shr    $0x4,%edx
80102bc4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bca:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bcd:	8b 75 08             	mov    0x8(%ebp),%esi
80102bd0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bd3:	89 06                	mov    %eax,(%esi)
80102bd5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bd8:	89 46 04             	mov    %eax,0x4(%esi)
80102bdb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bde:	89 46 08             	mov    %eax,0x8(%esi)
80102be1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102be4:	89 46 0c             	mov    %eax,0xc(%esi)
80102be7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bea:	89 46 10             	mov    %eax,0x10(%esi)
80102bed:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bf0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bf3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bfd:	5b                   	pop    %ebx
80102bfe:	5e                   	pop    %esi
80102bff:	5f                   	pop    %edi
80102c00:	5d                   	pop    %ebp
80102c01:	c3                   	ret    
80102c02:	66 90                	xchg   %ax,%ax
80102c04:	66 90                	xchg   %ax,%ax
80102c06:	66 90                	xchg   %ax,%ax
80102c08:	66 90                	xchg   %ax,%ax
80102c0a:	66 90                	xchg   %ax,%ax
80102c0c:	66 90                	xchg   %ax,%ax
80102c0e:	66 90                	xchg   %ax,%ax

80102c10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c10:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c16:	85 c9                	test   %ecx,%ecx
80102c18:	0f 8e 8a 00 00 00    	jle    80102ca8 <install_trans+0x98>
{
80102c1e:	55                   	push   %ebp
80102c1f:	89 e5                	mov    %esp,%ebp
80102c21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c22:	31 ff                	xor    %edi,%edi
{
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 0c             	sub    $0xc,%esp
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c30:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c35:	83 ec 08             	sub    $0x8,%esp
80102c38:	01 f8                	add    %edi,%eax
80102c3a:	83 c0 01             	add    $0x1,%eax
80102c3d:	50                   	push   %eax
80102c3e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c44:	e8 87 d4 ff ff       	call   801000d0 <bread>
80102c49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c4b:	58                   	pop    %eax
80102c4c:	5a                   	pop    %edx
80102c4d:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102c54:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5d:	e8 6e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6a:	68 00 02 00 00       	push   $0x200
80102c6f:	50                   	push   %eax
80102c70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c73:	50                   	push   %eax
80102c74:	e8 67 1b 00 00       	call   801047e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c79:	89 1c 24             	mov    %ebx,(%esp)
80102c7c:	e8 2f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 67 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c89:	89 1c 24             	mov    %ebx,(%esp)
80102c8c:	e8 5f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c91:	83 c4 10             	add    $0x10,%esp
80102c94:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102c9a:	7f 94                	jg     80102c30 <install_trans+0x20>
  }
}
80102c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c9f:	5b                   	pop    %ebx
80102ca0:	5e                   	pop    %esi
80102ca1:	5f                   	pop    %edi
80102ca2:	5d                   	pop    %ebp
80102ca3:	c3                   	ret    
80102ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ca8:	c3                   	ret    
80102ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cb7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102cbd:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102cc3:	e8 08 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ccb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ccd:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102cd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	7e 19                	jle    80102cf2 <write_head+0x42>
80102cd9:	31 d2                	xor    %edx,%edx
80102cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102ce0:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102ce7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ceb:	83 c2 01             	add    $0x1,%edx
80102cee:	39 d0                	cmp    %edx,%eax
80102cf0:	75 ee                	jne    80102ce0 <write_head+0x30>
  }
  bwrite(buf);
80102cf2:	83 ec 0c             	sub    $0xc,%esp
80102cf5:	53                   	push   %ebx
80102cf6:	e8 b5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cfb:	89 1c 24             	mov    %ebx,(%esp)
80102cfe:	e8 ed d4 ff ff       	call   801001f0 <brelse>
}
80102d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d06:	83 c4 10             	add    $0x10,%esp
80102d09:	c9                   	leave  
80102d0a:	c3                   	ret    
80102d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop

80102d10 <initlog>:
{
80102d10:	f3 0f 1e fb          	endbr32 
80102d14:	55                   	push   %ebp
80102d15:	89 e5                	mov    %esp,%ebp
80102d17:	53                   	push   %ebx
80102d18:	83 ec 2c             	sub    $0x2c,%esp
80102d1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d1e:	68 c0 77 10 80       	push   $0x801077c0
80102d23:	68 80 26 11 80       	push   $0x80112680
80102d28:	e8 83 17 00 00       	call   801044b0 <initlock>
  readsb(dev, &sb);
80102d2d:	58                   	pop    %eax
80102d2e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d31:	5a                   	pop    %edx
80102d32:	50                   	push   %eax
80102d33:	53                   	push   %ebx
80102d34:	e8 c7 e7 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d3c:	59                   	pop    %ecx
  log.dev = dev;
80102d3d:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102d43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d46:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102d4b:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102d51:	5a                   	pop    %edx
80102d52:	50                   	push   %eax
80102d53:	53                   	push   %ebx
80102d54:	e8 77 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d59:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d5c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d5f:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102d65:	85 c9                	test   %ecx,%ecx
80102d67:	7e 19                	jle    80102d82 <initlog+0x72>
80102d69:	31 d2                	xor    %edx,%edx
80102d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d6f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d70:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d74:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d7b:	83 c2 01             	add    $0x1,%edx
80102d7e:	39 d1                	cmp    %edx,%ecx
80102d80:	75 ee                	jne    80102d70 <initlog+0x60>
  brelse(buf);
80102d82:	83 ec 0c             	sub    $0xc,%esp
80102d85:	50                   	push   %eax
80102d86:	e8 65 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d8b:	e8 80 fe ff ff       	call   80102c10 <install_trans>
  log.lh.n = 0;
80102d90:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d97:	00 00 00 
  write_head(); // clear the log
80102d9a:	e8 11 ff ff ff       	call   80102cb0 <write_head>
}
80102d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	c9                   	leave  
80102da6:	c3                   	ret    
80102da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dba:	68 80 26 11 80       	push   $0x80112680
80102dbf:	e8 6c 18 00 00       	call   80104630 <acquire>
80102dc4:	83 c4 10             	add    $0x10,%esp
80102dc7:	eb 1c                	jmp    80102de5 <begin_op+0x35>
80102dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dd0:	83 ec 08             	sub    $0x8,%esp
80102dd3:	68 80 26 11 80       	push   $0x80112680
80102dd8:	68 80 26 11 80       	push   $0x80112680
80102ddd:	e8 be 11 00 00       	call   80103fa0 <sleep>
80102de2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102de5:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102dea:	85 c0                	test   %eax,%eax
80102dec:	75 e2                	jne    80102dd0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dee:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102df3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102df9:	83 c0 01             	add    $0x1,%eax
80102dfc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dff:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e02:	83 fa 1e             	cmp    $0x1e,%edx
80102e05:	7f c9                	jg     80102dd0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e07:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e0a:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102e0f:	68 80 26 11 80       	push   $0x80112680
80102e14:	e8 d7 18 00 00       	call   801046f0 <release>
      break;
    }
  }
}
80102e19:	83 c4 10             	add    $0x10,%esp
80102e1c:	c9                   	leave  
80102e1d:	c3                   	ret    
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e20:	f3 0f 1e fb          	endbr32 
80102e24:	55                   	push   %ebp
80102e25:	89 e5                	mov    %esp,%ebp
80102e27:	57                   	push   %edi
80102e28:	56                   	push   %esi
80102e29:	53                   	push   %ebx
80102e2a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e2d:	68 80 26 11 80       	push   $0x80112680
80102e32:	e8 f9 17 00 00       	call   80104630 <acquire>
  log.outstanding -= 1;
80102e37:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102e3c:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102e42:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e45:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e48:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102e4e:	85 f6                	test   %esi,%esi
80102e50:	0f 85 1e 01 00 00    	jne    80102f74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e56:	85 db                	test   %ebx,%ebx
80102e58:	0f 85 f2 00 00 00    	jne    80102f50 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e5e:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102e65:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e68:	83 ec 0c             	sub    $0xc,%esp
80102e6b:	68 80 26 11 80       	push   $0x80112680
80102e70:	e8 7b 18 00 00       	call   801046f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e75:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e7b:	83 c4 10             	add    $0x10,%esp
80102e7e:	85 c9                	test   %ecx,%ecx
80102e80:	7f 3e                	jg     80102ec0 <end_op+0xa0>
    acquire(&log.lock);
80102e82:	83 ec 0c             	sub    $0xc,%esp
80102e85:	68 80 26 11 80       	push   $0x80112680
80102e8a:	e8 a1 17 00 00       	call   80104630 <acquire>
    wakeup(&log);
80102e8f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e96:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e9d:	00 00 00 
    wakeup(&log);
80102ea0:	e8 bb 12 00 00       	call   80104160 <wakeup>
    release(&log.lock);
80102ea5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102eac:	e8 3f 18 00 00       	call   801046f0 <release>
80102eb1:	83 c4 10             	add    $0x10,%esp
}
80102eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb7:	5b                   	pop    %ebx
80102eb8:	5e                   	pop    %esi
80102eb9:	5f                   	pop    %edi
80102eba:	5d                   	pop    %ebp
80102ebb:	c3                   	ret    
80102ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ec0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ec5:	83 ec 08             	sub    $0x8,%esp
80102ec8:	01 d8                	add    %ebx,%eax
80102eca:	83 c0 01             	add    $0x1,%eax
80102ecd:	50                   	push   %eax
80102ece:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ed4:	e8 f7 d1 ff ff       	call   801000d0 <bread>
80102ed9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102edb:	58                   	pop    %eax
80102edc:	5a                   	pop    %edx
80102edd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ee4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eed:	e8 de d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ef2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ef5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ef7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102efa:	68 00 02 00 00       	push   $0x200
80102eff:	50                   	push   %eax
80102f00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f03:	50                   	push   %eax
80102f04:	e8 d7 18 00 00       	call   801047e0 <memmove>
    bwrite(to);  // write the log
80102f09:	89 34 24             	mov    %esi,(%esp)
80102f0c:	e8 9f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f11:	89 3c 24             	mov    %edi,(%esp)
80102f14:	e8 d7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 cf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102f2a:	7c 94                	jl     80102ec0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f2c:	e8 7f fd ff ff       	call   80102cb0 <write_head>
    install_trans(); // Now install writes to home locations
80102f31:	e8 da fc ff ff       	call   80102c10 <install_trans>
    log.lh.n = 0;
80102f36:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102f3d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f40:	e8 6b fd ff ff       	call   80102cb0 <write_head>
80102f45:	e9 38 ff ff ff       	jmp    80102e82 <end_op+0x62>
80102f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f50:	83 ec 0c             	sub    $0xc,%esp
80102f53:	68 80 26 11 80       	push   $0x80112680
80102f58:	e8 03 12 00 00       	call   80104160 <wakeup>
  release(&log.lock);
80102f5d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102f64:	e8 87 17 00 00       	call   801046f0 <release>
80102f69:	83 c4 10             	add    $0x10,%esp
}
80102f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5f                   	pop    %edi
80102f72:	5d                   	pop    %ebp
80102f73:	c3                   	ret    
    panic("log.committing");
80102f74:	83 ec 0c             	sub    $0xc,%esp
80102f77:	68 c4 77 10 80       	push   $0x801077c4
80102f7c:	e8 0f d4 ff ff       	call   80100390 <panic>
80102f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f8f:	90                   	nop

80102f90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f90:	f3 0f 1e fb          	endbr32 
80102f94:	55                   	push   %ebp
80102f95:	89 e5                	mov    %esp,%ebp
80102f97:	53                   	push   %ebx
80102f98:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f9b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102fa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa4:	83 fa 1d             	cmp    $0x1d,%edx
80102fa7:	0f 8f 91 00 00 00    	jg     8010303e <log_write+0xae>
80102fad:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102fb2:	83 e8 01             	sub    $0x1,%eax
80102fb5:	39 c2                	cmp    %eax,%edx
80102fb7:	0f 8d 81 00 00 00    	jge    8010303e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fbd:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102fc2:	85 c0                	test   %eax,%eax
80102fc4:	0f 8e 81 00 00 00    	jle    8010304b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fca:	83 ec 0c             	sub    $0xc,%esp
80102fcd:	68 80 26 11 80       	push   $0x80112680
80102fd2:	e8 59 16 00 00       	call   80104630 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fd7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102fdd:	83 c4 10             	add    $0x10,%esp
80102fe0:	85 d2                	test   %edx,%edx
80102fe2:	7e 4e                	jle    80103032 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fe7:	31 c0                	xor    %eax,%eax
80102fe9:	eb 0c                	jmp    80102ff7 <log_write+0x67>
80102feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fef:	90                   	nop
80102ff0:	83 c0 01             	add    $0x1,%eax
80102ff3:	39 c2                	cmp    %eax,%edx
80102ff5:	74 29                	je     80103020 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff7:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102ffe:	75 f0                	jne    80102ff0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103000:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103007:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010300a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010300d:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80103014:	c9                   	leave  
  release(&log.lock);
80103015:	e9 d6 16 00 00       	jmp    801046f0 <release>
8010301a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103020:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80103027:	83 c2 01             	add    $0x1,%edx
8010302a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80103030:	eb d5                	jmp    80103007 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103032:	8b 43 08             	mov    0x8(%ebx),%eax
80103035:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
8010303a:	75 cb                	jne    80103007 <log_write+0x77>
8010303c:	eb e9                	jmp    80103027 <log_write+0x97>
    panic("too big a transaction");
8010303e:	83 ec 0c             	sub    $0xc,%esp
80103041:	68 d3 77 10 80       	push   $0x801077d3
80103046:	e8 45 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010304b:	83 ec 0c             	sub    $0xc,%esp
8010304e:	68 e9 77 10 80       	push   $0x801077e9
80103053:	e8 38 d3 ff ff       	call   80100390 <panic>
80103058:	66 90                	xchg   %ax,%ax
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103060:	55                   	push   %ebp
80103061:	89 e5                	mov    %esp,%ebp
80103063:	53                   	push   %ebx
80103064:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103067:	e8 54 09 00 00       	call   801039c0 <cpuid>
8010306c:	89 c3                	mov    %eax,%ebx
8010306e:	e8 4d 09 00 00       	call   801039c0 <cpuid>
80103073:	83 ec 04             	sub    $0x4,%esp
80103076:	53                   	push   %ebx
80103077:	50                   	push   %eax
80103078:	68 04 78 10 80       	push   $0x80107804
8010307d:	e8 2e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103082:	e8 d9 2a 00 00       	call   80105b60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103087:	e8 c4 08 00 00       	call   80103950 <mycpu>
8010308c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010308e:	b8 01 00 00 00       	mov    $0x1,%eax
80103093:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010309a:	e8 11 0c 00 00       	call   80103cb0 <scheduler>
8010309f:	90                   	nop

801030a0 <mpenter>:
{
801030a0:	f3 0f 1e fb          	endbr32 
801030a4:	55                   	push   %ebp
801030a5:	89 e5                	mov    %esp,%ebp
801030a7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030aa:	e8 81 3b 00 00       	call   80106c30 <switchkvm>
  seginit();
801030af:	e8 ec 3a 00 00       	call   80106ba0 <seginit>
  lapicinit();
801030b4:	e8 67 f7 ff ff       	call   80102820 <lapicinit>
  mpmain();
801030b9:	e8 a2 ff ff ff       	call   80103060 <mpmain>
801030be:	66 90                	xchg   %ax,%ax

801030c0 <main>:
{
801030c0:	f3 0f 1e fb          	endbr32 
801030c4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030c8:	83 e4 f0             	and    $0xfffffff0,%esp
801030cb:	ff 71 fc             	pushl  -0x4(%ecx)
801030ce:	55                   	push   %ebp
801030cf:	89 e5                	mov    %esp,%ebp
801030d1:	53                   	push   %ebx
801030d2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030d3:	83 ec 08             	sub    $0x8,%esp
801030d6:	68 00 00 40 80       	push   $0x80400000
801030db:	68 f8 55 11 80       	push   $0x801155f8
801030e0:	e8 7b f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
801030e5:	e8 26 40 00 00       	call   80107110 <kvmalloc>
  mpinit();        // detect other processors
801030ea:	e8 81 01 00 00       	call   80103270 <mpinit>
  lapicinit();     // interrupt controller
801030ef:	e8 2c f7 ff ff       	call   80102820 <lapicinit>
  seginit();       // segment descriptors
801030f4:	e8 a7 3a 00 00       	call   80106ba0 <seginit>
  picinit();       // disable pic
801030f9:	e8 52 03 00 00       	call   80103450 <picinit>
  ioapicinit();    // another interrupt controller
801030fe:	e8 7d f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103103:	e8 28 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103108:	e8 53 2d 00 00       	call   80105e60 <uartinit>
  pinit();         // process table
8010310d:	e8 1e 08 00 00       	call   80103930 <pinit>
  tvinit();        // trap vectors
80103112:	e8 b9 29 00 00       	call   80105ad0 <tvinit>
  binit();         // buffer cache
80103117:	e8 24 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010311c:	e8 bf dc ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103121:	e8 2a f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103126:	83 c4 0c             	add    $0xc,%esp
80103129:	68 8a 00 00 00       	push   $0x8a
8010312e:	68 8c a4 10 80       	push   $0x8010a48c
80103133:	68 00 70 00 80       	push   $0x80007000
80103138:	e8 a3 16 00 00       	call   801047e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010313d:	83 c4 10             	add    $0x10,%esp
80103140:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103147:	00 00 00 
8010314a:	05 80 27 11 80       	add    $0x80112780,%eax
8010314f:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103154:	76 7a                	jbe    801031d0 <main+0x110>
80103156:	bb 80 27 11 80       	mov    $0x80112780,%ebx
8010315b:	eb 1c                	jmp    80103179 <main+0xb9>
8010315d:	8d 76 00             	lea    0x0(%esi),%esi
80103160:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103167:	00 00 00 
8010316a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103170:	05 80 27 11 80       	add    $0x80112780,%eax
80103175:	39 c3                	cmp    %eax,%ebx
80103177:	73 57                	jae    801031d0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103179:	e8 d2 07 00 00       	call   80103950 <mycpu>
8010317e:	39 c3                	cmp    %eax,%ebx
80103180:	74 de                	je     80103160 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103182:	e8 a9 f4 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103187:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010318a:	c7 05 f8 6f 00 80 a0 	movl   $0x801030a0,0x80006ff8
80103191:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103194:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010319b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010319e:	05 00 10 00 00       	add    $0x1000,%eax
801031a3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031a8:	0f b6 03             	movzbl (%ebx),%eax
801031ab:	68 00 70 00 00       	push   $0x7000
801031b0:	50                   	push   %eax
801031b1:	e8 ba f7 ff ff       	call   80102970 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031b6:	83 c4 10             	add    $0x10,%esp
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031c6:	85 c0                	test   %eax,%eax
801031c8:	74 f6                	je     801031c0 <main+0x100>
801031ca:	eb 94                	jmp    80103160 <main+0xa0>
801031cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031d0:	83 ec 08             	sub    $0x8,%esp
801031d3:	68 00 00 00 8e       	push   $0x8e000000
801031d8:	68 00 00 40 80       	push   $0x80400000
801031dd:	e8 ee f3 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
801031e2:	e8 29 08 00 00       	call   80103a10 <userinit>
  mpmain();        // finish this processor's setup
801031e7:	e8 74 fe ff ff       	call   80103060 <mpmain>
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031fb:	53                   	push   %ebx
  e = addr+len;
801031fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103202:	39 de                	cmp    %ebx,%esi
80103204:	72 10                	jb     80103216 <mpsearch1+0x26>
80103206:	eb 50                	jmp    80103258 <mpsearch1+0x68>
80103208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
80103210:	89 fe                	mov    %edi,%esi
80103212:	39 fb                	cmp    %edi,%ebx
80103214:	76 42                	jbe    80103258 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103216:	83 ec 04             	sub    $0x4,%esp
80103219:	8d 7e 10             	lea    0x10(%esi),%edi
8010321c:	6a 04                	push   $0x4
8010321e:	68 18 78 10 80       	push   $0x80107818
80103223:	56                   	push   %esi
80103224:	e8 67 15 00 00       	call   80104790 <memcmp>
80103229:	83 c4 10             	add    $0x10,%esp
8010322c:	85 c0                	test   %eax,%eax
8010322e:	75 e0                	jne    80103210 <mpsearch1+0x20>
80103230:	89 f2                	mov    %esi,%edx
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103238:	0f b6 0a             	movzbl (%edx),%ecx
8010323b:	83 c2 01             	add    $0x1,%edx
8010323e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103240:	39 fa                	cmp    %edi,%edx
80103242:	75 f4                	jne    80103238 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103244:	84 c0                	test   %al,%al
80103246:	75 c8                	jne    80103210 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103248:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010324b:	89 f0                	mov    %esi,%eax
8010324d:	5b                   	pop    %ebx
8010324e:	5e                   	pop    %esi
8010324f:	5f                   	pop    %edi
80103250:	5d                   	pop    %ebp
80103251:	c3                   	ret    
80103252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010325b:	31 f6                	xor    %esi,%esi
}
8010325d:	5b                   	pop    %ebx
8010325e:	89 f0                	mov    %esi,%eax
80103260:	5e                   	pop    %esi
80103261:	5f                   	pop    %edi
80103262:	5d                   	pop    %ebp
80103263:	c3                   	ret    
80103264:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010326b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010326f:	90                   	nop

80103270 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103270:	f3 0f 1e fb          	endbr32 
80103274:	55                   	push   %ebp
80103275:	89 e5                	mov    %esp,%ebp
80103277:	57                   	push   %edi
80103278:	56                   	push   %esi
80103279:	53                   	push   %ebx
8010327a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010327d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103284:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010328b:	c1 e0 08             	shl    $0x8,%eax
8010328e:	09 d0                	or     %edx,%eax
80103290:	c1 e0 04             	shl    $0x4,%eax
80103293:	75 1b                	jne    801032b0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103295:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010329c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032a3:	c1 e0 08             	shl    $0x8,%eax
801032a6:	09 d0                	or     %edx,%eax
801032a8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032ab:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032b0:	ba 00 04 00 00       	mov    $0x400,%edx
801032b5:	e8 36 ff ff ff       	call   801031f0 <mpsearch1>
801032ba:	89 c6                	mov    %eax,%esi
801032bc:	85 c0                	test   %eax,%eax
801032be:	0f 84 4c 01 00 00    	je     80103410 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c4:	8b 5e 04             	mov    0x4(%esi),%ebx
801032c7:	85 db                	test   %ebx,%ebx
801032c9:	0f 84 61 01 00 00    	je     80103430 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801032cf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032d2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032d8:	6a 04                	push   $0x4
801032da:	68 1d 78 10 80       	push   $0x8010781d
801032df:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032e3:	e8 a8 14 00 00       	call   80104790 <memcmp>
801032e8:	83 c4 10             	add    $0x10,%esp
801032eb:	85 c0                	test   %eax,%eax
801032ed:	0f 85 3d 01 00 00    	jne    80103430 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032f3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032fa:	3c 01                	cmp    $0x1,%al
801032fc:	74 08                	je     80103306 <mpinit+0x96>
801032fe:	3c 04                	cmp    $0x4,%al
80103300:	0f 85 2a 01 00 00    	jne    80103430 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103306:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010330d:	66 85 d2             	test   %dx,%dx
80103310:	74 26                	je     80103338 <mpinit+0xc8>
80103312:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103315:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103317:	31 d2                	xor    %edx,%edx
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103320:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103327:	83 c0 01             	add    $0x1,%eax
8010332a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010332c:	39 f8                	cmp    %edi,%eax
8010332e:	75 f0                	jne    80103320 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103330:	84 d2                	test   %dl,%dl
80103332:	0f 85 f8 00 00 00    	jne    80103430 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103338:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010333e:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103343:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103349:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103350:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103355:	03 55 e4             	add    -0x1c(%ebp),%edx
80103358:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010335b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010335f:	90                   	nop
80103360:	39 c2                	cmp    %eax,%edx
80103362:	76 15                	jbe    80103379 <mpinit+0x109>
    switch(*p){
80103364:	0f b6 08             	movzbl (%eax),%ecx
80103367:	80 f9 02             	cmp    $0x2,%cl
8010336a:	74 5c                	je     801033c8 <mpinit+0x158>
8010336c:	77 42                	ja     801033b0 <mpinit+0x140>
8010336e:	84 c9                	test   %cl,%cl
80103370:	74 6e                	je     801033e0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103372:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103375:	39 c2                	cmp    %eax,%edx
80103377:	77 eb                	ja     80103364 <mpinit+0xf4>
80103379:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010337c:	85 db                	test   %ebx,%ebx
8010337e:	0f 84 b9 00 00 00    	je     8010343d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103384:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103388:	74 15                	je     8010339f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010338a:	b8 70 00 00 00       	mov    $0x70,%eax
8010338f:	ba 22 00 00 00       	mov    $0x22,%edx
80103394:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103395:	ba 23 00 00 00       	mov    $0x23,%edx
8010339a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010339b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010339e:	ee                   	out    %al,(%dx)
  }
}
8010339f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033a2:	5b                   	pop    %ebx
801033a3:	5e                   	pop    %esi
801033a4:	5f                   	pop    %edi
801033a5:	5d                   	pop    %ebp
801033a6:	c3                   	ret    
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
    switch(*p){
801033b0:	83 e9 03             	sub    $0x3,%ecx
801033b3:	80 f9 01             	cmp    $0x1,%cl
801033b6:	76 ba                	jbe    80103372 <mpinit+0x102>
801033b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801033bf:	eb 9f                	jmp    80103360 <mpinit+0xf0>
801033c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033c8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033cf:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
801033d5:	eb 89                	jmp    80103360 <mpinit+0xf0>
801033d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033de:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801033e0:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801033e6:	83 f9 07             	cmp    $0x7,%ecx
801033e9:	7f 19                	jg     80103404 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033eb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033f1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033f5:	83 c1 01             	add    $0x1,%ecx
801033f8:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033fe:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103404:	83 c0 14             	add    $0x14,%eax
      continue;
80103407:	e9 54 ff ff ff       	jmp    80103360 <mpinit+0xf0>
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103410:	ba 00 00 01 00       	mov    $0x10000,%edx
80103415:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010341a:	e8 d1 fd ff ff       	call   801031f0 <mpsearch1>
8010341f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103421:	85 c0                	test   %eax,%eax
80103423:	0f 85 9b fe ff ff    	jne    801032c4 <mpinit+0x54>
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	68 22 78 10 80       	push   $0x80107822
80103438:	e8 53 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010343d:	83 ec 0c             	sub    $0xc,%esp
80103440:	68 3c 78 10 80       	push   $0x8010783c
80103445:	e8 46 cf ff ff       	call   80100390 <panic>
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103450:	f3 0f 1e fb          	endbr32 
80103454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103459:	ba 21 00 00 00       	mov    $0x21,%edx
8010345e:	ee                   	out    %al,(%dx)
8010345f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103464:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103465:	c3                   	ret    
80103466:	66 90                	xchg   %ax,%ax
80103468:	66 90                	xchg   %ax,%ax
8010346a:	66 90                	xchg   %ax,%ax
8010346c:	66 90                	xchg   %ax,%ax
8010346e:	66 90                	xchg   %ax,%ax

80103470 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103470:	f3 0f 1e fb          	endbr32 
80103474:	55                   	push   %ebp
80103475:	89 e5                	mov    %esp,%ebp
80103477:	57                   	push   %edi
80103478:	56                   	push   %esi
80103479:	53                   	push   %ebx
8010347a:	83 ec 0c             	sub    $0xc,%esp
8010347d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103480:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103483:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103489:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010348f:	e8 6c d9 ff ff       	call   80100e00 <filealloc>
80103494:	89 03                	mov    %eax,(%ebx)
80103496:	85 c0                	test   %eax,%eax
80103498:	0f 84 ac 00 00 00    	je     8010354a <pipealloc+0xda>
8010349e:	e8 5d d9 ff ff       	call   80100e00 <filealloc>
801034a3:	89 06                	mov    %eax,(%esi)
801034a5:	85 c0                	test   %eax,%eax
801034a7:	0f 84 8b 00 00 00    	je     80103538 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034ad:	e8 7e f1 ff ff       	call   80102630 <kalloc>
801034b2:	89 c7                	mov    %eax,%edi
801034b4:	85 c0                	test   %eax,%eax
801034b6:	0f 84 b4 00 00 00    	je     80103570 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801034bc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034c3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034c6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034c9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034d0:	00 00 00 
  p->nwrite = 0;
801034d3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034da:	00 00 00 
  p->nread = 0;
801034dd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034e4:	00 00 00 
  initlock(&p->lock, "pipe");
801034e7:	68 5b 78 10 80       	push   $0x8010785b
801034ec:	50                   	push   %eax
801034ed:	e8 be 0f 00 00       	call   801044b0 <initlock>
  (*f0)->type = FD_PIPE;
801034f2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034f4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034fd:	8b 03                	mov    (%ebx),%eax
801034ff:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103503:	8b 03                	mov    (%ebx),%eax
80103505:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103509:	8b 03                	mov    (%ebx),%eax
8010350b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010350e:	8b 06                	mov    (%esi),%eax
80103510:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103516:	8b 06                	mov    (%esi),%eax
80103518:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010351c:	8b 06                	mov    (%esi),%eax
8010351e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103522:	8b 06                	mov    (%esi),%eax
80103524:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103527:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010352a:	31 c0                	xor    %eax,%eax
}
8010352c:	5b                   	pop    %ebx
8010352d:	5e                   	pop    %esi
8010352e:	5f                   	pop    %edi
8010352f:	5d                   	pop    %ebp
80103530:	c3                   	ret    
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103538:	8b 03                	mov    (%ebx),%eax
8010353a:	85 c0                	test   %eax,%eax
8010353c:	74 1e                	je     8010355c <pipealloc+0xec>
    fileclose(*f0);
8010353e:	83 ec 0c             	sub    $0xc,%esp
80103541:	50                   	push   %eax
80103542:	e8 79 d9 ff ff       	call   80100ec0 <fileclose>
80103547:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010354a:	8b 06                	mov    (%esi),%eax
8010354c:	85 c0                	test   %eax,%eax
8010354e:	74 0c                	je     8010355c <pipealloc+0xec>
    fileclose(*f1);
80103550:	83 ec 0c             	sub    $0xc,%esp
80103553:	50                   	push   %eax
80103554:	e8 67 d9 ff ff       	call   80100ec0 <fileclose>
80103559:	83 c4 10             	add    $0x10,%esp
}
8010355c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010355f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103564:	5b                   	pop    %ebx
80103565:	5e                   	pop    %esi
80103566:	5f                   	pop    %edi
80103567:	5d                   	pop    %ebp
80103568:	c3                   	ret    
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103570:	8b 03                	mov    (%ebx),%eax
80103572:	85 c0                	test   %eax,%eax
80103574:	75 c8                	jne    8010353e <pipealloc+0xce>
80103576:	eb d2                	jmp    8010354a <pipealloc+0xda>
80103578:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010357f:	90                   	nop

80103580 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103580:	f3 0f 1e fb          	endbr32 
80103584:	55                   	push   %ebp
80103585:	89 e5                	mov    %esp,%ebp
80103587:	56                   	push   %esi
80103588:	53                   	push   %ebx
80103589:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010358c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010358f:	83 ec 0c             	sub    $0xc,%esp
80103592:	53                   	push   %ebx
80103593:	e8 98 10 00 00       	call   80104630 <acquire>
  if(writable){
80103598:	83 c4 10             	add    $0x10,%esp
8010359b:	85 f6                	test   %esi,%esi
8010359d:	74 41                	je     801035e0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010359f:	83 ec 0c             	sub    $0xc,%esp
801035a2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035a8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035af:	00 00 00 
    wakeup(&p->nread);
801035b2:	50                   	push   %eax
801035b3:	e8 a8 0b 00 00       	call   80104160 <wakeup>
801035b8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035bb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035c1:	85 d2                	test   %edx,%edx
801035c3:	75 0a                	jne    801035cf <pipeclose+0x4f>
801035c5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035cb:	85 c0                	test   %eax,%eax
801035cd:	74 31                	je     80103600 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d5:	5b                   	pop    %ebx
801035d6:	5e                   	pop    %esi
801035d7:	5d                   	pop    %ebp
    release(&p->lock);
801035d8:	e9 13 11 00 00       	jmp    801046f0 <release>
801035dd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035e9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035f0:	00 00 00 
    wakeup(&p->nwrite);
801035f3:	50                   	push   %eax
801035f4:	e8 67 0b 00 00       	call   80104160 <wakeup>
801035f9:	83 c4 10             	add    $0x10,%esp
801035fc:	eb bd                	jmp    801035bb <pipeclose+0x3b>
801035fe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103600:	83 ec 0c             	sub    $0xc,%esp
80103603:	53                   	push   %ebx
80103604:	e8 e7 10 00 00       	call   801046f0 <release>
    kfree((char*)p);
80103609:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010360c:	83 c4 10             	add    $0x10,%esp
}
8010360f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103612:	5b                   	pop    %ebx
80103613:	5e                   	pop    %esi
80103614:	5d                   	pop    %ebp
    kfree((char*)p);
80103615:	e9 56 ee ff ff       	jmp    80102470 <kfree>
8010361a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103620 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103620:	f3 0f 1e fb          	endbr32 
80103624:	55                   	push   %ebp
80103625:	89 e5                	mov    %esp,%ebp
80103627:	57                   	push   %edi
80103628:	56                   	push   %esi
80103629:	53                   	push   %ebx
8010362a:	83 ec 28             	sub    $0x28,%esp
8010362d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103630:	53                   	push   %ebx
80103631:	e8 fa 0f 00 00       	call   80104630 <acquire>
  for(i = 0; i < n; i++){
80103636:	8b 45 10             	mov    0x10(%ebp),%eax
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	85 c0                	test   %eax,%eax
8010363e:	0f 8e bc 00 00 00    	jle    80103700 <pipewrite+0xe0>
80103644:	8b 45 0c             	mov    0xc(%ebp),%eax
80103647:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010364d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103653:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103656:	03 45 10             	add    0x10(%ebp),%eax
80103659:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010365c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103662:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103668:	89 ca                	mov    %ecx,%edx
8010366a:	05 00 02 00 00       	add    $0x200,%eax
8010366f:	39 c1                	cmp    %eax,%ecx
80103671:	74 3b                	je     801036ae <pipewrite+0x8e>
80103673:	eb 63                	jmp    801036d8 <pipewrite+0xb8>
80103675:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103678:	e8 63 03 00 00       	call   801039e0 <myproc>
8010367d:	8b 48 24             	mov    0x24(%eax),%ecx
80103680:	85 c9                	test   %ecx,%ecx
80103682:	75 34                	jne    801036b8 <pipewrite+0x98>
      wakeup(&p->nread);
80103684:	83 ec 0c             	sub    $0xc,%esp
80103687:	57                   	push   %edi
80103688:	e8 d3 0a 00 00       	call   80104160 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010368d:	58                   	pop    %eax
8010368e:	5a                   	pop    %edx
8010368f:	53                   	push   %ebx
80103690:	56                   	push   %esi
80103691:	e8 0a 09 00 00       	call   80103fa0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103696:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010369c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036a2:	83 c4 10             	add    $0x10,%esp
801036a5:	05 00 02 00 00       	add    $0x200,%eax
801036aa:	39 c2                	cmp    %eax,%edx
801036ac:	75 2a                	jne    801036d8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801036ae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036b4:	85 c0                	test   %eax,%eax
801036b6:	75 c0                	jne    80103678 <pipewrite+0x58>
        release(&p->lock);
801036b8:	83 ec 0c             	sub    $0xc,%esp
801036bb:	53                   	push   %ebx
801036bc:	e8 2f 10 00 00       	call   801046f0 <release>
        return -1;
801036c1:	83 c4 10             	add    $0x10,%esp
801036c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036cc:	5b                   	pop    %ebx
801036cd:	5e                   	pop    %esi
801036ce:	5f                   	pop    %edi
801036cf:	5d                   	pop    %ebp
801036d0:	c3                   	ret    
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036db:	8d 4a 01             	lea    0x1(%edx),%ecx
801036de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036e4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ea:	0f b6 06             	movzbl (%esi),%eax
801036ed:	83 c6 01             	add    $0x1,%esi
801036f0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036f3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036f7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036fa:	0f 85 5c ff ff ff    	jne    8010365c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103709:	50                   	push   %eax
8010370a:	e8 51 0a 00 00       	call   80104160 <wakeup>
  release(&p->lock);
8010370f:	89 1c 24             	mov    %ebx,(%esp)
80103712:	e8 d9 0f 00 00       	call   801046f0 <release>
  return n;
80103717:	8b 45 10             	mov    0x10(%ebp),%eax
8010371a:	83 c4 10             	add    $0x10,%esp
8010371d:	eb aa                	jmp    801036c9 <pipewrite+0xa9>
8010371f:	90                   	nop

80103720 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103720:	f3 0f 1e fb          	endbr32 
80103724:	55                   	push   %ebp
80103725:	89 e5                	mov    %esp,%ebp
80103727:	57                   	push   %edi
80103728:	56                   	push   %esi
80103729:	53                   	push   %ebx
8010372a:	83 ec 18             	sub    $0x18,%esp
8010372d:	8b 75 08             	mov    0x8(%ebp),%esi
80103730:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103733:	56                   	push   %esi
80103734:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010373a:	e8 f1 0e 00 00       	call   80104630 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010373f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010374e:	74 33                	je     80103783 <piperead+0x63>
80103750:	eb 3b                	jmp    8010378d <piperead+0x6d>
80103752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103758:	e8 83 02 00 00       	call   801039e0 <myproc>
8010375d:	8b 48 24             	mov    0x24(%eax),%ecx
80103760:	85 c9                	test   %ecx,%ecx
80103762:	0f 85 88 00 00 00    	jne    801037f0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103768:	83 ec 08             	sub    $0x8,%esp
8010376b:	56                   	push   %esi
8010376c:	53                   	push   %ebx
8010376d:	e8 2e 08 00 00       	call   80103fa0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103772:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103778:	83 c4 10             	add    $0x10,%esp
8010377b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103781:	75 0a                	jne    8010378d <piperead+0x6d>
80103783:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103789:	85 c0                	test   %eax,%eax
8010378b:	75 cb                	jne    80103758 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010378d:	8b 55 10             	mov    0x10(%ebp),%edx
80103790:	31 db                	xor    %ebx,%ebx
80103792:	85 d2                	test   %edx,%edx
80103794:	7f 28                	jg     801037be <piperead+0x9e>
80103796:	eb 34                	jmp    801037cc <piperead+0xac>
80103798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010379f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037a0:	8d 48 01             	lea    0x1(%eax),%ecx
801037a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b6:	83 c3 01             	add    $0x1,%ebx
801037b9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037bc:	74 0e                	je     801037cc <piperead+0xac>
    if(p->nread == p->nwrite)
801037be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ca:	75 d4                	jne    801037a0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037d5:	50                   	push   %eax
801037d6:	e8 85 09 00 00       	call   80104160 <wakeup>
  release(&p->lock);
801037db:	89 34 24             	mov    %esi,(%esp)
801037de:	e8 0d 0f 00 00       	call   801046f0 <release>
  return i;
801037e3:	83 c4 10             	add    $0x10,%esp
}
801037e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e9:	89 d8                	mov    %ebx,%eax
801037eb:	5b                   	pop    %ebx
801037ec:	5e                   	pop    %esi
801037ed:	5f                   	pop    %edi
801037ee:	5d                   	pop    %ebp
801037ef:	c3                   	ret    
      release(&p->lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037f8:	56                   	push   %esi
801037f9:	e8 f2 0e 00 00       	call   801046f0 <release>
      return -1;
801037fe:	83 c4 10             	add    $0x10,%esp
}
80103801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103804:	89 d8                	mov    %ebx,%eax
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret    
8010380b:	66 90                	xchg   %ax,%ax
8010380d:	66 90                	xchg   %ax,%ax
8010380f:	90                   	nop

80103810 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
  struct proc *p;
  char *sp;
  
  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103814:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103819:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010381c:	68 20 2d 11 80       	push   $0x80112d20
80103821:	e8 0a 0e 00 00       	call   80104630 <acquire>
80103826:	83 c4 10             	add    $0x10,%esp
80103829:	eb 10                	jmp    8010383b <allocproc+0x2b>
8010382b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010382f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	83 eb 80             	sub    $0xffffff80,%ebx
80103833:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103839:	74 75                	je     801038b0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010383b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010383e:	85 c0                	test   %eax,%eax
80103840:	75 ee                	jne    80103830 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103842:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103847:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010384a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103851:	89 43 10             	mov    %eax,0x10(%ebx)
80103854:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103857:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010385c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103862:	e8 89 0e 00 00       	call   801046f0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103867:	e8 c4 ed ff ff       	call   80102630 <kalloc>
8010386c:	83 c4 10             	add    $0x10,%esp
8010386f:	89 43 08             	mov    %eax,0x8(%ebx)
80103872:	85 c0                	test   %eax,%eax
80103874:	74 53                	je     801038c9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103876:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010387c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010387f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103884:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103887:	c7 40 14 bb 5a 10 80 	movl   $0x80105abb,0x14(%eax)
  p->context = (struct context*)sp;
8010388e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103891:	6a 14                	push   $0x14
80103893:	6a 00                	push   $0x0
80103895:	50                   	push   %eax
80103896:	e8 a5 0e 00 00       	call   80104740 <memset>
  p->context->eip = (uint)forkret;
8010389b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010389e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038a1:	c7 40 10 e0 38 10 80 	movl   $0x801038e0,0x10(%eax)
}
801038a8:	89 d8                	mov    %ebx,%eax
801038aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ad:	c9                   	leave  
801038ae:	c3                   	ret    
801038af:	90                   	nop
  release(&ptable.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038b5:	68 20 2d 11 80       	push   $0x80112d20
801038ba:	e8 31 0e 00 00       	call   801046f0 <release>
}
801038bf:	89 d8                	mov    %ebx,%eax
  return 0;
801038c1:	83 c4 10             	add    $0x10,%esp
}
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave  
801038c8:	c3                   	ret    
    p->state = UNUSED;
801038c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038d0:	31 db                	xor    %ebx,%ebx
}
801038d2:	89 d8                	mov    %ebx,%eax
801038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d7:	c9                   	leave  
801038d8:	c3                   	ret    
801038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038ea:	68 20 2d 11 80       	push   $0x80112d20
801038ef:	e8 fc 0d 00 00       	call   801046f0 <release>

  if (first) {
801038f4:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038f9:	83 c4 10             	add    $0x10,%esp
801038fc:	85 c0                	test   %eax,%eax
801038fe:	75 08                	jne    80103908 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103900:	c9                   	leave  
80103901:	c3                   	ret    
80103902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103908:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010390f:	00 00 00 
    iinit(ROOTDEV);
80103912:	83 ec 0c             	sub    $0xc,%esp
80103915:	6a 01                	push   $0x1
80103917:	e8 24 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010391c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103923:	e8 e8 f3 ff ff       	call   80102d10 <initlog>
}
80103928:	83 c4 10             	add    $0x10,%esp
8010392b:	c9                   	leave  
8010392c:	c3                   	ret    
8010392d:	8d 76 00             	lea    0x0(%esi),%esi

80103930 <pinit>:
{
80103930:	f3 0f 1e fb          	endbr32 
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010393a:	68 60 78 10 80       	push   $0x80107860
8010393f:	68 20 2d 11 80       	push   $0x80112d20
80103944:	e8 67 0b 00 00       	call   801044b0 <initlock>
}
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	c9                   	leave  
8010394d:	c3                   	ret    
8010394e:	66 90                	xchg   %ax,%ax

80103950 <mycpu>:
{
80103950:	f3 0f 1e fb          	endbr32 
80103954:	55                   	push   %ebp
80103955:	89 e5                	mov    %esp,%ebp
80103957:	56                   	push   %esi
80103958:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103959:	9c                   	pushf  
8010395a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010395b:	f6 c4 02             	test   $0x2,%ah
8010395e:	75 4a                	jne    801039aa <mycpu+0x5a>
  apicid = lapicid();
80103960:	e8 bb ef ff ff       	call   80102920 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103965:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
8010396b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010396d:	85 f6                	test   %esi,%esi
8010396f:	7e 2c                	jle    8010399d <mycpu+0x4d>
80103971:	31 d2                	xor    %edx,%edx
80103973:	eb 0a                	jmp    8010397f <mycpu+0x2f>
80103975:	8d 76 00             	lea    0x0(%esi),%esi
80103978:	83 c2 01             	add    $0x1,%edx
8010397b:	39 f2                	cmp    %esi,%edx
8010397d:	74 1e                	je     8010399d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010397f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103985:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010398c:	39 d8                	cmp    %ebx,%eax
8010398e:	75 e8                	jne    80103978 <mycpu+0x28>
}
80103990:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103993:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103999:	5b                   	pop    %ebx
8010399a:	5e                   	pop    %esi
8010399b:	5d                   	pop    %ebp
8010399c:	c3                   	ret    
  panic("unknown apicid\n");
8010399d:	83 ec 0c             	sub    $0xc,%esp
801039a0:	68 67 78 10 80       	push   $0x80107867
801039a5:	e8 e6 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039aa:	83 ec 0c             	sub    $0xc,%esp
801039ad:	68 44 79 10 80       	push   $0x80107944
801039b2:	e8 d9 c9 ff ff       	call   80100390 <panic>
801039b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039be:	66 90                	xchg   %ax,%ax

801039c0 <cpuid>:
cpuid() {
801039c0:	f3 0f 1e fb          	endbr32 
801039c4:	55                   	push   %ebp
801039c5:	89 e5                	mov    %esp,%ebp
801039c7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039ca:	e8 81 ff ff ff       	call   80103950 <mycpu>
}
801039cf:	c9                   	leave  
  return mycpu()-cpus;
801039d0:	2d 80 27 11 80       	sub    $0x80112780,%eax
801039d5:	c1 f8 04             	sar    $0x4,%eax
801039d8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039de:	c3                   	ret    
801039df:	90                   	nop

801039e0 <myproc>:
myproc(void) {
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	53                   	push   %ebx
801039e8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039eb:	e8 40 0b 00 00       	call   80104530 <pushcli>
  c = mycpu();
801039f0:	e8 5b ff ff ff       	call   80103950 <mycpu>
  p = c->proc;
801039f5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039fb:	e8 80 0b 00 00       	call   80104580 <popcli>
}
80103a00:	83 c4 04             	add    $0x4,%esp
80103a03:	89 d8                	mov    %ebx,%eax
80103a05:	5b                   	pop    %ebx
80103a06:	5d                   	pop    %ebp
80103a07:	c3                   	ret    
80103a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop

80103a10 <userinit>:
{
80103a10:	f3 0f 1e fb          	endbr32 
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	53                   	push   %ebx
80103a18:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a1b:	e8 f0 fd ff ff       	call   80103810 <allocproc>
80103a20:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a22:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103a27:	e8 64 36 00 00       	call   80107090 <setupkvm>
80103a2c:	89 43 04             	mov    %eax,0x4(%ebx)
80103a2f:	85 c0                	test   %eax,%eax
80103a31:	0f 84 bd 00 00 00    	je     80103af4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a37:	83 ec 04             	sub    $0x4,%esp
80103a3a:	68 2c 00 00 00       	push   $0x2c
80103a3f:	68 60 a4 10 80       	push   $0x8010a460
80103a44:	50                   	push   %eax
80103a45:	e8 16 33 00 00       	call   80106d60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a4a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a4d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a53:	6a 4c                	push   $0x4c
80103a55:	6a 00                	push   $0x0
80103a57:	ff 73 18             	pushl  0x18(%ebx)
80103a5a:	e8 e1 0c 00 00       	call   80104740 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a62:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a67:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a6a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a73:	8b 43 18             	mov    0x18(%ebx),%eax
80103a76:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a7a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a7d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a81:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a85:	8b 43 18             	mov    0x18(%ebx),%eax
80103a88:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a8c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a90:	8b 43 18             	mov    0x18(%ebx),%eax
80103a93:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a9a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a9d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103aa4:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aae:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ab1:	6a 10                	push   $0x10
80103ab3:	68 90 78 10 80       	push   $0x80107890
80103ab8:	50                   	push   %eax
80103ab9:	e8 42 0e 00 00       	call   80104900 <safestrcpy>
  p->cwd = namei("/");
80103abe:	c7 04 24 99 78 10 80 	movl   $0x80107899,(%esp)
80103ac5:	e8 66 e5 ff ff       	call   80102030 <namei>
80103aca:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103acd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ad4:	e8 57 0b 00 00       	call   80104630 <acquire>
  p->state = RUNNABLE;
80103ad9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103ae0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ae7:	e8 04 0c 00 00       	call   801046f0 <release>
}
80103aec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	c9                   	leave  
80103af3:	c3                   	ret    
    panic("userinit: out of memory?");
80103af4:	83 ec 0c             	sub    $0xc,%esp
80103af7:	68 77 78 10 80       	push   $0x80107877
80103afc:	e8 8f c8 ff ff       	call   80100390 <panic>
80103b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b0f:	90                   	nop

80103b10 <growproc>:
{
80103b10:	f3 0f 1e fb          	endbr32 
80103b14:	55                   	push   %ebp
80103b15:	89 e5                	mov    %esp,%ebp
80103b17:	56                   	push   %esi
80103b18:	53                   	push   %ebx
80103b19:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b1c:	e8 0f 0a 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103b21:	e8 2a fe ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b26:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b2c:	e8 4f 0a 00 00       	call   80104580 <popcli>
  sz = curproc->sz;
80103b31:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b33:	85 f6                	test   %esi,%esi
80103b35:	7f 19                	jg     80103b50 <growproc+0x40>
  } else if(n < 0){
80103b37:	75 37                	jne    80103b70 <growproc+0x60>
  switchuvm(curproc);
80103b39:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b3c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b3e:	53                   	push   %ebx
80103b3f:	e8 0c 31 00 00       	call   80106c50 <switchuvm>
  return 0;
80103b44:	83 c4 10             	add    $0x10,%esp
80103b47:	31 c0                	xor    %eax,%eax
}
80103b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b4c:	5b                   	pop    %ebx
80103b4d:	5e                   	pop    %esi
80103b4e:	5d                   	pop    %ebp
80103b4f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b50:	83 ec 04             	sub    $0x4,%esp
80103b53:	01 c6                	add    %eax,%esi
80103b55:	56                   	push   %esi
80103b56:	50                   	push   %eax
80103b57:	ff 73 04             	pushl  0x4(%ebx)
80103b5a:	e8 51 33 00 00       	call   80106eb0 <allocuvm>
80103b5f:	83 c4 10             	add    $0x10,%esp
80103b62:	85 c0                	test   %eax,%eax
80103b64:	75 d3                	jne    80103b39 <growproc+0x29>
      return -1;
80103b66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b6b:	eb dc                	jmp    80103b49 <growproc+0x39>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b70:	83 ec 04             	sub    $0x4,%esp
80103b73:	01 c6                	add    %eax,%esi
80103b75:	56                   	push   %esi
80103b76:	50                   	push   %eax
80103b77:	ff 73 04             	pushl  0x4(%ebx)
80103b7a:	e8 61 34 00 00       	call   80106fe0 <deallocuvm>
80103b7f:	83 c4 10             	add    $0x10,%esp
80103b82:	85 c0                	test   %eax,%eax
80103b84:	75 b3                	jne    80103b39 <growproc+0x29>
80103b86:	eb de                	jmp    80103b66 <growproc+0x56>
80103b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <fork>:
{
80103b90:	f3 0f 1e fb          	endbr32 
80103b94:	55                   	push   %ebp
80103b95:	89 e5                	mov    %esp,%ebp
80103b97:	57                   	push   %edi
80103b98:	56                   	push   %esi
80103b99:	53                   	push   %ebx
80103b9a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b9d:	e8 8e 09 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103ba2:	e8 a9 fd ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103ba7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bad:	e8 ce 09 00 00       	call   80104580 <popcli>
  if((np = allocproc()) == 0){
80103bb2:	e8 59 fc ff ff       	call   80103810 <allocproc>
80103bb7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bba:	85 c0                	test   %eax,%eax
80103bbc:	0f 84 bb 00 00 00    	je     80103c7d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bc2:	83 ec 08             	sub    $0x8,%esp
80103bc5:	ff 33                	pushl  (%ebx)
80103bc7:	89 c7                	mov    %eax,%edi
80103bc9:	ff 73 04             	pushl  0x4(%ebx)
80103bcc:	e8 8f 35 00 00       	call   80107160 <copyuvm>
80103bd1:	83 c4 10             	add    $0x10,%esp
80103bd4:	89 47 04             	mov    %eax,0x4(%edi)
80103bd7:	85 c0                	test   %eax,%eax
80103bd9:	0f 84 a5 00 00 00    	je     80103c84 <fork+0xf4>
  np->sz = curproc->sz;
80103bdf:	8b 03                	mov    (%ebx),%eax
80103be1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103be4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103be6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103be9:	89 c8                	mov    %ecx,%eax
80103beb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bee:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bf3:	8b 73 18             	mov    0x18(%ebx),%esi
80103bf6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bf8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bfa:	8b 40 18             	mov    0x18(%eax),%eax
80103bfd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103c08:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c0c:	85 c0                	test   %eax,%eax
80103c0e:	74 13                	je     80103c23 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	50                   	push   %eax
80103c14:	e8 57 d2 ff ff       	call   80100e70 <filedup>
80103c19:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c1c:	83 c4 10             	add    $0x10,%esp
80103c1f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c23:	83 c6 01             	add    $0x1,%esi
80103c26:	83 fe 10             	cmp    $0x10,%esi
80103c29:	75 dd                	jne    80103c08 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103c2b:	83 ec 0c             	sub    $0xc,%esp
80103c2e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c31:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c34:	e8 f7 da ff ff       	call   80101730 <idup>
80103c39:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c3c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c3f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c42:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c45:	6a 10                	push   $0x10
80103c47:	53                   	push   %ebx
80103c48:	50                   	push   %eax
80103c49:	e8 b2 0c 00 00       	call   80104900 <safestrcpy>
  pid = np->pid;
80103c4e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c51:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c58:	e8 d3 09 00 00       	call   80104630 <acquire>
  np->state = RUNNABLE;
80103c5d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c64:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c6b:	e8 80 0a 00 00       	call   801046f0 <release>
  return pid;
80103c70:	83 c4 10             	add    $0x10,%esp
}
80103c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c76:	89 d8                	mov    %ebx,%eax
80103c78:	5b                   	pop    %ebx
80103c79:	5e                   	pop    %esi
80103c7a:	5f                   	pop    %edi
80103c7b:	5d                   	pop    %ebp
80103c7c:	c3                   	ret    
    return -1;
80103c7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c82:	eb ef                	jmp    80103c73 <fork+0xe3>
    kfree(np->kstack);
80103c84:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c87:	83 ec 0c             	sub    $0xc,%esp
80103c8a:	ff 73 08             	pushl  0x8(%ebx)
80103c8d:	e8 de e7 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103c92:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c99:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c9c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ca3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ca8:	eb c9                	jmp    80103c73 <fork+0xe3>
80103caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103cb0 <scheduler>:
{
80103cb0:	f3 0f 1e fb          	endbr32 
80103cb4:	55                   	push   %ebp
80103cb5:	89 e5                	mov    %esp,%ebp
80103cb7:	57                   	push   %edi
80103cb8:	56                   	push   %esi
80103cb9:	53                   	push   %ebx
80103cba:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103cbd:	e8 8e fc ff ff       	call   80103950 <mycpu>
  c->proc = 0;
80103cc2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cc9:	00 00 00 
  struct cpu *c = mycpu();
80103ccc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103cce:	8d 78 04             	lea    0x4(%eax),%edi
80103cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103cd8:	fb                   	sti    
    acquire(&ptable.lock);
80103cd9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cdc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103ce1:	68 20 2d 11 80       	push   $0x80112d20
80103ce6:	e8 45 09 00 00       	call   80104630 <acquire>
80103ceb:	83 c4 10             	add    $0x10,%esp
80103cee:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103cf0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103cf4:	75 33                	jne    80103d29 <scheduler+0x79>
      switchuvm(p);
80103cf6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cf9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103cff:	53                   	push   %ebx
80103d00:	e8 4b 2f 00 00       	call   80106c50 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d05:	58                   	pop    %eax
80103d06:	5a                   	pop    %edx
80103d07:	ff 73 1c             	pushl  0x1c(%ebx)
80103d0a:	57                   	push   %edi
      p->state = RUNNING;
80103d0b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d12:	e8 4c 0c 00 00       	call   80104963 <swtch>
      switchkvm();
80103d17:	e8 14 2f 00 00       	call   80106c30 <switchkvm>
      c->proc = 0;
80103d1c:	83 c4 10             	add    $0x10,%esp
80103d1f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d26:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d29:	83 eb 80             	sub    $0xffffff80,%ebx
80103d2c:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103d32:	75 bc                	jne    80103cf0 <scheduler+0x40>
    release(&ptable.lock);
80103d34:	83 ec 0c             	sub    $0xc,%esp
80103d37:	68 20 2d 11 80       	push   $0x80112d20
80103d3c:	e8 af 09 00 00       	call   801046f0 <release>
    sti();
80103d41:	83 c4 10             	add    $0x10,%esp
80103d44:	eb 92                	jmp    80103cd8 <scheduler+0x28>
80103d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi

80103d50 <sched>:
{
80103d50:	f3 0f 1e fb          	endbr32 
80103d54:	55                   	push   %ebp
80103d55:	89 e5                	mov    %esp,%ebp
80103d57:	56                   	push   %esi
80103d58:	53                   	push   %ebx
  pushcli();
80103d59:	e8 d2 07 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103d5e:	e8 ed fb ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103d63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d69:	e8 12 08 00 00       	call   80104580 <popcli>
  if(!holding(&ptable.lock))
80103d6e:	83 ec 0c             	sub    $0xc,%esp
80103d71:	68 20 2d 11 80       	push   $0x80112d20
80103d76:	e8 65 08 00 00       	call   801045e0 <holding>
80103d7b:	83 c4 10             	add    $0x10,%esp
80103d7e:	85 c0                	test   %eax,%eax
80103d80:	74 4f                	je     80103dd1 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d82:	e8 c9 fb ff ff       	call   80103950 <mycpu>
80103d87:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d8e:	75 68                	jne    80103df8 <sched+0xa8>
  if(p->state == RUNNING)
80103d90:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d94:	74 55                	je     80103deb <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d96:	9c                   	pushf  
80103d97:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d98:	f6 c4 02             	test   $0x2,%ah
80103d9b:	75 41                	jne    80103dde <sched+0x8e>
  intena = mycpu()->intena;
80103d9d:	e8 ae fb ff ff       	call   80103950 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103da2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103da5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dab:	e8 a0 fb ff ff       	call   80103950 <mycpu>
80103db0:	83 ec 08             	sub    $0x8,%esp
80103db3:	ff 70 04             	pushl  0x4(%eax)
80103db6:	53                   	push   %ebx
80103db7:	e8 a7 0b 00 00       	call   80104963 <swtch>
  mycpu()->intena = intena;
80103dbc:	e8 8f fb ff ff       	call   80103950 <mycpu>
}
80103dc1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103dc4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103dca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dcd:	5b                   	pop    %ebx
80103dce:	5e                   	pop    %esi
80103dcf:	5d                   	pop    %ebp
80103dd0:	c3                   	ret    
    panic("sched ptable.lock");
80103dd1:	83 ec 0c             	sub    $0xc,%esp
80103dd4:	68 9b 78 10 80       	push   $0x8010789b
80103dd9:	e8 b2 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103dde:	83 ec 0c             	sub    $0xc,%esp
80103de1:	68 c7 78 10 80       	push   $0x801078c7
80103de6:	e8 a5 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103deb:	83 ec 0c             	sub    $0xc,%esp
80103dee:	68 b9 78 10 80       	push   $0x801078b9
80103df3:	e8 98 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103df8:	83 ec 0c             	sub    $0xc,%esp
80103dfb:	68 ad 78 10 80       	push   $0x801078ad
80103e00:	e8 8b c5 ff ff       	call   80100390 <panic>
80103e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e10 <exit>:
{
80103e10:	f3 0f 1e fb          	endbr32 
80103e14:	55                   	push   %ebp
80103e15:	89 e5                	mov    %esp,%ebp
80103e17:	57                   	push   %edi
80103e18:	56                   	push   %esi
80103e19:	53                   	push   %ebx
80103e1a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e1d:	e8 0e 07 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103e22:	e8 29 fb ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103e27:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e2d:	e8 4e 07 00 00       	call   80104580 <popcli>
  if(curproc == initproc)
80103e32:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e35:	8d 7e 68             	lea    0x68(%esi),%edi
80103e38:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103e3e:	0f 84 f3 00 00 00    	je     80103f37 <exit+0x127>
80103e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103e48:	8b 03                	mov    (%ebx),%eax
80103e4a:	85 c0                	test   %eax,%eax
80103e4c:	74 12                	je     80103e60 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103e4e:	83 ec 0c             	sub    $0xc,%esp
80103e51:	50                   	push   %eax
80103e52:	e8 69 d0 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103e57:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e5d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e60:	83 c3 04             	add    $0x4,%ebx
80103e63:	39 df                	cmp    %ebx,%edi
80103e65:	75 e1                	jne    80103e48 <exit+0x38>
  begin_op();
80103e67:	e8 44 ef ff ff       	call   80102db0 <begin_op>
  iput(curproc->cwd);
80103e6c:	83 ec 0c             	sub    $0xc,%esp
80103e6f:	ff 76 68             	pushl  0x68(%esi)
80103e72:	e8 19 da ff ff       	call   80101890 <iput>
  end_op();
80103e77:	e8 a4 ef ff ff       	call   80102e20 <end_op>
  curproc->cwd = 0;
80103e7c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e83:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e8a:	e8 a1 07 00 00       	call   80104630 <acquire>
  wakeup1(curproc->parent);
80103e8f:	8b 56 14             	mov    0x14(%esi),%edx
80103e92:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e95:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e9a:	eb 0e                	jmp    80103eaa <exit+0x9a>
80103e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea0:	83 e8 80             	sub    $0xffffff80,%eax
80103ea3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ea8:	74 1c                	je     80103ec6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103eaa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eae:	75 f0                	jne    80103ea0 <exit+0x90>
80103eb0:	3b 50 20             	cmp    0x20(%eax),%edx
80103eb3:	75 eb                	jne    80103ea0 <exit+0x90>
      p->state = RUNNABLE;
80103eb5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ebc:	83 e8 80             	sub    $0xffffff80,%eax
80103ebf:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ec4:	75 e4                	jne    80103eaa <exit+0x9a>
      p->parent = initproc;
80103ec6:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ecc:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ed1:	eb 10                	jmp    80103ee3 <exit+0xd3>
80103ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed7:	90                   	nop
80103ed8:	83 ea 80             	sub    $0xffffff80,%edx
80103edb:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103ee1:	74 3b                	je     80103f1e <exit+0x10e>
    if(p->parent == curproc){
80103ee3:	39 72 14             	cmp    %esi,0x14(%edx)
80103ee6:	75 f0                	jne    80103ed8 <exit+0xc8>
      if(p->state == ZOMBIE)
80103ee8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103eec:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eef:	75 e7                	jne    80103ed8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ef1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ef6:	eb 12                	jmp    80103f0a <exit+0xfa>
80103ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eff:	90                   	nop
80103f00:	83 e8 80             	sub    $0xffffff80,%eax
80103f03:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103f08:	74 ce                	je     80103ed8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103f0a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f0e:	75 f0                	jne    80103f00 <exit+0xf0>
80103f10:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f13:	75 eb                	jne    80103f00 <exit+0xf0>
      p->state = RUNNABLE;
80103f15:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f1c:	eb e2                	jmp    80103f00 <exit+0xf0>
  curproc->state = ZOMBIE;
80103f1e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103f25:	e8 26 fe ff ff       	call   80103d50 <sched>
  panic("zombie exit");
80103f2a:	83 ec 0c             	sub    $0xc,%esp
80103f2d:	68 e8 78 10 80       	push   $0x801078e8
80103f32:	e8 59 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f37:	83 ec 0c             	sub    $0xc,%esp
80103f3a:	68 db 78 10 80       	push   $0x801078db
80103f3f:	e8 4c c4 ff ff       	call   80100390 <panic>
80103f44:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f4f:	90                   	nop

80103f50 <yield>:
{
80103f50:	f3 0f 1e fb          	endbr32 
80103f54:	55                   	push   %ebp
80103f55:	89 e5                	mov    %esp,%ebp
80103f57:	53                   	push   %ebx
80103f58:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f5b:	68 20 2d 11 80       	push   $0x80112d20
80103f60:	e8 cb 06 00 00       	call   80104630 <acquire>
  pushcli();
80103f65:	e8 c6 05 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103f6a:	e8 e1 f9 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103f6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f75:	e8 06 06 00 00       	call   80104580 <popcli>
  myproc()->state = RUNNABLE;
80103f7a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f81:	e8 ca fd ff ff       	call   80103d50 <sched>
  release(&ptable.lock);
80103f86:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f8d:	e8 5e 07 00 00       	call   801046f0 <release>
}
80103f92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f95:	83 c4 10             	add    $0x10,%esp
80103f98:	c9                   	leave  
80103f99:	c3                   	ret    
80103f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103fa0 <sleep>:
{
80103fa0:	f3 0f 1e fb          	endbr32 
80103fa4:	55                   	push   %ebp
80103fa5:	89 e5                	mov    %esp,%ebp
80103fa7:	57                   	push   %edi
80103fa8:	56                   	push   %esi
80103fa9:	53                   	push   %ebx
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	8b 7d 08             	mov    0x8(%ebp),%edi
80103fb0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103fb3:	e8 78 05 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103fb8:	e8 93 f9 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103fbd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fc3:	e8 b8 05 00 00       	call   80104580 <popcli>
  if(p == 0)
80103fc8:	85 db                	test   %ebx,%ebx
80103fca:	0f 84 83 00 00 00    	je     80104053 <sleep+0xb3>
  if(lk == 0)
80103fd0:	85 f6                	test   %esi,%esi
80103fd2:	74 72                	je     80104046 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fd4:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103fda:	74 4c                	je     80104028 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fdc:	83 ec 0c             	sub    $0xc,%esp
80103fdf:	68 20 2d 11 80       	push   $0x80112d20
80103fe4:	e8 47 06 00 00       	call   80104630 <acquire>
    release(lk);
80103fe9:	89 34 24             	mov    %esi,(%esp)
80103fec:	e8 ff 06 00 00       	call   801046f0 <release>
  p->chan = chan;
80103ff1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ff4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ffb:	e8 50 fd ff ff       	call   80103d50 <sched>
  p->chan = 0;
80104000:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104007:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010400e:	e8 dd 06 00 00       	call   801046f0 <release>
    acquire(lk);
80104013:	89 75 08             	mov    %esi,0x8(%ebp)
80104016:	83 c4 10             	add    $0x10,%esp
}
80104019:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010401c:	5b                   	pop    %ebx
8010401d:	5e                   	pop    %esi
8010401e:	5f                   	pop    %edi
8010401f:	5d                   	pop    %ebp
    acquire(lk);
80104020:	e9 0b 06 00 00       	jmp    80104630 <acquire>
80104025:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104028:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010402b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104032:	e8 19 fd ff ff       	call   80103d50 <sched>
  p->chan = 0;
80104037:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010403e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104041:	5b                   	pop    %ebx
80104042:	5e                   	pop    %esi
80104043:	5f                   	pop    %edi
80104044:	5d                   	pop    %ebp
80104045:	c3                   	ret    
    panic("sleep without lk");
80104046:	83 ec 0c             	sub    $0xc,%esp
80104049:	68 fa 78 10 80       	push   $0x801078fa
8010404e:	e8 3d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80104053:	83 ec 0c             	sub    $0xc,%esp
80104056:	68 f4 78 10 80       	push   $0x801078f4
8010405b:	e8 30 c3 ff ff       	call   80100390 <panic>

80104060 <wait>:
{
80104060:	f3 0f 1e fb          	endbr32 
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	56                   	push   %esi
80104068:	53                   	push   %ebx
  pushcli();
80104069:	e8 c2 04 00 00       	call   80104530 <pushcli>
  c = mycpu();
8010406e:	e8 dd f8 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80104073:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104079:	e8 02 05 00 00       	call   80104580 <popcli>
  acquire(&ptable.lock);
8010407e:	83 ec 0c             	sub    $0xc,%esp
80104081:	68 20 2d 11 80       	push   $0x80112d20
80104086:	e8 a5 05 00 00       	call   80104630 <acquire>
8010408b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010408e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104090:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104095:	eb 14                	jmp    801040ab <wait+0x4b>
80104097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409e:	66 90                	xchg   %ax,%ax
801040a0:	83 eb 80             	sub    $0xffffff80,%ebx
801040a3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801040a9:	74 1b                	je     801040c6 <wait+0x66>
      if(p->parent != curproc)
801040ab:	39 73 14             	cmp    %esi,0x14(%ebx)
801040ae:	75 f0                	jne    801040a0 <wait+0x40>
      if(p->state == ZOMBIE){
801040b0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801040b4:	74 32                	je     801040e8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b6:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
801040b9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040be:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801040c4:	75 e5                	jne    801040ab <wait+0x4b>
    if(!havekids || curproc->killed){
801040c6:	85 c0                	test   %eax,%eax
801040c8:	74 74                	je     8010413e <wait+0xde>
801040ca:	8b 46 24             	mov    0x24(%esi),%eax
801040cd:	85 c0                	test   %eax,%eax
801040cf:	75 6d                	jne    8010413e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040d1:	83 ec 08             	sub    $0x8,%esp
801040d4:	68 20 2d 11 80       	push   $0x80112d20
801040d9:	56                   	push   %esi
801040da:	e8 c1 fe ff ff       	call   80103fa0 <sleep>
    havekids = 0;
801040df:	83 c4 10             	add    $0x10,%esp
801040e2:	eb aa                	jmp    8010408e <wait+0x2e>
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040ee:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040f1:	e8 7a e3 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
801040f6:	5a                   	pop    %edx
801040f7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040fa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104101:	e8 0a 2f 00 00       	call   80107010 <freevm>
        release(&ptable.lock);
80104106:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010410d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104114:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010411b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010411f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104126:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010412d:	e8 be 05 00 00       	call   801046f0 <release>
        return pid;
80104132:	83 c4 10             	add    $0x10,%esp
}
80104135:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104138:	89 f0                	mov    %esi,%eax
8010413a:	5b                   	pop    %ebx
8010413b:	5e                   	pop    %esi
8010413c:	5d                   	pop    %ebp
8010413d:	c3                   	ret    
      release(&ptable.lock);
8010413e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104141:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104146:	68 20 2d 11 80       	push   $0x80112d20
8010414b:	e8 a0 05 00 00       	call   801046f0 <release>
      return -1;
80104150:	83 c4 10             	add    $0x10,%esp
80104153:	eb e0                	jmp    80104135 <wait+0xd5>
80104155:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104160:	f3 0f 1e fb          	endbr32 
80104164:	55                   	push   %ebp
80104165:	89 e5                	mov    %esp,%ebp
80104167:	53                   	push   %ebx
80104168:	83 ec 10             	sub    $0x10,%esp
8010416b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010416e:	68 20 2d 11 80       	push   $0x80112d20
80104173:	e8 b8 04 00 00       	call   80104630 <acquire>
80104178:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010417b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104180:	eb 10                	jmp    80104192 <wakeup+0x32>
80104182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104188:	83 e8 80             	sub    $0xffffff80,%eax
8010418b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104190:	74 1c                	je     801041ae <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104192:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104196:	75 f0                	jne    80104188 <wakeup+0x28>
80104198:	3b 58 20             	cmp    0x20(%eax),%ebx
8010419b:	75 eb                	jne    80104188 <wakeup+0x28>
      p->state = RUNNABLE;
8010419d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041a4:	83 e8 80             	sub    $0xffffff80,%eax
801041a7:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801041ac:	75 e4                	jne    80104192 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801041ae:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801041b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b8:	c9                   	leave  
  release(&ptable.lock);
801041b9:	e9 32 05 00 00       	jmp    801046f0 <release>
801041be:	66 90                	xchg   %ax,%ax

801041c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041c0:	f3 0f 1e fb          	endbr32 
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	53                   	push   %ebx
801041c8:	83 ec 10             	sub    $0x10,%esp
801041cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041ce:	68 20 2d 11 80       	push   $0x80112d20
801041d3:	e8 58 04 00 00       	call   80104630 <acquire>
801041d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041db:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041e0:	eb 10                	jmp    801041f2 <kill+0x32>
801041e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041e8:	83 e8 80             	sub    $0xffffff80,%eax
801041eb:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801041f0:	74 36                	je     80104228 <kill+0x68>
    if(p->pid == pid){
801041f2:	39 58 10             	cmp    %ebx,0x10(%eax)
801041f5:	75 f1                	jne    801041e8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041f7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041fb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104202:	75 07                	jne    8010420b <kill+0x4b>
        p->state = RUNNABLE;
80104204:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010420b:	83 ec 0c             	sub    $0xc,%esp
8010420e:	68 20 2d 11 80       	push   $0x80112d20
80104213:	e8 d8 04 00 00       	call   801046f0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010421b:	83 c4 10             	add    $0x10,%esp
8010421e:	31 c0                	xor    %eax,%eax
}
80104220:	c9                   	leave  
80104221:	c3                   	ret    
80104222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	68 20 2d 11 80       	push   $0x80112d20
80104230:	e8 bb 04 00 00       	call   801046f0 <release>
}
80104235:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104238:	83 c4 10             	add    $0x10,%esp
8010423b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104240:	c9                   	leave  
80104241:	c3                   	ret    
80104242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	57                   	push   %edi
80104258:	56                   	push   %esi
80104259:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010425c:	53                   	push   %ebx
8010425d:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104262:	83 ec 3c             	sub    $0x3c,%esp
80104265:	eb 28                	jmp    8010428f <procdump+0x3f>
80104267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010426e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	68 af 7c 10 80       	push   $0x80107caf
80104278:	e8 33 c4 ff ff       	call   801006b0 <cprintf>
8010427d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104280:	83 eb 80             	sub    $0xffffff80,%ebx
80104283:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80104289:	0f 84 81 00 00 00    	je     80104310 <procdump+0xc0>
    if(p->state == UNUSED)
8010428f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104292:	85 c0                	test   %eax,%eax
80104294:	74 ea                	je     80104280 <procdump+0x30>
      state = "???";
80104296:	ba 0b 79 10 80       	mov    $0x8010790b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010429b:	83 f8 05             	cmp    $0x5,%eax
8010429e:	77 11                	ja     801042b1 <procdump+0x61>
801042a0:	8b 14 85 6c 79 10 80 	mov    -0x7fef8694(,%eax,4),%edx
      state = "???";
801042a7:	b8 0b 79 10 80       	mov    $0x8010790b,%eax
801042ac:	85 d2                	test   %edx,%edx
801042ae:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042b1:	53                   	push   %ebx
801042b2:	52                   	push   %edx
801042b3:	ff 73 a4             	pushl  -0x5c(%ebx)
801042b6:	68 0f 79 10 80       	push   $0x8010790f
801042bb:	e8 f0 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801042c0:	83 c4 10             	add    $0x10,%esp
801042c3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801042c7:	75 a7                	jne    80104270 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042c9:	83 ec 08             	sub    $0x8,%esp
801042cc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042cf:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042d2:	50                   	push   %eax
801042d3:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042d6:	8b 40 0c             	mov    0xc(%eax),%eax
801042d9:	83 c0 08             	add    $0x8,%eax
801042dc:	50                   	push   %eax
801042dd:	e8 ee 01 00 00       	call   801044d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042e2:	83 c4 10             	add    $0x10,%esp
801042e5:	8d 76 00             	lea    0x0(%esi),%esi
801042e8:	8b 17                	mov    (%edi),%edx
801042ea:	85 d2                	test   %edx,%edx
801042ec:	74 82                	je     80104270 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042ee:	83 ec 08             	sub    $0x8,%esp
801042f1:	83 c7 04             	add    $0x4,%edi
801042f4:	52                   	push   %edx
801042f5:	68 61 73 10 80       	push   $0x80107361
801042fa:	e8 b1 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042ff:	83 c4 10             	add    $0x10,%esp
80104302:	39 fe                	cmp    %edi,%esi
80104304:	75 e2                	jne    801042e8 <procdump+0x98>
80104306:	e9 65 ff ff ff       	jmp    80104270 <procdump+0x20>
8010430b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010430f:	90                   	nop
  }
}
80104310:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104313:	5b                   	pop    %ebx
80104314:	5e                   	pop    %esi
80104315:	5f                   	pop    %edi
80104316:	5d                   	pop    %ebp
80104317:	c3                   	ret    
80104318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010431f:	90                   	nop

80104320 <kgetnumproc>:

unsigned int
kgetnumproc(void) {
80104320:	f3 0f 1e fb          	endbr32 
80104324:	55                   	push   %ebp
80104325:	89 e5                	mov    %esp,%ebp
80104327:	53                   	push   %ebx
    struct proc *p;
    unsigned int count = 0;
80104328:	31 db                	xor    %ebx,%ebx
kgetnumproc(void) {
8010432a:	83 ec 10             	sub    $0x10,%esp

    acquire(&ptable.lock);
8010432d:	68 20 2d 11 80       	push   $0x80112d20
80104332:	e8 f9 02 00 00       	call   80104630 <acquire>
80104337:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010433a:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010433f:	90                   	nop
        if(p->state != UNUSED)
            count++;
80104340:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
80104344:	83 db ff             	sbb    $0xffffffff,%ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104347:	83 e8 80             	sub    $0xffffff80,%eax
8010434a:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
8010434f:	75 ef                	jne    80104340 <kgetnumproc+0x20>
    }
    release(&ptable.lock);
80104351:	83 ec 0c             	sub    $0xc,%esp
80104354:	68 20 2d 11 80       	push   $0x80112d20
80104359:	e8 92 03 00 00       	call   801046f0 <release>

    return count;
8010435e:	89 d8                	mov    %ebx,%eax
80104360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104363:	c9                   	leave  
80104364:	c3                   	ret    
80104365:	66 90                	xchg   %ax,%ax
80104367:	66 90                	xchg   %ax,%ax
80104369:	66 90                	xchg   %ax,%ax
8010436b:	66 90                	xchg   %ax,%ax
8010436d:	66 90                	xchg   %ax,%ax
8010436f:	90                   	nop

80104370 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	53                   	push   %ebx
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010437e:	68 84 79 10 80       	push   $0x80107984
80104383:	8d 43 04             	lea    0x4(%ebx),%eax
80104386:	50                   	push   %eax
80104387:	e8 24 01 00 00       	call   801044b0 <initlock>
  lk->name = name;
8010438c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010438f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104395:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104398:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010439f:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a5:	c9                   	leave  
801043a6:	c3                   	ret    
801043a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ae:	66 90                	xchg   %ax,%ax

801043b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043b0:	f3 0f 1e fb          	endbr32 
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	56                   	push   %esi
801043b8:	53                   	push   %ebx
801043b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043bc:	8d 73 04             	lea    0x4(%ebx),%esi
801043bf:	83 ec 0c             	sub    $0xc,%esp
801043c2:	56                   	push   %esi
801043c3:	e8 68 02 00 00       	call   80104630 <acquire>
  while (lk->locked) {
801043c8:	8b 13                	mov    (%ebx),%edx
801043ca:	83 c4 10             	add    $0x10,%esp
801043cd:	85 d2                	test   %edx,%edx
801043cf:	74 1a                	je     801043eb <acquiresleep+0x3b>
801043d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801043d8:	83 ec 08             	sub    $0x8,%esp
801043db:	56                   	push   %esi
801043dc:	53                   	push   %ebx
801043dd:	e8 be fb ff ff       	call   80103fa0 <sleep>
  while (lk->locked) {
801043e2:	8b 03                	mov    (%ebx),%eax
801043e4:	83 c4 10             	add    $0x10,%esp
801043e7:	85 c0                	test   %eax,%eax
801043e9:	75 ed                	jne    801043d8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801043eb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043f1:	e8 ea f5 ff ff       	call   801039e0 <myproc>
801043f6:	8b 40 10             	mov    0x10(%eax),%eax
801043f9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043fc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104402:	5b                   	pop    %ebx
80104403:	5e                   	pop    %esi
80104404:	5d                   	pop    %ebp
  release(&lk->lk);
80104405:	e9 e6 02 00 00       	jmp    801046f0 <release>
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	56                   	push   %esi
80104418:	53                   	push   %ebx
80104419:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010441c:	8d 73 04             	lea    0x4(%ebx),%esi
8010441f:	83 ec 0c             	sub    $0xc,%esp
80104422:	56                   	push   %esi
80104423:	e8 08 02 00 00       	call   80104630 <acquire>
  lk->locked = 0;
80104428:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010442e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104435:	89 1c 24             	mov    %ebx,(%esp)
80104438:	e8 23 fd ff ff       	call   80104160 <wakeup>
  release(&lk->lk);
8010443d:	89 75 08             	mov    %esi,0x8(%ebp)
80104440:	83 c4 10             	add    $0x10,%esp
}
80104443:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104446:	5b                   	pop    %ebx
80104447:	5e                   	pop    %esi
80104448:	5d                   	pop    %ebp
  release(&lk->lk);
80104449:	e9 a2 02 00 00       	jmp    801046f0 <release>
8010444e:	66 90                	xchg   %ax,%ax

80104450 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104450:	f3 0f 1e fb          	endbr32 
80104454:	55                   	push   %ebp
80104455:	89 e5                	mov    %esp,%ebp
80104457:	57                   	push   %edi
80104458:	31 ff                	xor    %edi,%edi
8010445a:	56                   	push   %esi
8010445b:	53                   	push   %ebx
8010445c:	83 ec 18             	sub    $0x18,%esp
8010445f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104462:	8d 73 04             	lea    0x4(%ebx),%esi
80104465:	56                   	push   %esi
80104466:	e8 c5 01 00 00       	call   80104630 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010446b:	8b 03                	mov    (%ebx),%eax
8010446d:	83 c4 10             	add    $0x10,%esp
80104470:	85 c0                	test   %eax,%eax
80104472:	75 1c                	jne    80104490 <holdingsleep+0x40>
  release(&lk->lk);
80104474:	83 ec 0c             	sub    $0xc,%esp
80104477:	56                   	push   %esi
80104478:	e8 73 02 00 00       	call   801046f0 <release>
  return r;
}
8010447d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104480:	89 f8                	mov    %edi,%eax
80104482:	5b                   	pop    %ebx
80104483:	5e                   	pop    %esi
80104484:	5f                   	pop    %edi
80104485:	5d                   	pop    %ebp
80104486:	c3                   	ret    
80104487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010448e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104490:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104493:	e8 48 f5 ff ff       	call   801039e0 <myproc>
80104498:	39 58 10             	cmp    %ebx,0x10(%eax)
8010449b:	0f 94 c0             	sete   %al
8010449e:	0f b6 c0             	movzbl %al,%eax
801044a1:	89 c7                	mov    %eax,%edi
801044a3:	eb cf                	jmp    80104474 <holdingsleep+0x24>
801044a5:	66 90                	xchg   %ax,%ax
801044a7:	66 90                	xchg   %ax,%ax
801044a9:	66 90                	xchg   %ax,%ax
801044ab:	66 90                	xchg   %ax,%ax
801044ad:	66 90                	xchg   %ax,%ax
801044af:	90                   	nop

801044b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044b0:	f3 0f 1e fb          	endbr32 
801044b4:	55                   	push   %ebp
801044b5:	89 e5                	mov    %esp,%ebp
801044b7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044c3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044c6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044cd:	5d                   	pop    %ebp
801044ce:	c3                   	ret    
801044cf:	90                   	nop

801044d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044d5:	31 d2                	xor    %edx,%edx
{
801044d7:	89 e5                	mov    %esp,%ebp
801044d9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801044da:	8b 45 08             	mov    0x8(%ebp),%eax
{
801044dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801044e0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044f4:	77 1a                	ja     80104510 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044f6:	8b 58 04             	mov    0x4(%eax),%ebx
801044f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044fc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104501:	83 fa 0a             	cmp    $0xa,%edx
80104504:	75 e2                	jne    801044e8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104506:	5b                   	pop    %ebx
80104507:	5d                   	pop    %ebp
80104508:	c3                   	ret    
80104509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104510:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104513:	8d 51 28             	lea    0x28(%ecx),%edx
80104516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104520:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104526:	83 c0 04             	add    $0x4,%eax
80104529:	39 d0                	cmp    %edx,%eax
8010452b:	75 f3                	jne    80104520 <getcallerpcs+0x50>
}
8010452d:	5b                   	pop    %ebx
8010452e:	5d                   	pop    %ebp
8010452f:	c3                   	ret    

80104530 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	53                   	push   %ebx
80104538:	83 ec 04             	sub    $0x4,%esp
8010453b:	9c                   	pushf  
8010453c:	5b                   	pop    %ebx
  asm volatile("cli");
8010453d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010453e:	e8 0d f4 ff ff       	call   80103950 <mycpu>
80104543:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104549:	85 c0                	test   %eax,%eax
8010454b:	74 13                	je     80104560 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010454d:	e8 fe f3 ff ff       	call   80103950 <mycpu>
80104552:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104559:	83 c4 04             	add    $0x4,%esp
8010455c:	5b                   	pop    %ebx
8010455d:	5d                   	pop    %ebp
8010455e:	c3                   	ret    
8010455f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104560:	e8 eb f3 ff ff       	call   80103950 <mycpu>
80104565:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010456b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104571:	eb da                	jmp    8010454d <pushcli+0x1d>
80104573:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104580 <popcli>:

void
popcli(void)
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010458a:	9c                   	pushf  
8010458b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010458c:	f6 c4 02             	test   $0x2,%ah
8010458f:	75 31                	jne    801045c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104591:	e8 ba f3 ff ff       	call   80103950 <mycpu>
80104596:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010459d:	78 30                	js     801045cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010459f:	e8 ac f3 ff ff       	call   80103950 <mycpu>
801045a4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045aa:	85 d2                	test   %edx,%edx
801045ac:	74 02                	je     801045b0 <popcli+0x30>
    sti();
}
801045ae:	c9                   	leave  
801045af:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045b0:	e8 9b f3 ff ff       	call   80103950 <mycpu>
801045b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045bb:	85 c0                	test   %eax,%eax
801045bd:	74 ef                	je     801045ae <popcli+0x2e>
  asm volatile("sti");
801045bf:	fb                   	sti    
}
801045c0:	c9                   	leave  
801045c1:	c3                   	ret    
    panic("popcli - interruptible");
801045c2:	83 ec 0c             	sub    $0xc,%esp
801045c5:	68 8f 79 10 80       	push   $0x8010798f
801045ca:	e8 c1 bd ff ff       	call   80100390 <panic>
    panic("popcli");
801045cf:	83 ec 0c             	sub    $0xc,%esp
801045d2:	68 a6 79 10 80       	push   $0x801079a6
801045d7:	e8 b4 bd ff ff       	call   80100390 <panic>
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <holding>:
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
801045e5:	89 e5                	mov    %esp,%ebp
801045e7:	56                   	push   %esi
801045e8:	53                   	push   %ebx
801045e9:	8b 75 08             	mov    0x8(%ebp),%esi
801045ec:	31 db                	xor    %ebx,%ebx
  pushcli();
801045ee:	e8 3d ff ff ff       	call   80104530 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045f3:	8b 06                	mov    (%esi),%eax
801045f5:	85 c0                	test   %eax,%eax
801045f7:	75 0f                	jne    80104608 <holding+0x28>
  popcli();
801045f9:	e8 82 ff ff ff       	call   80104580 <popcli>
}
801045fe:	89 d8                	mov    %ebx,%eax
80104600:	5b                   	pop    %ebx
80104601:	5e                   	pop    %esi
80104602:	5d                   	pop    %ebp
80104603:	c3                   	ret    
80104604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104608:	8b 5e 08             	mov    0x8(%esi),%ebx
8010460b:	e8 40 f3 ff ff       	call   80103950 <mycpu>
80104610:	39 c3                	cmp    %eax,%ebx
80104612:	0f 94 c3             	sete   %bl
  popcli();
80104615:	e8 66 ff ff ff       	call   80104580 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010461a:	0f b6 db             	movzbl %bl,%ebx
}
8010461d:	89 d8                	mov    %ebx,%eax
8010461f:	5b                   	pop    %ebx
80104620:	5e                   	pop    %esi
80104621:	5d                   	pop    %ebp
80104622:	c3                   	ret    
80104623:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <acquire>:
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	56                   	push   %esi
80104638:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104639:	e8 f2 fe ff ff       	call   80104530 <pushcli>
  if(holding(lk))
8010463e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104641:	83 ec 0c             	sub    $0xc,%esp
80104644:	53                   	push   %ebx
80104645:	e8 96 ff ff ff       	call   801045e0 <holding>
8010464a:	83 c4 10             	add    $0x10,%esp
8010464d:	85 c0                	test   %eax,%eax
8010464f:	0f 85 7f 00 00 00    	jne    801046d4 <acquire+0xa4>
80104655:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104657:	ba 01 00 00 00       	mov    $0x1,%edx
8010465c:	eb 05                	jmp    80104663 <acquire+0x33>
8010465e:	66 90                	xchg   %ax,%ax
80104660:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104663:	89 d0                	mov    %edx,%eax
80104665:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104668:	85 c0                	test   %eax,%eax
8010466a:	75 f4                	jne    80104660 <acquire+0x30>
  __sync_synchronize();
8010466c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104671:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104674:	e8 d7 f2 ff ff       	call   80103950 <mycpu>
80104679:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010467c:	89 e8                	mov    %ebp,%eax
8010467e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104680:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104686:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010468c:	77 22                	ja     801046b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010468e:	8b 50 04             	mov    0x4(%eax),%edx
80104691:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104695:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104698:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010469a:	83 fe 0a             	cmp    $0xa,%esi
8010469d:	75 e1                	jne    80104680 <acquire+0x50>
}
8010469f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046a2:	5b                   	pop    %ebx
801046a3:	5e                   	pop    %esi
801046a4:	5d                   	pop    %ebp
801046a5:	c3                   	ret    
801046a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801046b0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801046b4:	83 c3 34             	add    $0x34,%ebx
801046b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046c6:	83 c0 04             	add    $0x4,%eax
801046c9:	39 d8                	cmp    %ebx,%eax
801046cb:	75 f3                	jne    801046c0 <acquire+0x90>
}
801046cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d0:	5b                   	pop    %ebx
801046d1:	5e                   	pop    %esi
801046d2:	5d                   	pop    %ebp
801046d3:	c3                   	ret    
    panic("acquire");
801046d4:	83 ec 0c             	sub    $0xc,%esp
801046d7:	68 ad 79 10 80       	push   $0x801079ad
801046dc:	e8 af bc ff ff       	call   80100390 <panic>
801046e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046ef:	90                   	nop

801046f0 <release>:
{
801046f0:	f3 0f 1e fb          	endbr32 
801046f4:	55                   	push   %ebp
801046f5:	89 e5                	mov    %esp,%ebp
801046f7:	53                   	push   %ebx
801046f8:	83 ec 10             	sub    $0x10,%esp
801046fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801046fe:	53                   	push   %ebx
801046ff:	e8 dc fe ff ff       	call   801045e0 <holding>
80104704:	83 c4 10             	add    $0x10,%esp
80104707:	85 c0                	test   %eax,%eax
80104709:	74 22                	je     8010472d <release+0x3d>
  lk->pcs[0] = 0;
8010470b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104712:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104719:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010471e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104724:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104727:	c9                   	leave  
  popcli();
80104728:	e9 53 fe ff ff       	jmp    80104580 <popcli>
    panic("release");
8010472d:	83 ec 0c             	sub    $0xc,%esp
80104730:	68 b5 79 10 80       	push   $0x801079b5
80104735:	e8 56 bc ff ff       	call   80100390 <panic>
8010473a:	66 90                	xchg   %ax,%ax
8010473c:	66 90                	xchg   %ax,%ax
8010473e:	66 90                	xchg   %ax,%ax

80104740 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104740:	f3 0f 1e fb          	endbr32 
80104744:	55                   	push   %ebp
80104745:	89 e5                	mov    %esp,%ebp
80104747:	57                   	push   %edi
80104748:	8b 55 08             	mov    0x8(%ebp),%edx
8010474b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010474e:	53                   	push   %ebx
8010474f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104752:	89 d7                	mov    %edx,%edi
80104754:	09 cf                	or     %ecx,%edi
80104756:	83 e7 03             	and    $0x3,%edi
80104759:	75 25                	jne    80104780 <memset+0x40>
    c &= 0xFF;
8010475b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010475e:	c1 e0 18             	shl    $0x18,%eax
80104761:	89 fb                	mov    %edi,%ebx
80104763:	c1 e9 02             	shr    $0x2,%ecx
80104766:	c1 e3 10             	shl    $0x10,%ebx
80104769:	09 d8                	or     %ebx,%eax
8010476b:	09 f8                	or     %edi,%eax
8010476d:	c1 e7 08             	shl    $0x8,%edi
80104770:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104772:	89 d7                	mov    %edx,%edi
80104774:	fc                   	cld    
80104775:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104777:	5b                   	pop    %ebx
80104778:	89 d0                	mov    %edx,%eax
8010477a:	5f                   	pop    %edi
8010477b:	5d                   	pop    %ebp
8010477c:	c3                   	ret    
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104780:	89 d7                	mov    %edx,%edi
80104782:	fc                   	cld    
80104783:	f3 aa                	rep stos %al,%es:(%edi)
80104785:	5b                   	pop    %ebx
80104786:	89 d0                	mov    %edx,%eax
80104788:	5f                   	pop    %edi
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    
8010478b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010478f:	90                   	nop

80104790 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	56                   	push   %esi
80104798:	8b 75 10             	mov    0x10(%ebp),%esi
8010479b:	8b 55 08             	mov    0x8(%ebp),%edx
8010479e:	53                   	push   %ebx
8010479f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047a2:	85 f6                	test   %esi,%esi
801047a4:	74 2a                	je     801047d0 <memcmp+0x40>
801047a6:	01 c6                	add    %eax,%esi
801047a8:	eb 10                	jmp    801047ba <memcmp+0x2a>
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801047b0:	83 c0 01             	add    $0x1,%eax
801047b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801047b6:	39 f0                	cmp    %esi,%eax
801047b8:	74 16                	je     801047d0 <memcmp+0x40>
    if(*s1 != *s2)
801047ba:	0f b6 0a             	movzbl (%edx),%ecx
801047bd:	0f b6 18             	movzbl (%eax),%ebx
801047c0:	38 d9                	cmp    %bl,%cl
801047c2:	74 ec                	je     801047b0 <memcmp+0x20>
      return *s1 - *s2;
801047c4:	0f b6 c1             	movzbl %cl,%eax
801047c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801047c9:	5b                   	pop    %ebx
801047ca:	5e                   	pop    %esi
801047cb:	5d                   	pop    %ebp
801047cc:	c3                   	ret    
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
801047d0:	5b                   	pop    %ebx
  return 0;
801047d1:	31 c0                	xor    %eax,%eax
}
801047d3:	5e                   	pop    %esi
801047d4:	5d                   	pop    %ebp
801047d5:	c3                   	ret    
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi

801047e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	57                   	push   %edi
801047e8:	8b 55 08             	mov    0x8(%ebp),%edx
801047eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047ee:	56                   	push   %esi
801047ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047f2:	39 d6                	cmp    %edx,%esi
801047f4:	73 2a                	jae    80104820 <memmove+0x40>
801047f6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801047f9:	39 fa                	cmp    %edi,%edx
801047fb:	73 23                	jae    80104820 <memmove+0x40>
801047fd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104800:	85 c9                	test   %ecx,%ecx
80104802:	74 13                	je     80104817 <memmove+0x37>
80104804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104808:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010480c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010480f:	83 e8 01             	sub    $0x1,%eax
80104812:	83 f8 ff             	cmp    $0xffffffff,%eax
80104815:	75 f1                	jne    80104808 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104817:	5e                   	pop    %esi
80104818:	89 d0                	mov    %edx,%eax
8010481a:	5f                   	pop    %edi
8010481b:	5d                   	pop    %ebp
8010481c:	c3                   	ret    
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104820:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104823:	89 d7                	mov    %edx,%edi
80104825:	85 c9                	test   %ecx,%ecx
80104827:	74 ee                	je     80104817 <memmove+0x37>
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104830:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104831:	39 f0                	cmp    %esi,%eax
80104833:	75 fb                	jne    80104830 <memmove+0x50>
}
80104835:	5e                   	pop    %esi
80104836:	89 d0                	mov    %edx,%eax
80104838:	5f                   	pop    %edi
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    
8010483b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010483f:	90                   	nop

80104840 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104840:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104844:	eb 9a                	jmp    801047e0 <memmove>
80104846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

80104850 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	56                   	push   %esi
80104858:	8b 75 10             	mov    0x10(%ebp),%esi
8010485b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010485e:	53                   	push   %ebx
8010485f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104862:	85 f6                	test   %esi,%esi
80104864:	74 32                	je     80104898 <strncmp+0x48>
80104866:	01 c6                	add    %eax,%esi
80104868:	eb 14                	jmp    8010487e <strncmp+0x2e>
8010486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104870:	38 da                	cmp    %bl,%dl
80104872:	75 14                	jne    80104888 <strncmp+0x38>
    n--, p++, q++;
80104874:	83 c0 01             	add    $0x1,%eax
80104877:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010487a:	39 f0                	cmp    %esi,%eax
8010487c:	74 1a                	je     80104898 <strncmp+0x48>
8010487e:	0f b6 11             	movzbl (%ecx),%edx
80104881:	0f b6 18             	movzbl (%eax),%ebx
80104884:	84 d2                	test   %dl,%dl
80104886:	75 e8                	jne    80104870 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104888:	0f b6 c2             	movzbl %dl,%eax
8010488b:	29 d8                	sub    %ebx,%eax
}
8010488d:	5b                   	pop    %ebx
8010488e:	5e                   	pop    %esi
8010488f:	5d                   	pop    %ebp
80104890:	c3                   	ret    
80104891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104898:	5b                   	pop    %ebx
    return 0;
80104899:	31 c0                	xor    %eax,%eax
}
8010489b:	5e                   	pop    %esi
8010489c:	5d                   	pop    %ebp
8010489d:	c3                   	ret    
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	57                   	push   %edi
801048a8:	56                   	push   %esi
801048a9:	8b 75 08             	mov    0x8(%ebp),%esi
801048ac:	53                   	push   %ebx
801048ad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048b0:	89 f2                	mov    %esi,%edx
801048b2:	eb 1b                	jmp    801048cf <strncpy+0x2f>
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801048bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801048bf:	83 c2 01             	add    $0x1,%edx
801048c2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801048c6:	89 f9                	mov    %edi,%ecx
801048c8:	88 4a ff             	mov    %cl,-0x1(%edx)
801048cb:	84 c9                	test   %cl,%cl
801048cd:	74 09                	je     801048d8 <strncpy+0x38>
801048cf:	89 c3                	mov    %eax,%ebx
801048d1:	83 e8 01             	sub    $0x1,%eax
801048d4:	85 db                	test   %ebx,%ebx
801048d6:	7f e0                	jg     801048b8 <strncpy+0x18>
    ;
  while(n-- > 0)
801048d8:	89 d1                	mov    %edx,%ecx
801048da:	85 c0                	test   %eax,%eax
801048dc:	7e 15                	jle    801048f3 <strncpy+0x53>
801048de:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801048e0:	83 c1 01             	add    $0x1,%ecx
801048e3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801048e7:	89 c8                	mov    %ecx,%eax
801048e9:	f7 d0                	not    %eax
801048eb:	01 d0                	add    %edx,%eax
801048ed:	01 d8                	add    %ebx,%eax
801048ef:	85 c0                	test   %eax,%eax
801048f1:	7f ed                	jg     801048e0 <strncpy+0x40>
  return os;
}
801048f3:	5b                   	pop    %ebx
801048f4:	89 f0                	mov    %esi,%eax
801048f6:	5e                   	pop    %esi
801048f7:	5f                   	pop    %edi
801048f8:	5d                   	pop    %ebp
801048f9:	c3                   	ret    
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104900 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	56                   	push   %esi
80104908:	8b 55 10             	mov    0x10(%ebp),%edx
8010490b:	8b 75 08             	mov    0x8(%ebp),%esi
8010490e:	53                   	push   %ebx
8010490f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104912:	85 d2                	test   %edx,%edx
80104914:	7e 21                	jle    80104937 <safestrcpy+0x37>
80104916:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010491a:	89 f2                	mov    %esi,%edx
8010491c:	eb 12                	jmp    80104930 <safestrcpy+0x30>
8010491e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104920:	0f b6 08             	movzbl (%eax),%ecx
80104923:	83 c0 01             	add    $0x1,%eax
80104926:	83 c2 01             	add    $0x1,%edx
80104929:	88 4a ff             	mov    %cl,-0x1(%edx)
8010492c:	84 c9                	test   %cl,%cl
8010492e:	74 04                	je     80104934 <safestrcpy+0x34>
80104930:	39 d8                	cmp    %ebx,%eax
80104932:	75 ec                	jne    80104920 <safestrcpy+0x20>
    ;
  *s = 0;
80104934:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104937:	89 f0                	mov    %esi,%eax
80104939:	5b                   	pop    %ebx
8010493a:	5e                   	pop    %esi
8010493b:	5d                   	pop    %ebp
8010493c:	c3                   	ret    
8010493d:	8d 76 00             	lea    0x0(%esi),%esi

80104940 <strlen>:

int
strlen(const char *s)
{
80104940:	f3 0f 1e fb          	endbr32 
80104944:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104945:	31 c0                	xor    %eax,%eax
{
80104947:	89 e5                	mov    %esp,%ebp
80104949:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010494c:	80 3a 00             	cmpb   $0x0,(%edx)
8010494f:	74 10                	je     80104961 <strlen+0x21>
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104958:	83 c0 01             	add    $0x1,%eax
8010495b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010495f:	75 f7                	jne    80104958 <strlen+0x18>
    ;
  return n;
}
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret    

80104963 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104963:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104967:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010496b:	55                   	push   %ebp
  pushl %ebx
8010496c:	53                   	push   %ebx
  pushl %esi
8010496d:	56                   	push   %esi
  pushl %edi
8010496e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010496f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104971:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104973:	5f                   	pop    %edi
  popl %esi
80104974:	5e                   	pop    %esi
  popl %ebx
80104975:	5b                   	pop    %ebx
  popl %ebp
80104976:	5d                   	pop    %ebp
  ret
80104977:	c3                   	ret    
80104978:	66 90                	xchg   %ax,%ax
8010497a:	66 90                	xchg   %ax,%ax
8010497c:	66 90                	xchg   %ax,%ax
8010497e:	66 90                	xchg   %ax,%ax

80104980 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
80104985:	89 e5                	mov    %esp,%ebp
80104987:	53                   	push   %ebx
80104988:	83 ec 04             	sub    $0x4,%esp
8010498b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010498e:	e8 4d f0 ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104993:	8b 00                	mov    (%eax),%eax
80104995:	39 d8                	cmp    %ebx,%eax
80104997:	76 17                	jbe    801049b0 <fetchint+0x30>
80104999:	8d 53 04             	lea    0x4(%ebx),%edx
8010499c:	39 d0                	cmp    %edx,%eax
8010499e:	72 10                	jb     801049b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801049a3:	8b 13                	mov    (%ebx),%edx
801049a5:	89 10                	mov    %edx,(%eax)
  return 0;
801049a7:	31 c0                	xor    %eax,%eax
}
801049a9:	83 c4 04             	add    $0x4,%esp
801049ac:	5b                   	pop    %ebx
801049ad:	5d                   	pop    %ebp
801049ae:	c3                   	ret    
801049af:	90                   	nop
    return -1;
801049b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b5:	eb f2                	jmp    801049a9 <fetchint+0x29>
801049b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049be:	66 90                	xchg   %ax,%ax

801049c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	53                   	push   %ebx
801049c8:	83 ec 04             	sub    $0x4,%esp
801049cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049ce:	e8 0d f0 ff ff       	call   801039e0 <myproc>

  if(addr >= curproc->sz)
801049d3:	39 18                	cmp    %ebx,(%eax)
801049d5:	76 31                	jbe    80104a08 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801049d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801049da:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801049dc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801049de:	39 d3                	cmp    %edx,%ebx
801049e0:	73 26                	jae    80104a08 <fetchstr+0x48>
801049e2:	89 d8                	mov    %ebx,%eax
801049e4:	eb 11                	jmp    801049f7 <fetchstr+0x37>
801049e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
801049f0:	83 c0 01             	add    $0x1,%eax
801049f3:	39 c2                	cmp    %eax,%edx
801049f5:	76 11                	jbe    80104a08 <fetchstr+0x48>
    if(*s == 0)
801049f7:	80 38 00             	cmpb   $0x0,(%eax)
801049fa:	75 f4                	jne    801049f0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801049fc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801049ff:	29 d8                	sub    %ebx,%eax
}
80104a01:	5b                   	pop    %ebx
80104a02:	5d                   	pop    %ebp
80104a03:	c3                   	ret    
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a08:	83 c4 04             	add    $0x4,%esp
    return -1;
80104a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a10:	5b                   	pop    %ebx
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a20:	f3 0f 1e fb          	endbr32 
80104a24:	55                   	push   %ebp
80104a25:	89 e5                	mov    %esp,%ebp
80104a27:	56                   	push   %esi
80104a28:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a29:	e8 b2 ef ff ff       	call   801039e0 <myproc>
80104a2e:	8b 55 08             	mov    0x8(%ebp),%edx
80104a31:	8b 40 18             	mov    0x18(%eax),%eax
80104a34:	8b 40 44             	mov    0x44(%eax),%eax
80104a37:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a3a:	e8 a1 ef ff ff       	call   801039e0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a3f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a42:	8b 00                	mov    (%eax),%eax
80104a44:	39 c6                	cmp    %eax,%esi
80104a46:	73 18                	jae    80104a60 <argint+0x40>
80104a48:	8d 53 08             	lea    0x8(%ebx),%edx
80104a4b:	39 d0                	cmp    %edx,%eax
80104a4d:	72 11                	jb     80104a60 <argint+0x40>
  *ip = *(int*)(addr);
80104a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a52:	8b 53 04             	mov    0x4(%ebx),%edx
80104a55:	89 10                	mov    %edx,(%eax)
  return 0;
80104a57:	31 c0                	xor    %eax,%eax
}
80104a59:	5b                   	pop    %ebx
80104a5a:	5e                   	pop    %esi
80104a5b:	5d                   	pop    %ebp
80104a5c:	c3                   	ret    
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a65:	eb f2                	jmp    80104a59 <argint+0x39>
80104a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	56                   	push   %esi
80104a78:	53                   	push   %ebx
80104a79:	83 ec 10             	sub    $0x10,%esp
80104a7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a7f:	e8 5c ef ff ff       	call   801039e0 <myproc>
 
  if(argint(n, &i) < 0)
80104a84:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104a87:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104a89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a8c:	50                   	push   %eax
80104a8d:	ff 75 08             	pushl  0x8(%ebp)
80104a90:	e8 8b ff ff ff       	call   80104a20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a95:	83 c4 10             	add    $0x10,%esp
80104a98:	85 c0                	test   %eax,%eax
80104a9a:	78 24                	js     80104ac0 <argptr+0x50>
80104a9c:	85 db                	test   %ebx,%ebx
80104a9e:	78 20                	js     80104ac0 <argptr+0x50>
80104aa0:	8b 16                	mov    (%esi),%edx
80104aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa5:	39 c2                	cmp    %eax,%edx
80104aa7:	76 17                	jbe    80104ac0 <argptr+0x50>
80104aa9:	01 c3                	add    %eax,%ebx
80104aab:	39 da                	cmp    %ebx,%edx
80104aad:	72 11                	jb     80104ac0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ab2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ab4:	31 c0                	xor    %eax,%eax
}
80104ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab9:	5b                   	pop    %ebx
80104aba:	5e                   	pop    %esi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac5:	eb ef                	jmp    80104ab6 <argptr+0x46>
80104ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ada:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104add:	50                   	push   %eax
80104ade:	ff 75 08             	pushl  0x8(%ebp)
80104ae1:	e8 3a ff ff ff       	call   80104a20 <argint>
80104ae6:	83 c4 10             	add    $0x10,%esp
80104ae9:	85 c0                	test   %eax,%eax
80104aeb:	78 13                	js     80104b00 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104aed:	83 ec 08             	sub    $0x8,%esp
80104af0:	ff 75 0c             	pushl  0xc(%ebp)
80104af3:	ff 75 f4             	pushl  -0xc(%ebp)
80104af6:	e8 c5 fe ff ff       	call   801049c0 <fetchstr>
80104afb:	83 c4 10             	add    $0x10,%esp
}
80104afe:	c9                   	leave  
80104aff:	c3                   	ret    
80104b00:	c9                   	leave  
    return -1;
80104b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b06:	c3                   	ret    
80104b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <syscall>:
[SYS_halt]   sys_halt
};

void
syscall(void)
{
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	57                   	push   %edi
80104b18:	56                   	push   %esi
80104b19:	53                   	push   %ebx
80104b1a:	83 ec 0c             	sub    $0xc,%esp
  int num;
  struct proc *curproc = myproc();
80104b1d:	e8 be ee ff ff       	call   801039e0 <myproc>
  uint cmask;
  acquire(&tracemasklock);
80104b22:	83 ec 0c             	sub    $0xc,%esp
80104b25:	68 c0 55 11 80       	push   $0x801155c0
  struct proc *curproc = myproc();
80104b2a:	89 c3                	mov    %eax,%ebx
  acquire(&tracemasklock);
80104b2c:	e8 ff fa ff ff       	call   80104630 <acquire>
  cmask = tracemask;
  release(&tracemasklock);
80104b31:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
  cmask = tracemask;
80104b38:	8b 3d a0 55 11 80    	mov    0x801155a0,%edi
  release(&tracemasklock);
80104b3e:	e8 ad fb ff ff       	call   801046f0 <release>
  num = curproc->tf->eax;
80104b43:	8b 43 18             	mov    0x18(%ebx),%eax
  
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b46:	83 c4 10             	add    $0x10,%esp
  num = curproc->tf->eax;
80104b49:	8b 70 1c             	mov    0x1c(%eax),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b4c:	8d 46 ff             	lea    -0x1(%esi),%eax
80104b4f:	83 f8 17             	cmp    $0x17,%eax
80104b52:	77 3c                	ja     80104b90 <syscall+0x80>
80104b54:	8b 04 b5 00 7a 10 80 	mov    -0x7fef8600(,%esi,4),%eax
80104b5b:	85 c0                	test   %eax,%eax
80104b5d:	74 31                	je     80104b90 <syscall+0x80>
    curproc->tf->eax = syscalls[num]();
80104b5f:	ff d0                	call   *%eax
80104b61:	8b 53 18             	mov    0x18(%ebx),%edx
        if (cmask & (1 << num)){
80104b64:	0f a3 f7             	bt     %esi,%edi
    curproc->tf->eax = syscalls[num]();
80104b67:	89 42 1c             	mov    %eax,0x1c(%edx)
        if (cmask & (1 << num)){
80104b6a:	73 43                	jae    80104baf <syscall+0x9f>
        cprintf("%d %s returns %d\n", curproc->pid,
80104b6c:	8b 43 18             	mov    0x18(%ebx),%eax
80104b6f:	ff 70 1c             	pushl  0x1c(%eax)
                curproc->name, curproc->tf->eax);
80104b72:	8d 43 6c             	lea    0x6c(%ebx),%eax
        cprintf("%d %s returns %d\n", curproc->pid,
80104b75:	50                   	push   %eax
80104b76:	ff 73 10             	pushl  0x10(%ebx)
80104b79:	68 bd 79 10 80       	push   $0x801079bd
80104b7e:	e8 2d bb ff ff       	call   801006b0 <cprintf>
80104b83:	83 c4 10             	add    $0x10,%esp
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
80104b86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b89:	5b                   	pop    %ebx
80104b8a:	5e                   	pop    %esi
80104b8b:	5f                   	pop    %edi
80104b8c:	5d                   	pop    %ebp
80104b8d:	c3                   	ret    
80104b8e:	66 90                	xchg   %ax,%ax
            curproc->pid, curproc->name, num);
80104b90:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b93:	56                   	push   %esi
80104b94:	50                   	push   %eax
80104b95:	ff 73 10             	pushl  0x10(%ebx)
80104b98:	68 cf 79 10 80       	push   $0x801079cf
80104b9d:	e8 0e bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104ba2:	8b 43 18             	mov    0x18(%ebx),%eax
80104ba5:	83 c4 10             	add    $0x10,%esp
80104ba8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104baf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb2:	5b                   	pop    %ebx
80104bb3:	5e                   	pop    %esi
80104bb4:	5f                   	pop    %edi
80104bb5:	5d                   	pop    %ebp
80104bb6:	c3                   	ret    
80104bb7:	66 90                	xchg   %ax,%ax
80104bb9:	66 90                	xchg   %ax,%ax
80104bbb:	66 90                	xchg   %ax,%ax
80104bbd:	66 90                	xchg   %ax,%ax
80104bbf:	90                   	nop

80104bc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bc5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104bc8:	53                   	push   %ebx
80104bc9:	83 ec 34             	sub    $0x34,%esp
80104bcc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104bcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104bd2:	57                   	push   %edi
80104bd3:	50                   	push   %eax
{
80104bd4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104bd7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bda:	e8 71 d4 ff ff       	call   80102050 <nameiparent>
80104bdf:	83 c4 10             	add    $0x10,%esp
80104be2:	85 c0                	test   %eax,%eax
80104be4:	0f 84 46 01 00 00    	je     80104d30 <create+0x170>
    return 0;
  ilock(dp);
80104bea:	83 ec 0c             	sub    $0xc,%esp
80104bed:	89 c3                	mov    %eax,%ebx
80104bef:	50                   	push   %eax
80104bf0:	e8 6b cb ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104bf5:	83 c4 0c             	add    $0xc,%esp
80104bf8:	6a 00                	push   $0x0
80104bfa:	57                   	push   %edi
80104bfb:	53                   	push   %ebx
80104bfc:	e8 af d0 ff ff       	call   80101cb0 <dirlookup>
80104c01:	83 c4 10             	add    $0x10,%esp
80104c04:	89 c6                	mov    %eax,%esi
80104c06:	85 c0                	test   %eax,%eax
80104c08:	74 56                	je     80104c60 <create+0xa0>
    iunlockput(dp);
80104c0a:	83 ec 0c             	sub    $0xc,%esp
80104c0d:	53                   	push   %ebx
80104c0e:	e8 ed cd ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104c13:	89 34 24             	mov    %esi,(%esp)
80104c16:	e8 45 cb ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c1b:	83 c4 10             	add    $0x10,%esp
80104c1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c23:	75 1b                	jne    80104c40 <create+0x80>
80104c25:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c2a:	75 14                	jne    80104c40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c2f:	89 f0                	mov    %esi,%eax
80104c31:	5b                   	pop    %ebx
80104c32:	5e                   	pop    %esi
80104c33:	5f                   	pop    %edi
80104c34:	5d                   	pop    %ebp
80104c35:	c3                   	ret    
80104c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104c40:	83 ec 0c             	sub    $0xc,%esp
80104c43:	56                   	push   %esi
    return 0;
80104c44:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c46:	e8 b5 cd ff ff       	call   80101a00 <iunlockput>
    return 0;
80104c4b:	83 c4 10             	add    $0x10,%esp
}
80104c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c51:	89 f0                	mov    %esi,%eax
80104c53:	5b                   	pop    %ebx
80104c54:	5e                   	pop    %esi
80104c55:	5f                   	pop    %edi
80104c56:	5d                   	pop    %ebp
80104c57:	c3                   	ret    
80104c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c5f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104c60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104c64:	83 ec 08             	sub    $0x8,%esp
80104c67:	50                   	push   %eax
80104c68:	ff 33                	pushl  (%ebx)
80104c6a:	e8 71 c9 ff ff       	call   801015e0 <ialloc>
80104c6f:	83 c4 10             	add    $0x10,%esp
80104c72:	89 c6                	mov    %eax,%esi
80104c74:	85 c0                	test   %eax,%eax
80104c76:	0f 84 cd 00 00 00    	je     80104d49 <create+0x189>
  ilock(ip);
80104c7c:	83 ec 0c             	sub    $0xc,%esp
80104c7f:	50                   	push   %eax
80104c80:	e8 db ca ff ff       	call   80101760 <ilock>
  ip->major = major;
80104c85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104c89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104c91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c95:	b8 01 00 00 00       	mov    $0x1,%eax
80104c9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c9e:	89 34 24             	mov    %esi,(%esp)
80104ca1:	e8 fa c9 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ca6:	83 c4 10             	add    $0x10,%esp
80104ca9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104cae:	74 30                	je     80104ce0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104cb0:	83 ec 04             	sub    $0x4,%esp
80104cb3:	ff 76 04             	pushl  0x4(%esi)
80104cb6:	57                   	push   %edi
80104cb7:	53                   	push   %ebx
80104cb8:	e8 b3 d2 ff ff       	call   80101f70 <dirlink>
80104cbd:	83 c4 10             	add    $0x10,%esp
80104cc0:	85 c0                	test   %eax,%eax
80104cc2:	78 78                	js     80104d3c <create+0x17c>
  iunlockput(dp);
80104cc4:	83 ec 0c             	sub    $0xc,%esp
80104cc7:	53                   	push   %ebx
80104cc8:	e8 33 cd ff ff       	call   80101a00 <iunlockput>
  return ip;
80104ccd:	83 c4 10             	add    $0x10,%esp
}
80104cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cd3:	89 f0                	mov    %esi,%eax
80104cd5:	5b                   	pop    %ebx
80104cd6:	5e                   	pop    %esi
80104cd7:	5f                   	pop    %edi
80104cd8:	5d                   	pop    %ebp
80104cd9:	c3                   	ret    
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ce0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ce3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ce8:	53                   	push   %ebx
80104ce9:	e8 b2 c9 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cee:	83 c4 0c             	add    $0xc,%esp
80104cf1:	ff 76 04             	pushl  0x4(%esi)
80104cf4:	68 80 7a 10 80       	push   $0x80107a80
80104cf9:	56                   	push   %esi
80104cfa:	e8 71 d2 ff ff       	call   80101f70 <dirlink>
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	85 c0                	test   %eax,%eax
80104d04:	78 18                	js     80104d1e <create+0x15e>
80104d06:	83 ec 04             	sub    $0x4,%esp
80104d09:	ff 73 04             	pushl  0x4(%ebx)
80104d0c:	68 7f 7a 10 80       	push   $0x80107a7f
80104d11:	56                   	push   %esi
80104d12:	e8 59 d2 ff ff       	call   80101f70 <dirlink>
80104d17:	83 c4 10             	add    $0x10,%esp
80104d1a:	85 c0                	test   %eax,%eax
80104d1c:	79 92                	jns    80104cb0 <create+0xf0>
      panic("create dots");
80104d1e:	83 ec 0c             	sub    $0xc,%esp
80104d21:	68 73 7a 10 80       	push   $0x80107a73
80104d26:	e8 65 b6 ff ff       	call   80100390 <panic>
80104d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d2f:	90                   	nop
}
80104d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d33:	31 f6                	xor    %esi,%esi
}
80104d35:	5b                   	pop    %ebx
80104d36:	89 f0                	mov    %esi,%eax
80104d38:	5e                   	pop    %esi
80104d39:	5f                   	pop    %edi
80104d3a:	5d                   	pop    %ebp
80104d3b:	c3                   	ret    
    panic("create: dirlink");
80104d3c:	83 ec 0c             	sub    $0xc,%esp
80104d3f:	68 82 7a 10 80       	push   $0x80107a82
80104d44:	e8 47 b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d49:	83 ec 0c             	sub    $0xc,%esp
80104d4c:	68 64 7a 10 80       	push   $0x80107a64
80104d51:	e8 3a b6 ff ff       	call   80100390 <panic>
80104d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	89 d6                	mov    %edx,%esi
80104d66:	53                   	push   %ebx
80104d67:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d6c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d6f:	50                   	push   %eax
80104d70:	6a 00                	push   $0x0
80104d72:	e8 a9 fc ff ff       	call   80104a20 <argint>
80104d77:	83 c4 10             	add    $0x10,%esp
80104d7a:	85 c0                	test   %eax,%eax
80104d7c:	78 2a                	js     80104da8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d82:	77 24                	ja     80104da8 <argfd.constprop.0+0x48>
80104d84:	e8 57 ec ff ff       	call   801039e0 <myproc>
80104d89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d8c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d90:	85 c0                	test   %eax,%eax
80104d92:	74 14                	je     80104da8 <argfd.constprop.0+0x48>
  if(pfd)
80104d94:	85 db                	test   %ebx,%ebx
80104d96:	74 02                	je     80104d9a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d98:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d9a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d9c:	31 c0                	xor    %eax,%eax
}
80104d9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104da1:	5b                   	pop    %ebx
80104da2:	5e                   	pop    %esi
80104da3:	5d                   	pop    %ebp
80104da4:	c3                   	ret    
80104da5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dad:	eb ef                	jmp    80104d9e <argfd.constprop.0+0x3e>
80104daf:	90                   	nop

80104db0 <sys_dup>:
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104db5:	31 c0                	xor    %eax,%eax
{
80104db7:	89 e5                	mov    %esp,%ebp
80104db9:	56                   	push   %esi
80104dba:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104dbb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dbe:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104dc1:	e8 9a ff ff ff       	call   80104d60 <argfd.constprop.0>
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	78 1e                	js     80104de8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104dca:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104dcd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104dcf:	e8 0c ec ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104dd8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ddc:	85 d2                	test   %edx,%edx
80104dde:	74 20                	je     80104e00 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104de0:	83 c3 01             	add    $0x1,%ebx
80104de3:	83 fb 10             	cmp    $0x10,%ebx
80104de6:	75 f0                	jne    80104dd8 <sys_dup+0x28>
}
80104de8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104deb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104df0:	89 d8                	mov    %ebx,%eax
80104df2:	5b                   	pop    %ebx
80104df3:	5e                   	pop    %esi
80104df4:	5d                   	pop    %ebp
80104df5:	c3                   	ret    
80104df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104e00:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e04:	83 ec 0c             	sub    $0xc,%esp
80104e07:	ff 75 f4             	pushl  -0xc(%ebp)
80104e0a:	e8 61 c0 ff ff       	call   80100e70 <filedup>
  return fd;
80104e0f:	83 c4 10             	add    $0x10,%esp
}
80104e12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e15:	89 d8                	mov    %ebx,%eax
80104e17:	5b                   	pop    %ebx
80104e18:	5e                   	pop    %esi
80104e19:	5d                   	pop    %ebp
80104e1a:	c3                   	ret    
80104e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop

80104e20 <sys_read>:
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e25:	31 c0                	xor    %eax,%eax
{
80104e27:	89 e5                	mov    %esp,%ebp
80104e29:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e2c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e2f:	e8 2c ff ff ff       	call   80104d60 <argfd.constprop.0>
80104e34:	85 c0                	test   %eax,%eax
80104e36:	78 48                	js     80104e80 <sys_read+0x60>
80104e38:	83 ec 08             	sub    $0x8,%esp
80104e3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e3e:	50                   	push   %eax
80104e3f:	6a 02                	push   $0x2
80104e41:	e8 da fb ff ff       	call   80104a20 <argint>
80104e46:	83 c4 10             	add    $0x10,%esp
80104e49:	85 c0                	test   %eax,%eax
80104e4b:	78 33                	js     80104e80 <sys_read+0x60>
80104e4d:	83 ec 04             	sub    $0x4,%esp
80104e50:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e53:	ff 75 f0             	pushl  -0x10(%ebp)
80104e56:	50                   	push   %eax
80104e57:	6a 01                	push   $0x1
80104e59:	e8 12 fc ff ff       	call   80104a70 <argptr>
80104e5e:	83 c4 10             	add    $0x10,%esp
80104e61:	85 c0                	test   %eax,%eax
80104e63:	78 1b                	js     80104e80 <sys_read+0x60>
  return fileread(f, p, n);
80104e65:	83 ec 04             	sub    $0x4,%esp
80104e68:	ff 75 f0             	pushl  -0x10(%ebp)
80104e6b:	ff 75 f4             	pushl  -0xc(%ebp)
80104e6e:	ff 75 ec             	pushl  -0x14(%ebp)
80104e71:	e8 7a c1 ff ff       	call   80100ff0 <fileread>
80104e76:	83 c4 10             	add    $0x10,%esp
}
80104e79:	c9                   	leave  
80104e7a:	c3                   	ret    
80104e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e7f:	90                   	nop
80104e80:	c9                   	leave  
    return -1;
80104e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e86:	c3                   	ret    
80104e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8e:	66 90                	xchg   %ax,%ax

80104e90 <sys_write>:
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e95:	31 c0                	xor    %eax,%eax
{
80104e97:	89 e5                	mov    %esp,%ebp
80104e99:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e9c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e9f:	e8 bc fe ff ff       	call   80104d60 <argfd.constprop.0>
80104ea4:	85 c0                	test   %eax,%eax
80104ea6:	78 48                	js     80104ef0 <sys_write+0x60>
80104ea8:	83 ec 08             	sub    $0x8,%esp
80104eab:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104eae:	50                   	push   %eax
80104eaf:	6a 02                	push   $0x2
80104eb1:	e8 6a fb ff ff       	call   80104a20 <argint>
80104eb6:	83 c4 10             	add    $0x10,%esp
80104eb9:	85 c0                	test   %eax,%eax
80104ebb:	78 33                	js     80104ef0 <sys_write+0x60>
80104ebd:	83 ec 04             	sub    $0x4,%esp
80104ec0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ec3:	ff 75 f0             	pushl  -0x10(%ebp)
80104ec6:	50                   	push   %eax
80104ec7:	6a 01                	push   $0x1
80104ec9:	e8 a2 fb ff ff       	call   80104a70 <argptr>
80104ece:	83 c4 10             	add    $0x10,%esp
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	78 1b                	js     80104ef0 <sys_write+0x60>
  return filewrite(f, p, n);
80104ed5:	83 ec 04             	sub    $0x4,%esp
80104ed8:	ff 75 f0             	pushl  -0x10(%ebp)
80104edb:	ff 75 f4             	pushl  -0xc(%ebp)
80104ede:	ff 75 ec             	pushl  -0x14(%ebp)
80104ee1:	e8 aa c1 ff ff       	call   80101090 <filewrite>
80104ee6:	83 c4 10             	add    $0x10,%esp
}
80104ee9:	c9                   	leave  
80104eea:	c3                   	ret    
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop
80104ef0:	c9                   	leave  
    return -1;
80104ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ef6:	c3                   	ret    
80104ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efe:	66 90                	xchg   %ax,%ax

80104f00 <sys_close>:
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104f0a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f0d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f10:	e8 4b fe ff ff       	call   80104d60 <argfd.constprop.0>
80104f15:	85 c0                	test   %eax,%eax
80104f17:	78 27                	js     80104f40 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f19:	e8 c2 ea ff ff       	call   801039e0 <myproc>
80104f1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f21:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f24:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f2b:	00 
  fileclose(f);
80104f2c:	ff 75 f4             	pushl  -0xc(%ebp)
80104f2f:	e8 8c bf ff ff       	call   80100ec0 <fileclose>
  return 0;
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	31 c0                	xor    %eax,%eax
}
80104f39:	c9                   	leave  
80104f3a:	c3                   	ret    
80104f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop
80104f40:	c9                   	leave  
    return -1;
80104f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f46:	c3                   	ret    
80104f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <sys_fstat>:
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f55:	31 c0                	xor    %eax,%eax
{
80104f57:	89 e5                	mov    %esp,%ebp
80104f59:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f5c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f5f:	e8 fc fd ff ff       	call   80104d60 <argfd.constprop.0>
80104f64:	85 c0                	test   %eax,%eax
80104f66:	78 30                	js     80104f98 <sys_fstat+0x48>
80104f68:	83 ec 04             	sub    $0x4,%esp
80104f6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f6e:	6a 14                	push   $0x14
80104f70:	50                   	push   %eax
80104f71:	6a 01                	push   $0x1
80104f73:	e8 f8 fa ff ff       	call   80104a70 <argptr>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	78 19                	js     80104f98 <sys_fstat+0x48>
  return filestat(f, st);
80104f7f:	83 ec 08             	sub    $0x8,%esp
80104f82:	ff 75 f4             	pushl  -0xc(%ebp)
80104f85:	ff 75 f0             	pushl  -0x10(%ebp)
80104f88:	e8 13 c0 ff ff       	call   80100fa0 <filestat>
80104f8d:	83 c4 10             	add    $0x10,%esp
}
80104f90:	c9                   	leave  
80104f91:	c3                   	ret    
80104f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f98:	c9                   	leave  
    return -1;
80104f99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f9e:	c3                   	ret    
80104f9f:	90                   	nop

80104fa0 <sys_link>:
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	57                   	push   %edi
80104fa8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fa9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fac:	53                   	push   %ebx
80104fad:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fb0:	50                   	push   %eax
80104fb1:	6a 00                	push   $0x0
80104fb3:	e8 18 fb ff ff       	call   80104ad0 <argstr>
80104fb8:	83 c4 10             	add    $0x10,%esp
80104fbb:	85 c0                	test   %eax,%eax
80104fbd:	0f 88 ff 00 00 00    	js     801050c2 <sys_link+0x122>
80104fc3:	83 ec 08             	sub    $0x8,%esp
80104fc6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fc9:	50                   	push   %eax
80104fca:	6a 01                	push   $0x1
80104fcc:	e8 ff fa ff ff       	call   80104ad0 <argstr>
80104fd1:	83 c4 10             	add    $0x10,%esp
80104fd4:	85 c0                	test   %eax,%eax
80104fd6:	0f 88 e6 00 00 00    	js     801050c2 <sys_link+0x122>
  begin_op();
80104fdc:	e8 cf dd ff ff       	call   80102db0 <begin_op>
  if((ip = namei(old)) == 0){
80104fe1:	83 ec 0c             	sub    $0xc,%esp
80104fe4:	ff 75 d4             	pushl  -0x2c(%ebp)
80104fe7:	e8 44 d0 ff ff       	call   80102030 <namei>
80104fec:	83 c4 10             	add    $0x10,%esp
80104fef:	89 c3                	mov    %eax,%ebx
80104ff1:	85 c0                	test   %eax,%eax
80104ff3:	0f 84 e8 00 00 00    	je     801050e1 <sys_link+0x141>
  ilock(ip);
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	50                   	push   %eax
80104ffd:	e8 5e c7 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105002:	83 c4 10             	add    $0x10,%esp
80105005:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010500a:	0f 84 b9 00 00 00    	je     801050c9 <sys_link+0x129>
  iupdate(ip);
80105010:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105013:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105018:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010501b:	53                   	push   %ebx
8010501c:	e8 7f c6 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105021:	89 1c 24             	mov    %ebx,(%esp)
80105024:	e8 17 c8 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105029:	58                   	pop    %eax
8010502a:	5a                   	pop    %edx
8010502b:	57                   	push   %edi
8010502c:	ff 75 d0             	pushl  -0x30(%ebp)
8010502f:	e8 1c d0 ff ff       	call   80102050 <nameiparent>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	89 c6                	mov    %eax,%esi
80105039:	85 c0                	test   %eax,%eax
8010503b:	74 5f                	je     8010509c <sys_link+0xfc>
  ilock(dp);
8010503d:	83 ec 0c             	sub    $0xc,%esp
80105040:	50                   	push   %eax
80105041:	e8 1a c7 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105046:	8b 03                	mov    (%ebx),%eax
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	39 06                	cmp    %eax,(%esi)
8010504d:	75 41                	jne    80105090 <sys_link+0xf0>
8010504f:	83 ec 04             	sub    $0x4,%esp
80105052:	ff 73 04             	pushl  0x4(%ebx)
80105055:	57                   	push   %edi
80105056:	56                   	push   %esi
80105057:	e8 14 cf ff ff       	call   80101f70 <dirlink>
8010505c:	83 c4 10             	add    $0x10,%esp
8010505f:	85 c0                	test   %eax,%eax
80105061:	78 2d                	js     80105090 <sys_link+0xf0>
  iunlockput(dp);
80105063:	83 ec 0c             	sub    $0xc,%esp
80105066:	56                   	push   %esi
80105067:	e8 94 c9 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010506c:	89 1c 24             	mov    %ebx,(%esp)
8010506f:	e8 1c c8 ff ff       	call   80101890 <iput>
  end_op();
80105074:	e8 a7 dd ff ff       	call   80102e20 <end_op>
  return 0;
80105079:	83 c4 10             	add    $0x10,%esp
8010507c:	31 c0                	xor    %eax,%eax
}
8010507e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105081:	5b                   	pop    %ebx
80105082:	5e                   	pop    %esi
80105083:	5f                   	pop    %edi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105090:	83 ec 0c             	sub    $0xc,%esp
80105093:	56                   	push   %esi
80105094:	e8 67 c9 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105099:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010509c:	83 ec 0c             	sub    $0xc,%esp
8010509f:	53                   	push   %ebx
801050a0:	e8 bb c6 ff ff       	call   80101760 <ilock>
  ip->nlink--;
801050a5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050aa:	89 1c 24             	mov    %ebx,(%esp)
801050ad:	e8 ee c5 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801050b2:	89 1c 24             	mov    %ebx,(%esp)
801050b5:	e8 46 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
801050ba:	e8 61 dd ff ff       	call   80102e20 <end_op>
  return -1;
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c7:	eb b5                	jmp    8010507e <sys_link+0xde>
    iunlockput(ip);
801050c9:	83 ec 0c             	sub    $0xc,%esp
801050cc:	53                   	push   %ebx
801050cd:	e8 2e c9 ff ff       	call   80101a00 <iunlockput>
    end_op();
801050d2:	e8 49 dd ff ff       	call   80102e20 <end_op>
    return -1;
801050d7:	83 c4 10             	add    $0x10,%esp
801050da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050df:	eb 9d                	jmp    8010507e <sys_link+0xde>
    end_op();
801050e1:	e8 3a dd ff ff       	call   80102e20 <end_op>
    return -1;
801050e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050eb:	eb 91                	jmp    8010507e <sys_link+0xde>
801050ed:	8d 76 00             	lea    0x0(%esi),%esi

801050f0 <sys_unlink>:
{
801050f0:	f3 0f 1e fb          	endbr32 
801050f4:	55                   	push   %ebp
801050f5:	89 e5                	mov    %esp,%ebp
801050f7:	57                   	push   %edi
801050f8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801050f9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050fc:	53                   	push   %ebx
801050fd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105100:	50                   	push   %eax
80105101:	6a 00                	push   $0x0
80105103:	e8 c8 f9 ff ff       	call   80104ad0 <argstr>
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	85 c0                	test   %eax,%eax
8010510d:	0f 88 7d 01 00 00    	js     80105290 <sys_unlink+0x1a0>
  begin_op();
80105113:	e8 98 dc ff ff       	call   80102db0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105118:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010511b:	83 ec 08             	sub    $0x8,%esp
8010511e:	53                   	push   %ebx
8010511f:	ff 75 c0             	pushl  -0x40(%ebp)
80105122:	e8 29 cf ff ff       	call   80102050 <nameiparent>
80105127:	83 c4 10             	add    $0x10,%esp
8010512a:	89 c6                	mov    %eax,%esi
8010512c:	85 c0                	test   %eax,%eax
8010512e:	0f 84 66 01 00 00    	je     8010529a <sys_unlink+0x1aa>
  ilock(dp);
80105134:	83 ec 0c             	sub    $0xc,%esp
80105137:	50                   	push   %eax
80105138:	e8 23 c6 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010513d:	58                   	pop    %eax
8010513e:	5a                   	pop    %edx
8010513f:	68 80 7a 10 80       	push   $0x80107a80
80105144:	53                   	push   %ebx
80105145:	e8 46 cb ff ff       	call   80101c90 <namecmp>
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	85 c0                	test   %eax,%eax
8010514f:	0f 84 03 01 00 00    	je     80105258 <sys_unlink+0x168>
80105155:	83 ec 08             	sub    $0x8,%esp
80105158:	68 7f 7a 10 80       	push   $0x80107a7f
8010515d:	53                   	push   %ebx
8010515e:	e8 2d cb ff ff       	call   80101c90 <namecmp>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	0f 84 ea 00 00 00    	je     80105258 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010516e:	83 ec 04             	sub    $0x4,%esp
80105171:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105174:	50                   	push   %eax
80105175:	53                   	push   %ebx
80105176:	56                   	push   %esi
80105177:	e8 34 cb ff ff       	call   80101cb0 <dirlookup>
8010517c:	83 c4 10             	add    $0x10,%esp
8010517f:	89 c3                	mov    %eax,%ebx
80105181:	85 c0                	test   %eax,%eax
80105183:	0f 84 cf 00 00 00    	je     80105258 <sys_unlink+0x168>
  ilock(ip);
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	50                   	push   %eax
8010518d:	e8 ce c5 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105192:	83 c4 10             	add    $0x10,%esp
80105195:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010519a:	0f 8e 23 01 00 00    	jle    801052c3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801051a8:	74 66                	je     80105210 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051aa:	83 ec 04             	sub    $0x4,%esp
801051ad:	6a 10                	push   $0x10
801051af:	6a 00                	push   $0x0
801051b1:	57                   	push   %edi
801051b2:	e8 89 f5 ff ff       	call   80104740 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b7:	6a 10                	push   $0x10
801051b9:	ff 75 c4             	pushl  -0x3c(%ebp)
801051bc:	57                   	push   %edi
801051bd:	56                   	push   %esi
801051be:	e8 9d c9 ff ff       	call   80101b60 <writei>
801051c3:	83 c4 20             	add    $0x20,%esp
801051c6:	83 f8 10             	cmp    $0x10,%eax
801051c9:	0f 85 e7 00 00 00    	jne    801052b6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801051cf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d4:	0f 84 96 00 00 00    	je     80105270 <sys_unlink+0x180>
  iunlockput(dp);
801051da:	83 ec 0c             	sub    $0xc,%esp
801051dd:	56                   	push   %esi
801051de:	e8 1d c8 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
801051e3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051e8:	89 1c 24             	mov    %ebx,(%esp)
801051eb:	e8 b0 c4 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801051f0:	89 1c 24             	mov    %ebx,(%esp)
801051f3:	e8 08 c8 ff ff       	call   80101a00 <iunlockput>
  end_op();
801051f8:	e8 23 dc ff ff       	call   80102e20 <end_op>
  return 0;
801051fd:	83 c4 10             	add    $0x10,%esp
80105200:	31 c0                	xor    %eax,%eax
}
80105202:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105205:	5b                   	pop    %ebx
80105206:	5e                   	pop    %esi
80105207:	5f                   	pop    %edi
80105208:	5d                   	pop    %ebp
80105209:	c3                   	ret    
8010520a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105210:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105214:	76 94                	jbe    801051aa <sys_unlink+0xba>
80105216:	ba 20 00 00 00       	mov    $0x20,%edx
8010521b:	eb 0b                	jmp    80105228 <sys_unlink+0x138>
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
80105220:	83 c2 10             	add    $0x10,%edx
80105223:	39 53 58             	cmp    %edx,0x58(%ebx)
80105226:	76 82                	jbe    801051aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105228:	6a 10                	push   $0x10
8010522a:	52                   	push   %edx
8010522b:	57                   	push   %edi
8010522c:	53                   	push   %ebx
8010522d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105230:	e8 2b c8 ff ff       	call   80101a60 <readi>
80105235:	83 c4 10             	add    $0x10,%esp
80105238:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010523b:	83 f8 10             	cmp    $0x10,%eax
8010523e:	75 69                	jne    801052a9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105240:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105245:	74 d9                	je     80105220 <sys_unlink+0x130>
    iunlockput(ip);
80105247:	83 ec 0c             	sub    $0xc,%esp
8010524a:	53                   	push   %ebx
8010524b:	e8 b0 c7 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105250:	83 c4 10             	add    $0x10,%esp
80105253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105257:	90                   	nop
  iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	56                   	push   %esi
8010525c:	e8 9f c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105261:	e8 ba db ff ff       	call   80102e20 <end_op>
  return -1;
80105266:	83 c4 10             	add    $0x10,%esp
80105269:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526e:	eb 92                	jmp    80105202 <sys_unlink+0x112>
    iupdate(dp);
80105270:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105273:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105278:	56                   	push   %esi
80105279:	e8 22 c4 ff ff       	call   801016a0 <iupdate>
8010527e:	83 c4 10             	add    $0x10,%esp
80105281:	e9 54 ff ff ff       	jmp    801051da <sys_unlink+0xea>
80105286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105295:	e9 68 ff ff ff       	jmp    80105202 <sys_unlink+0x112>
    end_op();
8010529a:	e8 81 db ff ff       	call   80102e20 <end_op>
    return -1;
8010529f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a4:	e9 59 ff ff ff       	jmp    80105202 <sys_unlink+0x112>
      panic("isdirempty: readi");
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	68 a4 7a 10 80       	push   $0x80107aa4
801052b1:	e8 da b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801052b6:	83 ec 0c             	sub    $0xc,%esp
801052b9:	68 b6 7a 10 80       	push   $0x80107ab6
801052be:	e8 cd b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801052c3:	83 ec 0c             	sub    $0xc,%esp
801052c6:	68 92 7a 10 80       	push   $0x80107a92
801052cb:	e8 c0 b0 ff ff       	call   80100390 <panic>

801052d0 <sys_open>:

int
sys_open(void)
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	57                   	push   %edi
801052d8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052dc:	53                   	push   %ebx
801052dd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052e0:	50                   	push   %eax
801052e1:	6a 00                	push   $0x0
801052e3:	e8 e8 f7 ff ff       	call   80104ad0 <argstr>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	85 c0                	test   %eax,%eax
801052ed:	0f 88 8a 00 00 00    	js     8010537d <sys_open+0xad>
801052f3:	83 ec 08             	sub    $0x8,%esp
801052f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052f9:	50                   	push   %eax
801052fa:	6a 01                	push   $0x1
801052fc:	e8 1f f7 ff ff       	call   80104a20 <argint>
80105301:	83 c4 10             	add    $0x10,%esp
80105304:	85 c0                	test   %eax,%eax
80105306:	78 75                	js     8010537d <sys_open+0xad>
    return -1;

  begin_op();
80105308:	e8 a3 da ff ff       	call   80102db0 <begin_op>

  if(omode & O_CREATE){
8010530d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105311:	75 75                	jne    80105388 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105313:	83 ec 0c             	sub    $0xc,%esp
80105316:	ff 75 e0             	pushl  -0x20(%ebp)
80105319:	e8 12 cd ff ff       	call   80102030 <namei>
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	89 c6                	mov    %eax,%esi
80105323:	85 c0                	test   %eax,%eax
80105325:	74 7e                	je     801053a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	50                   	push   %eax
8010532b:	e8 30 c4 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105338:	0f 84 c2 00 00 00    	je     80105400 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010533e:	e8 bd ba ff ff       	call   80100e00 <filealloc>
80105343:	89 c7                	mov    %eax,%edi
80105345:	85 c0                	test   %eax,%eax
80105347:	74 23                	je     8010536c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105349:	e8 92 e6 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010534e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105350:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105354:	85 d2                	test   %edx,%edx
80105356:	74 60                	je     801053b8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105358:	83 c3 01             	add    $0x1,%ebx
8010535b:	83 fb 10             	cmp    $0x10,%ebx
8010535e:	75 f0                	jne    80105350 <sys_open+0x80>
    if(f)
      fileclose(f);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	57                   	push   %edi
80105364:	e8 57 bb ff ff       	call   80100ec0 <fileclose>
80105369:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	56                   	push   %esi
80105370:	e8 8b c6 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105375:	e8 a6 da ff ff       	call   80102e20 <end_op>
    return -1;
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105382:	eb 6d                	jmp    801053f1 <sys_open+0x121>
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010538e:	31 c9                	xor    %ecx,%ecx
80105390:	ba 02 00 00 00       	mov    $0x2,%edx
80105395:	6a 00                	push   $0x0
80105397:	e8 24 f8 ff ff       	call   80104bc0 <create>
    if(ip == 0){
8010539c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010539f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053a1:	85 c0                	test   %eax,%eax
801053a3:	75 99                	jne    8010533e <sys_open+0x6e>
      end_op();
801053a5:	e8 76 da ff ff       	call   80102e20 <end_op>
      return -1;
801053aa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053af:	eb 40                	jmp    801053f1 <sys_open+0x121>
801053b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801053b8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053bb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053bf:	56                   	push   %esi
801053c0:	e8 7b c4 ff ff       	call   80101840 <iunlock>
  end_op();
801053c5:	e8 56 da ff ff       	call   80102e20 <end_op>

  f->type = FD_INODE;
801053ca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053d3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801053d6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801053d9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801053db:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053e2:	f7 d0                	not    %eax
801053e4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053e7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801053ea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053ed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f4:	89 d8                	mov    %ebx,%eax
801053f6:	5b                   	pop    %ebx
801053f7:	5e                   	pop    %esi
801053f8:	5f                   	pop    %edi
801053f9:	5d                   	pop    %ebp
801053fa:	c3                   	ret    
801053fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105400:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105403:	85 c9                	test   %ecx,%ecx
80105405:	0f 84 33 ff ff ff    	je     8010533e <sys_open+0x6e>
8010540b:	e9 5c ff ff ff       	jmp    8010536c <sys_open+0x9c>

80105410 <sys_mkdir>:

int
sys_mkdir(void)
{
80105410:	f3 0f 1e fb          	endbr32 
80105414:	55                   	push   %ebp
80105415:	89 e5                	mov    %esp,%ebp
80105417:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010541a:	e8 91 d9 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010541f:	83 ec 08             	sub    $0x8,%esp
80105422:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105425:	50                   	push   %eax
80105426:	6a 00                	push   $0x0
80105428:	e8 a3 f6 ff ff       	call   80104ad0 <argstr>
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	85 c0                	test   %eax,%eax
80105432:	78 34                	js     80105468 <sys_mkdir+0x58>
80105434:	83 ec 0c             	sub    $0xc,%esp
80105437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010543a:	31 c9                	xor    %ecx,%ecx
8010543c:	ba 01 00 00 00       	mov    $0x1,%edx
80105441:	6a 00                	push   $0x0
80105443:	e8 78 f7 ff ff       	call   80104bc0 <create>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	74 19                	je     80105468 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	50                   	push   %eax
80105453:	e8 a8 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105458:	e8 c3 d9 ff ff       	call   80102e20 <end_op>
  return 0;
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	31 c0                	xor    %eax,%eax
}
80105462:	c9                   	leave  
80105463:	c3                   	ret    
80105464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105468:	e8 b3 d9 ff ff       	call   80102e20 <end_op>
    return -1;
8010546d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105472:	c9                   	leave  
80105473:	c3                   	ret    
80105474:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010547b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010547f:	90                   	nop

80105480 <sys_mknod>:

int
sys_mknod(void)
{
80105480:	f3 0f 1e fb          	endbr32 
80105484:	55                   	push   %ebp
80105485:	89 e5                	mov    %esp,%ebp
80105487:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010548a:	e8 21 d9 ff ff       	call   80102db0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010548f:	83 ec 08             	sub    $0x8,%esp
80105492:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105495:	50                   	push   %eax
80105496:	6a 00                	push   $0x0
80105498:	e8 33 f6 ff ff       	call   80104ad0 <argstr>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 64                	js     80105508 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801054a4:	83 ec 08             	sub    $0x8,%esp
801054a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054aa:	50                   	push   %eax
801054ab:	6a 01                	push   $0x1
801054ad:	e8 6e f5 ff ff       	call   80104a20 <argint>
  if((argstr(0, &path)) < 0 ||
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	85 c0                	test   %eax,%eax
801054b7:	78 4f                	js     80105508 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801054b9:	83 ec 08             	sub    $0x8,%esp
801054bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054bf:	50                   	push   %eax
801054c0:	6a 02                	push   $0x2
801054c2:	e8 59 f5 ff ff       	call   80104a20 <argint>
     argint(1, &major) < 0 ||
801054c7:	83 c4 10             	add    $0x10,%esp
801054ca:	85 c0                	test   %eax,%eax
801054cc:	78 3a                	js     80105508 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054ce:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801054d2:	83 ec 0c             	sub    $0xc,%esp
801054d5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054d9:	ba 03 00 00 00       	mov    $0x3,%edx
801054de:	50                   	push   %eax
801054df:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054e2:	e8 d9 f6 ff ff       	call   80104bc0 <create>
     argint(2, &minor) < 0 ||
801054e7:	83 c4 10             	add    $0x10,%esp
801054ea:	85 c0                	test   %eax,%eax
801054ec:	74 1a                	je     80105508 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054ee:	83 ec 0c             	sub    $0xc,%esp
801054f1:	50                   	push   %eax
801054f2:	e8 09 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
801054f7:	e8 24 d9 ff ff       	call   80102e20 <end_op>
  return 0;
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	31 c0                	xor    %eax,%eax
}
80105501:	c9                   	leave  
80105502:	c3                   	ret    
80105503:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105507:	90                   	nop
    end_op();
80105508:	e8 13 d9 ff ff       	call   80102e20 <end_op>
    return -1;
8010550d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105512:	c9                   	leave  
80105513:	c3                   	ret    
80105514:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010551f:	90                   	nop

80105520 <sys_chdir>:

int
sys_chdir(void)
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
80105525:	89 e5                	mov    %esp,%ebp
80105527:	56                   	push   %esi
80105528:	53                   	push   %ebx
80105529:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010552c:	e8 af e4 ff ff       	call   801039e0 <myproc>
80105531:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105533:	e8 78 d8 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105538:	83 ec 08             	sub    $0x8,%esp
8010553b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553e:	50                   	push   %eax
8010553f:	6a 00                	push   $0x0
80105541:	e8 8a f5 ff ff       	call   80104ad0 <argstr>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	78 73                	js     801055c0 <sys_chdir+0xa0>
8010554d:	83 ec 0c             	sub    $0xc,%esp
80105550:	ff 75 f4             	pushl  -0xc(%ebp)
80105553:	e8 d8 ca ff ff       	call   80102030 <namei>
80105558:	83 c4 10             	add    $0x10,%esp
8010555b:	89 c3                	mov    %eax,%ebx
8010555d:	85 c0                	test   %eax,%eax
8010555f:	74 5f                	je     801055c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105561:	83 ec 0c             	sub    $0xc,%esp
80105564:	50                   	push   %eax
80105565:	e8 f6 c1 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010556a:	83 c4 10             	add    $0x10,%esp
8010556d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105572:	75 2c                	jne    801055a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105574:	83 ec 0c             	sub    $0xc,%esp
80105577:	53                   	push   %ebx
80105578:	e8 c3 c2 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
8010557d:	58                   	pop    %eax
8010557e:	ff 76 68             	pushl  0x68(%esi)
80105581:	e8 0a c3 ff ff       	call   80101890 <iput>
  end_op();
80105586:	e8 95 d8 ff ff       	call   80102e20 <end_op>
  curproc->cwd = ip;
8010558b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	31 c0                	xor    %eax,%eax
}
80105593:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105596:	5b                   	pop    %ebx
80105597:	5e                   	pop    %esi
80105598:	5d                   	pop    %ebp
80105599:	c3                   	ret    
8010559a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	53                   	push   %ebx
801055a4:	e8 57 c4 ff ff       	call   80101a00 <iunlockput>
    end_op();
801055a9:	e8 72 d8 ff ff       	call   80102e20 <end_op>
    return -1;
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b6:	eb db                	jmp    80105593 <sys_chdir+0x73>
801055b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055bf:	90                   	nop
    end_op();
801055c0:	e8 5b d8 ff ff       	call   80102e20 <end_op>
    return -1;
801055c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ca:	eb c7                	jmp    80105593 <sys_chdir+0x73>
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055d0 <sys_exec>:

int
sys_exec(void)
{
801055d0:	f3 0f 1e fb          	endbr32 
801055d4:	55                   	push   %ebp
801055d5:	89 e5                	mov    %esp,%ebp
801055d7:	57                   	push   %edi
801055d8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055d9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055df:	53                   	push   %ebx
801055e0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055e6:	50                   	push   %eax
801055e7:	6a 00                	push   $0x0
801055e9:	e8 e2 f4 ff ff       	call   80104ad0 <argstr>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	0f 88 8b 00 00 00    	js     80105684 <sys_exec+0xb4>
801055f9:	83 ec 08             	sub    $0x8,%esp
801055fc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105602:	50                   	push   %eax
80105603:	6a 01                	push   $0x1
80105605:	e8 16 f4 ff ff       	call   80104a20 <argint>
8010560a:	83 c4 10             	add    $0x10,%esp
8010560d:	85 c0                	test   %eax,%eax
8010560f:	78 73                	js     80105684 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105611:	83 ec 04             	sub    $0x4,%esp
80105614:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010561a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010561c:	68 80 00 00 00       	push   $0x80
80105621:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105627:	6a 00                	push   $0x0
80105629:	50                   	push   %eax
8010562a:	e8 11 f1 ff ff       	call   80104740 <memset>
8010562f:	83 c4 10             	add    $0x10,%esp
80105632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105638:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010563e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105645:	83 ec 08             	sub    $0x8,%esp
80105648:	57                   	push   %edi
80105649:	01 f0                	add    %esi,%eax
8010564b:	50                   	push   %eax
8010564c:	e8 2f f3 ff ff       	call   80104980 <fetchint>
80105651:	83 c4 10             	add    $0x10,%esp
80105654:	85 c0                	test   %eax,%eax
80105656:	78 2c                	js     80105684 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105658:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010565e:	85 c0                	test   %eax,%eax
80105660:	74 36                	je     80105698 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105662:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105668:	83 ec 08             	sub    $0x8,%esp
8010566b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010566e:	52                   	push   %edx
8010566f:	50                   	push   %eax
80105670:	e8 4b f3 ff ff       	call   801049c0 <fetchstr>
80105675:	83 c4 10             	add    $0x10,%esp
80105678:	85 c0                	test   %eax,%eax
8010567a:	78 08                	js     80105684 <sys_exec+0xb4>
  for(i=0;; i++){
8010567c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010567f:	83 fb 20             	cmp    $0x20,%ebx
80105682:	75 b4                	jne    80105638 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105684:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010568c:	5b                   	pop    %ebx
8010568d:	5e                   	pop    %esi
8010568e:	5f                   	pop    %edi
8010568f:	5d                   	pop    %ebp
80105690:	c3                   	ret    
80105691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105698:	83 ec 08             	sub    $0x8,%esp
8010569b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801056a1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056a8:	00 00 00 00 
  return exec(path, argv);
801056ac:	50                   	push   %eax
801056ad:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801056b3:	e8 c8 b3 ff ff       	call   80100a80 <exec>
801056b8:	83 c4 10             	add    $0x10,%esp
}
801056bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056be:	5b                   	pop    %ebx
801056bf:	5e                   	pop    %esi
801056c0:	5f                   	pop    %edi
801056c1:	5d                   	pop    %ebp
801056c2:	c3                   	ret    
801056c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056d0 <sys_pipe>:

int
sys_pipe(void)
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	57                   	push   %edi
801056d8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056d9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801056dc:	53                   	push   %ebx
801056dd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056e0:	6a 08                	push   $0x8
801056e2:	50                   	push   %eax
801056e3:	6a 00                	push   $0x0
801056e5:	e8 86 f3 ff ff       	call   80104a70 <argptr>
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	85 c0                	test   %eax,%eax
801056ef:	78 4e                	js     8010573f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056f1:	83 ec 08             	sub    $0x8,%esp
801056f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056f7:	50                   	push   %eax
801056f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056fb:	50                   	push   %eax
801056fc:	e8 6f dd ff ff       	call   80103470 <pipealloc>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	85 c0                	test   %eax,%eax
80105706:	78 37                	js     8010573f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105708:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010570b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010570d:	e8 ce e2 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105718:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010571c:	85 f6                	test   %esi,%esi
8010571e:	74 30                	je     80105750 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105720:	83 c3 01             	add    $0x1,%ebx
80105723:	83 fb 10             	cmp    $0x10,%ebx
80105726:	75 f0                	jne    80105718 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105728:	83 ec 0c             	sub    $0xc,%esp
8010572b:	ff 75 e0             	pushl  -0x20(%ebp)
8010572e:	e8 8d b7 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105733:	58                   	pop    %eax
80105734:	ff 75 e4             	pushl  -0x1c(%ebp)
80105737:	e8 84 b7 ff ff       	call   80100ec0 <fileclose>
    return -1;
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105744:	eb 5b                	jmp    801057a1 <sys_pipe+0xd1>
80105746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105750:	8d 73 08             	lea    0x8(%ebx),%esi
80105753:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105757:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010575a:	e8 81 e2 ff ff       	call   801039e0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010575f:	31 d2                	xor    %edx,%edx
80105761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105768:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010576c:	85 c9                	test   %ecx,%ecx
8010576e:	74 20                	je     80105790 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105770:	83 c2 01             	add    $0x1,%edx
80105773:	83 fa 10             	cmp    $0x10,%edx
80105776:	75 f0                	jne    80105768 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105778:	e8 63 e2 ff ff       	call   801039e0 <myproc>
8010577d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105784:	00 
80105785:	eb a1                	jmp    80105728 <sys_pipe+0x58>
80105787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105790:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105794:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105797:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105799:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010579c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010579f:	31 c0                	xor    %eax,%eax
}
801057a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057a4:	5b                   	pop    %ebx
801057a5:	5e                   	pop    %esi
801057a6:	5f                   	pop    %edi
801057a7:	5d                   	pop    %ebp
801057a8:	c3                   	ret    
801057a9:	66 90                	xchg   %ax,%ax
801057ab:	66 90                	xchg   %ax,%ax
801057ad:	66 90                	xchg   %ax,%ax
801057af:	90                   	nop

801057b0 <sys_fork>:
#include "syscall.h"
#include "sysinfo.h"

int
sys_fork(void)
{
801057b0:	f3 0f 1e fb          	endbr32 
  return fork();
801057b4:	e9 d7 e3 ff ff       	jmp    80103b90 <fork>
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_exit>:
}

int
sys_exit(void)
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	83 ec 08             	sub    $0x8,%esp
  exit();
801057ca:	e8 41 e6 ff ff       	call   80103e10 <exit>
  return 0;  // not reached
}
801057cf:	31 c0                	xor    %eax,%eax
801057d1:	c9                   	leave  
801057d2:	c3                   	ret    
801057d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057e0 <sys_wait>:

int
sys_wait(void)
{
801057e0:	f3 0f 1e fb          	endbr32 
  return wait();
801057e4:	e9 77 e8 ff ff       	jmp    80104060 <wait>
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_kill>:
}

int
sys_kill(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057fd:	50                   	push   %eax
801057fe:	6a 00                	push   $0x0
80105800:	e8 1b f2 ff ff       	call   80104a20 <argint>
80105805:	83 c4 10             	add    $0x10,%esp
80105808:	85 c0                	test   %eax,%eax
8010580a:	78 14                	js     80105820 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010580c:	83 ec 0c             	sub    $0xc,%esp
8010580f:	ff 75 f4             	pushl  -0xc(%ebp)
80105812:	e8 a9 e9 ff ff       	call   801041c0 <kill>
80105817:	83 c4 10             	add    $0x10,%esp
}
8010581a:	c9                   	leave  
8010581b:	c3                   	ret    
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105820:	c9                   	leave  
    return -1;
80105821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105826:	c3                   	ret    
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax

80105830 <sys_getpid>:

int
sys_getpid(void)
{
80105830:	f3 0f 1e fb          	endbr32 
80105834:	55                   	push   %ebp
80105835:	89 e5                	mov    %esp,%ebp
80105837:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010583a:	e8 a1 e1 ff ff       	call   801039e0 <myproc>
8010583f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105842:	c9                   	leave  
80105843:	c3                   	ret    
80105844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop

80105850 <sys_sbrk>:

int
sys_sbrk(void)
{
80105850:	f3 0f 1e fb          	endbr32 
80105854:	55                   	push   %ebp
80105855:	89 e5                	mov    %esp,%ebp
80105857:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105858:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010585b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010585e:	50                   	push   %eax
8010585f:	6a 00                	push   $0x0
80105861:	e8 ba f1 ff ff       	call   80104a20 <argint>
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	85 c0                	test   %eax,%eax
8010586b:	78 23                	js     80105890 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010586d:	e8 6e e1 ff ff       	call   801039e0 <myproc>
  if(growproc(n) < 0)
80105872:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105875:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105877:	ff 75 f4             	pushl  -0xc(%ebp)
8010587a:	e8 91 e2 ff ff       	call   80103b10 <growproc>
8010587f:	83 c4 10             	add    $0x10,%esp
80105882:	85 c0                	test   %eax,%eax
80105884:	78 0a                	js     80105890 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105886:	89 d8                	mov    %ebx,%eax
80105888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010588b:	c9                   	leave  
8010588c:	c3                   	ret    
8010588d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105890:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105895:	eb ef                	jmp    80105886 <sys_sbrk+0x36>
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_sleep>:

int
sys_sleep(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058ab:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ae:	50                   	push   %eax
801058af:	6a 00                	push   $0x0
801058b1:	e8 6a f1 ff ff       	call   80104a20 <argint>
801058b6:	83 c4 10             	add    $0x10,%esp
801058b9:	85 c0                	test   %eax,%eax
801058bb:	0f 88 86 00 00 00    	js     80105947 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801058c1:	83 ec 0c             	sub    $0xc,%esp
801058c4:	68 60 4d 11 80       	push   $0x80114d60
801058c9:	e8 62 ed ff ff       	call   80104630 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801058d1:	8b 1d a4 55 11 80    	mov    0x801155a4,%ebx
  while(ticks - ticks0 < n){
801058d7:	83 c4 10             	add    $0x10,%esp
801058da:	85 d2                	test   %edx,%edx
801058dc:	75 23                	jne    80105901 <sys_sleep+0x61>
801058de:	eb 50                	jmp    80105930 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801058e0:	83 ec 08             	sub    $0x8,%esp
801058e3:	68 60 4d 11 80       	push   $0x80114d60
801058e8:	68 a4 55 11 80       	push   $0x801155a4
801058ed:	e8 ae e6 ff ff       	call   80103fa0 <sleep>
  while(ticks - ticks0 < n){
801058f2:	a1 a4 55 11 80       	mov    0x801155a4,%eax
801058f7:	83 c4 10             	add    $0x10,%esp
801058fa:	29 d8                	sub    %ebx,%eax
801058fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801058ff:	73 2f                	jae    80105930 <sys_sleep+0x90>
    if(myproc()->killed){
80105901:	e8 da e0 ff ff       	call   801039e0 <myproc>
80105906:	8b 40 24             	mov    0x24(%eax),%eax
80105909:	85 c0                	test   %eax,%eax
8010590b:	74 d3                	je     801058e0 <sys_sleep+0x40>
      release(&tickslock);
8010590d:	83 ec 0c             	sub    $0xc,%esp
80105910:	68 60 4d 11 80       	push   $0x80114d60
80105915:	e8 d6 ed ff ff       	call   801046f0 <release>
  }
  release(&tickslock);
  return 0;
}
8010591a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010591d:	83 c4 10             	add    $0x10,%esp
80105920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105925:	c9                   	leave  
80105926:	c3                   	ret    
80105927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010592e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105930:	83 ec 0c             	sub    $0xc,%esp
80105933:	68 60 4d 11 80       	push   $0x80114d60
80105938:	e8 b3 ed ff ff       	call   801046f0 <release>
  return 0;
8010593d:	83 c4 10             	add    $0x10,%esp
80105940:	31 c0                	xor    %eax,%eax
}
80105942:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105945:	c9                   	leave  
80105946:	c3                   	ret    
    return -1;
80105947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010594c:	eb f4                	jmp    80105942 <sys_sleep+0xa2>
8010594e:	66 90                	xchg   %ax,%ax

80105950 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105950:	f3 0f 1e fb          	endbr32 
80105954:	55                   	push   %ebp
80105955:	89 e5                	mov    %esp,%ebp
80105957:	53                   	push   %ebx
80105958:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010595b:	68 60 4d 11 80       	push   $0x80114d60
80105960:	e8 cb ec ff ff       	call   80104630 <acquire>
  xticks = ticks;
80105965:	8b 1d a4 55 11 80    	mov    0x801155a4,%ebx
  release(&tickslock);
8010596b:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105972:	e8 79 ed ff ff       	call   801046f0 <release>
  return xticks;
}
80105977:	89 d8                	mov    %ebx,%eax
80105979:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010597c:	c9                   	leave  
8010597d:	c3                   	ret    
8010597e:	66 90                	xchg   %ax,%ax

80105980 <trace>:

unsigned int trace (unsigned int mask, unsigned int setting)
{
80105980:	f3 0f 1e fb          	endbr32 
80105984:	55                   	push   %ebp
80105985:	89 e5                	mov    %esp,%ebp
80105987:	56                   	push   %esi
80105988:	53                   	push   %ebx
80105989:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint ptracemask;
  acquire(&tracemasklock);
8010598c:	83 ec 0c             	sub    $0xc,%esp
8010598f:	68 c0 55 11 80       	push   $0x801155c0
80105994:	e8 97 ec ff ff       	call   80104630 <acquire>
  ptracemask = tracemask;
80105999:	8b 35 a0 55 11 80    	mov    0x801155a0,%esi
  if (setting == 0) {
    tracemask = tracemask & (~mask);
8010599f:	8b 55 0c             	mov    0xc(%ebp),%edx
801059a2:	89 d8                	mov    %ebx,%eax
801059a4:	f7 d0                	not    %eax
  }else {
    tracemask = tracemask | mask;
  }
  release(&tracemasklock);
801059a6:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
    tracemask = tracemask & (~mask);
801059ad:	21 f0                	and    %esi,%eax
801059af:	09 f3                	or     %esi,%ebx
801059b1:	85 d2                	test   %edx,%edx
801059b3:	0f 44 d8             	cmove  %eax,%ebx
801059b6:	89 1d a0 55 11 80    	mov    %ebx,0x801155a0
  release(&tracemasklock);
801059bc:	e8 2f ed ff ff       	call   801046f0 <release>
  return ptracemask;
}
801059c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059c4:	89 f0                	mov    %esi,%eax
801059c6:	5b                   	pop    %ebx
801059c7:	5e                   	pop    %esi
801059c8:	5d                   	pop    %ebp
801059c9:	c3                   	ret    
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059d0 <sys_trace>:

int
sys_trace(void)
{
801059d0:	f3 0f 1e fb          	endbr32 
801059d4:	55                   	push   %ebp
801059d5:	89 e5                	mov    %esp,%ebp
801059d7:	83 ec 20             	sub    $0x20,%esp
  int mask, setting;
  if(argint(0, &mask) < 0 || argint(1, &setting) < 0)
801059da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059dd:	50                   	push   %eax
801059de:	6a 00                	push   $0x0
801059e0:	e8 3b f0 ff ff       	call   80104a20 <argint>
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	85 c0                	test   %eax,%eax
801059ea:	78 2c                	js     80105a18 <sys_trace+0x48>
801059ec:	83 ec 08             	sub    $0x8,%esp
801059ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f2:	50                   	push   %eax
801059f3:	6a 01                	push   $0x1
801059f5:	e8 26 f0 ff ff       	call   80104a20 <argint>
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	85 c0                	test   %eax,%eax
801059ff:	78 17                	js     80105a18 <sys_trace+0x48>
    return -1;
  return trace(mask, setting);
80105a01:	83 ec 08             	sub    $0x8,%esp
80105a04:	ff 75 f4             	pushl  -0xc(%ebp)
80105a07:	ff 75 f0             	pushl  -0x10(%ebp)
80105a0a:	e8 71 ff ff ff       	call   80105980 <trace>
80105a0f:	83 c4 10             	add    $0x10,%esp
}
80105a12:	c9                   	leave  
80105a13:	c3                   	ret    
80105a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a18:	c9                   	leave  
    return -1;
80105a19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1e:	c3                   	ret    
80105a1f:	90                   	nop

80105a20 <sys_sysinfo>:

int 
sys_sysinfo(void) {
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	53                   	push   %ebx
    struct sysinfo info;
    struct sysinfo *user_info;

    // Get the user-space pointer from the argument
    if (argptr(0, (void*)&user_info, sizeof(*user_info)) < 0)
80105a28:	8d 45 ec             	lea    -0x14(%ebp),%eax
sys_sysinfo(void) {
80105a2b:	83 ec 18             	sub    $0x18,%esp
    if (argptr(0, (void*)&user_info, sizeof(*user_info)) < 0)
80105a2e:	6a 08                	push   $0x8
80105a30:	50                   	push   %eax
80105a31:	6a 00                	push   $0x0
80105a33:	e8 38 f0 ff ff       	call   80104a70 <argptr>
80105a38:	83 c4 10             	add    $0x10,%esp
80105a3b:	85 c0                	test   %eax,%eax
80105a3d:	78 39                	js     80105a78 <sys_sysinfo+0x58>
        return -1;

    // Calculate free memory
    info.memfree = kgetfreemem();
80105a3f:	e8 5c cc ff ff       	call   801026a0 <kgetfreemem>
80105a44:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Get the number of processes
    info.numproc = kgetnumproc();
80105a47:	e8 d4 e8 ff ff       	call   80104320 <kgetnumproc>

    // Copy the info to user space
    if (copyout(myproc()->pgdir, (uint)user_info, &info, sizeof(info)) < 0)
80105a4c:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    info.numproc = kgetnumproc();
80105a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (copyout(myproc()->pgdir, (uint)user_info, &info, sizeof(info)) < 0)
80105a52:	e8 89 df ff ff       	call   801039e0 <myproc>
80105a57:	8d 55 f0             	lea    -0x10(%ebp),%edx
80105a5a:	6a 08                	push   $0x8
80105a5c:	52                   	push   %edx
80105a5d:	53                   	push   %ebx
80105a5e:	ff 70 04             	pushl  0x4(%eax)
80105a61:	e8 2a 18 00 00       	call   80107290 <copyout>
80105a66:	83 c4 10             	add    $0x10,%esp
80105a69:	c1 f8 1f             	sar    $0x1f,%eax
        return -1;

    return 0;
}
80105a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a6f:	c9                   	leave  
80105a70:	c3                   	ret    
80105a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105a78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7d:	eb ed                	jmp    80105a6c <sys_sysinfo+0x4c>
80105a7f:	90                   	nop

80105a80 <sys_halt>:

int
sys_halt(void)
{
80105a80:	f3 0f 1e fb          	endbr32 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a84:	b8 00 20 00 00       	mov    $0x2000,%eax
80105a89:	ba 04 06 00 00       	mov    $0x604,%edx
80105a8e:	66 ef                	out    %ax,(%dx)
80105a90:	ba 04 b0 ff ff       	mov    $0xffffb004,%edx
80105a95:	66 ef                	out    %ax,(%dx)
80105a97:	31 c0                	xor    %eax,%eax
80105a99:	ba 01 05 00 00       	mov    $0x501,%edx
80105a9e:	66 ef                	out    %ax,(%dx)
  outw(0x604, 0x2000);
  outw(0xb004, 0x2000);
  outw(0x501, 0x0);

  return 0;
}
80105aa0:	31 c0                	xor    %eax,%eax
80105aa2:	c3                   	ret    

80105aa3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105aa3:	1e                   	push   %ds
  pushl %es
80105aa4:	06                   	push   %es
  pushl %fs
80105aa5:	0f a0                	push   %fs
  pushl %gs
80105aa7:	0f a8                	push   %gs
  pushal
80105aa9:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105aaa:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105aae:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105ab0:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105ab2:	54                   	push   %esp
  call trap
80105ab3:	e8 d8 00 00 00       	call   80105b90 <trap>
  addl $4, %esp
80105ab8:	83 c4 04             	add    $0x4,%esp

80105abb <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105abb:	61                   	popa   
  popl %gs
80105abc:	0f a9                	pop    %gs
  popl %fs
80105abe:	0f a1                	pop    %fs
  popl %es
80105ac0:	07                   	pop    %es
  popl %ds
80105ac1:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ac2:	83 c4 08             	add    $0x8,%esp
  iret
80105ac5:	cf                   	iret   
80105ac6:	66 90                	xchg   %ax,%ax
80105ac8:	66 90                	xchg   %ax,%ax
80105aca:	66 90                	xchg   %ax,%ax
80105acc:	66 90                	xchg   %ax,%ax
80105ace:	66 90                	xchg   %ax,%ax

80105ad0 <tvinit>:
uint ticks;
uint tracemask;

void
tvinit(void)
{
80105ad0:	f3 0f 1e fb          	endbr32 
80105ad4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105ad5:	31 c0                	xor    %eax,%eax
{
80105ad7:	89 e5                	mov    %esp,%ebp
80105ad9:	83 ec 08             	sub    $0x8,%esp
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ae0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105ae7:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
80105aee:	08 00 00 8e 
80105af2:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105af9:	80 
80105afa:	c1 ea 10             	shr    $0x10,%edx
80105afd:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
80105b04:	80 
  for(i = 0; i < 256; i++)
80105b05:	83 c0 01             	add    $0x1,%eax
80105b08:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b0d:	75 d1                	jne    80105ae0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b0f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b12:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105b17:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
80105b1e:	00 00 ef 
  initlock(&tickslock, "time");
80105b21:	68 c5 7a 10 80       	push   $0x80107ac5
80105b26:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b2b:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105b31:	c1 e8 10             	shr    $0x10,%eax
80105b34:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
80105b3a:	e8 71 e9 ff ff       	call   801044b0 <initlock>
  initlock(&tracemasklock, "tracemask");
80105b3f:	58                   	pop    %eax
80105b40:	5a                   	pop    %edx
80105b41:	68 ca 7a 10 80       	push   $0x80107aca
80105b46:	68 c0 55 11 80       	push   $0x801155c0
80105b4b:	e8 60 e9 ff ff       	call   801044b0 <initlock>
}
80105b50:	83 c4 10             	add    $0x10,%esp
80105b53:	c9                   	leave  
80105b54:	c3                   	ret    
80105b55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <idtinit>:

void
idtinit(void)
{
80105b60:	f3 0f 1e fb          	endbr32 
80105b64:	55                   	push   %ebp
  pd[0] = size-1;
80105b65:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b6a:	89 e5                	mov    %esp,%ebp
80105b6c:	83 ec 10             	sub    $0x10,%esp
80105b6f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b73:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105b78:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b7c:	c1 e8 10             	shr    $0x10,%eax
80105b7f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b83:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b86:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b89:	c9                   	leave  
80105b8a:	c3                   	ret    
80105b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop

80105b90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	57                   	push   %edi
80105b98:	56                   	push   %esi
80105b99:	53                   	push   %ebx
80105b9a:	83 ec 1c             	sub    $0x1c,%esp
80105b9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105ba0:	8b 43 30             	mov    0x30(%ebx),%eax
80105ba3:	83 f8 40             	cmp    $0x40,%eax
80105ba6:	0f 84 bc 01 00 00    	je     80105d68 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105bac:	83 e8 20             	sub    $0x20,%eax
80105baf:	83 f8 1f             	cmp    $0x1f,%eax
80105bb2:	77 08                	ja     80105bbc <trap+0x2c>
80105bb4:	3e ff 24 85 78 7b 10 	notrack jmp *-0x7fef8488(,%eax,4)
80105bbb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105bbc:	e8 1f de ff ff       	call   801039e0 <myproc>
80105bc1:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bc4:	85 c0                	test   %eax,%eax
80105bc6:	0f 84 eb 01 00 00    	je     80105db7 <trap+0x227>
80105bcc:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105bd0:	0f 84 e1 01 00 00    	je     80105db7 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105bd6:	0f 20 d1             	mov    %cr2,%ecx
80105bd9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bdc:	e8 df dd ff ff       	call   801039c0 <cpuid>
80105be1:	8b 73 30             	mov    0x30(%ebx),%esi
80105be4:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105be7:	8b 43 34             	mov    0x34(%ebx),%eax
80105bea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105bed:	e8 ee dd ff ff       	call   801039e0 <myproc>
80105bf2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105bf5:	e8 e6 dd ff ff       	call   801039e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bfa:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105bfd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c00:	51                   	push   %ecx
80105c01:	57                   	push   %edi
80105c02:	52                   	push   %edx
80105c03:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c06:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c07:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c0a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c0d:	56                   	push   %esi
80105c0e:	ff 70 10             	pushl  0x10(%eax)
80105c11:	68 34 7b 10 80       	push   $0x80107b34
80105c16:	e8 95 aa ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105c1b:	83 c4 20             	add    $0x20,%esp
80105c1e:	e8 bd dd ff ff       	call   801039e0 <myproc>
80105c23:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c2a:	e8 b1 dd ff ff       	call   801039e0 <myproc>
80105c2f:	85 c0                	test   %eax,%eax
80105c31:	74 1d                	je     80105c50 <trap+0xc0>
80105c33:	e8 a8 dd ff ff       	call   801039e0 <myproc>
80105c38:	8b 50 24             	mov    0x24(%eax),%edx
80105c3b:	85 d2                	test   %edx,%edx
80105c3d:	74 11                	je     80105c50 <trap+0xc0>
80105c3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c43:	83 e0 03             	and    $0x3,%eax
80105c46:	66 83 f8 03          	cmp    $0x3,%ax
80105c4a:	0f 84 50 01 00 00    	je     80105da0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c50:	e8 8b dd ff ff       	call   801039e0 <myproc>
80105c55:	85 c0                	test   %eax,%eax
80105c57:	74 0f                	je     80105c68 <trap+0xd8>
80105c59:	e8 82 dd ff ff       	call   801039e0 <myproc>
80105c5e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105c62:	0f 84 e8 00 00 00    	je     80105d50 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c68:	e8 73 dd ff ff       	call   801039e0 <myproc>
80105c6d:	85 c0                	test   %eax,%eax
80105c6f:	74 1d                	je     80105c8e <trap+0xfe>
80105c71:	e8 6a dd ff ff       	call   801039e0 <myproc>
80105c76:	8b 40 24             	mov    0x24(%eax),%eax
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	74 11                	je     80105c8e <trap+0xfe>
80105c7d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c81:	83 e0 03             	and    $0x3,%eax
80105c84:	66 83 f8 03          	cmp    $0x3,%ax
80105c88:	0f 84 03 01 00 00    	je     80105d91 <trap+0x201>
    exit();
80105c8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c91:	5b                   	pop    %ebx
80105c92:	5e                   	pop    %esi
80105c93:	5f                   	pop    %edi
80105c94:	5d                   	pop    %ebp
80105c95:	c3                   	ret    
    ideintr();
80105c96:	e8 45 c5 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
80105c9b:	e8 a0 cc ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ca0:	e8 3b dd ff ff       	call   801039e0 <myproc>
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	75 8a                	jne    80105c33 <trap+0xa3>
80105ca9:	eb a5                	jmp    80105c50 <trap+0xc0>
    if(cpuid() == 0){
80105cab:	e8 10 dd ff ff       	call   801039c0 <cpuid>
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	75 e7                	jne    80105c9b <trap+0x10b>
      acquire(&tickslock);
80105cb4:	83 ec 0c             	sub    $0xc,%esp
80105cb7:	68 60 4d 11 80       	push   $0x80114d60
80105cbc:	e8 6f e9 ff ff       	call   80104630 <acquire>
      wakeup(&ticks);
80105cc1:	c7 04 24 a4 55 11 80 	movl   $0x801155a4,(%esp)
      ticks++;
80105cc8:	83 05 a4 55 11 80 01 	addl   $0x1,0x801155a4
      wakeup(&ticks);
80105ccf:	e8 8c e4 ff ff       	call   80104160 <wakeup>
      release(&tickslock);
80105cd4:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105cdb:	e8 10 ea ff ff       	call   801046f0 <release>
80105ce0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105ce3:	eb b6                	jmp    80105c9b <trap+0x10b>
    kbdintr();
80105ce5:	e8 16 cb ff ff       	call   80102800 <kbdintr>
    lapiceoi();
80105cea:	e8 51 cc ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cef:	e8 ec dc ff ff       	call   801039e0 <myproc>
80105cf4:	85 c0                	test   %eax,%eax
80105cf6:	0f 85 37 ff ff ff    	jne    80105c33 <trap+0xa3>
80105cfc:	e9 4f ff ff ff       	jmp    80105c50 <trap+0xc0>
    uartintr();
80105d01:	e8 4a 02 00 00       	call   80105f50 <uartintr>
    lapiceoi();
80105d06:	e8 35 cc ff ff       	call   80102940 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d0b:	e8 d0 dc ff ff       	call   801039e0 <myproc>
80105d10:	85 c0                	test   %eax,%eax
80105d12:	0f 85 1b ff ff ff    	jne    80105c33 <trap+0xa3>
80105d18:	e9 33 ff ff ff       	jmp    80105c50 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d1d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d20:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d24:	e8 97 dc ff ff       	call   801039c0 <cpuid>
80105d29:	57                   	push   %edi
80105d2a:	56                   	push   %esi
80105d2b:	50                   	push   %eax
80105d2c:	68 dc 7a 10 80       	push   $0x80107adc
80105d31:	e8 7a a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105d36:	e8 05 cc ff ff       	call   80102940 <lapiceoi>
    break;
80105d3b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d3e:	e8 9d dc ff ff       	call   801039e0 <myproc>
80105d43:	85 c0                	test   %eax,%eax
80105d45:	0f 85 e8 fe ff ff    	jne    80105c33 <trap+0xa3>
80105d4b:	e9 00 ff ff ff       	jmp    80105c50 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105d50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105d54:	0f 85 0e ff ff ff    	jne    80105c68 <trap+0xd8>
    yield();
80105d5a:	e8 f1 e1 ff ff       	call   80103f50 <yield>
80105d5f:	e9 04 ff ff ff       	jmp    80105c68 <trap+0xd8>
80105d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d68:	e8 73 dc ff ff       	call   801039e0 <myproc>
80105d6d:	8b 70 24             	mov    0x24(%eax),%esi
80105d70:	85 f6                	test   %esi,%esi
80105d72:	75 3c                	jne    80105db0 <trap+0x220>
    myproc()->tf = tf;
80105d74:	e8 67 dc ff ff       	call   801039e0 <myproc>
80105d79:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105d7c:	e8 8f ed ff ff       	call   80104b10 <syscall>
    if(myproc()->killed)
80105d81:	e8 5a dc ff ff       	call   801039e0 <myproc>
80105d86:	8b 48 24             	mov    0x24(%eax),%ecx
80105d89:	85 c9                	test   %ecx,%ecx
80105d8b:	0f 84 fd fe ff ff    	je     80105c8e <trap+0xfe>
80105d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d94:	5b                   	pop    %ebx
80105d95:	5e                   	pop    %esi
80105d96:	5f                   	pop    %edi
80105d97:	5d                   	pop    %ebp
      exit();
80105d98:	e9 73 e0 ff ff       	jmp    80103e10 <exit>
80105d9d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105da0:	e8 6b e0 ff ff       	call   80103e10 <exit>
80105da5:	e9 a6 fe ff ff       	jmp    80105c50 <trap+0xc0>
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105db0:	e8 5b e0 ff ff       	call   80103e10 <exit>
80105db5:	eb bd                	jmp    80105d74 <trap+0x1e4>
80105db7:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105dba:	e8 01 dc ff ff       	call   801039c0 <cpuid>
80105dbf:	83 ec 0c             	sub    $0xc,%esp
80105dc2:	56                   	push   %esi
80105dc3:	57                   	push   %edi
80105dc4:	50                   	push   %eax
80105dc5:	ff 73 30             	pushl  0x30(%ebx)
80105dc8:	68 00 7b 10 80       	push   $0x80107b00
80105dcd:	e8 de a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105dd2:	83 c4 14             	add    $0x14,%esp
80105dd5:	68 d4 7a 10 80       	push   $0x80107ad4
80105dda:	e8 b1 a5 ff ff       	call   80100390 <panic>
80105ddf:	90                   	nop

80105de0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105de0:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105de4:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105de9:	85 c0                	test   %eax,%eax
80105deb:	74 1b                	je     80105e08 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ded:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105df2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105df3:	a8 01                	test   $0x1,%al
80105df5:	74 11                	je     80105e08 <uartgetc+0x28>
80105df7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dfc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105dfd:	0f b6 c0             	movzbl %al,%eax
80105e00:	c3                   	ret    
80105e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e0d:	c3                   	ret    
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <uartputc.part.0>:
uartputc(int c)
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	57                   	push   %edi
80105e14:	89 c7                	mov    %eax,%edi
80105e16:	56                   	push   %esi
80105e17:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e1c:	53                   	push   %ebx
80105e1d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e22:	83 ec 0c             	sub    $0xc,%esp
80105e25:	eb 1b                	jmp    80105e42 <uartputc.part.0+0x32>
80105e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e2e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	6a 0a                	push   $0xa
80105e35:	e8 26 cb ff ff       	call   80102960 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e3a:	83 c4 10             	add    $0x10,%esp
80105e3d:	83 eb 01             	sub    $0x1,%ebx
80105e40:	74 07                	je     80105e49 <uartputc.part.0+0x39>
80105e42:	89 f2                	mov    %esi,%edx
80105e44:	ec                   	in     (%dx),%al
80105e45:	a8 20                	test   $0x20,%al
80105e47:	74 e7                	je     80105e30 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e4e:	89 f8                	mov    %edi,%eax
80105e50:	ee                   	out    %al,(%dx)
}
80105e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e54:	5b                   	pop    %ebx
80105e55:	5e                   	pop    %esi
80105e56:	5f                   	pop    %edi
80105e57:	5d                   	pop    %ebp
80105e58:	c3                   	ret    
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e60 <uartinit>:
{
80105e60:	f3 0f 1e fb          	endbr32 
80105e64:	55                   	push   %ebp
80105e65:	31 c9                	xor    %ecx,%ecx
80105e67:	89 c8                	mov    %ecx,%eax
80105e69:	89 e5                	mov    %esp,%ebp
80105e6b:	57                   	push   %edi
80105e6c:	56                   	push   %esi
80105e6d:	53                   	push   %ebx
80105e6e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105e73:	89 da                	mov    %ebx,%edx
80105e75:	83 ec 0c             	sub    $0xc,%esp
80105e78:	ee                   	out    %al,(%dx)
80105e79:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105e7e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e83:	89 fa                	mov    %edi,%edx
80105e85:	ee                   	out    %al,(%dx)
80105e86:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e8b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e90:	ee                   	out    %al,(%dx)
80105e91:	be f9 03 00 00       	mov    $0x3f9,%esi
80105e96:	89 c8                	mov    %ecx,%eax
80105e98:	89 f2                	mov    %esi,%edx
80105e9a:	ee                   	out    %al,(%dx)
80105e9b:	b8 03 00 00 00       	mov    $0x3,%eax
80105ea0:	89 fa                	mov    %edi,%edx
80105ea2:	ee                   	out    %al,(%dx)
80105ea3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ea8:	89 c8                	mov    %ecx,%eax
80105eaa:	ee                   	out    %al,(%dx)
80105eab:	b8 01 00 00 00       	mov    $0x1,%eax
80105eb0:	89 f2                	mov    %esi,%edx
80105eb2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eb3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105eb8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105eb9:	3c ff                	cmp    $0xff,%al
80105ebb:	74 52                	je     80105f0f <uartinit+0xaf>
  uart = 1;
80105ebd:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ec4:	00 00 00 
80105ec7:	89 da                	mov    %ebx,%edx
80105ec9:	ec                   	in     (%dx),%al
80105eca:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ecf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ed0:	83 ec 08             	sub    $0x8,%esp
80105ed3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105ed8:	bb f8 7b 10 80       	mov    $0x80107bf8,%ebx
  ioapicenable(IRQ_COM1, 0);
80105edd:	6a 00                	push   $0x0
80105edf:	6a 04                	push   $0x4
80105ee1:	e8 4a c5 ff ff       	call   80102430 <ioapicenable>
80105ee6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105ee9:	b8 78 00 00 00       	mov    $0x78,%eax
80105eee:	eb 04                	jmp    80105ef4 <uartinit+0x94>
80105ef0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105ef4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105efa:	85 d2                	test   %edx,%edx
80105efc:	74 08                	je     80105f06 <uartinit+0xa6>
    uartputc(*p);
80105efe:	0f be c0             	movsbl %al,%eax
80105f01:	e8 0a ff ff ff       	call   80105e10 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105f06:	89 f0                	mov    %esi,%eax
80105f08:	83 c3 01             	add    $0x1,%ebx
80105f0b:	84 c0                	test   %al,%al
80105f0d:	75 e1                	jne    80105ef0 <uartinit+0x90>
}
80105f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f12:	5b                   	pop    %ebx
80105f13:	5e                   	pop    %esi
80105f14:	5f                   	pop    %edi
80105f15:	5d                   	pop    %ebp
80105f16:	c3                   	ret    
80105f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f1e:	66 90                	xchg   %ax,%ax

80105f20 <uartputc>:
{
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
  if(!uart)
80105f25:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105f2b:	89 e5                	mov    %esp,%ebp
80105f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105f30:	85 d2                	test   %edx,%edx
80105f32:	74 0c                	je     80105f40 <uartputc+0x20>
}
80105f34:	5d                   	pop    %ebp
80105f35:	e9 d6 fe ff ff       	jmp    80105e10 <uartputc.part.0>
80105f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f40:	5d                   	pop    %ebp
80105f41:	c3                   	ret    
80105f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f50 <uartintr>:

void
uartintr(void)
{
80105f50:	f3 0f 1e fb          	endbr32 
80105f54:	55                   	push   %ebp
80105f55:	89 e5                	mov    %esp,%ebp
80105f57:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f5a:	68 e0 5d 10 80       	push   $0x80105de0
80105f5f:	e8 fc a8 ff ff       	call   80100860 <consoleintr>
}
80105f64:	83 c4 10             	add    $0x10,%esp
80105f67:	c9                   	leave  
80105f68:	c3                   	ret    

80105f69 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $0
80105f6b:	6a 00                	push   $0x0
  jmp alltraps
80105f6d:	e9 31 fb ff ff       	jmp    80105aa3 <alltraps>

80105f72 <vector1>:
.globl vector1
vector1:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $1
80105f74:	6a 01                	push   $0x1
  jmp alltraps
80105f76:	e9 28 fb ff ff       	jmp    80105aa3 <alltraps>

80105f7b <vector2>:
.globl vector2
vector2:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $2
80105f7d:	6a 02                	push   $0x2
  jmp alltraps
80105f7f:	e9 1f fb ff ff       	jmp    80105aa3 <alltraps>

80105f84 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $3
80105f86:	6a 03                	push   $0x3
  jmp alltraps
80105f88:	e9 16 fb ff ff       	jmp    80105aa3 <alltraps>

80105f8d <vector4>:
.globl vector4
vector4:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $4
80105f8f:	6a 04                	push   $0x4
  jmp alltraps
80105f91:	e9 0d fb ff ff       	jmp    80105aa3 <alltraps>

80105f96 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $5
80105f98:	6a 05                	push   $0x5
  jmp alltraps
80105f9a:	e9 04 fb ff ff       	jmp    80105aa3 <alltraps>

80105f9f <vector6>:
.globl vector6
vector6:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $6
80105fa1:	6a 06                	push   $0x6
  jmp alltraps
80105fa3:	e9 fb fa ff ff       	jmp    80105aa3 <alltraps>

80105fa8 <vector7>:
.globl vector7
vector7:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $7
80105faa:	6a 07                	push   $0x7
  jmp alltraps
80105fac:	e9 f2 fa ff ff       	jmp    80105aa3 <alltraps>

80105fb1 <vector8>:
.globl vector8
vector8:
  pushl $8
80105fb1:	6a 08                	push   $0x8
  jmp alltraps
80105fb3:	e9 eb fa ff ff       	jmp    80105aa3 <alltraps>

80105fb8 <vector9>:
.globl vector9
vector9:
  pushl $0
80105fb8:	6a 00                	push   $0x0
  pushl $9
80105fba:	6a 09                	push   $0x9
  jmp alltraps
80105fbc:	e9 e2 fa ff ff       	jmp    80105aa3 <alltraps>

80105fc1 <vector10>:
.globl vector10
vector10:
  pushl $10
80105fc1:	6a 0a                	push   $0xa
  jmp alltraps
80105fc3:	e9 db fa ff ff       	jmp    80105aa3 <alltraps>

80105fc8 <vector11>:
.globl vector11
vector11:
  pushl $11
80105fc8:	6a 0b                	push   $0xb
  jmp alltraps
80105fca:	e9 d4 fa ff ff       	jmp    80105aa3 <alltraps>

80105fcf <vector12>:
.globl vector12
vector12:
  pushl $12
80105fcf:	6a 0c                	push   $0xc
  jmp alltraps
80105fd1:	e9 cd fa ff ff       	jmp    80105aa3 <alltraps>

80105fd6 <vector13>:
.globl vector13
vector13:
  pushl $13
80105fd6:	6a 0d                	push   $0xd
  jmp alltraps
80105fd8:	e9 c6 fa ff ff       	jmp    80105aa3 <alltraps>

80105fdd <vector14>:
.globl vector14
vector14:
  pushl $14
80105fdd:	6a 0e                	push   $0xe
  jmp alltraps
80105fdf:	e9 bf fa ff ff       	jmp    80105aa3 <alltraps>

80105fe4 <vector15>:
.globl vector15
vector15:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $15
80105fe6:	6a 0f                	push   $0xf
  jmp alltraps
80105fe8:	e9 b6 fa ff ff       	jmp    80105aa3 <alltraps>

80105fed <vector16>:
.globl vector16
vector16:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $16
80105fef:	6a 10                	push   $0x10
  jmp alltraps
80105ff1:	e9 ad fa ff ff       	jmp    80105aa3 <alltraps>

80105ff6 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ff6:	6a 11                	push   $0x11
  jmp alltraps
80105ff8:	e9 a6 fa ff ff       	jmp    80105aa3 <alltraps>

80105ffd <vector18>:
.globl vector18
vector18:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $18
80105fff:	6a 12                	push   $0x12
  jmp alltraps
80106001:	e9 9d fa ff ff       	jmp    80105aa3 <alltraps>

80106006 <vector19>:
.globl vector19
vector19:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $19
80106008:	6a 13                	push   $0x13
  jmp alltraps
8010600a:	e9 94 fa ff ff       	jmp    80105aa3 <alltraps>

8010600f <vector20>:
.globl vector20
vector20:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $20
80106011:	6a 14                	push   $0x14
  jmp alltraps
80106013:	e9 8b fa ff ff       	jmp    80105aa3 <alltraps>

80106018 <vector21>:
.globl vector21
vector21:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $21
8010601a:	6a 15                	push   $0x15
  jmp alltraps
8010601c:	e9 82 fa ff ff       	jmp    80105aa3 <alltraps>

80106021 <vector22>:
.globl vector22
vector22:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $22
80106023:	6a 16                	push   $0x16
  jmp alltraps
80106025:	e9 79 fa ff ff       	jmp    80105aa3 <alltraps>

8010602a <vector23>:
.globl vector23
vector23:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $23
8010602c:	6a 17                	push   $0x17
  jmp alltraps
8010602e:	e9 70 fa ff ff       	jmp    80105aa3 <alltraps>

80106033 <vector24>:
.globl vector24
vector24:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $24
80106035:	6a 18                	push   $0x18
  jmp alltraps
80106037:	e9 67 fa ff ff       	jmp    80105aa3 <alltraps>

8010603c <vector25>:
.globl vector25
vector25:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $25
8010603e:	6a 19                	push   $0x19
  jmp alltraps
80106040:	e9 5e fa ff ff       	jmp    80105aa3 <alltraps>

80106045 <vector26>:
.globl vector26
vector26:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $26
80106047:	6a 1a                	push   $0x1a
  jmp alltraps
80106049:	e9 55 fa ff ff       	jmp    80105aa3 <alltraps>

8010604e <vector27>:
.globl vector27
vector27:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $27
80106050:	6a 1b                	push   $0x1b
  jmp alltraps
80106052:	e9 4c fa ff ff       	jmp    80105aa3 <alltraps>

80106057 <vector28>:
.globl vector28
vector28:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $28
80106059:	6a 1c                	push   $0x1c
  jmp alltraps
8010605b:	e9 43 fa ff ff       	jmp    80105aa3 <alltraps>

80106060 <vector29>:
.globl vector29
vector29:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $29
80106062:	6a 1d                	push   $0x1d
  jmp alltraps
80106064:	e9 3a fa ff ff       	jmp    80105aa3 <alltraps>

80106069 <vector30>:
.globl vector30
vector30:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $30
8010606b:	6a 1e                	push   $0x1e
  jmp alltraps
8010606d:	e9 31 fa ff ff       	jmp    80105aa3 <alltraps>

80106072 <vector31>:
.globl vector31
vector31:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $31
80106074:	6a 1f                	push   $0x1f
  jmp alltraps
80106076:	e9 28 fa ff ff       	jmp    80105aa3 <alltraps>

8010607b <vector32>:
.globl vector32
vector32:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $32
8010607d:	6a 20                	push   $0x20
  jmp alltraps
8010607f:	e9 1f fa ff ff       	jmp    80105aa3 <alltraps>

80106084 <vector33>:
.globl vector33
vector33:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $33
80106086:	6a 21                	push   $0x21
  jmp alltraps
80106088:	e9 16 fa ff ff       	jmp    80105aa3 <alltraps>

8010608d <vector34>:
.globl vector34
vector34:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $34
8010608f:	6a 22                	push   $0x22
  jmp alltraps
80106091:	e9 0d fa ff ff       	jmp    80105aa3 <alltraps>

80106096 <vector35>:
.globl vector35
vector35:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $35
80106098:	6a 23                	push   $0x23
  jmp alltraps
8010609a:	e9 04 fa ff ff       	jmp    80105aa3 <alltraps>

8010609f <vector36>:
.globl vector36
vector36:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $36
801060a1:	6a 24                	push   $0x24
  jmp alltraps
801060a3:	e9 fb f9 ff ff       	jmp    80105aa3 <alltraps>

801060a8 <vector37>:
.globl vector37
vector37:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $37
801060aa:	6a 25                	push   $0x25
  jmp alltraps
801060ac:	e9 f2 f9 ff ff       	jmp    80105aa3 <alltraps>

801060b1 <vector38>:
.globl vector38
vector38:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $38
801060b3:	6a 26                	push   $0x26
  jmp alltraps
801060b5:	e9 e9 f9 ff ff       	jmp    80105aa3 <alltraps>

801060ba <vector39>:
.globl vector39
vector39:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $39
801060bc:	6a 27                	push   $0x27
  jmp alltraps
801060be:	e9 e0 f9 ff ff       	jmp    80105aa3 <alltraps>

801060c3 <vector40>:
.globl vector40
vector40:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $40
801060c5:	6a 28                	push   $0x28
  jmp alltraps
801060c7:	e9 d7 f9 ff ff       	jmp    80105aa3 <alltraps>

801060cc <vector41>:
.globl vector41
vector41:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $41
801060ce:	6a 29                	push   $0x29
  jmp alltraps
801060d0:	e9 ce f9 ff ff       	jmp    80105aa3 <alltraps>

801060d5 <vector42>:
.globl vector42
vector42:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $42
801060d7:	6a 2a                	push   $0x2a
  jmp alltraps
801060d9:	e9 c5 f9 ff ff       	jmp    80105aa3 <alltraps>

801060de <vector43>:
.globl vector43
vector43:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $43
801060e0:	6a 2b                	push   $0x2b
  jmp alltraps
801060e2:	e9 bc f9 ff ff       	jmp    80105aa3 <alltraps>

801060e7 <vector44>:
.globl vector44
vector44:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $44
801060e9:	6a 2c                	push   $0x2c
  jmp alltraps
801060eb:	e9 b3 f9 ff ff       	jmp    80105aa3 <alltraps>

801060f0 <vector45>:
.globl vector45
vector45:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $45
801060f2:	6a 2d                	push   $0x2d
  jmp alltraps
801060f4:	e9 aa f9 ff ff       	jmp    80105aa3 <alltraps>

801060f9 <vector46>:
.globl vector46
vector46:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $46
801060fb:	6a 2e                	push   $0x2e
  jmp alltraps
801060fd:	e9 a1 f9 ff ff       	jmp    80105aa3 <alltraps>

80106102 <vector47>:
.globl vector47
vector47:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $47
80106104:	6a 2f                	push   $0x2f
  jmp alltraps
80106106:	e9 98 f9 ff ff       	jmp    80105aa3 <alltraps>

8010610b <vector48>:
.globl vector48
vector48:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $48
8010610d:	6a 30                	push   $0x30
  jmp alltraps
8010610f:	e9 8f f9 ff ff       	jmp    80105aa3 <alltraps>

80106114 <vector49>:
.globl vector49
vector49:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $49
80106116:	6a 31                	push   $0x31
  jmp alltraps
80106118:	e9 86 f9 ff ff       	jmp    80105aa3 <alltraps>

8010611d <vector50>:
.globl vector50
vector50:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $50
8010611f:	6a 32                	push   $0x32
  jmp alltraps
80106121:	e9 7d f9 ff ff       	jmp    80105aa3 <alltraps>

80106126 <vector51>:
.globl vector51
vector51:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $51
80106128:	6a 33                	push   $0x33
  jmp alltraps
8010612a:	e9 74 f9 ff ff       	jmp    80105aa3 <alltraps>

8010612f <vector52>:
.globl vector52
vector52:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $52
80106131:	6a 34                	push   $0x34
  jmp alltraps
80106133:	e9 6b f9 ff ff       	jmp    80105aa3 <alltraps>

80106138 <vector53>:
.globl vector53
vector53:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $53
8010613a:	6a 35                	push   $0x35
  jmp alltraps
8010613c:	e9 62 f9 ff ff       	jmp    80105aa3 <alltraps>

80106141 <vector54>:
.globl vector54
vector54:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $54
80106143:	6a 36                	push   $0x36
  jmp alltraps
80106145:	e9 59 f9 ff ff       	jmp    80105aa3 <alltraps>

8010614a <vector55>:
.globl vector55
vector55:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $55
8010614c:	6a 37                	push   $0x37
  jmp alltraps
8010614e:	e9 50 f9 ff ff       	jmp    80105aa3 <alltraps>

80106153 <vector56>:
.globl vector56
vector56:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $56
80106155:	6a 38                	push   $0x38
  jmp alltraps
80106157:	e9 47 f9 ff ff       	jmp    80105aa3 <alltraps>

8010615c <vector57>:
.globl vector57
vector57:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $57
8010615e:	6a 39                	push   $0x39
  jmp alltraps
80106160:	e9 3e f9 ff ff       	jmp    80105aa3 <alltraps>

80106165 <vector58>:
.globl vector58
vector58:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $58
80106167:	6a 3a                	push   $0x3a
  jmp alltraps
80106169:	e9 35 f9 ff ff       	jmp    80105aa3 <alltraps>

8010616e <vector59>:
.globl vector59
vector59:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $59
80106170:	6a 3b                	push   $0x3b
  jmp alltraps
80106172:	e9 2c f9 ff ff       	jmp    80105aa3 <alltraps>

80106177 <vector60>:
.globl vector60
vector60:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $60
80106179:	6a 3c                	push   $0x3c
  jmp alltraps
8010617b:	e9 23 f9 ff ff       	jmp    80105aa3 <alltraps>

80106180 <vector61>:
.globl vector61
vector61:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $61
80106182:	6a 3d                	push   $0x3d
  jmp alltraps
80106184:	e9 1a f9 ff ff       	jmp    80105aa3 <alltraps>

80106189 <vector62>:
.globl vector62
vector62:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $62
8010618b:	6a 3e                	push   $0x3e
  jmp alltraps
8010618d:	e9 11 f9 ff ff       	jmp    80105aa3 <alltraps>

80106192 <vector63>:
.globl vector63
vector63:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $63
80106194:	6a 3f                	push   $0x3f
  jmp alltraps
80106196:	e9 08 f9 ff ff       	jmp    80105aa3 <alltraps>

8010619b <vector64>:
.globl vector64
vector64:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $64
8010619d:	6a 40                	push   $0x40
  jmp alltraps
8010619f:	e9 ff f8 ff ff       	jmp    80105aa3 <alltraps>

801061a4 <vector65>:
.globl vector65
vector65:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $65
801061a6:	6a 41                	push   $0x41
  jmp alltraps
801061a8:	e9 f6 f8 ff ff       	jmp    80105aa3 <alltraps>

801061ad <vector66>:
.globl vector66
vector66:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $66
801061af:	6a 42                	push   $0x42
  jmp alltraps
801061b1:	e9 ed f8 ff ff       	jmp    80105aa3 <alltraps>

801061b6 <vector67>:
.globl vector67
vector67:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $67
801061b8:	6a 43                	push   $0x43
  jmp alltraps
801061ba:	e9 e4 f8 ff ff       	jmp    80105aa3 <alltraps>

801061bf <vector68>:
.globl vector68
vector68:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $68
801061c1:	6a 44                	push   $0x44
  jmp alltraps
801061c3:	e9 db f8 ff ff       	jmp    80105aa3 <alltraps>

801061c8 <vector69>:
.globl vector69
vector69:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $69
801061ca:	6a 45                	push   $0x45
  jmp alltraps
801061cc:	e9 d2 f8 ff ff       	jmp    80105aa3 <alltraps>

801061d1 <vector70>:
.globl vector70
vector70:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $70
801061d3:	6a 46                	push   $0x46
  jmp alltraps
801061d5:	e9 c9 f8 ff ff       	jmp    80105aa3 <alltraps>

801061da <vector71>:
.globl vector71
vector71:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $71
801061dc:	6a 47                	push   $0x47
  jmp alltraps
801061de:	e9 c0 f8 ff ff       	jmp    80105aa3 <alltraps>

801061e3 <vector72>:
.globl vector72
vector72:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $72
801061e5:	6a 48                	push   $0x48
  jmp alltraps
801061e7:	e9 b7 f8 ff ff       	jmp    80105aa3 <alltraps>

801061ec <vector73>:
.globl vector73
vector73:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $73
801061ee:	6a 49                	push   $0x49
  jmp alltraps
801061f0:	e9 ae f8 ff ff       	jmp    80105aa3 <alltraps>

801061f5 <vector74>:
.globl vector74
vector74:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $74
801061f7:	6a 4a                	push   $0x4a
  jmp alltraps
801061f9:	e9 a5 f8 ff ff       	jmp    80105aa3 <alltraps>

801061fe <vector75>:
.globl vector75
vector75:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $75
80106200:	6a 4b                	push   $0x4b
  jmp alltraps
80106202:	e9 9c f8 ff ff       	jmp    80105aa3 <alltraps>

80106207 <vector76>:
.globl vector76
vector76:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $76
80106209:	6a 4c                	push   $0x4c
  jmp alltraps
8010620b:	e9 93 f8 ff ff       	jmp    80105aa3 <alltraps>

80106210 <vector77>:
.globl vector77
vector77:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $77
80106212:	6a 4d                	push   $0x4d
  jmp alltraps
80106214:	e9 8a f8 ff ff       	jmp    80105aa3 <alltraps>

80106219 <vector78>:
.globl vector78
vector78:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $78
8010621b:	6a 4e                	push   $0x4e
  jmp alltraps
8010621d:	e9 81 f8 ff ff       	jmp    80105aa3 <alltraps>

80106222 <vector79>:
.globl vector79
vector79:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $79
80106224:	6a 4f                	push   $0x4f
  jmp alltraps
80106226:	e9 78 f8 ff ff       	jmp    80105aa3 <alltraps>

8010622b <vector80>:
.globl vector80
vector80:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $80
8010622d:	6a 50                	push   $0x50
  jmp alltraps
8010622f:	e9 6f f8 ff ff       	jmp    80105aa3 <alltraps>

80106234 <vector81>:
.globl vector81
vector81:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $81
80106236:	6a 51                	push   $0x51
  jmp alltraps
80106238:	e9 66 f8 ff ff       	jmp    80105aa3 <alltraps>

8010623d <vector82>:
.globl vector82
vector82:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $82
8010623f:	6a 52                	push   $0x52
  jmp alltraps
80106241:	e9 5d f8 ff ff       	jmp    80105aa3 <alltraps>

80106246 <vector83>:
.globl vector83
vector83:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $83
80106248:	6a 53                	push   $0x53
  jmp alltraps
8010624a:	e9 54 f8 ff ff       	jmp    80105aa3 <alltraps>

8010624f <vector84>:
.globl vector84
vector84:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $84
80106251:	6a 54                	push   $0x54
  jmp alltraps
80106253:	e9 4b f8 ff ff       	jmp    80105aa3 <alltraps>

80106258 <vector85>:
.globl vector85
vector85:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $85
8010625a:	6a 55                	push   $0x55
  jmp alltraps
8010625c:	e9 42 f8 ff ff       	jmp    80105aa3 <alltraps>

80106261 <vector86>:
.globl vector86
vector86:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $86
80106263:	6a 56                	push   $0x56
  jmp alltraps
80106265:	e9 39 f8 ff ff       	jmp    80105aa3 <alltraps>

8010626a <vector87>:
.globl vector87
vector87:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $87
8010626c:	6a 57                	push   $0x57
  jmp alltraps
8010626e:	e9 30 f8 ff ff       	jmp    80105aa3 <alltraps>

80106273 <vector88>:
.globl vector88
vector88:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $88
80106275:	6a 58                	push   $0x58
  jmp alltraps
80106277:	e9 27 f8 ff ff       	jmp    80105aa3 <alltraps>

8010627c <vector89>:
.globl vector89
vector89:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $89
8010627e:	6a 59                	push   $0x59
  jmp alltraps
80106280:	e9 1e f8 ff ff       	jmp    80105aa3 <alltraps>

80106285 <vector90>:
.globl vector90
vector90:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $90
80106287:	6a 5a                	push   $0x5a
  jmp alltraps
80106289:	e9 15 f8 ff ff       	jmp    80105aa3 <alltraps>

8010628e <vector91>:
.globl vector91
vector91:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $91
80106290:	6a 5b                	push   $0x5b
  jmp alltraps
80106292:	e9 0c f8 ff ff       	jmp    80105aa3 <alltraps>

80106297 <vector92>:
.globl vector92
vector92:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $92
80106299:	6a 5c                	push   $0x5c
  jmp alltraps
8010629b:	e9 03 f8 ff ff       	jmp    80105aa3 <alltraps>

801062a0 <vector93>:
.globl vector93
vector93:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $93
801062a2:	6a 5d                	push   $0x5d
  jmp alltraps
801062a4:	e9 fa f7 ff ff       	jmp    80105aa3 <alltraps>

801062a9 <vector94>:
.globl vector94
vector94:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $94
801062ab:	6a 5e                	push   $0x5e
  jmp alltraps
801062ad:	e9 f1 f7 ff ff       	jmp    80105aa3 <alltraps>

801062b2 <vector95>:
.globl vector95
vector95:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $95
801062b4:	6a 5f                	push   $0x5f
  jmp alltraps
801062b6:	e9 e8 f7 ff ff       	jmp    80105aa3 <alltraps>

801062bb <vector96>:
.globl vector96
vector96:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $96
801062bd:	6a 60                	push   $0x60
  jmp alltraps
801062bf:	e9 df f7 ff ff       	jmp    80105aa3 <alltraps>

801062c4 <vector97>:
.globl vector97
vector97:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $97
801062c6:	6a 61                	push   $0x61
  jmp alltraps
801062c8:	e9 d6 f7 ff ff       	jmp    80105aa3 <alltraps>

801062cd <vector98>:
.globl vector98
vector98:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $98
801062cf:	6a 62                	push   $0x62
  jmp alltraps
801062d1:	e9 cd f7 ff ff       	jmp    80105aa3 <alltraps>

801062d6 <vector99>:
.globl vector99
vector99:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $99
801062d8:	6a 63                	push   $0x63
  jmp alltraps
801062da:	e9 c4 f7 ff ff       	jmp    80105aa3 <alltraps>

801062df <vector100>:
.globl vector100
vector100:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $100
801062e1:	6a 64                	push   $0x64
  jmp alltraps
801062e3:	e9 bb f7 ff ff       	jmp    80105aa3 <alltraps>

801062e8 <vector101>:
.globl vector101
vector101:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $101
801062ea:	6a 65                	push   $0x65
  jmp alltraps
801062ec:	e9 b2 f7 ff ff       	jmp    80105aa3 <alltraps>

801062f1 <vector102>:
.globl vector102
vector102:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $102
801062f3:	6a 66                	push   $0x66
  jmp alltraps
801062f5:	e9 a9 f7 ff ff       	jmp    80105aa3 <alltraps>

801062fa <vector103>:
.globl vector103
vector103:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $103
801062fc:	6a 67                	push   $0x67
  jmp alltraps
801062fe:	e9 a0 f7 ff ff       	jmp    80105aa3 <alltraps>

80106303 <vector104>:
.globl vector104
vector104:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $104
80106305:	6a 68                	push   $0x68
  jmp alltraps
80106307:	e9 97 f7 ff ff       	jmp    80105aa3 <alltraps>

8010630c <vector105>:
.globl vector105
vector105:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $105
8010630e:	6a 69                	push   $0x69
  jmp alltraps
80106310:	e9 8e f7 ff ff       	jmp    80105aa3 <alltraps>

80106315 <vector106>:
.globl vector106
vector106:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $106
80106317:	6a 6a                	push   $0x6a
  jmp alltraps
80106319:	e9 85 f7 ff ff       	jmp    80105aa3 <alltraps>

8010631e <vector107>:
.globl vector107
vector107:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $107
80106320:	6a 6b                	push   $0x6b
  jmp alltraps
80106322:	e9 7c f7 ff ff       	jmp    80105aa3 <alltraps>

80106327 <vector108>:
.globl vector108
vector108:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $108
80106329:	6a 6c                	push   $0x6c
  jmp alltraps
8010632b:	e9 73 f7 ff ff       	jmp    80105aa3 <alltraps>

80106330 <vector109>:
.globl vector109
vector109:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $109
80106332:	6a 6d                	push   $0x6d
  jmp alltraps
80106334:	e9 6a f7 ff ff       	jmp    80105aa3 <alltraps>

80106339 <vector110>:
.globl vector110
vector110:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $110
8010633b:	6a 6e                	push   $0x6e
  jmp alltraps
8010633d:	e9 61 f7 ff ff       	jmp    80105aa3 <alltraps>

80106342 <vector111>:
.globl vector111
vector111:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $111
80106344:	6a 6f                	push   $0x6f
  jmp alltraps
80106346:	e9 58 f7 ff ff       	jmp    80105aa3 <alltraps>

8010634b <vector112>:
.globl vector112
vector112:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $112
8010634d:	6a 70                	push   $0x70
  jmp alltraps
8010634f:	e9 4f f7 ff ff       	jmp    80105aa3 <alltraps>

80106354 <vector113>:
.globl vector113
vector113:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $113
80106356:	6a 71                	push   $0x71
  jmp alltraps
80106358:	e9 46 f7 ff ff       	jmp    80105aa3 <alltraps>

8010635d <vector114>:
.globl vector114
vector114:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $114
8010635f:	6a 72                	push   $0x72
  jmp alltraps
80106361:	e9 3d f7 ff ff       	jmp    80105aa3 <alltraps>

80106366 <vector115>:
.globl vector115
vector115:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $115
80106368:	6a 73                	push   $0x73
  jmp alltraps
8010636a:	e9 34 f7 ff ff       	jmp    80105aa3 <alltraps>

8010636f <vector116>:
.globl vector116
vector116:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $116
80106371:	6a 74                	push   $0x74
  jmp alltraps
80106373:	e9 2b f7 ff ff       	jmp    80105aa3 <alltraps>

80106378 <vector117>:
.globl vector117
vector117:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $117
8010637a:	6a 75                	push   $0x75
  jmp alltraps
8010637c:	e9 22 f7 ff ff       	jmp    80105aa3 <alltraps>

80106381 <vector118>:
.globl vector118
vector118:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $118
80106383:	6a 76                	push   $0x76
  jmp alltraps
80106385:	e9 19 f7 ff ff       	jmp    80105aa3 <alltraps>

8010638a <vector119>:
.globl vector119
vector119:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $119
8010638c:	6a 77                	push   $0x77
  jmp alltraps
8010638e:	e9 10 f7 ff ff       	jmp    80105aa3 <alltraps>

80106393 <vector120>:
.globl vector120
vector120:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $120
80106395:	6a 78                	push   $0x78
  jmp alltraps
80106397:	e9 07 f7 ff ff       	jmp    80105aa3 <alltraps>

8010639c <vector121>:
.globl vector121
vector121:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $121
8010639e:	6a 79                	push   $0x79
  jmp alltraps
801063a0:	e9 fe f6 ff ff       	jmp    80105aa3 <alltraps>

801063a5 <vector122>:
.globl vector122
vector122:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $122
801063a7:	6a 7a                	push   $0x7a
  jmp alltraps
801063a9:	e9 f5 f6 ff ff       	jmp    80105aa3 <alltraps>

801063ae <vector123>:
.globl vector123
vector123:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $123
801063b0:	6a 7b                	push   $0x7b
  jmp alltraps
801063b2:	e9 ec f6 ff ff       	jmp    80105aa3 <alltraps>

801063b7 <vector124>:
.globl vector124
vector124:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $124
801063b9:	6a 7c                	push   $0x7c
  jmp alltraps
801063bb:	e9 e3 f6 ff ff       	jmp    80105aa3 <alltraps>

801063c0 <vector125>:
.globl vector125
vector125:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $125
801063c2:	6a 7d                	push   $0x7d
  jmp alltraps
801063c4:	e9 da f6 ff ff       	jmp    80105aa3 <alltraps>

801063c9 <vector126>:
.globl vector126
vector126:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $126
801063cb:	6a 7e                	push   $0x7e
  jmp alltraps
801063cd:	e9 d1 f6 ff ff       	jmp    80105aa3 <alltraps>

801063d2 <vector127>:
.globl vector127
vector127:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $127
801063d4:	6a 7f                	push   $0x7f
  jmp alltraps
801063d6:	e9 c8 f6 ff ff       	jmp    80105aa3 <alltraps>

801063db <vector128>:
.globl vector128
vector128:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $128
801063dd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801063e2:	e9 bc f6 ff ff       	jmp    80105aa3 <alltraps>

801063e7 <vector129>:
.globl vector129
vector129:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $129
801063e9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063ee:	e9 b0 f6 ff ff       	jmp    80105aa3 <alltraps>

801063f3 <vector130>:
.globl vector130
vector130:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $130
801063f5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063fa:	e9 a4 f6 ff ff       	jmp    80105aa3 <alltraps>

801063ff <vector131>:
.globl vector131
vector131:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $131
80106401:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106406:	e9 98 f6 ff ff       	jmp    80105aa3 <alltraps>

8010640b <vector132>:
.globl vector132
vector132:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $132
8010640d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106412:	e9 8c f6 ff ff       	jmp    80105aa3 <alltraps>

80106417 <vector133>:
.globl vector133
vector133:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $133
80106419:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010641e:	e9 80 f6 ff ff       	jmp    80105aa3 <alltraps>

80106423 <vector134>:
.globl vector134
vector134:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $134
80106425:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010642a:	e9 74 f6 ff ff       	jmp    80105aa3 <alltraps>

8010642f <vector135>:
.globl vector135
vector135:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $135
80106431:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106436:	e9 68 f6 ff ff       	jmp    80105aa3 <alltraps>

8010643b <vector136>:
.globl vector136
vector136:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $136
8010643d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106442:	e9 5c f6 ff ff       	jmp    80105aa3 <alltraps>

80106447 <vector137>:
.globl vector137
vector137:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $137
80106449:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010644e:	e9 50 f6 ff ff       	jmp    80105aa3 <alltraps>

80106453 <vector138>:
.globl vector138
vector138:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $138
80106455:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010645a:	e9 44 f6 ff ff       	jmp    80105aa3 <alltraps>

8010645f <vector139>:
.globl vector139
vector139:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $139
80106461:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106466:	e9 38 f6 ff ff       	jmp    80105aa3 <alltraps>

8010646b <vector140>:
.globl vector140
vector140:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $140
8010646d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106472:	e9 2c f6 ff ff       	jmp    80105aa3 <alltraps>

80106477 <vector141>:
.globl vector141
vector141:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $141
80106479:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010647e:	e9 20 f6 ff ff       	jmp    80105aa3 <alltraps>

80106483 <vector142>:
.globl vector142
vector142:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $142
80106485:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010648a:	e9 14 f6 ff ff       	jmp    80105aa3 <alltraps>

8010648f <vector143>:
.globl vector143
vector143:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $143
80106491:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106496:	e9 08 f6 ff ff       	jmp    80105aa3 <alltraps>

8010649b <vector144>:
.globl vector144
vector144:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $144
8010649d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064a2:	e9 fc f5 ff ff       	jmp    80105aa3 <alltraps>

801064a7 <vector145>:
.globl vector145
vector145:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $145
801064a9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064ae:	e9 f0 f5 ff ff       	jmp    80105aa3 <alltraps>

801064b3 <vector146>:
.globl vector146
vector146:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $146
801064b5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064ba:	e9 e4 f5 ff ff       	jmp    80105aa3 <alltraps>

801064bf <vector147>:
.globl vector147
vector147:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $147
801064c1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064c6:	e9 d8 f5 ff ff       	jmp    80105aa3 <alltraps>

801064cb <vector148>:
.globl vector148
vector148:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $148
801064cd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064d2:	e9 cc f5 ff ff       	jmp    80105aa3 <alltraps>

801064d7 <vector149>:
.globl vector149
vector149:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $149
801064d9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801064de:	e9 c0 f5 ff ff       	jmp    80105aa3 <alltraps>

801064e3 <vector150>:
.globl vector150
vector150:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $150
801064e5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064ea:	e9 b4 f5 ff ff       	jmp    80105aa3 <alltraps>

801064ef <vector151>:
.globl vector151
vector151:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $151
801064f1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064f6:	e9 a8 f5 ff ff       	jmp    80105aa3 <alltraps>

801064fb <vector152>:
.globl vector152
vector152:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $152
801064fd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106502:	e9 9c f5 ff ff       	jmp    80105aa3 <alltraps>

80106507 <vector153>:
.globl vector153
vector153:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $153
80106509:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010650e:	e9 90 f5 ff ff       	jmp    80105aa3 <alltraps>

80106513 <vector154>:
.globl vector154
vector154:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $154
80106515:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010651a:	e9 84 f5 ff ff       	jmp    80105aa3 <alltraps>

8010651f <vector155>:
.globl vector155
vector155:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $155
80106521:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106526:	e9 78 f5 ff ff       	jmp    80105aa3 <alltraps>

8010652b <vector156>:
.globl vector156
vector156:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $156
8010652d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106532:	e9 6c f5 ff ff       	jmp    80105aa3 <alltraps>

80106537 <vector157>:
.globl vector157
vector157:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $157
80106539:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010653e:	e9 60 f5 ff ff       	jmp    80105aa3 <alltraps>

80106543 <vector158>:
.globl vector158
vector158:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $158
80106545:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010654a:	e9 54 f5 ff ff       	jmp    80105aa3 <alltraps>

8010654f <vector159>:
.globl vector159
vector159:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $159
80106551:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106556:	e9 48 f5 ff ff       	jmp    80105aa3 <alltraps>

8010655b <vector160>:
.globl vector160
vector160:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $160
8010655d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106562:	e9 3c f5 ff ff       	jmp    80105aa3 <alltraps>

80106567 <vector161>:
.globl vector161
vector161:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $161
80106569:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010656e:	e9 30 f5 ff ff       	jmp    80105aa3 <alltraps>

80106573 <vector162>:
.globl vector162
vector162:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $162
80106575:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010657a:	e9 24 f5 ff ff       	jmp    80105aa3 <alltraps>

8010657f <vector163>:
.globl vector163
vector163:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $163
80106581:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106586:	e9 18 f5 ff ff       	jmp    80105aa3 <alltraps>

8010658b <vector164>:
.globl vector164
vector164:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $164
8010658d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106592:	e9 0c f5 ff ff       	jmp    80105aa3 <alltraps>

80106597 <vector165>:
.globl vector165
vector165:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $165
80106599:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010659e:	e9 00 f5 ff ff       	jmp    80105aa3 <alltraps>

801065a3 <vector166>:
.globl vector166
vector166:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $166
801065a5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065aa:	e9 f4 f4 ff ff       	jmp    80105aa3 <alltraps>

801065af <vector167>:
.globl vector167
vector167:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $167
801065b1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065b6:	e9 e8 f4 ff ff       	jmp    80105aa3 <alltraps>

801065bb <vector168>:
.globl vector168
vector168:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $168
801065bd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065c2:	e9 dc f4 ff ff       	jmp    80105aa3 <alltraps>

801065c7 <vector169>:
.globl vector169
vector169:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $169
801065c9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065ce:	e9 d0 f4 ff ff       	jmp    80105aa3 <alltraps>

801065d3 <vector170>:
.globl vector170
vector170:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $170
801065d5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801065da:	e9 c4 f4 ff ff       	jmp    80105aa3 <alltraps>

801065df <vector171>:
.globl vector171
vector171:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $171
801065e1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065e6:	e9 b8 f4 ff ff       	jmp    80105aa3 <alltraps>

801065eb <vector172>:
.globl vector172
vector172:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $172
801065ed:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065f2:	e9 ac f4 ff ff       	jmp    80105aa3 <alltraps>

801065f7 <vector173>:
.globl vector173
vector173:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $173
801065f9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065fe:	e9 a0 f4 ff ff       	jmp    80105aa3 <alltraps>

80106603 <vector174>:
.globl vector174
vector174:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $174
80106605:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010660a:	e9 94 f4 ff ff       	jmp    80105aa3 <alltraps>

8010660f <vector175>:
.globl vector175
vector175:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $175
80106611:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106616:	e9 88 f4 ff ff       	jmp    80105aa3 <alltraps>

8010661b <vector176>:
.globl vector176
vector176:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $176
8010661d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106622:	e9 7c f4 ff ff       	jmp    80105aa3 <alltraps>

80106627 <vector177>:
.globl vector177
vector177:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $177
80106629:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010662e:	e9 70 f4 ff ff       	jmp    80105aa3 <alltraps>

80106633 <vector178>:
.globl vector178
vector178:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $178
80106635:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010663a:	e9 64 f4 ff ff       	jmp    80105aa3 <alltraps>

8010663f <vector179>:
.globl vector179
vector179:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $179
80106641:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106646:	e9 58 f4 ff ff       	jmp    80105aa3 <alltraps>

8010664b <vector180>:
.globl vector180
vector180:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $180
8010664d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106652:	e9 4c f4 ff ff       	jmp    80105aa3 <alltraps>

80106657 <vector181>:
.globl vector181
vector181:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $181
80106659:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010665e:	e9 40 f4 ff ff       	jmp    80105aa3 <alltraps>

80106663 <vector182>:
.globl vector182
vector182:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $182
80106665:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010666a:	e9 34 f4 ff ff       	jmp    80105aa3 <alltraps>

8010666f <vector183>:
.globl vector183
vector183:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $183
80106671:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106676:	e9 28 f4 ff ff       	jmp    80105aa3 <alltraps>

8010667b <vector184>:
.globl vector184
vector184:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $184
8010667d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106682:	e9 1c f4 ff ff       	jmp    80105aa3 <alltraps>

80106687 <vector185>:
.globl vector185
vector185:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $185
80106689:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010668e:	e9 10 f4 ff ff       	jmp    80105aa3 <alltraps>

80106693 <vector186>:
.globl vector186
vector186:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $186
80106695:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010669a:	e9 04 f4 ff ff       	jmp    80105aa3 <alltraps>

8010669f <vector187>:
.globl vector187
vector187:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $187
801066a1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066a6:	e9 f8 f3 ff ff       	jmp    80105aa3 <alltraps>

801066ab <vector188>:
.globl vector188
vector188:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $188
801066ad:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066b2:	e9 ec f3 ff ff       	jmp    80105aa3 <alltraps>

801066b7 <vector189>:
.globl vector189
vector189:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $189
801066b9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066be:	e9 e0 f3 ff ff       	jmp    80105aa3 <alltraps>

801066c3 <vector190>:
.globl vector190
vector190:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $190
801066c5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066ca:	e9 d4 f3 ff ff       	jmp    80105aa3 <alltraps>

801066cf <vector191>:
.globl vector191
vector191:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $191
801066d1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801066d6:	e9 c8 f3 ff ff       	jmp    80105aa3 <alltraps>

801066db <vector192>:
.globl vector192
vector192:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $192
801066dd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801066e2:	e9 bc f3 ff ff       	jmp    80105aa3 <alltraps>

801066e7 <vector193>:
.globl vector193
vector193:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $193
801066e9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066ee:	e9 b0 f3 ff ff       	jmp    80105aa3 <alltraps>

801066f3 <vector194>:
.globl vector194
vector194:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $194
801066f5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066fa:	e9 a4 f3 ff ff       	jmp    80105aa3 <alltraps>

801066ff <vector195>:
.globl vector195
vector195:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $195
80106701:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106706:	e9 98 f3 ff ff       	jmp    80105aa3 <alltraps>

8010670b <vector196>:
.globl vector196
vector196:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $196
8010670d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106712:	e9 8c f3 ff ff       	jmp    80105aa3 <alltraps>

80106717 <vector197>:
.globl vector197
vector197:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $197
80106719:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010671e:	e9 80 f3 ff ff       	jmp    80105aa3 <alltraps>

80106723 <vector198>:
.globl vector198
vector198:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $198
80106725:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010672a:	e9 74 f3 ff ff       	jmp    80105aa3 <alltraps>

8010672f <vector199>:
.globl vector199
vector199:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $199
80106731:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106736:	e9 68 f3 ff ff       	jmp    80105aa3 <alltraps>

8010673b <vector200>:
.globl vector200
vector200:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $200
8010673d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106742:	e9 5c f3 ff ff       	jmp    80105aa3 <alltraps>

80106747 <vector201>:
.globl vector201
vector201:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $201
80106749:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010674e:	e9 50 f3 ff ff       	jmp    80105aa3 <alltraps>

80106753 <vector202>:
.globl vector202
vector202:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $202
80106755:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010675a:	e9 44 f3 ff ff       	jmp    80105aa3 <alltraps>

8010675f <vector203>:
.globl vector203
vector203:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $203
80106761:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106766:	e9 38 f3 ff ff       	jmp    80105aa3 <alltraps>

8010676b <vector204>:
.globl vector204
vector204:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $204
8010676d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106772:	e9 2c f3 ff ff       	jmp    80105aa3 <alltraps>

80106777 <vector205>:
.globl vector205
vector205:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $205
80106779:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010677e:	e9 20 f3 ff ff       	jmp    80105aa3 <alltraps>

80106783 <vector206>:
.globl vector206
vector206:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $206
80106785:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010678a:	e9 14 f3 ff ff       	jmp    80105aa3 <alltraps>

8010678f <vector207>:
.globl vector207
vector207:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $207
80106791:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106796:	e9 08 f3 ff ff       	jmp    80105aa3 <alltraps>

8010679b <vector208>:
.globl vector208
vector208:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $208
8010679d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067a2:	e9 fc f2 ff ff       	jmp    80105aa3 <alltraps>

801067a7 <vector209>:
.globl vector209
vector209:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $209
801067a9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067ae:	e9 f0 f2 ff ff       	jmp    80105aa3 <alltraps>

801067b3 <vector210>:
.globl vector210
vector210:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $210
801067b5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067ba:	e9 e4 f2 ff ff       	jmp    80105aa3 <alltraps>

801067bf <vector211>:
.globl vector211
vector211:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $211
801067c1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067c6:	e9 d8 f2 ff ff       	jmp    80105aa3 <alltraps>

801067cb <vector212>:
.globl vector212
vector212:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $212
801067cd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067d2:	e9 cc f2 ff ff       	jmp    80105aa3 <alltraps>

801067d7 <vector213>:
.globl vector213
vector213:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $213
801067d9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801067de:	e9 c0 f2 ff ff       	jmp    80105aa3 <alltraps>

801067e3 <vector214>:
.globl vector214
vector214:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $214
801067e5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067ea:	e9 b4 f2 ff ff       	jmp    80105aa3 <alltraps>

801067ef <vector215>:
.globl vector215
vector215:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $215
801067f1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067f6:	e9 a8 f2 ff ff       	jmp    80105aa3 <alltraps>

801067fb <vector216>:
.globl vector216
vector216:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $216
801067fd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106802:	e9 9c f2 ff ff       	jmp    80105aa3 <alltraps>

80106807 <vector217>:
.globl vector217
vector217:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $217
80106809:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010680e:	e9 90 f2 ff ff       	jmp    80105aa3 <alltraps>

80106813 <vector218>:
.globl vector218
vector218:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $218
80106815:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010681a:	e9 84 f2 ff ff       	jmp    80105aa3 <alltraps>

8010681f <vector219>:
.globl vector219
vector219:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $219
80106821:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106826:	e9 78 f2 ff ff       	jmp    80105aa3 <alltraps>

8010682b <vector220>:
.globl vector220
vector220:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $220
8010682d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106832:	e9 6c f2 ff ff       	jmp    80105aa3 <alltraps>

80106837 <vector221>:
.globl vector221
vector221:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $221
80106839:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010683e:	e9 60 f2 ff ff       	jmp    80105aa3 <alltraps>

80106843 <vector222>:
.globl vector222
vector222:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $222
80106845:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010684a:	e9 54 f2 ff ff       	jmp    80105aa3 <alltraps>

8010684f <vector223>:
.globl vector223
vector223:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $223
80106851:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106856:	e9 48 f2 ff ff       	jmp    80105aa3 <alltraps>

8010685b <vector224>:
.globl vector224
vector224:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $224
8010685d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106862:	e9 3c f2 ff ff       	jmp    80105aa3 <alltraps>

80106867 <vector225>:
.globl vector225
vector225:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $225
80106869:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010686e:	e9 30 f2 ff ff       	jmp    80105aa3 <alltraps>

80106873 <vector226>:
.globl vector226
vector226:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $226
80106875:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010687a:	e9 24 f2 ff ff       	jmp    80105aa3 <alltraps>

8010687f <vector227>:
.globl vector227
vector227:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $227
80106881:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106886:	e9 18 f2 ff ff       	jmp    80105aa3 <alltraps>

8010688b <vector228>:
.globl vector228
vector228:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $228
8010688d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106892:	e9 0c f2 ff ff       	jmp    80105aa3 <alltraps>

80106897 <vector229>:
.globl vector229
vector229:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $229
80106899:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010689e:	e9 00 f2 ff ff       	jmp    80105aa3 <alltraps>

801068a3 <vector230>:
.globl vector230
vector230:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $230
801068a5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068aa:	e9 f4 f1 ff ff       	jmp    80105aa3 <alltraps>

801068af <vector231>:
.globl vector231
vector231:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $231
801068b1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068b6:	e9 e8 f1 ff ff       	jmp    80105aa3 <alltraps>

801068bb <vector232>:
.globl vector232
vector232:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $232
801068bd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068c2:	e9 dc f1 ff ff       	jmp    80105aa3 <alltraps>

801068c7 <vector233>:
.globl vector233
vector233:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $233
801068c9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068ce:	e9 d0 f1 ff ff       	jmp    80105aa3 <alltraps>

801068d3 <vector234>:
.globl vector234
vector234:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $234
801068d5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801068da:	e9 c4 f1 ff ff       	jmp    80105aa3 <alltraps>

801068df <vector235>:
.globl vector235
vector235:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $235
801068e1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068e6:	e9 b8 f1 ff ff       	jmp    80105aa3 <alltraps>

801068eb <vector236>:
.globl vector236
vector236:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $236
801068ed:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068f2:	e9 ac f1 ff ff       	jmp    80105aa3 <alltraps>

801068f7 <vector237>:
.globl vector237
vector237:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $237
801068f9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068fe:	e9 a0 f1 ff ff       	jmp    80105aa3 <alltraps>

80106903 <vector238>:
.globl vector238
vector238:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $238
80106905:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010690a:	e9 94 f1 ff ff       	jmp    80105aa3 <alltraps>

8010690f <vector239>:
.globl vector239
vector239:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $239
80106911:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106916:	e9 88 f1 ff ff       	jmp    80105aa3 <alltraps>

8010691b <vector240>:
.globl vector240
vector240:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $240
8010691d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106922:	e9 7c f1 ff ff       	jmp    80105aa3 <alltraps>

80106927 <vector241>:
.globl vector241
vector241:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $241
80106929:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010692e:	e9 70 f1 ff ff       	jmp    80105aa3 <alltraps>

80106933 <vector242>:
.globl vector242
vector242:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $242
80106935:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010693a:	e9 64 f1 ff ff       	jmp    80105aa3 <alltraps>

8010693f <vector243>:
.globl vector243
vector243:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $243
80106941:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106946:	e9 58 f1 ff ff       	jmp    80105aa3 <alltraps>

8010694b <vector244>:
.globl vector244
vector244:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $244
8010694d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106952:	e9 4c f1 ff ff       	jmp    80105aa3 <alltraps>

80106957 <vector245>:
.globl vector245
vector245:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $245
80106959:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010695e:	e9 40 f1 ff ff       	jmp    80105aa3 <alltraps>

80106963 <vector246>:
.globl vector246
vector246:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $246
80106965:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010696a:	e9 34 f1 ff ff       	jmp    80105aa3 <alltraps>

8010696f <vector247>:
.globl vector247
vector247:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $247
80106971:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106976:	e9 28 f1 ff ff       	jmp    80105aa3 <alltraps>

8010697b <vector248>:
.globl vector248
vector248:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $248
8010697d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106982:	e9 1c f1 ff ff       	jmp    80105aa3 <alltraps>

80106987 <vector249>:
.globl vector249
vector249:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $249
80106989:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010698e:	e9 10 f1 ff ff       	jmp    80105aa3 <alltraps>

80106993 <vector250>:
.globl vector250
vector250:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $250
80106995:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010699a:	e9 04 f1 ff ff       	jmp    80105aa3 <alltraps>

8010699f <vector251>:
.globl vector251
vector251:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $251
801069a1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069a6:	e9 f8 f0 ff ff       	jmp    80105aa3 <alltraps>

801069ab <vector252>:
.globl vector252
vector252:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $252
801069ad:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069b2:	e9 ec f0 ff ff       	jmp    80105aa3 <alltraps>

801069b7 <vector253>:
.globl vector253
vector253:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $253
801069b9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069be:	e9 e0 f0 ff ff       	jmp    80105aa3 <alltraps>

801069c3 <vector254>:
.globl vector254
vector254:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $254
801069c5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069ca:	e9 d4 f0 ff ff       	jmp    80105aa3 <alltraps>

801069cf <vector255>:
.globl vector255
vector255:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $255
801069d1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801069d6:	e9 c8 f0 ff ff       	jmp    80105aa3 <alltraps>
801069db:	66 90                	xchg   %ax,%ax
801069dd:	66 90                	xchg   %ax,%ax
801069df:	90                   	nop

801069e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	57                   	push   %edi
801069e4:	56                   	push   %esi
801069e5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801069e7:	c1 ea 16             	shr    $0x16,%edx
{
801069ea:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801069eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801069ee:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801069f1:	8b 1f                	mov    (%edi),%ebx
801069f3:	f6 c3 01             	test   $0x1,%bl
801069f6:	74 28                	je     80106a20 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801069fe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a04:	89 f0                	mov    %esi,%eax
}
80106a06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a09:	c1 e8 0a             	shr    $0xa,%eax
80106a0c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a11:	01 d8                	add    %ebx,%eax
}
80106a13:	5b                   	pop    %ebx
80106a14:	5e                   	pop    %esi
80106a15:	5f                   	pop    %edi
80106a16:	5d                   	pop    %ebp
80106a17:	c3                   	ret    
80106a18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a1f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a20:	85 c9                	test   %ecx,%ecx
80106a22:	74 2c                	je     80106a50 <walkpgdir+0x70>
80106a24:	e8 07 bc ff ff       	call   80102630 <kalloc>
80106a29:	89 c3                	mov    %eax,%ebx
80106a2b:	85 c0                	test   %eax,%eax
80106a2d:	74 21                	je     80106a50 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106a2f:	83 ec 04             	sub    $0x4,%esp
80106a32:	68 00 10 00 00       	push   $0x1000
80106a37:	6a 00                	push   $0x0
80106a39:	50                   	push   %eax
80106a3a:	e8 01 dd ff ff       	call   80104740 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106a3f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a45:	83 c4 10             	add    $0x10,%esp
80106a48:	83 c8 07             	or     $0x7,%eax
80106a4b:	89 07                	mov    %eax,(%edi)
80106a4d:	eb b5                	jmp    80106a04 <walkpgdir+0x24>
80106a4f:	90                   	nop
}
80106a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106a53:	31 c0                	xor    %eax,%eax
}
80106a55:	5b                   	pop    %ebx
80106a56:	5e                   	pop    %esi
80106a57:	5f                   	pop    %edi
80106a58:	5d                   	pop    %ebp
80106a59:	c3                   	ret    
80106a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a60 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a66:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106a6a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106a70:	89 d6                	mov    %edx,%esi
{
80106a72:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106a73:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106a79:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a82:	29 f0                	sub    %esi,%eax
80106a84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a87:	eb 1f                	jmp    80106aa8 <mappages+0x48>
80106a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106a90:	f6 00 01             	testb  $0x1,(%eax)
80106a93:	75 45                	jne    80106ada <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a95:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106a98:	83 cb 01             	or     $0x1,%ebx
80106a9b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106a9d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106aa0:	74 2e                	je     80106ad0 <mappages+0x70>
      break;
    a += PGSIZE;
80106aa2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106aab:	b9 01 00 00 00       	mov    $0x1,%ecx
80106ab0:	89 f2                	mov    %esi,%edx
80106ab2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106ab5:	89 f8                	mov    %edi,%eax
80106ab7:	e8 24 ff ff ff       	call   801069e0 <walkpgdir>
80106abc:	85 c0                	test   %eax,%eax
80106abe:	75 d0                	jne    80106a90 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ac3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ac8:	5b                   	pop    %ebx
80106ac9:	5e                   	pop    %esi
80106aca:	5f                   	pop    %edi
80106acb:	5d                   	pop    %ebp
80106acc:	c3                   	ret    
80106acd:	8d 76 00             	lea    0x0(%esi),%esi
80106ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ad3:	31 c0                	xor    %eax,%eax
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
      panic("remap");
80106ada:	83 ec 0c             	sub    $0xc,%esp
80106add:	68 00 7c 10 80       	push   $0x80107c00
80106ae2:	e8 a9 98 ff ff       	call   80100390 <panic>
80106ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aee:	66 90                	xchg   %ax,%ax

80106af0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	89 c6                	mov    %eax,%esi
80106af7:	53                   	push   %ebx
80106af8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106afa:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106b00:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b06:	83 ec 1c             	sub    $0x1c,%esp
80106b09:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b0c:	39 da                	cmp    %ebx,%edx
80106b0e:	73 5b                	jae    80106b6b <deallocuvm.part.0+0x7b>
80106b10:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106b13:	89 d7                	mov    %edx,%edi
80106b15:	eb 14                	jmp    80106b2b <deallocuvm.part.0+0x3b>
80106b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b1e:	66 90                	xchg   %ax,%ax
80106b20:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106b26:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106b29:	76 40                	jbe    80106b6b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106b2b:	31 c9                	xor    %ecx,%ecx
80106b2d:	89 fa                	mov    %edi,%edx
80106b2f:	89 f0                	mov    %esi,%eax
80106b31:	e8 aa fe ff ff       	call   801069e0 <walkpgdir>
80106b36:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106b38:	85 c0                	test   %eax,%eax
80106b3a:	74 44                	je     80106b80 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106b3c:	8b 00                	mov    (%eax),%eax
80106b3e:	a8 01                	test   $0x1,%al
80106b40:	74 de                	je     80106b20 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106b42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b47:	74 47                	je     80106b90 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106b49:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b4c:	05 00 00 00 80       	add    $0x80000000,%eax
80106b51:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106b57:	50                   	push   %eax
80106b58:	e8 13 b9 ff ff       	call   80102470 <kfree>
      *pte = 0;
80106b5d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106b63:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106b66:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106b69:	77 c0                	ja     80106b2b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106b6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b71:	5b                   	pop    %ebx
80106b72:	5e                   	pop    %esi
80106b73:	5f                   	pop    %edi
80106b74:	5d                   	pop    %ebp
80106b75:	c3                   	ret    
80106b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b7d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106b80:	89 fa                	mov    %edi,%edx
80106b82:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106b88:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106b8e:	eb 96                	jmp    80106b26 <deallocuvm.part.0+0x36>
        panic("kfree");
80106b90:	83 ec 0c             	sub    $0xc,%esp
80106b93:	68 86 75 10 80       	push   $0x80107586
80106b98:	e8 f3 97 ff ff       	call   80100390 <panic>
80106b9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ba0 <seginit>:
{
80106ba0:	f3 0f 1e fb          	endbr32 
80106ba4:	55                   	push   %ebp
80106ba5:	89 e5                	mov    %esp,%ebp
80106ba7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106baa:	e8 11 ce ff ff       	call   801039c0 <cpuid>
  pd[0] = size-1;
80106baf:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106bb4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106bba:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bbe:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106bc5:	ff 00 00 
80106bc8:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106bcf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bd2:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106bd9:	ff 00 00 
80106bdc:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106be3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106be6:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106bed:	ff 00 00 
80106bf0:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106bf7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106bfa:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106c01:	ff 00 00 
80106c04:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106c0b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c0e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106c13:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c17:	c1 e8 10             	shr    $0x10,%eax
80106c1a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c1e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c21:	0f 01 10             	lgdtl  (%eax)
}
80106c24:	c9                   	leave  
80106c25:	c3                   	ret    
80106c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi

80106c30 <switchkvm>:
{
80106c30:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c34:	a1 f4 55 11 80       	mov    0x801155f4,%eax
80106c39:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c3e:	0f 22 d8             	mov    %eax,%cr3
}
80106c41:	c3                   	ret    
80106c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c50 <switchuvm>:
{
80106c50:	f3 0f 1e fb          	endbr32 
80106c54:	55                   	push   %ebp
80106c55:	89 e5                	mov    %esp,%ebp
80106c57:	57                   	push   %edi
80106c58:	56                   	push   %esi
80106c59:	53                   	push   %ebx
80106c5a:	83 ec 1c             	sub    $0x1c,%esp
80106c5d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c60:	85 f6                	test   %esi,%esi
80106c62:	0f 84 cb 00 00 00    	je     80106d33 <switchuvm+0xe3>
  if(p->kstack == 0)
80106c68:	8b 46 08             	mov    0x8(%esi),%eax
80106c6b:	85 c0                	test   %eax,%eax
80106c6d:	0f 84 da 00 00 00    	je     80106d4d <switchuvm+0xfd>
  if(p->pgdir == 0)
80106c73:	8b 46 04             	mov    0x4(%esi),%eax
80106c76:	85 c0                	test   %eax,%eax
80106c78:	0f 84 c2 00 00 00    	je     80106d40 <switchuvm+0xf0>
  pushcli();
80106c7e:	e8 ad d8 ff ff       	call   80104530 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c83:	e8 c8 cc ff ff       	call   80103950 <mycpu>
80106c88:	89 c3                	mov    %eax,%ebx
80106c8a:	e8 c1 cc ff ff       	call   80103950 <mycpu>
80106c8f:	89 c7                	mov    %eax,%edi
80106c91:	e8 ba cc ff ff       	call   80103950 <mycpu>
80106c96:	83 c7 08             	add    $0x8,%edi
80106c99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c9c:	e8 af cc ff ff       	call   80103950 <mycpu>
80106ca1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ca4:	ba 67 00 00 00       	mov    $0x67,%edx
80106ca9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cb0:	83 c0 08             	add    $0x8,%eax
80106cb3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cba:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cbf:	83 c1 08             	add    $0x8,%ecx
80106cc2:	c1 e8 18             	shr    $0x18,%eax
80106cc5:	c1 e9 10             	shr    $0x10,%ecx
80106cc8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106cce:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106cd4:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106cd9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ce0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ce5:	e8 66 cc ff ff       	call   80103950 <mycpu>
80106cea:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cf1:	e8 5a cc ff ff       	call   80103950 <mycpu>
80106cf6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106cfa:	8b 5e 08             	mov    0x8(%esi),%ebx
80106cfd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d03:	e8 48 cc ff ff       	call   80103950 <mycpu>
80106d08:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d0b:	e8 40 cc ff ff       	call   80103950 <mycpu>
80106d10:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d14:	b8 28 00 00 00       	mov    $0x28,%eax
80106d19:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d1c:	8b 46 04             	mov    0x4(%esi),%eax
80106d1f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d24:	0f 22 d8             	mov    %eax,%cr3
}
80106d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d2a:	5b                   	pop    %ebx
80106d2b:	5e                   	pop    %esi
80106d2c:	5f                   	pop    %edi
80106d2d:	5d                   	pop    %ebp
  popcli();
80106d2e:	e9 4d d8 ff ff       	jmp    80104580 <popcli>
    panic("switchuvm: no process");
80106d33:	83 ec 0c             	sub    $0xc,%esp
80106d36:	68 06 7c 10 80       	push   $0x80107c06
80106d3b:	e8 50 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106d40:	83 ec 0c             	sub    $0xc,%esp
80106d43:	68 31 7c 10 80       	push   $0x80107c31
80106d48:	e8 43 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106d4d:	83 ec 0c             	sub    $0xc,%esp
80106d50:	68 1c 7c 10 80       	push   $0x80107c1c
80106d55:	e8 36 96 ff ff       	call   80100390 <panic>
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d60 <inituvm>:
{
80106d60:	f3 0f 1e fb          	endbr32 
80106d64:	55                   	push   %ebp
80106d65:	89 e5                	mov    %esp,%ebp
80106d67:	57                   	push   %edi
80106d68:	56                   	push   %esi
80106d69:	53                   	push   %ebx
80106d6a:	83 ec 1c             	sub    $0x1c,%esp
80106d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d70:	8b 75 10             	mov    0x10(%ebp),%esi
80106d73:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d79:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d7f:	77 4b                	ja     80106dcc <inituvm+0x6c>
  mem = kalloc();
80106d81:	e8 aa b8 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80106d86:	83 ec 04             	sub    $0x4,%esp
80106d89:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d8e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d90:	6a 00                	push   $0x0
80106d92:	50                   	push   %eax
80106d93:	e8 a8 d9 ff ff       	call   80104740 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d98:	58                   	pop    %eax
80106d99:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d9f:	5a                   	pop    %edx
80106da0:	6a 06                	push   $0x6
80106da2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106da7:	31 d2                	xor    %edx,%edx
80106da9:	50                   	push   %eax
80106daa:	89 f8                	mov    %edi,%eax
80106dac:	e8 af fc ff ff       	call   80106a60 <mappages>
  memmove(mem, init, sz);
80106db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db4:	89 75 10             	mov    %esi,0x10(%ebp)
80106db7:	83 c4 10             	add    $0x10,%esp
80106dba:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106dbd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106dc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dc3:	5b                   	pop    %ebx
80106dc4:	5e                   	pop    %esi
80106dc5:	5f                   	pop    %edi
80106dc6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106dc7:	e9 14 da ff ff       	jmp    801047e0 <memmove>
    panic("inituvm: more than a page");
80106dcc:	83 ec 0c             	sub    $0xc,%esp
80106dcf:	68 45 7c 10 80       	push   $0x80107c45
80106dd4:	e8 b7 95 ff ff       	call   80100390 <panic>
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106de0 <loaduvm>:
{
80106de0:	f3 0f 1e fb          	endbr32 
80106de4:	55                   	push   %ebp
80106de5:	89 e5                	mov    %esp,%ebp
80106de7:	57                   	push   %edi
80106de8:	56                   	push   %esi
80106de9:	53                   	push   %ebx
80106dea:	83 ec 1c             	sub    $0x1c,%esp
80106ded:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106df3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106df8:	0f 85 99 00 00 00    	jne    80106e97 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106dfe:	01 f0                	add    %esi,%eax
80106e00:	89 f3                	mov    %esi,%ebx
80106e02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e05:	8b 45 14             	mov    0x14(%ebp),%eax
80106e08:	01 f0                	add    %esi,%eax
80106e0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e0d:	85 f6                	test   %esi,%esi
80106e0f:	75 15                	jne    80106e26 <loaduvm+0x46>
80106e11:	eb 6d                	jmp    80106e80 <loaduvm+0xa0>
80106e13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e17:	90                   	nop
80106e18:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e1e:	89 f0                	mov    %esi,%eax
80106e20:	29 d8                	sub    %ebx,%eax
80106e22:	39 c6                	cmp    %eax,%esi
80106e24:	76 5a                	jbe    80106e80 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e29:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2c:	31 c9                	xor    %ecx,%ecx
80106e2e:	29 da                	sub    %ebx,%edx
80106e30:	e8 ab fb ff ff       	call   801069e0 <walkpgdir>
80106e35:	85 c0                	test   %eax,%eax
80106e37:	74 51                	je     80106e8a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106e39:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e3e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e48:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106e4e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e51:	29 d9                	sub    %ebx,%ecx
80106e53:	05 00 00 00 80       	add    $0x80000000,%eax
80106e58:	57                   	push   %edi
80106e59:	51                   	push   %ecx
80106e5a:	50                   	push   %eax
80106e5b:	ff 75 10             	pushl  0x10(%ebp)
80106e5e:	e8 fd ab ff ff       	call   80101a60 <readi>
80106e63:	83 c4 10             	add    $0x10,%esp
80106e66:	39 f8                	cmp    %edi,%eax
80106e68:	74 ae                	je     80106e18 <loaduvm+0x38>
}
80106e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e72:	5b                   	pop    %ebx
80106e73:	5e                   	pop    %esi
80106e74:	5f                   	pop    %edi
80106e75:	5d                   	pop    %ebp
80106e76:	c3                   	ret    
80106e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e7e:	66 90                	xchg   %ax,%ax
80106e80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e83:	31 c0                	xor    %eax,%eax
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
      panic("loaduvm: address should exist");
80106e8a:	83 ec 0c             	sub    $0xc,%esp
80106e8d:	68 5f 7c 10 80       	push   $0x80107c5f
80106e92:	e8 f9 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106e97:	83 ec 0c             	sub    $0xc,%esp
80106e9a:	68 00 7d 10 80       	push   $0x80107d00
80106e9f:	e8 ec 94 ff ff       	call   80100390 <panic>
80106ea4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106eaf:	90                   	nop

80106eb0 <allocuvm>:
{
80106eb0:	f3 0f 1e fb          	endbr32 
80106eb4:	55                   	push   %ebp
80106eb5:	89 e5                	mov    %esp,%ebp
80106eb7:	57                   	push   %edi
80106eb8:	56                   	push   %esi
80106eb9:	53                   	push   %ebx
80106eba:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106ebd:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106ec0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106ec3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ec6:	85 c0                	test   %eax,%eax
80106ec8:	0f 88 b2 00 00 00    	js     80106f80 <allocuvm+0xd0>
  if(newsz < oldsz)
80106ece:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106ed4:	0f 82 96 00 00 00    	jb     80106f70 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106eda:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106ee0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106ee6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106ee9:	77 40                	ja     80106f2b <allocuvm+0x7b>
80106eeb:	e9 83 00 00 00       	jmp    80106f73 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106ef0:	83 ec 04             	sub    $0x4,%esp
80106ef3:	68 00 10 00 00       	push   $0x1000
80106ef8:	6a 00                	push   $0x0
80106efa:	50                   	push   %eax
80106efb:	e8 40 d8 ff ff       	call   80104740 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f00:	58                   	pop    %eax
80106f01:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f07:	5a                   	pop    %edx
80106f08:	6a 06                	push   $0x6
80106f0a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f0f:	89 f2                	mov    %esi,%edx
80106f11:	50                   	push   %eax
80106f12:	89 f8                	mov    %edi,%eax
80106f14:	e8 47 fb ff ff       	call   80106a60 <mappages>
80106f19:	83 c4 10             	add    $0x10,%esp
80106f1c:	85 c0                	test   %eax,%eax
80106f1e:	78 78                	js     80106f98 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106f20:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f26:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f29:	76 48                	jbe    80106f73 <allocuvm+0xc3>
    mem = kalloc();
80106f2b:	e8 00 b7 ff ff       	call   80102630 <kalloc>
80106f30:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f32:	85 c0                	test   %eax,%eax
80106f34:	75 ba                	jne    80106ef0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f36:	83 ec 0c             	sub    $0xc,%esp
80106f39:	68 7d 7c 10 80       	push   $0x80107c7d
80106f3e:	e8 6d 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f43:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f46:	83 c4 10             	add    $0x10,%esp
80106f49:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f4c:	74 32                	je     80106f80 <allocuvm+0xd0>
80106f4e:	8b 55 10             	mov    0x10(%ebp),%edx
80106f51:	89 c1                	mov    %eax,%ecx
80106f53:	89 f8                	mov    %edi,%eax
80106f55:	e8 96 fb ff ff       	call   80106af0 <deallocuvm.part.0>
      return 0;
80106f5a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f67:	5b                   	pop    %ebx
80106f68:	5e                   	pop    %esi
80106f69:	5f                   	pop    %edi
80106f6a:	5d                   	pop    %ebp
80106f6b:	c3                   	ret    
80106f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106f70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106f73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f79:	5b                   	pop    %ebx
80106f7a:	5e                   	pop    %esi
80106f7b:	5f                   	pop    %edi
80106f7c:	5d                   	pop    %ebp
80106f7d:	c3                   	ret    
80106f7e:	66 90                	xchg   %ax,%ax
    return 0;
80106f80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5f                   	pop    %edi
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    
80106f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f98:	83 ec 0c             	sub    $0xc,%esp
80106f9b:	68 95 7c 10 80       	push   $0x80107c95
80106fa0:	e8 0b 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa8:	83 c4 10             	add    $0x10,%esp
80106fab:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fae:	74 0c                	je     80106fbc <allocuvm+0x10c>
80106fb0:	8b 55 10             	mov    0x10(%ebp),%edx
80106fb3:	89 c1                	mov    %eax,%ecx
80106fb5:	89 f8                	mov    %edi,%eax
80106fb7:	e8 34 fb ff ff       	call   80106af0 <deallocuvm.part.0>
      kfree(mem);
80106fbc:	83 ec 0c             	sub    $0xc,%esp
80106fbf:	53                   	push   %ebx
80106fc0:	e8 ab b4 ff ff       	call   80102470 <kfree>
      return 0;
80106fc5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106fcc:	83 c4 10             	add    $0x10,%esp
}
80106fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fd5:	5b                   	pop    %ebx
80106fd6:	5e                   	pop    %esi
80106fd7:	5f                   	pop    %edi
80106fd8:	5d                   	pop    %ebp
80106fd9:	c3                   	ret    
80106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fe0 <deallocuvm>:
{
80106fe0:	f3 0f 1e fb          	endbr32 
80106fe4:	55                   	push   %ebp
80106fe5:	89 e5                	mov    %esp,%ebp
80106fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fea:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106fed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106ff0:	39 d1                	cmp    %edx,%ecx
80106ff2:	73 0c                	jae    80107000 <deallocuvm+0x20>
}
80106ff4:	5d                   	pop    %ebp
80106ff5:	e9 f6 fa ff ff       	jmp    80106af0 <deallocuvm.part.0>
80106ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107000:	89 d0                	mov    %edx,%eax
80107002:	5d                   	pop    %ebp
80107003:	c3                   	ret    
80107004:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010700f:	90                   	nop

80107010 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107010:	f3 0f 1e fb          	endbr32 
80107014:	55                   	push   %ebp
80107015:	89 e5                	mov    %esp,%ebp
80107017:	57                   	push   %edi
80107018:	56                   	push   %esi
80107019:	53                   	push   %ebx
8010701a:	83 ec 0c             	sub    $0xc,%esp
8010701d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107020:	85 f6                	test   %esi,%esi
80107022:	74 55                	je     80107079 <freevm+0x69>
  if(newsz >= oldsz)
80107024:	31 c9                	xor    %ecx,%ecx
80107026:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010702b:	89 f0                	mov    %esi,%eax
8010702d:	89 f3                	mov    %esi,%ebx
8010702f:	e8 bc fa ff ff       	call   80106af0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107034:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010703a:	eb 0b                	jmp    80107047 <freevm+0x37>
8010703c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107040:	83 c3 04             	add    $0x4,%ebx
80107043:	39 df                	cmp    %ebx,%edi
80107045:	74 23                	je     8010706a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107047:	8b 03                	mov    (%ebx),%eax
80107049:	a8 01                	test   $0x1,%al
8010704b:	74 f3                	je     80107040 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010704d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107052:	83 ec 0c             	sub    $0xc,%esp
80107055:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107058:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010705d:	50                   	push   %eax
8010705e:	e8 0d b4 ff ff       	call   80102470 <kfree>
80107063:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107066:	39 df                	cmp    %ebx,%edi
80107068:	75 dd                	jne    80107047 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010706a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010706d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107070:	5b                   	pop    %ebx
80107071:	5e                   	pop    %esi
80107072:	5f                   	pop    %edi
80107073:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107074:	e9 f7 b3 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107079:	83 ec 0c             	sub    $0xc,%esp
8010707c:	68 b1 7c 10 80       	push   $0x80107cb1
80107081:	e8 0a 93 ff ff       	call   80100390 <panic>
80107086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010708d:	8d 76 00             	lea    0x0(%esi),%esi

80107090 <setupkvm>:
{
80107090:	f3 0f 1e fb          	endbr32 
80107094:	55                   	push   %ebp
80107095:	89 e5                	mov    %esp,%ebp
80107097:	56                   	push   %esi
80107098:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107099:	e8 92 b5 ff ff       	call   80102630 <kalloc>
8010709e:	89 c6                	mov    %eax,%esi
801070a0:	85 c0                	test   %eax,%eax
801070a2:	74 42                	je     801070e6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801070a4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070a7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070ac:	68 00 10 00 00       	push   $0x1000
801070b1:	6a 00                	push   $0x0
801070b3:	50                   	push   %eax
801070b4:	e8 87 d6 ff ff       	call   80104740 <memset>
801070b9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801070bc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070bf:	83 ec 08             	sub    $0x8,%esp
801070c2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070c5:	ff 73 0c             	pushl  0xc(%ebx)
801070c8:	8b 13                	mov    (%ebx),%edx
801070ca:	50                   	push   %eax
801070cb:	29 c1                	sub    %eax,%ecx
801070cd:	89 f0                	mov    %esi,%eax
801070cf:	e8 8c f9 ff ff       	call   80106a60 <mappages>
801070d4:	83 c4 10             	add    $0x10,%esp
801070d7:	85 c0                	test   %eax,%eax
801070d9:	78 15                	js     801070f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070db:	83 c3 10             	add    $0x10,%ebx
801070de:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801070e4:	75 d6                	jne    801070bc <setupkvm+0x2c>
}
801070e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070e9:	89 f0                	mov    %esi,%eax
801070eb:	5b                   	pop    %ebx
801070ec:	5e                   	pop    %esi
801070ed:	5d                   	pop    %ebp
801070ee:	c3                   	ret    
801070ef:	90                   	nop
      freevm(pgdir);
801070f0:	83 ec 0c             	sub    $0xc,%esp
801070f3:	56                   	push   %esi
      return 0;
801070f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801070f6:	e8 15 ff ff ff       	call   80107010 <freevm>
      return 0;
801070fb:	83 c4 10             	add    $0x10,%esp
}
801070fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107101:	89 f0                	mov    %esi,%eax
80107103:	5b                   	pop    %ebx
80107104:	5e                   	pop    %esi
80107105:	5d                   	pop    %ebp
80107106:	c3                   	ret    
80107107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710e:	66 90                	xchg   %ax,%ax

80107110 <kvmalloc>:
{
80107110:	f3 0f 1e fb          	endbr32 
80107114:	55                   	push   %ebp
80107115:	89 e5                	mov    %esp,%ebp
80107117:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010711a:	e8 71 ff ff ff       	call   80107090 <setupkvm>
8010711f:	a3 f4 55 11 80       	mov    %eax,0x801155f4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107124:	05 00 00 00 80       	add    $0x80000000,%eax
80107129:	0f 22 d8             	mov    %eax,%cr3
}
8010712c:	c9                   	leave  
8010712d:	c3                   	ret    
8010712e:	66 90                	xchg   %ax,%ax

80107130 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107130:	f3 0f 1e fb          	endbr32 
80107134:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107135:	31 c9                	xor    %ecx,%ecx
{
80107137:	89 e5                	mov    %esp,%ebp
80107139:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010713c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010713f:	8b 45 08             	mov    0x8(%ebp),%eax
80107142:	e8 99 f8 ff ff       	call   801069e0 <walkpgdir>
  if(pte == 0)
80107147:	85 c0                	test   %eax,%eax
80107149:	74 05                	je     80107150 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010714b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010714e:	c9                   	leave  
8010714f:	c3                   	ret    
    panic("clearpteu");
80107150:	83 ec 0c             	sub    $0xc,%esp
80107153:	68 c2 7c 10 80       	push   $0x80107cc2
80107158:	e8 33 92 ff ff       	call   80100390 <panic>
8010715d:	8d 76 00             	lea    0x0(%esi),%esi

80107160 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107160:	f3 0f 1e fb          	endbr32 
80107164:	55                   	push   %ebp
80107165:	89 e5                	mov    %esp,%ebp
80107167:	57                   	push   %edi
80107168:	56                   	push   %esi
80107169:	53                   	push   %ebx
8010716a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010716d:	e8 1e ff ff ff       	call   80107090 <setupkvm>
80107172:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107175:	85 c0                	test   %eax,%eax
80107177:	0f 84 9b 00 00 00    	je     80107218 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010717d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107180:	85 c9                	test   %ecx,%ecx
80107182:	0f 84 90 00 00 00    	je     80107218 <copyuvm+0xb8>
80107188:	31 f6                	xor    %esi,%esi
8010718a:	eb 46                	jmp    801071d2 <copyuvm+0x72>
8010718c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107190:	83 ec 04             	sub    $0x4,%esp
80107193:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107199:	68 00 10 00 00       	push   $0x1000
8010719e:	57                   	push   %edi
8010719f:	50                   	push   %eax
801071a0:	e8 3b d6 ff ff       	call   801047e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801071a5:	58                   	pop    %eax
801071a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071ac:	5a                   	pop    %edx
801071ad:	ff 75 e4             	pushl  -0x1c(%ebp)
801071b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071b5:	89 f2                	mov    %esi,%edx
801071b7:	50                   	push   %eax
801071b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071bb:	e8 a0 f8 ff ff       	call   80106a60 <mappages>
801071c0:	83 c4 10             	add    $0x10,%esp
801071c3:	85 c0                	test   %eax,%eax
801071c5:	78 61                	js     80107228 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801071c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801071d0:	76 46                	jbe    80107218 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801071d2:	8b 45 08             	mov    0x8(%ebp),%eax
801071d5:	31 c9                	xor    %ecx,%ecx
801071d7:	89 f2                	mov    %esi,%edx
801071d9:	e8 02 f8 ff ff       	call   801069e0 <walkpgdir>
801071de:	85 c0                	test   %eax,%eax
801071e0:	74 61                	je     80107243 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801071e2:	8b 00                	mov    (%eax),%eax
801071e4:	a8 01                	test   $0x1,%al
801071e6:	74 4e                	je     80107236 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801071e8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801071ea:	25 ff 0f 00 00       	and    $0xfff,%eax
801071ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801071f2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801071f8:	e8 33 b4 ff ff       	call   80102630 <kalloc>
801071fd:	89 c3                	mov    %eax,%ebx
801071ff:	85 c0                	test   %eax,%eax
80107201:	75 8d                	jne    80107190 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107203:	83 ec 0c             	sub    $0xc,%esp
80107206:	ff 75 e0             	pushl  -0x20(%ebp)
80107209:	e8 02 fe ff ff       	call   80107010 <freevm>
  return 0;
8010720e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107215:	83 c4 10             	add    $0x10,%esp
}
80107218:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010721b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010721e:	5b                   	pop    %ebx
8010721f:	5e                   	pop    %esi
80107220:	5f                   	pop    %edi
80107221:	5d                   	pop    %ebp
80107222:	c3                   	ret    
80107223:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107227:	90                   	nop
      kfree(mem);
80107228:	83 ec 0c             	sub    $0xc,%esp
8010722b:	53                   	push   %ebx
8010722c:	e8 3f b2 ff ff       	call   80102470 <kfree>
      goto bad;
80107231:	83 c4 10             	add    $0x10,%esp
80107234:	eb cd                	jmp    80107203 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107236:	83 ec 0c             	sub    $0xc,%esp
80107239:	68 e6 7c 10 80       	push   $0x80107ce6
8010723e:	e8 4d 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107243:	83 ec 0c             	sub    $0xc,%esp
80107246:	68 cc 7c 10 80       	push   $0x80107ccc
8010724b:	e8 40 91 ff ff       	call   80100390 <panic>

80107250 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107250:	f3 0f 1e fb          	endbr32 
80107254:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107255:	31 c9                	xor    %ecx,%ecx
{
80107257:	89 e5                	mov    %esp,%ebp
80107259:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010725c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010725f:	8b 45 08             	mov    0x8(%ebp),%eax
80107262:	e8 79 f7 ff ff       	call   801069e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107267:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107269:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010726a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010726c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107271:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107274:	05 00 00 00 80       	add    $0x80000000,%eax
80107279:	83 fa 05             	cmp    $0x5,%edx
8010727c:	ba 00 00 00 00       	mov    $0x0,%edx
80107281:	0f 45 c2             	cmovne %edx,%eax
}
80107284:	c3                   	ret    
80107285:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107290:	f3 0f 1e fb          	endbr32 
80107294:	55                   	push   %ebp
80107295:	89 e5                	mov    %esp,%ebp
80107297:	57                   	push   %edi
80107298:	56                   	push   %esi
80107299:	53                   	push   %ebx
8010729a:	83 ec 0c             	sub    $0xc,%esp
8010729d:	8b 75 14             	mov    0x14(%ebp),%esi
801072a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072a3:	85 f6                	test   %esi,%esi
801072a5:	75 3c                	jne    801072e3 <copyout+0x53>
801072a7:	eb 67                	jmp    80107310 <copyout+0x80>
801072a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801072b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801072b3:	89 fb                	mov    %edi,%ebx
801072b5:	29 d3                	sub    %edx,%ebx
801072b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801072bd:	39 f3                	cmp    %esi,%ebx
801072bf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801072c2:	29 fa                	sub    %edi,%edx
801072c4:	83 ec 04             	sub    $0x4,%esp
801072c7:	01 c2                	add    %eax,%edx
801072c9:	53                   	push   %ebx
801072ca:	ff 75 10             	pushl  0x10(%ebp)
801072cd:	52                   	push   %edx
801072ce:	e8 0d d5 ff ff       	call   801047e0 <memmove>
    len -= n;
    buf += n;
801072d3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801072d6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801072dc:	83 c4 10             	add    $0x10,%esp
801072df:	29 de                	sub    %ebx,%esi
801072e1:	74 2d                	je     80107310 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801072e3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801072e5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801072e8:	89 55 0c             	mov    %edx,0xc(%ebp)
801072eb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801072f1:	57                   	push   %edi
801072f2:	ff 75 08             	pushl  0x8(%ebp)
801072f5:	e8 56 ff ff ff       	call   80107250 <uva2ka>
    if(pa0 == 0)
801072fa:	83 c4 10             	add    $0x10,%esp
801072fd:	85 c0                	test   %eax,%eax
801072ff:	75 af                	jne    801072b0 <copyout+0x20>
  }
  return 0;
}
80107301:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107304:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107309:	5b                   	pop    %ebx
8010730a:	5e                   	pop    %esi
8010730b:	5f                   	pop    %edi
8010730c:	5d                   	pop    %ebp
8010730d:	c3                   	ret    
8010730e:	66 90                	xchg   %ax,%ax
80107310:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107313:	31 c0                	xor    %eax,%eax
}
80107315:	5b                   	pop    %ebx
80107316:	5e                   	pop    %esi
80107317:	5f                   	pop    %edi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    
