.code16

.global _bootstart

.equ BOOTSEG, 0x07c0

.text

ljmp $BOOTSEG, $_bootstart

_bootstart:
    # 调用 10.3 号中断, 获取当前光标所在行和列
    # dh 中存储行, dl 中存储列, 用于打印中断
    mov $0x03, %ah
    int $0x10
    # 打印文字
    # es:bp 存储了字符串
    # es 寄存器不能够直接赋值, 必须先存储到其他寄存器, 再代为转存
    mov $BOOTSEG, %ax
    mov %ax, %es
    mov $_string, %bp
    # 调用 10.13 号打印中断, 打印一行文字, 文档如下:
        # ah = 13 模式号
        # al 写模式, bit 0: 是否移动光标, bit 1: 0 = 属性存储在 bl 中, 1 = 属性存储在字符串中
        mov $0x1301, %ax
        # bh 图形页, 我们目前没有分页, 所以直接设置为 0
        # bl 属性可能存储在这里, 这取决于 al 的值
        mov $0x000b, %bx
        # cx 字符串的长度, 忽略属性, 这里直接硬编码
        mov $20, %cx
        # dh, dl 如上所述表示光标所在行和列
    # 直接赋值给 ax 和 bx 等, 可以简化赋值过程
    int $0x10

# 在这里死循环
deadloop:
    jmp deadloop

_string:
    .ascii "Hello, Bootloader!\r\n\r\n"

# 对齐到 510 字节, 为了放置 0x55, 0xaa
# 为了 BIOS 能够识别这个引导扇区, 需要 0x55, 0xaa 的标记
.= 510

signature:
    .word 0xaa55
