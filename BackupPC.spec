%include	/usr/lib/rpm/macros.perl
Summary:	A high-performance, enterprise-grade system for backing up PCs
Summary(pl):	Wysoko wydajny, profesjonalnej klasy system do kopii zapasowych z PC
Name:		backuppc
Version:	2.0.2
Release:	2
License:	GPL
Group:		Networking/Utilities
Source0:	http://dl.sourceforge.net/backuppc/BackupPC-%{version}.tar.gz
# Source0-md5:	d60aacbf46eb83a7e4ffbbe9e4f72c11
Patch0:		%{name}-debian.patch
URL:		http://backuppc.sourceforge.net/
BuildRequires:	fakeroot
BuildRequires:	perl-devel >= 1:5.6.0
BuildRequires:	perl-Compress-Zlib
BuildRequires:	perl-Digest-MD5
Requires:	tar > 1.13
Requires:	samba-clients
Requires:	sperl
Requires:	webserver
Obsoletes:	BackupPC
BuildArch:	noarch
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

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
  przegl±daæ pliki logów, konfiguracjê i aktualny stan oraz u¿ytkownikom
  rozpoczynaæ lub przerywaæ tworzenie kopii oraz szybko przegl±daæ i
  odtwarzaæ pliki z kopii zapasowych.
- Nie jest wymagane oprogramowanie po stronie klienta. Na WinXX
  u¿ywany jest protokó³ SMB. Na klientach linuksowych lub uniksowych
  mo¿na u¿ywaæ rsynca lub tara (po ssh/rsh/NFS).
- Dostêpne s± elastyczne opcje odzyskiwania. Mo¿na ¶ci±gaæ pojedyncze
  pliki z kopii bezpo¶rednio z interfejsu CGI. Tak¿e archiwa zip lub tar
  z wybranymi plikami lub katalogami mog± byæ ¶ci±gane z poziomu
  interfejsu CGI.
- BackupPC obs³uguje ¶rodowiska przeno¶ne, gdzie laptopy s± pod³±czane
  do sieci tylko z przerwami i maj± dynamiczne adresy IP (z DHCP).
- Elastyczna konfiguracja parametrów pozwala na wykonywanie wielu
  kopii równolegle.
- Wiele wiêcej mo¿na odkryæ w manualu...

%prep
%setup -q -n BackupPC-%{version}
%patch0 -p1

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/etc/{rc.d/init.d,backuppc,httpd/httpd.conf}

echo "y" | \
fakeroot DEBIANDEST=$RPM_BUILD_ROOT %{__perl} configure.pl

pod2man --section=8 --center="BackupPC manual" doc/BackupPC.pod backuppc.8
perl -e "s/.IX Title.*/.SH NAME\nbackuppc \\- BackupPC manual/g" -p -i.tmp backuppc.8
rm -f $RPM_BUILD_ROOT%{_datadir}/backuppc/doc/*
mv -f $RPM_BUILD_ROOT/var/lib/backuppc/conf/* $RPM_BUILD_ROOT%{_sysconfdir}/backuppc
mv -f $RPM_BUILD_ROOT%{_datadir}/backuppc/cgi-bin/* $RPM_BUILD_ROOT%{_datadir}/backuppc/cgi-bin/index.cgi
install --mode=644 conf/hosts $RPM_BUILD_ROOT%{_sysconfdir}/backuppc
install --mode=644 debian/localhost.pl $RPM_BUILD_ROOT%{_sysconfdir}/backuppc
install --mode=644 debian/apache.conf $RPM_BUILD_ROOT%{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf
rmdir $RPM_BUILD_ROOT/var/lib/backuppc/conf
install -d $RPM_BUILD_ROOT/var/lib/backuppc/pc/localhost

cd $RPM_BUILD_ROOT%{_datadir}/backuppc/cgi-bin
ln -s ../image

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc doc/*.html
%attr(750,root,root) %dir %{_sysconfdir}/backuppc
%config(noreplace) %verify(not md5 size mtime) %attr(640,root,root) %{_sysconfdir}/backuppc/*
%attr(755,root,root) %{_bindir}/*
%attr(750,root,root) %dir %{_var}/lib/backuppc
%{_mandir}/man?/*
