%include	/usr/lib/rpm/macros.perl
Summary:	A high-performance, enterprise-grade system for backing up PCs
Name:		backuppc
Version:	2.0.2
Release:	1
License:	GPL
Group:		Networking/Utilities
Source0:	http://dl.sourceforge.net/backuppc/BackupPC-%{version}.tar.gz
# Source0-md5:	d60aacbf46eb83a7e4ffbbe9e4f72c11
Patch0:		%{name}-debian.patch
URL:		http://backuppc.sourceforge.net/
BuildRequires:	perl >= 5.6.0
BuildRequires:	perl-devel
BuildRequires:	perl-Digest-MD5
BuildRequires:	perl-Compress-Zlib
BuildRequires:	fakeroot
Requires:	tar > 1.13
Requires:	samba-clients
Requires:	webserver
Requires:	sperl
BuildArch:	noarch
Obsoletes:	BackupPC
BuildRoot:	%{tmpdir}/%{name}-%{version}-root-%(id -u -n)

%description
BackupPC is disk based and not tape based. This particularity allows
features not found in any other backup solution:
 * Clever pooling scheme minimizes disk storage and disk I/O.
   Identical files across multiple backups of the same or different PC are
   stored only once (using hard links), resulting in substantial savings
   in disk storage and disk writes.
 * Optional compression provides additional reductions in storage.
   CPU impact of compression is low since only new files (those not already
   in the pool) need to be compressed.
 * A powerful http/cgi user interface allows administrators to view log files,
   configuration, current status and allows users to initiate and cancel
   backups and browse and restore files from backups very quickly.
 * No client-side software is needed. On WinXX the smb protocol is used.
   On linux or unix clients, rsync or tar (over ssh/rsh/nfs) can be used
 * Flexible restore options. Single files can be downloaded from any backup
   directly from the CGI interface. Zip or Tar archives for selected files
   or directories can also be downloaded from the CGI interface.
 * BackupPC supports mobile environments where laptops are only intermittently
   connected to the network and have dynamic IP addresses (DHCP).
 * Flexible configuration parameters allow multiple backups to be performed
   in parallel.
 * and more to discover in the manual...

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
rm -f $RPM_BUILD_ROOT/usr/share/backuppc/doc/*
mv -f $RPM_BUILD_ROOT/var/lib/backuppc/conf/* $RPM_BUILD_ROOT/etc/backuppc
mv -f $RPM_BUILD_ROOT/usr/share/backuppc/cgi-bin/* $RPM_BUILD_ROOT/usr/share/backuppc/cgi-bin/index.cgi
install --mode=644 conf/hosts $RPM_BUILD_ROOT/etc/backuppc
install --mode=644 debian/localhost.pl $RPM_BUILD_ROOT/etc/backuppc
install --mode=644 debian/apache.conf $RPM_BUILD_ROOT/etc/httpd/httpd.conf/93_backuppc.conf
rmdir $RPM_BUILD_ROOT/var/lib/backuppc/conf/
mkdir $RPM_BUILD_ROOT/var/lib/backuppc/pc/localhost/
(cd $RPM_BUILD_ROOT/usr/share/backuppc/cgi-bin; ln -s ../image)

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(644,root,root,755)
%doc doc/*.html
%attr(750,root,root) %dir %{_var}/backuppc
%attr(750,root,root) %dir %{_sysconfdir}/backuppc
%config(noreplace) %verify(not md5 size mtime) %attr(640,root,root) %{_sysconfdir}/backuppc/*
%attr(755,root,root) %{_bindir}/*
%{_mandir}/man?/*
