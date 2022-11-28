CC		= gcc
OBJD	= objdump
UNSAFEF = -fno-stack-protector -m32 -no-pie

default: index

index:
	@echo "Dependencies:"
	@echo "-	make multilib -> install gcc-multilib."
	@echo "Binaries:"
	@echo "-	make hacked -> generate hacked originals binary."
	@echo "-	make exploit -> generate a c version of the original exploit."
	@echo "Run:"
	@echo "-	make pyexploit -> run the python3 version of the exploit."
	@echo "-	make cexploit -> run the c version of the exploit."
	@echo "Miscelaneous:"
	@echo "-	make hacked-dump -> generate hacked objdump."
	@echo "-	make clean -> clean /bin directory."

multilib:
	sudo apt install gcc-multilib

hacked: original/hacked.c original/secrets.c
	@$(CC) -o bin/hacked original/hacked.c original/secrets.c $(UNSAFEF)

dumphacked: bin/hacked
	@$(OBJD) -d bin/hacked > hacked-dump

exploit: exploits/exploit.c
	@$(CC) -o bin/exploit exploits/exploit.c $(UNSAFEF)

pyexploit: exploits/exploit.py
	(python3 exploits/exploit.py; cat) | ./bin/hacked

cexploit: bin/exploit
	(./bin/exploit; cat) | ./bin.hacked

clean:
	@rm ./bin/*