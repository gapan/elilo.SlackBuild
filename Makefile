DESTDIR ?= /
PACKAGE_LOCALE_DIR ?= /usr/share/locale

.PHONY: mo
mo:
	for i in `ls po/*.po`;do \
		echo "Compiling `echo $$i|sed "s|/po||"`"; \
		msgfmt $$i -o `echo $$i | sed "s/\.po//"`.mo; \
	done

.PHONY: pot
pot:
	xgettext --from-code=utf-8 -L shell -o po/eliloconfig.pot eliloconfig

.PHONY: update-po
update-po: pot
	for i in `ls po/*.po`; do \
		echo "Merging $$i translation..."; \
		msgmerge -U $$i po/eliloconfig.pot; \
	done

.PHONY: clean
clean:
	rm -f po/*.mo
	rm -f po/*~

.PHONY: cleanpo
cleanpo:
	find po/ -name '*.po' -print0 | while read -d '' -r file; do msgattrib --output-file="$$file" --no-obsolete "$$file"; done

.PHONY: install
install:
	for i in `ls po/*.mo`; do \
		install -d -m 755 \
		$(DESTDIR)/$(PACKAGE_LOCALE_DIR)/`basename $$i|sed "s/.mo//"`/LC_MESSAGES \
		2> /dev/null; \
		install -m 644 $$i \
		$(DESTDIR)/$(PACKAGE_LOCALE_DIR)/`basename $$i|sed "s/.mo//"`/LC_MESSAGES/eliloconfig.mo; \
	done;
