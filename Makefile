# Makefile to build the SDL Image library

INCLUDE = -I./
CFLAGS  = -g -O2 $(INCLUDE)
CC = xenon-gcc
AR	= xenon-ar
AS	= xenon-as
RANLIB	= xenon-ranlib

CFLAGS=$(INCLUDE) -ffunction-sections -fdata-sections  -mno-altivec -mhard-float -mcpu=cell -mtune=cell -m32 -fno-pic -mpowerpc64 -DXENON -DLOAD_JPG -DLOAD_PNG -DLOAD_BMP -DLOAD_GIF -DLOAD_LBM -DLOAD_PCX -DLOAD_PNM -DLOAD_TGA -DLOAD_XCF -DLOAD_XPM -DLOAD_XV -I$(DEVKITXENON)/usr/include/ -I$(DEVKITXENON)/usr/include/SDL/

TARGET  = libSDL_image.a
SOURCES = \
	*.c \	

OBJECTS = $(shell echo $(SOURCES) | sed -e 's,\.c,\.o,g' -e 's,\.s,\.o,g')

all: $(TARGET)

$(TARGET): $(CONFIG_H) $(OBJECTS) 
	$(AR) crv $@ $^

%.o: %.c
	@echo [$(notdir $<)]
	@$(CC) -o $@ -c $< $(CFLAGS)
	
%.o: %.s
	@echo [$(notdir $<) $@ $*]
	$(CC) -MMD -MP -MF $*.d -x assembler-with-cpp $(ASFLAGS) -m32 -mno-altivec -fno-pic -mpowerpc64 -mhard-float -c $< -o $@
	
clean:
	rm -f $(TARGET) $(OBJECTS)

install: all		
	cp -r *.h $(DEVKITXENON)/usr/include/SDL/ 
	cp $(TARGET) $(DEVKITXENON)/usr/lib/$(TARGET)
