
# - now path in browser is  http://localhost/cgi/BackupPC/BackupPC_Admin
# TODO:
# - patch for service user - now is static backuppc
# - polish translation - cvs -z3 -d:pserver:anonymous@cvs.pld-linux.org:/gnomepl co gnomepl/others/BackupPC-pl.pm
# - edit apache configuration, autorizations - SOURCES: backuppc_apache.conf
# - patch at user and gid/uid user - http://sourceforge.net/mailarchive/forum.php?thread_id=6201024&forum_id=17540
# - compliant to FHS - http://sourceforge.net/mailarchive/forum.php?thread_id=5602342&forum_id=17540
# - change or/and add Requires for  --bin-path sendmail=%{_sbindir}/sendmail
# - ping not working --bin-path ping=/bin/ping

%define		BPCuser		http
%define		BPCgroup	http
%include	/usr/lib/rpm/macros.perl

Summary:	A high-performance, enterprise-grade system for backing up PCs
Summary(pl):	Wysoko wydajny, profesjonalnej klasy system do kopii zapasowych z PC
Name:		backuppc
Version:	2.1.1
Release:	0.1
License:	GPL
Group:		Networking/Utilities
Source0:	http://dl.sourceforge.net/backuppc/BackupPC-%{version}.tar.gz
# Source0-md5:	fadbce1c3d4679dffc98514e48ed7917
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
Requires:	apache-mod_perl
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
  u¿ywany jest protokó³ SMB lub rsync (specjalnie przygotowana wersja
  pod cygwinem). Na klientach linuksowych lub uniksowych mo¿na u¿ywaæ
  rsynca lub tara (po ssh/rsh/NFS).
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
install -d -m 755 	$RPM_BUILD_ROOT%{_sysconfdir}/{rc.d/init.d,httpd/httpd.conf} \
			$RPM_BUILD_ROOT%{_usr}/share/%{name}/www/{html,cgi-bin} \
			$RPM_BUILD_ROOT%{_var}/{lib/%{name}/pc/localhost,log} \
			$RPM_BUILD_ROOT%{_datadir}/%{name}/conf \

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
	--bin-path hostname=/bin/hostname \
	--bin-path split=%{_bindir}/split \
	--bin-path cat=/bin/cat \
	--bin-path gzip=/bin/gzip \
	--bin-path bzip2=%{_bindir}/bzip2 \
	--cgi-dir %{_usr}/share/%{name}/www/cgi-bin \
	--data-dir %{_var}/lib/%{name} \
	--dest-dir $RPM_BUILD_ROOT \
	--hostname localhost \
	--html-dir %{_usr}/share/%{name}/www/html \
	--html-dir-url /BackupPC \
	--install-dir %{_usr} \
	--uid-ignore
#	--config-path

#change user in init script
sed -i -e 's#--user backuppc#--user %{BPCuser}#' init.d/linux-backuppc
#change user in config file
sed -i -e "s#'backuppc';#'%{BPCuser}';#" $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf/config.pl
sed -i -e 's/$Conf{SendmailPath} =/#$Conf{SendmailPath} =/' $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf/config.pl

install init.d/linux-backuppc $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d/backuppc
install %{SOURCE1} $RPM_BUILD_ROOT%{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf
install %{SOURCE2} $RPM_BUILD_ROOT%{_usr}/share/%{name}/www/cgi-bin/.htaccess

# Cleanups:
rm -f $RPM_BUILD_ROOT%{_datadir}/%{name}/www/html/CVS

# symlinks
cd $RPM_BUILD_ROOT%{_sysconfdir}
ln -sf %{_var}/lib/%{name}/conf %{name}

cd $RPM_BUILD_ROOT%{_var}/log
ln -sf %{_var}/lib/%{name}/log %{name}

cd $RPM_BUILD_ROOT%{_usr}/share/%{name}/www/cgi-bin
ln -sf BackupPC_Admin index.cgi

cd $RPM_BUILD_ROOT%{_var}/lib/%{name}/conf
ln -sf %{_usr}/share/%{name}/www/html/BackupPC_stnd.css BackupPC_stnd.css

%pre
# Add the "backuppc" user and group
#if [ -n "`/usr/bin/getgid %{BPCgroup}`" ]; then
#	if [ "`/usr/bin/getgid %{BPCgroup}`" != "150" ]; then
#		echo "Error: group %{BPCgroup} doesn't have gid=150. Correct this before installing %{name}." 1>&2
#		exit 1
#	fi
#else
#	/usr/sbin/groupadd -g 150 %{BPCgroup}
#fi
#if [ -n "`/bin/id -u %{BPCuser} 2>/dev/null`" ]; then
#	if [ "`/bin/id -u %{BPCuser}`" != 150 ]; then
#		echo "Error: user %{BPCuser} doesn't have uid=150. Correct this before installing %{name}." 1>&2
#		exit 1
#	fi
#else
#	/usr/sbin/useradd -c "system user for %{name}" -u 150 \
#		-d /home/services/BackupPC -s /bin/false -g %{BPCgroup} %{BPCuser} 1>&2
#fi

%post
/etc/init.d/backuppc restart

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
%dir %{_usr}/share/%{name}/www/cgi-bin
%attr(755,root,root)%{_usr}/share/%{name}/www/cgi-bin/BackupPC_Admin
%config(noreplace) %verify(not md5 size mtime) %{_usr}/share/%{name}/www/cgi-bin/.htaccess
%dir %{_usr}/share/%{name}/www/html
%{_usr}/share/%{name}/www/html/*.gif
%config(noreplace) %verify(not md5 size mtime) %{_usr}/share/%{name}/www/html/BackupPC_stnd.css
%dir %{_libdir}/BackupPC
%{_libdir}/BackupPC/Attrib.pm
%{_libdir}/BackupPC/FileZIO.pm
%{_libdir}/BackupPC/Lib.pm
%{_libdir}/BackupPC/PoolWrite.pm
%{_libdir}/BackupPC/View.pm
%dir %{_libdir}/BackupPC/CGI
%{_libdir}/BackupPC/CGI/*
%dir %{_libdir}/BackupPC/Xfer
%{_libdir}/BackupPC/Xfer/*
%dir %{_libdir}/BackupPC/Zip
%{_libdir}/BackupPC/Zip/*
%dir %{_libdir}/BackupPC/Lang
%lang(en) %{_libdir}/BackupPC/Lang/en.pm
%lang(de) %{_libdir}/BackupPC/Lang/de.pm
%lang(fr) %{_libdir}/BackupPC/Lang/fr.pm
%lang(es) %{_libdir}/BackupPC/Lang/es.pm
%lang(it) %{_libdir}/BackupPC/Lang/it.pm
%lang(nl) %{_libdir}/BackupPC/Lang/nl.pm
#%lang(pl) %{_libdir}/BackupPC/Lang/pl.pm
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/cpool
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/log
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/pc
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/pool
%dir %attr(750,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/trash
%dir %attr(755,%{BPCuser},%{BPCgroup}) %{_var}/lib/%{name}/conf
%dir %{_var}/log/%{name}
%attr(755,root,root) %{_sysconfdir}/rc.d/init.d/backuppc
%{_sysconfdir}/httpd/httpd.conf/93_backuppc.conf
%dir %{_sysconfdir}/%{name}
%config(noreplace) %verify(not md5 size mtime) %attr(644,%{BPCuser},%{BPCgroup})  %{_var}/lib/%{name}/conf/*
