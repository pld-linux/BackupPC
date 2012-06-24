# TODO:
# - make it simply build...
# - make pre/post for apache
# - add all needed files to %files
%include	/usr/lib/rpm/macros.perl
Summary:	A high-performance, enterprise-grade system for backing up PCs
Summary(pl):	Wysoko wydajny, profesjonalnej klasy system do kopii zapasowych z PC
Name:		backuppc
Version:	2.1.0
Release:	0.5
License:	GPL
Group:		Networking/Utilities
Source0:	http://dl.sourceforge.net/backuppc/BackupPC-%{version}.tar.gz
# Source0-md5:	4e201f00842c88cf241e0429643c6ec4
Patch0:		%{name}-usernotexist.patch
URL:		http://backuppc.sourceforge.net/
#BuildRequires:	fakeroot
BuildRequires:	perl-base
BuildRequires:	perl-devel >= 1:5.6.0
BuildRequires:	perl-Compress-Zlib
BuildRequires:	perl-Digest-MD5
Requires:	samba-client
# lets check if it's really needed
#Requires:	sperl
Requires:	tar > 1.13
Requires:	webserver
Obsoletes:	BackupPC
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%define		_backuppcdir	%{_datadir}/%{name}

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

%description -l pl
BackupPC jest oparty na dyskach, a nie ta�mach. Ta osobliwo�� daje
mo�liwo�ci, kt�rych nie maj� inne rozwi�zania problemu kopii
zapasowych:
- Inteligentny schemat �ci�gania minimalizuje zajmowane miejsce i
  ilo�� operacji wej�cia/wyj�cia na dysku. Takie same pliki s�
  przechowywane tylko raz (przy u�yciu twardych dowi�za�), co daje
  znacz�c� oszcz�dno�� w miejscu na dysku i czasie zapisu.
- Opcjonalna kompresja pozwala na dalsze ograniczenie rozmiaru.
  Obci��enie procesora jest ma�e, poniewa� tylko nowe pliki musz� by�
  kompresowane.
- Pot�ny interfejs u�ytkownika HTTP/CGI pozwala administratorom
  przegl�da� pliki log�w, konfiguracj� i aktualny stan oraz u�ytkownikom
  rozpoczyna� lub przerywa� tworzenie kopii oraz szybko przegl�da� i
  odtwarza� pliki z kopii zapasowych.
- Nie jest wymagane oprogramowanie po stronie klienta. Na WinXX
  u�ywany jest protok� SMB. Na klientach linuksowych lub uniksowych
  mo�na u�ywa� rsynca lub tara (po ssh/rsh/NFS).
- Dost�pne s� elastyczne opcje odzyskiwania. Mo�na �ci�ga� pojedyncze
  pliki z kopii bezpo�rednio z interfejsu CGI. Tak�e archiwa zip lub tar
  z wybranymi plikami lub katalogami mog� by� �ci�gane z poziomu
  interfejsu CGI.
- BackupPC obs�uguje �rodowiska przeno�ne, gdzie laptopy s� pod��czane
  do sieci tylko z przerwami i maj� dynamiczne adresy IP (z DHCP).
- Elastyczna konfiguracja parametr�w pozwala na wykonywanie wielu
  kopii r�wnolegle.
- Wiele wi�cej mo�na odkry� w manualu...

%prep
%setup -q -n BackupPC-%{version}
%patch0 -p1

%build
sed -i -e 's#!/bin/perl#!%{__perl}#' configure.pl
sed -i -e 's#!/bin/perl#!%{__perl}#' {bin,cgi-bin,doc}/*
sed -i -e 's#!/bin/perl#!%{__perl}#' */src/*
sed -i -e 's#!/bin/perl#!%{__perl}#' */*/*/*.pm

pod2man --section=8 --center="BackupPC manual" doc/BackupPC.pod backuppc.8
perl -e "s/.IX Title.*/.SH NAME\nbackuppc \\- BackupPC manual/g" -p -i.tmp backuppc.8

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/etc/{rc.d/init.d,%{name},httpd/httpd.conf} \
	$RPM_BUILD_ROOT%{_var}/lib/%{name}/pc/localhost

# Does not work, yet... some voodoo-magic is needed
#echo "y" | fakeroot DEBIANDEST=$RPM_BUILD_ROOT configure.pl
%{__perl} configure.pl \
	--batch \
	--bin-path perl=%{__perl} \
	--bin-path tar=/bin/tar \
	--bin-path smbclient=%{_bindir}/smbclient \
	--bin-path nmblookup=%{_bindir}/nmblookup \
	--bin-path rsync=%{_bindir}/rsync \
	--bin-path ping=/bin/ping \
	--bin-path df=/bin/df \
	--bin-path ssh=%{_bindir}/ssh \
	--bin-path sendmail=%{_sbindir}/sendmail \
	--bin-path hostname=/bin/hostname \
	--bin-path split=%{_bindir}/split \
	--bin-path cat=/bin/cat \
	--bin-path gzip=/bin/gzip \
	--bin-path bzip2=%{_bindir}/bzip2 \
	--cgi-dir %{_datadir}/BackupPC/cgi-bin \
	--data-dir %{_var}/lib/BackupPC \
	--dest-dir $RPM_BUILD_ROOT \
	--hostname localhost \
	--html-dir %{_usr}/share/BackupPC/www/html \
	--html-dir-url /BackupPC \
	--install-dir  %{_usr} \
	--uid-ignore
#	--config-path %{_sysconfdir}/backuppc \

#mv -f $RPM_BUILD_ROOT/var/lib/backuppc/conf/* $RPM_BUILD_ROOT%{_sysconfdir}/backuppc
#mv -f $RPM_BUILD_ROOT%{_datadir}/backuppc/cgi-bin/BackupPC_Admin $RPM_BUILD_ROOT%{_datadir}/backuppc/cgi-bin/index.cgi
#install conf/hosts $RPM_BUILD_ROOT%{_sysconfdir}/backuppc
#install debian/localhost.pl $RPM_BUILD_ROOT%{_sysconfdir}/backuppc
#install debian/apache.conf $RPM_BUILD_ROOT%{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf

# Cleanups:
#rm -f $RPM_BUILD_ROOT%{_datadir}/backuppc/doc/*
#rmdir $RPM_BUILD_ROOT/var/lib/backuppc/conf

# Linking cgi:
#cd $RPM_BUILD_ROOT%{_datadir}/backuppc/cgi-bin
#ln -s ../image

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc doc/*.html
#%attr(750,root,root) %dir %{_sysconfdir}/backuppc
#%config(noreplace) %verify(not md5 size mtime) %attr(640,root,root) %{_sysconfdir}/backuppc/*
#%config(noreplace) %verify(not md5 size mtime) %attr(640,root,root) %{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf
#%attr(755,root,root) %{_bindir}/*
%attr(750,root,root) %dir %{_var}/lib/backuppc
