
# - now path in browser is  http://localhost/cgi/BackupPC/BackupPC_Admin
# TODO:
# - trigers
# - polish translation in SOURCE/backuppc-pl.pm
# - patch at user and gid/uid user - http://sourceforge.net/mailarchive/forum.php?thread_id=6201024&forum_id=17540
# - change or/and add Requires for  --bin-path sendmail=%{_sbindir}/sendmail
# - correct config file

%define		oldname		backuppc
%define		BPCuser		http
%define		BPCgroup	http
%include	/usr/lib/rpm/macros.perl

Summary:	A high-performance, enterprise-grade system for backing up
Summary(pl.UTF-8):	Wysoko wydajny, profesjonalnej klasy system do kopii zapasowych
Name:		BackupPC
Version:	3.0.0
Release:	0.1
License:	GPL
Group:		Networking/Utilities
Source0:	http://dl.sourceforge.net/backuppc/%{name}-%{version}.tar.gz
# Source0-md5:	dc37728c1dc9225354523f279045f3f3
Source1:	%{oldname}_apache.conf
Source2:	%{oldname}-pl.pm
Patch0:		%{oldname}-usernotexist.patch
Patch1:		%{oldname}-pathtodocs.patch
URL:		http://backuppc.sourceforge.net/
BuildRequires:	perl-Compress-Zlib
BuildRequires:	perl-Digest-MD5
BuildRequires:	perl-devel >= 1:5.6.0
BuildRequires:	rpm-perlprov
BuildRequires:	rpmbuild(macros) >= 1.268
BuildRequires:	sed >= 4.0
Requires(post,preun):	/sbin/chkconfig
Requires:	apache(mod_auth)
Requires:	apache(mod_perl)
Requires:	par2cmdline
Requires:	perl-Archive-Zip
Requires:	perl-Compress-Bzip2
Requires:	perl-Compress-Zlib
Requires:	perl-File-RsyncP >= 0.52
Requires:	rc-scripts
Requires:	rsync
Requires:	samba-client
Requires:	sperl
Requires:	tar > 1.13
Requires:	webapps
Provides:	group(%{BPCgroup})
Provides:	user(%{BPCuser})
Obsoletes:	BackupPC
Obsoletes:      backuppc
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%define		_webapps	/etc/webapps
%define		_webapp		%{name}
%define		_libdir		/usr/lib

%description
BackupPC is disk based and not tape based. This particularity allows
features not found in any other backup solution:
- Clever pooling scheme minimizes disk storage and disk I/O. Identical
  files across multiple backups of the same or different PC are stored
  only once (using hard links), resulting in substantial savings in disk
  storage and disk writes.
- Optional compression provides additional reductions in storage. CPU
  impact of compression is low since only new files (those not already
  in the pool) need to be compressed.
- A powerful http/cgi user interface allows administrators to view log
  files, configuration, current status and allows users to initiate and
  cancel backups and browse and restore files from backups very quickly.
- No client-side software is needed. On WinXX the SMB protocol is
  used. On Linux or unix clients, rsync or tar (over ssh/rsh/NFS) can be
  used.
- Flexible restore options. Single files can be downloaded from any
  backup directly from the CGI interface. Zip or Tar archives for
  selected files or directories can also be downloaded from the CGI
  interface.
- BackupPC supports mobile environments where laptops are only
  intermittently connected to the network and have dynamic IP addresses
  (DHCP).
- Flexible configuration parameters allow multiple backups to be
  performed in parallel.
- and more to discover in the manual...

%description -l pl.UTF-8
BackupPC jest oparty na dyskach, a nie taśmach. Ta osobliwość daje
możliwości, których nie mają inne rozwiązania problemu kopii
zapasowych:
- Inteligentny schemat ściągania minimalizuje zajmowane miejsce i
  ilość operacji wejścia/wyjścia na dysku. Takie same pliki są
  przechowywane tylko raz (przy użyciu twardych dowiązań), co daje
  znaczącą oszczędność w miejscu na dysku i czasie zapisu.
- Opcjonalna kompresja pozwala na dalsze ograniczenie rozmiaru.
  Obciążenie procesora jest małe, ponieważ tylko nowe pliki muszą być
  kompresowane.
- Potężny interfejs użytkownika HTTP/CGI pozwala administratorom
  przeglądać pliki logów, konfigurację i aktualny stan oraz użytkownikom
  rozpoczynać lub przerywać tworzenie kopii oraz szybko przeglądać i
  odtwarzać pliki z kopii zapasowych.
- Nie jest wymagane oprogramowanie po stronie klienta. Na WinXX
  używany jest protokół SMB lub rsync (specjalnie przygotowana wersja
  pod cygwinem). Na klientach linuksowych lub uniksowych można używać
  rsynca lub tara (po ssh/rsh/NFS).
- Dostępne są elastyczne opcje odzyskiwania. Można ściągać pojedyncze
  pliki z kopii bezpośrednio z interfejsu CGI. Także archiwa zip lub tar
  z wybranymi plikami lub katalogami mogą być ściągane z poziomu
  interfejsu CGI.
- BackupPC obsługuje środowiska przenośne, gdzie laptopy są podłączane
  do sieci tylko z przerwami i mają dynamiczne adresy IP (z DHCP).
- Elastyczna konfiguracja parametrów pozwala na wykonywanie wielu
  kopii równolegle.
- Istnieje możliwość nagrywania backupu na inne nośniki (tasmy,
  DVD-R/RW, CD-R/RW i inne)
- Wiele więcej można odkryć w manualu...

%prep
%setup -q

sed -i -e 's#!/bin/perl#!%{__perl}#' configure.pl
sed -i -e 's#!/bin/perl#!%{__perl}#' {bin,cgi-bin,doc}/*
sed -i -e 's#!/bin/perl#!%{__perl}#' */src/*
sed -i -e 's#!/bin/perl#!%{__perl}#' */*/*/*.pm

pod2man --section=8 --center="BackupPC manual" doc/BackupPC.pod backuppc.8
%{__perl} -e "s/.IX Title.*/.SH NAME\nbackuppc \\- BackupPC manual/g" -p -i.tmp backuppc.8

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/etc/{rc.d/init.d,httpd/httpd.conf} \
			$RPM_BUILD_ROOT%{_mandir}/man8 \
			$RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/doc \
			$RPM_BUILD_ROOT%{_var}/{lib/%{name}/{pc/localhost,log},log} \
			$RPM_BUILD_ROOT%{_datadir}/%{name}/conf \
			$RPM_BUILD_ROOT%{_sysconfdir}/%{name}

%{__perl} configure.pl \
	--batch \
	--bin-path perl=%{__perl} \
	--bin-path tar=/bin/tar \
	--bin-path smbclient=%{_bindir}/smbclient \
	--bin-path nmblookup=%{_bindir}/nmblookup \
	--bin-path rsync=%{_bindir}/rsync \
	--bin-path ping=/bin/echo \
	--bin-path df=/bin/df \
	--bin-path ssh=%{_bindir}/ssh \
	--bin-path sendmail=%{_sbindir}/sendmail \
	--bin-path par2=%{_bindir}/par \
	--bin-path hostname=/bin/hostname \
	--bin-path split=%{_bindir}/split \
	--bin-path cat=/bin/cat \
	--bin-path gzip=/bin/gzip \
	--bin-path bzip2=%{_bindir}/bzip2 \
	--cgi-dir %{_datadir}/%{name}/www/cgi-bin \
	--data-dir %{_var}/lib/%{name} \
	--dest-dir $RPM_BUILD_ROOT \
	--hostname localhost \
	--html-dir %{_datadir}/%{name}/www/html \
	--html-dir-url /BackupPC \
	--install-dir %{_usr} \
	--uid-ignore \
	--no-set-perms \
	--fhs \
	--dest-dir $RPM_BUILD_ROOT \
	--compress-level=3 \
	--backuppc-user=%{BPCuser}
#	--config-path=%{_sysconfdir}/%{name}/config.pl

#change user in init script
sed -i -e 's#--user backuppc#--user %{BPCuser}#' init.d/linux-backuppc
#change user in config file
#sed -i -e "s#'backuppc';#'%{BPCuser}';#" $RPM_BUILD_ROOT%{_sysconfdir}/%{name}/config.pl
#sed -i -e 's/$Conf{SendmailPath} =/#$Conf{SendmailPath} =/' $RPM_BUILD_ROOTT%{_sysconfdir}/%{name}/config.pl

install init.d/linux-backuppc $RPM_BUILD_ROOT/etc/rc.d/init.d/backuppc
install backuppc.8 $RPM_BUILD_ROOT%{_mandir}/man8
install %{SOURCE2} $RPM_BUILD_ROOT%{_libdir}/BackupPC/Lang/pl.pm
install doc/* $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/doc
# Cleanups:
rm -f $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/CVS
rm -rdf $RPM_BUILD_ROOT%{_prefix}/doc

# symlinks
cd $RPM_BUILD_ROOT%{_var}/lib/%{name}
ln -sf %{_sysconfdir}/%{name} $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf

cd $RPM_BUILD_ROOT%{_var}/log
ln -sf %{_var}/lib/%{name}/log %{name}

cd $RPM_BUILD_ROOT%{_datadir}/%{name}/www/cgi-bin
ln -sf BackupPC_Admin index.cgi

mv $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/*.css \
	$RPM_BUILD_ROOT%{_sysconfdir}/%{name}

cd $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html
ln -sf %{_sysconfdir}/%{name}/BackupPC_stnd.css BackupPC_stnd.css
ln -sf %{_sysconfdir}/%{name}/BackupPC_stnd.css BackupPC.css

install -d $RPM_BUILD_ROOT%{_webapps}/%{_webapp}
install %{SOURCE1} $RPM_BUILD_ROOT%{_webapps}/%{_webapp}/apache.conf
install %{SOURCE1} $RPM_BUILD_ROOT%{_webapps}/%{_webapp}/httpd.conf
touch $RPM_BUILD_ROOT%{_webapps}/%{_webapp}/htpasswd

%if 0
%pre
# Add the "backuppc" user and "http" group
%groupadd -g 150 %{BPCgroup}
%useradd -c "system user for %{name}" -u 150 -d /var/lib/backuppc -s /bin/false -g %{BPCgroup} %{BPCuser}
%endif

%post
%service backuppc restart "BackupPC"

%preun
if [ "$1" = "0" ]; then
	%service backuppc stop
	/sbin/chkconfig --del backuppc
fi

%postun
if [ "$1" = "0" ]; then
	%userremove %{BPCuser}
	%groupremove %{BPCgroup}
fi

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%attr(755,root,root) %{_bindir}/*
%attr(755,root,root) %{_datadir}/%{name}/www/cgi-bin/BackupPC_Admin
%dir %{_datadir}/%{name}
%dir %{_datadir}/%{name}/www/html/doc
%{_datadir}/%{name}/www/html/doc/*
%dir %{_datadir}/%{name}/www
%dir %{_datadir}/%{name}/www/html
%dir %{_datadir}/%{name}/www/cgi-bin
%{_datadir}/%{name}/www/html/*.png
%{_datadir}/%{name}/www/html/*.gif
%config(noreplace) %verify(not md5 mtime size) %{_datadir}/%{name}/www/html/*.css
%dir %{_libdir}/%{name}
%{_libdir}/%{name}/CGI/*
%{_libdir}/%{name}/Xfer/*
%{_libdir}/%{name}/Storage/*
%{_libdir}/%{name}/Zip/*
%{_libdir}/%{name}/Config/*
%{_libdir}/%{name}/Attrib.pm
%{_libdir}/%{name}/Config.pm
%{_libdir}/%{name}/FileZIO.pm
%{_libdir}/%{name}/Lib.pm
%{_libdir}/%{name}/PoolWrite.pm
%{_libdir}/%{name}/Storage.pm
%{_libdir}/%{name}/View.pm
%dir %attr(755,%{BPCuser},%{BPCgroup}) %{_libdir}/BackupPC/Lang
%lang(en) %{_libdir}/BackupPC/Lang/en.pm
%lang(de) %{_libdir}/BackupPC/Lang/de.pm
%lang(fr) %{_libdir}/BackupPC/Lang/fr.pm
%lang(es) %{_libdir}/BackupPC/Lang/es.pm
%lang(it) %{_libdir}/BackupPC/Lang/it.pm
%lang(nl) %{_libdir}/BackupPC/Lang/nl.pm
%lang(pl) %{_libdir}/BackupPC/Lang/pl.pm
%lang(pt_br) %{_libdir}/BackupPC/Lang/pt_br.pm
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/cpool
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/log
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/pc
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/pool
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/trash
%dir %attr(755,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/conf
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/log/%{name}
%attr(754,root,root) /etc/rc.d/init.d/backuppc
%dir %{_sysconfdir}/%{name}
%{_mandir}/man8/backuppc*
%config(noreplace) %verify(not md5 mtime size) %attr(644,%{BPCuser},%{BPCgroup}) %{_sysconfdir}/%{name}/*
%dir %attr(750,root,http) %{_webapps}/%{_webapp}
%attr(640,root,root) %config(noreplace) %verify(not md5 mtime size) %{_webapps}/%{_webapp}/apache.conf
%attr(640,root,root) %config(noreplace) %verify(not md5 mtime size) %{_webapps}/%{_webapp}/httpd.conf
%attr(640,root,http) %config(noreplace) %verify(not md5 mtime size) %{_webapps}/%{_webapp}/htpasswd
