
%define		BPCuser		backuppc
%define		BPCgroup	backuppc
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
Source1:	%{name}_apache.conf
Source2:	%{name}_htaccess
Patch0:		%{name}-usernotexist.patch
URL:		http://backuppc.sourceforge.net/
BuildRequires:	perl-Compress-Zlib
BuildRequires:	perl-Digest-MD5
BuildRequires:	perl-base
BuildRequires:	perl-devel >= 1:5.6.0
BuildRequires:	rpmbuild(macros) >= 1.159
Requires:	apache
Requires:	samba-client
# lets check if it's really needed
#Requires:	sperl
Requires:	tar > 1.13
Provides:	group(%{BPCgroup})
Provides:	user(%{BPCuser})
Obsoletes:	BackupPC
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
BackupPC is disk based and not tape based. This particularity allows
features not found in any other backup solution:
- Clever pooling scheme minimizes disk storage and disk I/O. Identical
  files across multiple backups of the same or different PC are stored
  only once (using hard links), resulting in substantial savings in
  disk storage and disk writes.
- Optional compression provides additional reductions in storage. CPU
  impact of compression is low since only new files (those not already
  in the pool) need to be compressed.
- A powerful http/cgi user interface allows administrators to view log
  files, configuration, current status and allows users to initiate
  and cancel backups and browse and restore files from backups very
  quickly.
- No client-side software is needed. On WinXX the SMB protocol is
  used. On Linux or unix clients, rsync or tar (over ssh/rsh/NFS) can
  be used.
- Flexible restore options. Single files can be downloaded from any
  backup directly from the CGI interface. Zip or Tar archives for
  selected files or directories can also be downloaded from the CGI
  interface.
- BackupPC supports mobile environments where laptops are only
  intermittently connected to the network and have dynamic IP
  addresses (DHCP).
- Flexible configuration parameters allow multiple backups to be
  performed in parallel.
- and more to discover in the manual...

%description -l pl
BackupPC jest oparty na dyskach, a nie ta¶mach. Ta osobliwo¶æ daje
mo¿liwo¶ci, których nie maj± inne rozwi±zania problemu kopii
zapasowych:
- Inteligentny schemat ¶ci±gania minimalizuje zajmowane miejsce i
  ilo¶æ operacji wej¶cia/wyj¶cia na dysku. Takie same pliki s±
  przechowywane tylko raz (przy u¿yciu twardych dowi±zañ), co daje
  znacz±c± oszczêdno¶æ w miejscu na dysku i czasie zapisu.
- Opcjonalna kompresja pozwala na dalsze ograniczenie rozmiaru.
  Obci±¿enie procesora jest ma³e, poniewa¿ tylko nowe pliki musz± byæ
  kompresowane.
- Potê¿ny interfejs u¿ytkownika HTTP/CGI pozwala administratorom
  przegl±daæ pliki logów, konfiguracjê i aktualny stan oraz
  u¿ytkownikom rozpoczynaæ lub przerywaæ tworzenie kopii oraz szybko
  przegl±daæ i odtwarzaæ pliki z kopii zapasowych.
- Nie jest wymagane oprogramowanie po stronie klienta. Na WinXX
  u¿ywany jest protokó³ SMB. Na klientach linuksowych lub uniksowych
  mo¿na u¿ywaæ rsynca lub tara (po ssh/rsh/NFS).
- Dostêpne s± elastyczne opcje odzyskiwania. Mo¿na ¶ci±gaæ pojedyncze
  pliki z kopii bezpo¶rednio z interfejsu CGI. Tak¿e archiwa zip lub
  tar z wybranymi plikami lub katalogami mog± byæ ¶ci±gane z poziomu
  interfejsu CGI.
- BackupPC obs³uguje ¶rodowiska przeno¶ne, gdzie laptopy s± pod³±czane
  do sieci tylko z przerwami i maj± dynamiczne adresy IP (z DHCP).
- Elastyczna konfiguracja parametrów pozwala na wykonywanie wielu
  kopii równolegle.
- Wiele wiêcej mo¿na odkryæ w manualu...

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
install -d -m 755 $RPM_BUILD_ROOT%{_sysconfdir}/{rc.d/init.d,%{name},httpd/httpd.conf} \
	$RPM_BUILD_ROOT%{_usr}/share/%{name}/www/html \
	$RPM_BUILD_ROOT%{_var}/lib/%{name}/pc/localhost \
	$RPM_BUILD_ROOT%{_datadir}/%{name}/conf \
	$RPM_BUILD_ROOT%/home/services/httpd/cgi-bin/%{name}

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
	--cgi-dir /home/services/httpd/cgi-bin/%{name} \
	--data-dir %{_var}/lib/%{name} \
	--dest-dir $RPM_BUILD_ROOT \
	--hostname localhost \
	--html-dir %{_usr}/share/%{name}/www/html \
	--html-dir-url /BackupPC \
	--install-dir  %{_usr} \
	--uid-ignore
#	--config-path

install init.d/linux-backuppc $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d/backuppc
install conf/BackupPC_stnd.css  $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf/BackupPC_stnd.css
install %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf
install %{SOURCE2} $RPM_BUILD_ROOT/home/services/httpd/cgi-bin/%{name}/.htaccess

#mv -f $RPM_BUILD_ROOT/var/lib/backuppc/conf/* $RPM_BUILD_ROOT%{_sysconfdir}/backuppc
#mv -f $RPM_BUILD_ROOT%{_datadir}/backuppc/cgi-bin/BackupPC_Admin $RPM_BUILD_ROOT%{_datadir}/backuppc/cgi-bin/index.cgi

# Cleanups:
rm -f $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/CVS

%pre
# Add the "backuppc" user and group
if [ -n "`/usr/bin/getgid %{BPCgroup}`" ]; then
	if [ "`/usr/bin/getgid %{BPCgroup}`" != "150" ]; then
		echo "Error: group %{BPCgroup} doesn't have gid=150. Correct this before installing %{name}." 1>&2
		exit 1
	fi
else
	/usr/sbin/groupadd -g 150 %{BPCgroup}
fi
if [ -n "`/bin/id -u %{BPCuser} 2>/dev/null`" ]; then
	if [ "`/bin/id -u %{BPCuser}`" != 150 ]; then
		echo "Error: user %{BPCuser} doesn't have uid=150. Correct this before installing %{name}." 1>&2
		exit 1
	fi
else
	/usr/sbin/useradd -c "system user for %{name}" -u 150 \
		-d /home/services/BackupPC -s /bin/false -g %{BPCgroup} %{BPCuser} 1>&2
fi

%post
ln -s %{_var}/lib/%{name}/conf/ %{_sysconfdir}/%{name}

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
%doc %{_usr}/doc/*.html
%doc %{_usr}/doc/BackupPC.pod
%dir /home/services/httpd/cgi-bin/%{name}/
%attr(755,root,root)/home/services/httpd/cgi-bin/%{name}/*
%dir %{_usr}/share/%{name}/www/html/
%{_usr}/share/%{name}/www/html/*
%dir %{_libdir}/BackupPC/
%{_libdir}/BackupPC/*
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/cpool/
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/log/
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/pc/
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/pool/
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/trash/
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/conf/
%attr(755,root,root) %{_sysconfdir}/rc.d/init.d/backuppc
%{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf
%config(noreplace) %verify(not md5 size mtime) %attr(640,root,root) /home/services/httpd/cgi-bin/%{name}/.htaccess
%config(noreplace) %verify(not md5 size mtime) %attr(640,%{BPCuser},%{BPCgroup})  %{_var}/lib/%{name}/conf/*
