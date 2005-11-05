
# - now path in browser is  http://localhost/cgi/BackupPC/BackupPC_Admin
# TODO:
# - polish translation in SOURCE/backuppc-pl.pm
# - patch for service user - now is static backuppc
# - patch at user and gid/uid user - http://sourceforge.net/mailarchive/forum.php?thread_id=6201024&forum_id=17540
# - compliant to FHS - http://sourceforge.net/mailarchive/forum.php?thread_id=5602342&forum_id=17540 - directory /var/log/backuppc
# - change or/and add Requires for  --bin-path sendmail=%{_sbindir}/sendmail
# - correct config file

%define		BPCuser		http
%define		BPCgroup	http
%include	/usr/lib/rpm/macros.perl

Summary:	A high-performance, enterprise-grade system for backing up PCs
Summary(pl):	Wysoko wydajny, profesjonalnej klasy system do kopii zapasowych z PC
Name:		backuppc
Version:	2.1.2
Release:	2
License:	GPL
Group:		Networking/Utilities
Source0:	http://dl.sourceforge.net/backuppc/BackupPC-%{version}.tar.gz
# Source0-md5:	72fc0f09084f44c42ba5d22451cfe29b
Source1:	%{name}_apache.conf
Source2:	%{name}_htaccess
Source3:	%{name}-pl.pm
Patch0:		%{name}-usernotexist.patch
Patch1:		%{name}-pathtodocs.patch
URL:		http://backuppc.sourceforge.net/
BuildRequires:	perl-Compress-Zlib
BuildRequires:	perl-Digest-MD5
BuildRequires:	perl-devel >= 1:5.6.0
BuildRequires:	rpm-perlprov
BuildRequires:	rpmbuild(macros) >= 1.202
BuildRequires:	sed >= 4.0
Requires:	apache
Requires:	perl-File-RsyncP >= 0.52
Requires:	perl-Compress-Zlib
Requires:	perl-Archive-Zip
Requires:	perl-Compress-Bzip2
Requires:	rsync
Requires:	apache-mod_perl
Requires:	apache-mod_auth
Requires:	par2cmdline
Requires:	samba-client
Requires:	sperl
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
  u¿ywany jest protokó³ SMB lub rsync (specjalnie przygotowana wersja
  pod cygwinem). Na klientach linuksowych lub uniksowych mo¿na u¿ywaæ
  rsynca lub tara (po ssh/rsh/NFS).
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
%patch1 -p1

%build
sed -i -e 's#!/bin/perl#!%{__perl}#' configure.pl
sed -i -e 's#!/bin/perl#!%{__perl}#' {bin,cgi-bin,doc}/*
sed -i -e 's#!/bin/perl#!%{__perl}#' */src/*
sed -i -e 's#!/bin/perl#!%{__perl}#' */*/*/*.pm



pod2man --section=8 --center="BackupPC manual" doc/BackupPC.pod backuppc.8
%{__perl} -e "s/.IX Title.*/.SH NAME\nbackuppc \\- BackupPC manual/g" -p -i.tmp backuppc.8

%install
rm -rf $RPM_BUILD_ROOT
install -d		$RPM_BUILD_ROOT/etc/{rc.d/init.d,httpd/httpd.conf} \
			$RPM_BUILD_ROOT%{_mandir}/man8 \
			$RPM_BUILD_ROOT%{_datadir}/%{name}/www/{html,cgi-bin,html/doc} \
			$RPM_BUILD_ROOT%{_var}/{lib/%{name}/pc/localhost,log} \
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
	--uid-ignore
#	--config-path

#change user in init script
sed -i -e 's#--user backuppc#--user %{BPCuser}#' init.d/linux-backuppc
#change user in config file
sed -i -e "s#'backuppc';#'%{BPCuser}';#" $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf/config.pl
sed -i -e 's/$Conf{SendmailPath} =/#$Conf{SendmailPath} =/' $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf/config.pl

install init.d/linux-backuppc $RPM_BUILD_ROOT/etc/rc.d/init.d/backuppc
install %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf
#install %{SOURCE2} $RPM_BUILD_ROOT%{_datadir}/%{name}/www/cgi-bin/.htaccess
install backuppc.8 $RPM_BUILD_ROOT%{_mandir}/man8
#install %{SOURCE3} $RPM_BUILD_ROOT%{_libdir}/BackupPC/Lang/pl.pm
install doc/* $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/doc
# Cleanups:
rm -f $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/CVS
rm -rdf $RPM_BUILD_ROOT/usr/doc

# symlinks
mv $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf/* $RPM_BUILD_ROOT%{_sysconfdir}/%{name}
rm -rdf $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf

cd $RPM_BUILD_ROOT%{_var}/lib/%{name}
ln -sf %{_sysconfdir}/%{name} $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf

cd $RPM_BUILD_ROOT%{_var}/log
ln -sf %{_var}/lib/%{name}/log %{name}

cd $RPM_BUILD_ROOT%{_datadir}/%{name}/www/cgi-bin
ln -sf BackupPC_Admin index.cgi

mv $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/BackupPC_stnd.css \
	$RPM_BUILD_ROOT/%{_sysconfdir}/%{name}

cd $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html
ln -sf %{_sysconfdir}/%{name}/BackupPC_stnd.css BackupPC_stnd.css


%if 0

%pre
# Add the "backuppc" user and "http" group
%groupadd -g 150 %{BPCgroup}
%useradd -c "system user for %{name}" -u 150 -d /var/lib/backuppc -s /bin/false -g %{BPCgroup} %{BPCuser}
%endif

%preun
if [ "$1" = "0" ]; then
	if [ -f /var/lock/subsys/backuppc ]; then
		/etc/rc.d/init.d/backuppc stop
	fi
	/sbin/chkconfig --del backuppc
fi


%post
if [ ! -f /etc/backuppc/password ]; then
# FIXME? $PASS variable cames from?
	openssl rand -base64 6 > $PASS
	/usr/bin/htpasswd -cb /etc/backuppc/password admin $PASS
	echo "Your web pasword is: $PASS ."
	echo "Change this: htpasswd -b /etc/backuppc/password user password"
fi

if [ -f /var/lock/subsys/backuppc ]; then
	/etc/rc.d/init.d/backuppc restart
else
	echo "Run \"/etc/rc.d/init.d/backuppc start\" to start BackupPC."
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
#%config(noreplace) %verify(not md5 size mtime) %{_datadir}/%{name}/www/cgi-bin/.htaccess
%dir %{_datadir}/%{name}
%dir %{_datadir}/%{name}/www/html/doc
%{_datadir}/%{name}/www/html/doc/*
%dir %{_datadir}/%{name}/www
%dir %{_datadir}/%{name}/www/html
%dir %{_datadir}/%{name}/www/cgi-bin
%{_datadir}/%{name}/www/html/*.gif
%config(noreplace) %verify(not md5 mtime size) %{_datadir}/%{name}/www/html/BackupPC_stnd.css
%dir %{_libdir}/BackupPC
%{_libdir}/BackupPC/Attrib.pm
%{_libdir}/BackupPC/FileZIO.pm
%{_libdir}/BackupPC/Lib.pm
%{_libdir}/BackupPC/PoolWrite.pm
%{_libdir}/BackupPC/View.pm
%{_libdir}/BackupPC/CGI
%{_libdir}/BackupPC/Xfer
%{_libdir}/BackupPC/Zip
%dir %attr(755,%{BPCuser},%{BPCgroup}) %{_libdir}/BackupPC/Lang
%lang(en) %{_libdir}/BackupPC/Lang/en.pm
%lang(de) %{_libdir}/BackupPC/Lang/de.pm
%lang(fr) %{_libdir}/BackupPC/Lang/fr.pm
%lang(es) %{_libdir}/BackupPC/Lang/es.pm
%lang(it) %{_libdir}/BackupPC/Lang/it.pm
%lang(nl) %{_libdir}/BackupPC/Lang/nl.pm
#%lang(pl) %{_libdir}/BackupPC/Lang/pl.pm
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/cpool
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/log
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/pc
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/pool
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/trash
%dir %attr(755,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/conf
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/log/%{name}
%attr(754,root,root) /etc/rc.d/init.d/backuppc
%{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf
%dir %{_sysconfdir}/%{name}
%config(noreplace) %verify(not md5 mtime size) %attr(644,%{BPCuser},%{BPCgroup})  %{_sysconfdir}/%{name}/*
%{_mandir}/man8/backuppc*
