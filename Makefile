DIR_OBJ = ./lib
DIR_BIN = ./bin
DIR_Config = ./lib/Config
DIR_Examples = ./examples
DIR_FONT = ./lib/Fonts
DIR_OLED = ./lib/OLED



OBJ_C = $(wildcard ${DIR_OBJ}/*.c ${DIR_Examples}/*.c ${DIR_Config}/*.c ${DIR_FONT}/*.c ${DIR_OLED}/*.c)
OBJ_O = $(patsubst %.c,${DIR_BIN}/%.o,$(notdir ${OBJ_C}))

TARGET = fanChecker
#BIN_TARGET = ${DIR_BIN}/${TARGET}

CC = gcc

DEBUG = -O3 -Wall
CFLAGS += $(DEBUG)

# USELIB = USE_BCM2835_LIB
# USELIB = USE_WIRINGPI_LIB
USELIB = USE_DEV_LIB
DEBUG += -D $(USELIB)
ifeq ($(USELIB), USE_BCM2835_LIB)
    LIB = -lbcm2835 -lm 
else ifeq ($(USELIB), USE_WIRINGPI_LIB)
    LIB = -lwiringPi -lm 
endif

${TARGET}:${OBJ_O}
	$(CC) $(CFLAGS) $(OBJ_O) -o $@ $(LIB)

${DIR_BIN}/%.o : $(DIR_Examples)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c  $< -o $@ $(LIB) -I $(DIR_OBJ) -I $(DIR_Config) -I $(DIR_FONT)  -I $(DIR_OLED)

${DIR_BIN}/%.o : $(DIR_OBJ)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c  $< -o $@ $(LIB) -I $(DIR_Config) -I $(DIR_FONT) -I $(DIR_OLED) 
    
${DIR_BIN}/%.o : $(DIR_OLED)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c  $< -o $@ $(LIB) -I $(DIR_Config) -I $(DIR_FONT) 

${DIR_BIN}/%.o : $(DIR_FONT)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c  $< -o $@ $(LIB)
    
${DIR_BIN}/%.o : $(DIR_Config)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c  $< -o $@ $(LIB)

clean :
	rm $(DIR_BIN)/*.* 
	rm $(TARGET) 

install:
	cp -f fanChecker.service /usr/lib/systemd/system/
	cp -f fanChecker /usr/bin/
	systemctl daemon-reload
	systemctl enable fanChecker
	systemctl restart fanChecker
# creare utente fan-checker e inserirlo gruppo i2c