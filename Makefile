ARCH ?= x86

TRIPLE ?= i686-elf-

CARGO ?= cargo
RUSTC ?= rustc
LD := $(TRIPLE)ld
AS := $(TRIPLE)as
OBJDUMP := $(TRIPLE)objdump
OBJCOPY := $(TRIPLE)objcopy

OBJDIR := .obj/$(ARCH)/

LINKFLAGS := -T src/linker.ld
LINKFLAGS += -Map $(OBJDIR)map.txt
LINKFLAGS += --gc-sections
LINKFLAGS += -z max-page-size=0x1000

OBJS := start.o kernel.a
OBJS := $(OBJS:%=$(OBJDIR)%)
BIN := kernel.bin

.PHONY: all clean PHONY

all: $(BIN)

clean:
	$(RM) -rf $(BIN) $(BIN).dsm $(OBJDIR)

$(BIN): $(OBJS) src/linker.ld
	$(LD) -o $@ $(LINKFLAGS) $(OBJS)
	$(OBJDUMP) -S $@ > $@.dsm


$(OBJDIR)kernel.a: PHONY Makefile $(TARGETSPEC)
	@mkdir -p $(dir $@)
	$(CARGO) build --release
	@cp --preserve target/target/release/libk_os.a $@

# Compile architecture's assembly stub
$(OBJDIR)start.o: src/boot.s Makefile
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<


# Include dependency files
-include $(OBJDIR)start.d

run: kernel.bin
	qemu-system-i386 -kernel kernel.bin
