## GNU Makefile

CFLAGS = -Wall -Wextra -Wno-unused-parameter -g -O2

headers = $(wildcard src/*.h)
sources = $(wildcard src/*.c)
objects = $(sources:.c=.o)

vcprompt: $(objects)
	$(CC) $(LDFLAGS) $(CPPFLAGS) -o $@ $(objects)

# Maximally pessimistic view of header dependencies.
$(objects): $(headers)

.PHONY: check check-simple check-git
check: check-simple check-git

gitrepo = tests/git-repo.tar

check-simple: vcprompt
	cd tests && ./test-simple

check-git: vcprompt $(gitrepo)
	cd tests && ./test-git

$(gitrepo): tests/setup-git
	cd tests && ./setup-git

clean:
	$(RM) $(objects) vcprompt

DESTDIR =
PREFIX = /usr/local
.PHONY: install
install: vcprompt
	install -d $(DESTDIR)/$(PREFIX)/bin
	install -m 755 vcprompt $(DESTDIR)/$(PREFIX)/bin
