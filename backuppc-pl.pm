#!/usr/bin/perl

#my %lang;
#use strict;

# --------------------------------

$Lang{Start_Archive} = "Start Archive";
$Lang{Stop_Dequeue_Archive} = "Stop/Dequeue Archive";
$Lang{Start_Full_Backup} = "Uruchom pe�ny Backup";
$Lang{Start_Incr_Backup} = "Uruchom przyrostowy Backup";
$Lang{Stop_Dequeue_Backup} = "Stop/Dequeue Backup";
$Lang{Restore} = "Przywr��";

$Lang{Type_full} = "Pe�ny";
$Lang{Type_incr} = "przyrostowy";

# -----

$Lang{Only_privileged_users_can_view_admin_options} = "Tylko u�ytkownik posiadaj�cy uprawnienia ma dostep do opcji administracyjnych.";
$Lang{H_Admin_Options} = "BackupPC serwer: administracja";
$Lang{Admin_Options} = "Administracja";
$Lang{Admin_Options_Page} = <<EOF;
\${h1(qq{$Lang{Admin_Options}})}
<br>
\${h2("Kontrola serwera")}
<form action="\$MyURL" method="get">
<table class="tableStnd">
  <!--<tr><td>Zatrzymaj serwer:<td><input type="submit" name="action" value="Stop">-->
  <tr><td>Wczytaj ponownie konfiguracje:<td><input type="submit" name="action" value="Reload">
</table>
</form>
<!--
\${h2("Konfiguracja serwera")}
<ul>
  <li><i>Other options can go here... e.g.,</i>
  <li>Edycja konfiguracji serwera
</ul>
-->
EOF
$Lang{Unable_to_connect_to_BackupPC_server} = "Nie mo�na uzyska� po��czenia z serwerem BackupPC",
            "Skrypt CGI (\$MyURL) is unable to connect to the BackupPC"
          . " server na \$Conf{ServerHost} port \$Conf{ServerPort}.  The error"
          . " was: \$err.",
            "Perhaps the BackupPC server is not running or there is a "
          . " B��d konfiguracji. Zawiadom administratora systemu.";
$Lang{Admin_Start_Server} = <<EOF;
\${h1(qq{$Lang{Unable_to_connect_to_BackupPC_server}})}
<form action="\$MyURL" method="get">
BackupPC serwer na <tt>\$Conf{ServerHost}</tt> port <tt>\$Conf{ServerPort}</tt>
nie jest aktualnie uruchomiony (maybe you just stopped it, or haven't yet started it).<br>
Czy chcesz uruchomi� serwer?
<input type="hidden" name="action" value="startServer">
<input type="submit" value="Start Server" name="ignore">
</form>
EOF

# -----

$Lang{H_BackupPC_Server_Status} = "Status serwera BackupPC";

$Lang{BackupPC_Server_Status_General_Info}= <<EOF;
\${h2(\"General Server Information\")}

<ul>
<li> PID serwera: \$Info{pid}, na komputerze \$Conf{ServerHost},
     wersja \$Info{Version}, uruchomiony o \$serverStartTime.
<li> Status wygenerowano o \$now.
<li> Ostatnie wczytanie konfiguracji: \$configLoadTime.
<li> PCs will be next queued at \$nextWakeupTime.
<li> Pozosta�e informacje:
    <ul>
        <li>\$numBgQueue pending backup requests from last scheduled wakeup,
        <li>\$numUserQueue pending user backup requests,
        <li>\$numCmdQueue pending command requests,
        \$poolInfo
        <li>Pool file system was recently at \$Info{DUlastValue}%
            (\$DUlastTime), today\'s max is \$Info{DUDailyMax}% (\$DUmaxTime)
            and yesterday\'s max was \$Info{DUDailyMaxPrev}%.
    </ul>
</ul>
EOF

$Lang{BackupPC_Server_Status} = <<EOF;
\${h1(qq{$Lang{H_BackupPC_Server_Status}})}

<p>
\$generalInfo

\${h2("Aktualnie uruchomione zadania")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3">
<tr class="tableheader"><td> Komputer </td>
    <td> Typ </td>
    <td> U�ytkownik </td>
    <td> Rozpocz�cie </td>
    <td> Command </td>
    <td align="center"> PID </td>
    <td align="center"> Xfer PID </td>
    </tr>
\$jobStr
</table>
<p>

\${h2("Failures that need attention")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3">
<tr class="tableheader"><td align="center"> Host </td>
    <td align="center"> Typ </td>
    <td align="center"> U�ytkownik </td>
    <td align="center"> Last Try </td>
    <td align="center"> Szczeg�y </td>
    <td align="center"> Error Time </td>
    <td> Last error (other than no ping) </td></tr>
\$statusStr
</table>
EOF

# --------------------------------
$Lang{BackupPC__Server_Summary} = "BackupPC: Podsumowanie ";
$Lang{BackupPC__Archive} = "BackupPC: Archive";
$Lang{BackupPC_Summary} = <<EOF;

\${h1(qq{$Lang{BackupPC__Server_Summary}})}
<p>
Status wygenerowano o \$now.
</p>

\${h2("Hosts with good Backups")}
<p>
There are \$hostCntGood hosts that have been backed up, for a total of:
<ul>
<li> \$fullTot full backups of total size \${fullSizeTot}GB
     (prior to pooling and compression),
<li> \$incrTot incr backups of total size \${incrSizeTot}GB
     (prior to pooling and compression).
</ul>
</p>
<table class="tableStnd" border cellpadding="3" cellspacing="1">
<tr class="tableheader"><td> Komputer </td>
    <td align="center"> U�ytkownik </td>
    <td align="center"> #Full </td>
    <td align="center"> Full Age/days </td>
    <td align="center"> Wielko��/GB </td>
    <td align="center"> Szybko�� MB/sec </td>
    <td align="center"> #Incr </td>
    <td align="center"> Incr Age/days </td>
    <td align="center"> State </td>
    <td align="center"> Last attempt </td></tr>
\$strGood
</table>
<br><br>
\${h2("Hosts with no Backups")}
<p>
There are \$hostCntNone hosts with no backups.
<p>
<table class="tableStnd" border cellpadding="3" cellspacing="1">
<tr class="tableheader"><td> Host </td>
    <td align="center"> User </td>
    <td align="center"> #Full </td>
    <td align="center"> Full Age/days </td>
    <td align="center"> Wielko��/GB </td>
    <td align="center"> Szybko�� MB/sec </td>
    <td align="center"> #Incr </td>
    <td align="center"> Incr Age/days </td>
    <td align="center"> Current State </td>
    <td align="center"> Last backup attempt </td></tr>
\$strNone
</table>
EOF

$Lang{BackupPC_Archive} = <<EOF;
\${h1(qq{$Lang{BackupPC__Archive}})}
<script language="javascript" type="text/javascript">
<!--

    function checkAll(location)
    {
      for (var i=0;i<document.form1.elements.length;i++)
      {
        var e = document.form1.elements[i];
        if ((e.checked || !e.checked) && e.name != \'all\') {
            if (eval("document.form1."+location+".checked")) {
                e.checked = true;
            } else {
                e.checked = false;
            }
        }
      }
    }

    function toggleThis(checkbox)
    {
       var cb = eval("document.form1."+checkbox);
       cb.checked = !cb.checked;
    }

//-->
</script>

There are \$hostCntGood hosts that have been backed up for a total size of \${fullSizeTot}GB
<p>
<form name="form1" method="post" action="\$MyURL">
<input type="hidden" name="fcbMax" value="\$checkBoxCnt">
<input type="hidden" name="type" value="1">
<input type="hidden" name="host" value="\${EscHTML(\$archHost)}">
<input type="hidden" name="action" value="Archive">
<table class="tableStnd" border cellpadding="3" cellspacing="1">
<tr class="tableheader"><td align=center> Komputer</td>
    <td align="center"> U�ytkownik </td>
    <td align="center"> Wielko�� Backup-u </td>
\$strGood
\$checkAllHosts
</table>
</form>
<p>

EOF

$Lang{BackupPC_Archive2} = <<EOF;
\${h1(qq{$Lang{BackupPC__Archive}})}
About to archive the following hosts
<ul>
\$HostListStr
</ul>
<form action="\$MyURL" method="post">
\$hiddenStr
<input type="hidden" name="action" value="Archive">
<input type="hidden" name="host" value="\${EscHTML(\$archHost)}">
<input type="hidden" name="type" value="2">
<input type="hidden" value="0" name="archive_type">
<table class="tableStnd" border cellspacing="1" cellpadding="3">
\$paramStr
<tr>
    <td colspan=2><input type="submit" value="Start the Archive" name=""></td>
</tr>
</form>
</table>
EOF

$Lang{BackupPC_Archive2_location} = <<EOF;
<tr>
    <td>Archive Location/Device</td>
    <td><input type="text" value="\$ArchiveDest" name="archive_device"></td>
</tr>
EOF

$Lang{BackupPC_Archive2_compression} = <<EOF;
<tr>
    <td>Kompresja</td>
    <td>
    <input type="radio" value="0" name="compression" \$ArchiveCompNone>brak<br>
    <input type="radio" value="1" name="compression" \$ArchiveCompGzip>gzip<br>
    <input type="radio" value="2" name="compression" \$ArchiveCompBzip2>bzip2
    </td>
</tr>
EOF

$Lang{BackupPC_Archive2_parity} = <<EOF;
<tr>
    <td>Percentage of Parity Data (0 = disable, 5 = typical)</td>
    <td><input type="numeric" value="\$ArchivePar" name="par"></td>
</tr>
EOF

$Lang{BackupPC_Archive2_split} = <<EOF;
<tr>
    <td>Split output into</td>
    <td><input type="numeric" value="\$ArchiveSplit" name="splitsize">Megabytes</td>
</tr>
EOF

# -----------------------------------
$Lang{Pool_Stat} = <<EOF;
        <li>Pool is \${poolSize}GB comprising \$info->{"\${name}FileCnt"} files
            and \$info->{"\${name}DirCnt"} directories (as of \$poolTime),
        <li>Pool hashing gives \$info->{"\${name}FileCntRep"} repeated
            files with longest chain \$info->{"\${name}FileRepMax"},
        <li>Nightly cleanup removed \$info->{"\${name}FileCntRm"} files of
            size \${poolRmSize}GB (around \$poolTime),
EOF

# --------------------------------
$Lang{BackupPC__Backup_Requested_on__host} = "BackupPC: Backup Requested on \$host";
# --------------------------------
$Lang{REPLY_FROM_SERVER} = <<EOF;
\${h1(\$str)}
<p>
Reply from server was: \$reply
<p>
Go back to <a href="\$MyURL?host=\$host">\$host home page</a>.
EOF
# --------------------------------
$Lang{BackupPC__Start_Backup_Confirm_on__host} = "BackupPC: Start Backup Confirm on \$host";
# --------------------------------
$Lang{Are_you_sure_start} = <<EOF;
\${h1("Are you sure?")}
<p>
You are about to start a \$type backup on \$host.

<form action="\$MyURL" method="get">
<input type="hidden" name="host" value="\$host">
<input type="hidden" name="hostIP" value="\$ipAddr">
<input type="hidden" name="doit" value="1">
Do you really want to do this?
<input type="submit" value="\$In{action}" name="action">
<input type="submit" value="No" name="">
</form>
EOF
# --------------------------------
$Lang{BackupPC__Stop_Backup_Confirm_on__host} = "BackupPC: Stop Backup Confirm on \$host";
# --------------------------------
$Lang{Are_you_sure_stop} = <<EOF;

\${h1("Are you sure?")}

<p>
You are about to stop/dequeue backups on \$host;

<form action="\$MyURL" method="get">
<input type="hidden" name="host" value="\$host">
<input type="hidden" name="doit" value="1">
Also, please don\'t start another backup for
<input type="text" name="backoff" size="10" value="\$backoff"> hours.
<p>
Do you really want to do this?
<input type="submit" value="\$In{action}" name="action">
<input type="submit" value="No" name="">
</form>

EOF
# --------------------------------
$Lang{Only_privileged_users_can_view_queues_} = "Only privileged users can view queues.";
# --------------------------------
$Lang{Only_privileged_users_can_archive} = "Only privileged users can Archive.";
# --------------------------------
$Lang{BackupPC__Queue_Summary} = "BackupPC: Queue Summary";
# --------------------------------
$Lang{Backup_Queue_Summary} = <<EOF;
\${h1("Backup Queue Summary")}
<br><br>
\${h2("User Queue Summary")}
<p>
The following user requests are currently queued:
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td> Host </td>
    <td> Req Time </td>
    <td> User </td></tr>
\$strUser
</table>
<br><br>

\${h2("Background Queue Summary")}
<p>
The following background requests are currently queued:
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td> Host </td>
    <td> Req Time </td>
    <td> User </td></tr>
\$strBg
</table>
<br><br>
\${h2("Command Queue Summary")}
<p>
The following command requests are currently queued:
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td> Host </td>
    <td> Req Time </td>
    <td> User </td>
    <td> Command </td></tr>
\$strCmd
</table>
EOF

# --------------------------------
$Lang{Backup_PC__Log_File__file} = "BackupPC: File \$file";
$Lang{Log_File__file__comment} = <<EOF;
\${h1("File \$file \$comment")}
<p>
EOF
# --------------------------------
$Lang{Contents_of_log_file} = <<EOF;
Contents of file <tt>\$file</tt>, modified \$mtimeStr \$comment
EOF

# --------------------------------
$Lang{skipped__skipped_lines} = "[ skipped \$skipped lines ]\n";
# --------------------------------
$Lang{_pre___Can_t_open_log_file__file} = "<pre>\nCan\'t open log file \$file\n";

# --------------------------------
$Lang{BackupPC__Log_File_History} = "BackupPC: Log File History";
$Lang{Log_File_History__hdr} = <<EOF;
\${h1("Log File History \$hdr")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> File </td>
    <td align="center"> Size </td>
    <td align="center"> Modification time </td></tr>
\$str
</table>
EOF

# -------------------------------
$Lang{Recent_Email_Summary} = <<EOF;
\${h1("Recent Email Summary (Reverse time order)")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> Recipient </td>
    <td align="center"> Host </td>
    <td align="center"> Time </td>
    <td align="center"> Subject </td></tr>
\$str
</table>
EOF


# ------------------------------
$Lang{Browse_backup__num_for__host} = "BackupPC: Browse backup \$num for \$host";

# ------------------------------
$Lang{Restore_Options_for__host} = "BackupPC: Restore Options for \$host";
$Lang{Restore_Options_for__host2} = <<EOF;
\${h1("Restore Options for \$host")}
<p>
You have selected the following files/directories from
share \$share, backup number #\$num:
<ul>
\$fileListStr
</ul>
</p><p>
You have three choices for restoring these files/directories.
Please select one of the following options.
</p>
\${h2("Option 1: Direct Restore")}
<p>
EOF

$Lang{Restore_Options_for__host_Option1} = <<EOF;
You can start a restore that will restore these files directly onto
\$host.
</p><p>
<b>Warning:</b> any existing files that match the ones you have
selected will be overwritten!
</p>
<form action="\$MyURL" method="post" name="direct">
<input type="hidden" name="host" value="\${EscHTML(\$host)}">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="type" value="3">
\$hiddenStr
<input type="hidden" value="\$In{action}" name="action">
<table border="0">
<tr>
    <td>Restore the files to host</td>
    <td><!--<input type="text" size="40" value="\${EscHTML(\$host)}"
	 name="hostDest">-->
	 <select name="hostDest" onChange="document.direct.shareDest.value=''">
	 \$hostDestSel
	 </select>
	 <script language="Javascript">
	 function myOpen(URL) {
		window.open(URL,'','width=500,height=400');
	 }
	 </script>
	 <!--<a href="javascript:myOpen('\$MyURL?action=findShares&host='+document.direct.hostDest.options.value)">Search for available shares (NOT IMPLEMENTED)</a>--></td>
</tr><tr>
    <td>Restore the files to share</td>
    <td><input type="text" size="40" value="\${EscHTML(\$share)}"
	 name="shareDest"></td>
</tr><tr>
    <td>Restore the files below dir<br>(relative to share)</td>
    <td valign="top"><input type="text" size="40" maxlength="256"
	value="\${EscHTML(\$pathHdr)}" name="pathHdr"></td>
</tr><tr>
    <td><input type="submit" value="Start Restore" name=""></td>
</table>
</form>
EOF

$Lang{Restore_Options_for__host_Option1_disabled} = <<EOF;
Direct restore has been disabled for host \${EscHTML(\$hostDest)}.
Please select one of the other restore options.
EOF

# ------------------------------
$Lang{Option_2__Download_Zip_archive} = <<EOF;
<p>
\${h2("Option 2: Download Zip archive")}
<p>
You can download a Zip archive containing all the files/directories you have
selected.  You can then use a local application, such as WinZip,
to view or extract any of the files.
</p><p>
<b>Warning:</b> depending upon which files/directories you have selected,
this archive might be very very large.  It might take many minutes to
create and transfer the archive, and you will need enough local disk
space to store it.
</p>
<form action="\$MyURL" method="post">
<input type="hidden" name="host" value="\${EscHTML(\$host)}">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="type" value="2">
\$hiddenStr
<input type="hidden" value="\$In{action}" name="action">
<input type="checkbox" value="1" name="relative" checked> Make archive relative
to \${EscHTML(\$pathHdr eq "" ? "/" : \$pathHdr)}
(otherwise archive will contain full paths).
<br>
Compression (0=off, 1=fast,...,9=best)
<input type="text" size="6" value="5" name="compressLevel">
<br>
<input type="submit" value="Download Zip File" name="">
</form>
EOF

# ------------------------------

$Lang{Option_2__Download_Zip_archive2} = <<EOF;
<p>
\${h2("Option 2: Download Zip archive")}
<p>
Archive::Zip is not installed so you will not be able to download a
zip archive.
Please ask your system adminstrator to install Archive::Zip from
<a href="http://www.cpan.org">www.cpan.org</a>.
</p>
EOF


# ------------------------------
$Lang{Option_3__Download_Zip_archive} = <<EOF;
\${h2("Option 3: Download Tar archive")}
<p>
You can download a Tar archive containing all the files/directories you
have selected.  You can then use a local application, such as tar or
WinZip to view or extract any of the files.
</p><p>
<b>Warning:</b> depending upon which files/directories you have selected,
this archive might be very very large.  It might take many minutes to
create and transfer the archive, and you will need enough local disk
space to store it.
</p>
<form action="\$MyURL" method="post">
<input type="hidden" name="host" value="\${EscHTML(\$host)}">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="type" value="1">
\$hiddenStr
<input type="hidden" value="\$In{action}" name="action">
<input type="checkbox" value="1" name="relative" checked> Make archive relative
to \${EscHTML(\$pathHdr eq "" ? "/" : \$pathHdr)}
(otherwise archive will contain full paths).
<br>
<input type="submit" value="Download Tar File" name="">
</form>
EOF


# ------------------------------
$Lang{Restore_Confirm_on__host} = "BackupPC: Restore Confirm on \$host";

$Lang{Are_you_sure} = <<EOF;
\${h1("Are you sure?")}
<p>
You are about to start a restore directly to the machine \$In{hostDest}.
The following files will be restored to share \$In{shareDest}, from
backup number \$num:
<p>
<table border>
<tr><td>Original file/dir</td><td>Will be restored to</td></tr>
\$fileListStr
</table>

<form action="\$MyURL" method="post">
<input type="hidden" name="host" value="\${EscHTML(\$host)}">
<input type="hidden" name="hostDest" value="\${EscHTML(\$In{hostDest})}">
<input type="hidden" name="shareDest" value="\${EscHTML(\$In{shareDest})}">
<input type="hidden" name="pathHdr" value="\${EscHTML(\$In{pathHdr})}">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="type" value="4">
\$hiddenStr
Do you really want to do this?
<input type="submit" value="\$In{action}" name="action">
<input type="submit" value="No" name="">
</form>
EOF


# --------------------------
$Lang{Restore_Requested_on__hostDest} = "BackupPC: Restore Requested on \$hostDest";
$Lang{Reply_from_server_was___reply} = <<EOF;
\${h1(\$str)}
<p>
Reply from server was: \$reply
<p>
Go back to <a href="\$MyURL?host=\$hostDest">\$hostDest home page</a>.
EOF

$Lang{BackupPC_Archive_Reply_from_server} = <<EOF;
\${h1(\$str)}
<p>
Reply from server was: \$reply
EOF


# -------------------------
$Lang{Host__host_Backup_Summary} = "BackupPC: Host \$host Backup Summary";

$Lang{Host__host_Backup_Summary2} = <<EOF;
\${h1("Host \$host Backup Summary")}
<p>
\$warnStr
<ul>
\$statusStr
</ul>
</p>
\${h2("User Actions")}
<p>
<form action="\$MyURL" method="get">
<input type="hidden" name="host" value="\$host">
\$startIncrStr
<input type="submit" value="$Lang{Start_Full_Backup}" name="action">
<input type="submit" value="$Lang{Stop_Dequeue_Backup}" name="action">
</form>
</p>
\${h2("Backup Summary")}
<p>
Click on the backup number to browse and restore backup files.
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3">
<tr class="tableheader"><td align="center"> Backup# </td>
    <td align="center"> Type </td>
    <td align="center"> Filled </td>
    <td align="center"> Start Date </td>
    <td align="center"> Duration/mins </td>
    <td align="center"> Age/days </td>
    <td align="center"> Server Backup Path </td>
</tr>
\$str
</table>
<p>

\$restoreStr
</p>
<br><br>
\${h2("Xfer Error Summary")}
<br><br>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> Backup# </td>
    <td align="center"> Type </td>
    <td align="center"> View </td>
    <td align="center"> #Xfer errs </td>
    <td align="center"> #bad files </td>
    <td align="center"> #bad share </td>
    <td align="center"> #tar errs </td>
</tr>
\$errStr
</table>
<br><br>

\${h2("File Size/Count Reuse Summary")}
<p>
Existing files are those already in the pool; new files are those added
to the pool.
Empty files and SMB errors aren\'t counted in the reuse and new counts.
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td colspan="2" bgcolor="#ffffff"></td>
    <td align="center" colspan="3"> Totals </td>
    <td align="center" colspan="2"> Existing Files </td>
    <td align="center" colspan="2"> New Files </td>
</tr>
<tr class="tableheader">
    <td align="center"> Backup# </td>
    <td align="center"> Type </td>
    <td align="center"> #Files </td>
    <td align="center"> Size/MB </td>
    <td align="center"> MB/sec </td>
    <td align="center"> #Files </td>
    <td align="center"> Size/MB </td>
    <td align="center"> #Files </td>
    <td align="center"> Size/MB </td>
</tr>
\$sizeStr
</table>
<br><br>

\${h2("Compression Summary")}
<p>
Compression performance for files already in the pool and newly
compressed files.
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td colspan="3" bgcolor="#ffffff"></td>
    <td align="center" colspan="3"> Existing Files </td>
    <td align="center" colspan="3"> New Files </td>
</tr>
<tr class="tableheader"><td align="center"> Backup# </td>
    <td align="center"> Type </td>
    <td align="center"> Comp Level </td>
    <td align="center"> Size/MB </td>
    <td align="center"> Comp/MB </td>
    <td align="center"> Comp </td>
    <td align="center"> Size/MB </td>
    <td align="center"> Comp/MB </td>
    <td align="center"> Comp </td>
</tr>
\$compStr
</table>
<br><br>
EOF

$Lang{Host__host_Archive_Summary} = "BackupPC: Host \$host Archive Summary";
$Lang{Host__host_Archive_Summary2} = <<EOF;
\${h1("Host \$host Archive Summary")}
<p>
\$warnStr
<ul>
\$statusStr
</ul>

\${h2("User Actions")}
<p>
<form action="\$MyURL" method="get">
<input type="hidden" name="archivehost" value="\$host">
<input type="hidden" name="host" value="\$host">
<input type="submit" value="$Lang{Start_Archive}" name="action">
<input type="submit" value="$Lang{Stop_Dequeue_Archive}" name="action">
</form>

\$ArchiveStr

EOF

# -------------------------
$Lang{Error} = "BackupPC: Error";
$Lang{Error____head} = <<EOF;
\${h1("Error: \$head")}
<p>\$mesg</p>
EOF

# -------------------------
$Lang{NavSectionTitle_} = "Serwer";

# -------------------------
$Lang{Backup_browse_for__host} = <<EOF;
\${h1("Backup browse for \$host")}

<script language="javascript" type="text/javascript">
<!--

    function checkAll(location)
    {
      for (var i=0;i<document.form1.elements.length;i++)
      {
        var e = document.form1.elements[i];
        if ((e.checked || !e.checked) && e.name != \'all\') {
            if (eval("document.form1."+location+".checked")) {
            	e.checked = true;
            } else {
            	e.checked = false;
            }
        }
      }
    }

    function toggleThis(checkbox)
    {
       var cb = eval("document.form1."+checkbox);
       cb.checked = !cb.checked;
    }

//-->
</script>

<form name="form0" method="post" action="\$MyURL">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="host" value="\$host">
<input type="hidden" name="share" value="\${EscHTML(\$share)}">
<input type="hidden" name="action" value="browse">
<ul>
<li> You are browsing backup #\$num, which started around \$backupTime
        (\$backupAge days ago),
\$filledBackup
<li> Enter directory: <input type="text" name="dir" size="50" maxlength="4096" value="\${EscHTML(\$dir)}"> <input type="submit" value="\$Lang->{Go}" name="Submit">
<li> Click on a directory below to navigate into that directory,
<li> Click on a file below to restore that file,
<li> You can view the backup <a href="\$MyURL?action=dirHistory&host=\${EscURI(\$host)}&share=\$shareURI&dir=\$pathURI">historia</a> of the current directory.
</ul>
</form>

\${h2("Contents of \${EscHTML(\$dirDisplay)}")}
<form name="form1" method="post" action="\$MyURL">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="host" value="\$host">
<input type="hidden" name="share" value="\${EscHTML(\$share)}">
<input type="hidden" name="fcbMax" value="\$checkBoxCnt">
<input type="hidden" name="action" value="$Lang{Restore}">
<br>
<table width="100%">
<tr><td valign="top">
    <br><table align="center" border="0" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
    \$dirStr
    </table>
</td><td width="3%">
</td><td valign="top">
    <br>
        <table border="0" width="100%" align="left" cellpadding="3" cellspacing="1">
        \$fileHeader
        \$topCheckAll
        \$fileStr
        \$checkAll
        </table>
    </td></tr></table>
<br>
<!--
This is now in the checkAll row
<input type="submit" name="Submit" value="Restore selected files">
-->
</form>
EOF

# ------------------------------
$Lang{DirHistory_backup_for__host} = "BackupPC: Directory backup history for \$host";

#
# These two strings are used to build the links for directories and
# file versions.  Files are appended with a version number.
#
$Lang{DirHistory_dirLink}  = "dir";
$Lang{DirHistory_fileLink} = "v";

$Lang{DirHistory_for__host} = <<EOF;
\${h1("Directory backup history for \$host")}
<p>
This display shows each unique version of files across all
the backups:
<ul>
<li> Click on a backup number to return to the backup browser,
<li> Click on a directory link (\$Lang->{DirHistory_dirLink}) to navigate
     into that directory,
<li> Click on a file version link (\$Lang->{DirHistory_fileLink}0,
     \$Lang->{DirHistory_fileLink}1, ...) to download that file,
<li> Files with the same contents between different backups have the same
     version number,
<li> Files or directories not present in a particular backup have an
     empty box.
<li> Files shown with the same version might have different attributes.
     Select the backup number to see the file attributes.
</ul>

\${h2("History of \${EscHTML(\$dirDisplay)}")}

<br>
<table cellspacing="2" cellpadding="3">
<tr class="fviewheader"><td>Backup number</td>\$backupNumStr</tr>
<tr class="fviewheader"><td>Backup time</td>\$backupTimeStr</tr>
\$fileStr
</table>
EOF

# ------------------------------
$Lang{Restore___num_details_for__host} = "BackupPC: Restore #\$num details for \$host";

$Lang{Restore___num_details_for__host2} = <<EOF;
\${h1("Restore #\$num Details for \$host")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="90%">
<tr><td class="tableheader"> Number </td><td class="border"> \$Restores[\$i]{num} </td></tr>
<tr><td class="tableheader"> Requested by </td><td class="border"> \$RestoreReq{user} </td></tr>
<tr><td class="tableheader"> Request time </td><td class="border"> \$reqTime </td></tr>
<tr><td class="tableheader"> Result </td><td class="border"> \$Restores[\$i]{result} </td></tr>
<tr><td class="tableheader"> Error Message </td><td class="border"> \$Restores[\$i]{errorMsg} </td></tr>
<tr><td class="tableheader"> Source host </td><td class="border"> \$RestoreReq{hostSrc} </td></tr>
<tr><td class="tableheader"> Source backup num </td><td class="border"> \$RestoreReq{num} </td></tr>
<tr><td class="tableheader"> Source share </td><td class="border"> \$RestoreReq{shareSrc} </td></tr>
<tr><td class="tableheader"> Destination host </td><td class="border"> \$RestoreReq{hostDest} </td></tr>
<tr><td class="tableheader"> Destination share </td><td class="border"> \$RestoreReq{shareDest} </td></tr>
<tr><td class="tableheader"> Start time </td><td class="border"> \$startTime </td></tr>
<tr><td class="tableheader"> Duration </td><td class="border"> \$duration min </td></tr>
<tr><td class="tableheader"> Number of files </td><td class="border"> \$Restores[\$i]{nFiles} </td></tr>
<tr><td class="tableheader"> Total size </td><td class="border"> \${MB} MB </td></tr>
<tr><td class="tableheader"> Transfer rate </td><td class="border"> \$MBperSec MB/sec </td></tr>
<tr><td class="tableheader"> TarCreate errors </td><td class="border"> \$Restores[\$i]{tarCreateErrs} </td></tr>
<tr><td class="tableheader"> Xfer errors </td><td class="border"> \$Restores[\$i]{xferErrs} </td></tr>
<tr><td class="tableheader"> Xfer log file </td><td class="border">
<a href="\$MyURL?action=view&type=RestoreLOG&num=\$Restores[\$i]{num}&host=\$host">View</a>,
<a href="\$MyURL?action=view&type=RestoreErr&num=\$Restores[\$i]{num}&host=\$host">Errors</a>
</tr></tr>
</table>
</p>
\${h1("File/Directory list")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="100%">
<tr class="tableheader"><td>Original file/dir</td><td>Restored to</td></tr>
\$fileListStr
</table>
EOF

# ------------------------------
$Lang{Archive___num_details_for__host} = "BackupPC: Archive #\$num details for \$host";

$Lang{Archive___num_details_for__host2 } = <<EOF;
\${h1("Archive #\$num Details for \$host")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr><td class="tableheader"> Number </td><td class="border"> \$Archives[\$i]{num} </td></tr>
<tr><td class="tableheader"> Requested by </td><td class="border"> \$ArchiveReq{user} </td></tr>
<tr><td class="tableheader"> Request time </td><td class="border"> \$reqTime </td></tr>
<tr><td class="tableheader"> Result </td><td class="border"> \$Archives[\$i]{result} </td></tr>
<tr><td class="tableheader"> Error Message </td><td class="border"> \$Archives[\$i]{errorMsg} </td></tr>
<tr><td class="tableheader"> Start time </td><td class="border"> \$startTime </td></tr>
<tr><td class="tableheader"> Duration </td><td class="border"> \$duration min </td></tr>
<tr><td class="tableheader"> Xfer log file </td><td class="border">
<a href="\$MyURL?action=view&type=ArchiveLOG&num=\$Archives[\$i]{num}&host=\$host">View</a>,
<a href="\$MyURL?action=view&type=ArchiveErr&num=\$Archives[\$i]{num}&host=\$host">Errors</a>
</tr></tr>
</table>
<p>
\${h1("Host list")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td>Host</td><td>Backup Number</td></tr>
\$HostListStr
</table>
EOF

# -----------------------------------
$Lang{Email_Summary} = "BackupPC: Email Summary";

# -----------------------------------
#  !! ERROR messages !!
# -----------------------------------
$Lang{BackupPC__Lib__new_failed__check_apache_error_log} = "BackupPC::Lib->new failed: check apache error_log\n";
$Lang{Wrong_user__my_userid_is___} =
              "Wrong user: my userid is \$>, instead of \$uid"
            . "(\$Conf{BackupPCUser})\n";
# $Lang{Only_privileged_users_can_view_PC_summaries} = "Only privileged users can view PC summaries.";
$Lang{Only_privileged_users_can_stop_or_start_backups} =
                  "Only privileged users can stop or start backups on"
		. " \${EscHTML(\$host)}.";
$Lang{Invalid_number__num} = "Invalid number \$num";
$Lang{Unable_to_open__file__configuration_problem} = "Unable to open \$file: configuration problem?";
$Lang{Only_privileged_users_can_view_log_or_config_files} = "Only privileged users can view log or config files.";
$Lang{Only_privileged_users_can_view_log_files} = "Only privileged users can view log files.";
$Lang{Only_privileged_users_can_view_email_summaries} = "Only privileged users can view email summaries.";
$Lang{Only_privileged_users_can_browse_backup_files} = "Only privileged users can browse backup files"
                . " for host \${EscHTML(\$In{host})}.";
$Lang{Empty_host_name} = "Empty host name.";
$Lang{Directory___EscHTML} = "Directory \${EscHTML(\"\$TopDir/pc/\$host/\$num\")}"
		    . " is empty";
$Lang{Can_t_browse_bad_directory_name2} = "Can\'t browse bad directory name"
	            . " \${EscHTML(\$relDir)}";
$Lang{Only_privileged_users_can_restore_backup_files} = "Only privileged users can restore backup files"
                . " for host \${EscHTML(\$In{host})}.";
$Lang{Bad_host_name} = "Bad host name \${EscHTML(\$host)}";
$Lang{You_haven_t_selected_any_files__please_go_Back_to} = "You haven\'t selected any files; please go Back to"
                . " select some files.";
$Lang{You_haven_t_selected_any_hosts} = "You haven\'t selected any hosts; please go Back to"
                . " select some hosts.";
$Lang{Nice_try__but_you_can_t_put} = "Nice try, but you can\'t put \'..\' in any of the file names";
$Lang{Host__doesn_t_exist} = "Host \${EscHTML(\$In{hostDest})} doesn\'t exist";
$Lang{You_don_t_have_permission_to_restore_onto_host} = "You don\'t have permission to restore onto host"
		    . " \${EscHTML(\$In{hostDest})}";
$Lang{Can_t_open_create} = "Can\'t open/create "
                    . "\${EscHTML(\"\$TopDir/pc/\$hostDest/\$reqFileName\")}";
$Lang{Only_privileged_users_can_restore_backup_files2} = "Only privileged users can restore backup files"
                . " for host \${EscHTML(\$host)}.";
$Lang{Empty_host_name} = "Empty host name";
$Lang{Unknown_host_or_user} = "Unknown host or user \${EscHTML(\$host)}";
$Lang{Only_privileged_users_can_view_information_about} = "Only privileged users can view information about"
                . " host \${EscHTML(\$host)}." ;
$Lang{Only_privileged_users_can_view_archive_information} = "Only privileged users can view archive information.";
$Lang{Only_privileged_users_can_view_restore_information} = "Only privileged users can view restore information.";
$Lang{Restore_number__num_for_host__does_not_exist} = "Restore number \$num for host \${EscHTML(\$host)} does"
	        . " not exist.";
$Lang{Archive_number__num_for_host__does_not_exist} = "Archive number \$num for host \${EscHTML(\$host)} does"
                . " not exist.";
$Lang{Can_t_find_IP_address_for} = "Can\'t find IP address for \${EscHTML(\$host)}";
$Lang{host_is_a_DHCP_host} = <<EOF;
\$host is a DHCP host, and I don\'t know its IP address.  I checked the
netbios name of \$ENV{REMOTE_ADDR}\$tryIP, and found that that machine
is not \$host.
<p>
Until I see \$host at a particular DHCP address, you can only
start this request from the client machine itself.
EOF

# ------------------------------------
# !! Server Mesg !!
# ------------------------------------

$Lang{Backup_requested_on_DHCP__host} = "Backup requested on DHCP \$host (\$In{hostIP}) by"
		                      . " \$User from \$ENV{REMOTE_ADDR}";
$Lang{Backup_requested_on__host_by__User} = "Backup requested on \$host by \$User";
$Lang{Backup_stopped_dequeued_on__host_by__User} = "Backup stopped/dequeued on \$host by \$User";
$Lang{Restore_requested_to_host__hostDest__backup___num} = "Restore requested to host \$hostDest, backup #\$num,"
	     . " by \$User from \$ENV{REMOTE_ADDR}";
$Lang{Archive_requested} = "Archive requested by \$User from \$ENV{REMOTE_ADDR}";

# -------------------------------------------------
# ------- Stuff that was forgotten ----------------
# -------------------------------------------------

$Lang{Status} = "Status";
$Lang{PC_Summary} = "Podsumowanie";
$Lang{LOG_file} = "LOG file";
$Lang{LOG_files} = "LOG files";
$Lang{Old_LOGs} = "Old LOGs";
$Lang{Email_summary} = "Email summary";
$Lang{Config_file} = "Config file";
$Lang{Hosts_file} = "Hosts file";
$Lang{Current_queues} = "Current queues";
$Lang{Documentation} = "Dokumentacja";

#$Lang{Host_or_User_name} = "<small>Host or User name:</small>";
$Lang{Go} = "Go";
$Lang{Hosts} = "Hosts";
$Lang{Select_a_host} = "Select a host...";

$Lang{There_have_been_no_archives} = "<h2> There have been no archives </h2>\n";
$Lang{This_PC_has_never_been_backed_up} = "<h2> This PC has never been backed up!! </h2>\n";
$Lang{This_PC_is_used_by} = "<li>This PC is used by \${UserLink(\$user)}";

$Lang{Extracting_only_Errors} = "(Extracting only Errors)";
$Lang{XferLOG} = "XferLOG";
$Lang{Errors}  = "Errors";

# ------------
$Lang{Last_email_sent_to__was_at___subject} = <<EOF;
<li>Last email sent to \${UserLink(\$user)} was at \$mailTime, subject "\$subj".
EOF
# ------------
$Lang{The_command_cmd_is_currently_running_for_started} = <<EOF;
<li>The command \$cmd is currently running for \$host, started \$startTime.
EOF

# -----------
$Lang{Host_host_is_queued_on_the_background_queue_will_be_backed_up_soon} = <<EOF;
<li>Host \$host is queued on the background queue (will be backed up soon).
EOF

# ----------
$Lang{Host_host_is_queued_on_the_user_queue__will_be_backed_up_soon} = <<EOF;
<li>Host \$host is queued on the user queue (will be backed up soon).
EOF

# ---------
$Lang{A_command_for_host_is_on_the_command_queue_will_run_soon} = <<EOF;
<li>A command for \$host is on the command queue (will run soon).
EOF

# --------
$Lang{Last_status_is_state_StatusHost_state_reason_as_of_startTime} = <<EOF;
<li>Last status is state \"\$Lang->{\$StatusHost{state}}\"\$reason as of \$startTime.
EOF

# --------
$Lang{Last_error_is____EscHTML_StatusHost_error} = <<EOF;
<li>Last error is \"\${EscHTML(\$StatusHost{error})}\".
EOF

# ------
$Lang{Pings_to_host_have_failed_StatusHost_deadCnt__consecutive_times} = <<EOF;
<li>Pings to \$host have failed \$StatusHost{deadCnt} consecutive times.
EOF

# -----
$Lang{Prior_to_that__pings} = "Prior to that, pings";

# -----
$Lang{priorStr_to_host_have_succeeded_StatusHostaliveCnt_consecutive_times} = <<EOF;
<li>\$priorStr to \$host have succeeded \$StatusHost{aliveCnt}
        consecutive times.
EOF

$Lang{Because__host_has_been_on_the_network_at_least__Conf_BlackoutGoodCnt_consecutive_times___} = <<EOF;
<li>Because \$host has been on the network at least \$Conf{BlackoutGoodCnt}
consecutive times, it will not be backed up from \$blackoutStr.
EOF

$Lang{__time0_to__time1_on__days} = "\$t0 to \$t1 on \$days";

$Lang{Backups_are_deferred_for_hours_hours_change_this_number} = <<EOF;
<li>Backups are deferred for \$hours hours
(<a href=\"\$MyURL?action=\${EscURI(\$Lang->{Stop_Dequeue_Archive})}&host=\$host\">change this number</a>).
EOF

$Lang{tryIP} = " and \$StatusHost{dhcpHostIP}";

# $Lang{Host_Inhost} = "Host \$In{host}";

$Lang{checkAll} = <<EOF;
<tr><td class="fviewborder">
<input type="checkbox" name="allFiles" onClick="return checkAll('allFiles');">&nbsp;Select all
</td><td colspan="5" align="center" class="fviewborder">
<input type="submit" name="Submit" value="Restore selected files">
</td></tr>
EOF

$Lang{checkAllHosts} = <<EOF;
<tr><td class="fviewborder">
<input type="checkbox" name="allFiles" onClick="return checkAll('allFiles');">&nbsp;Select all
</td><td colspan="2" align="center" class="fviewborder">
<input type="submit" name="Submit" value="Archive selected hosts">
</td></tr>
EOF

$Lang{fileHeader} = <<EOF;
    <tr class="fviewheader"><td align=center> Name</td>
       <td align="center"> Type</td>
       <td align="center"> Mode</td>
       <td align="center"> #</td>
       <td align="center"> Size</td>
       <td align="center"> Date modified</td>
    </tr>
EOF

$Lang{Home} = "Home";
$Lang{Browse} = "Browse backups";
$Lang{Last_bad_XferLOG} = "Last bad XferLOG";
$Lang{Last_bad_XferLOG_errors_only} = "Last bad XferLOG (errors&nbsp;only)";

$Lang{This_display_is_merged_with_backup} = <<EOF;
<li> This display is merged with backup #\$numF.
EOF

$Lang{Visit_this_directory_in_backup} = <<EOF;
<li> Select the backup you wish to view: <select onChange="window.location=this.value">\$otherDirs </select>
EOF

$Lang{Restore_Summary} = <<EOF;
\${h2("Restore Summary")}
<p>
Click on the restore number for more details.
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> Restore# </td>
    <td align="center"> Rezultat </td>
    <td align="right"> Data rozpocz�cia</td>
    <td align="right"> Dur/mins</td>
    <td align="right"> #plik�w </td>
    <td align="right"> MB </td>
    <td align="right"> #tar errs </td>
    <td align="right"> #xferErrs </td>
</tr>
\$restoreStr
</table>
<p>
EOF

$Lang{Archive_Summary} = <<EOF;
\${h2("Archive Summary")}
<p>
kliknij na numerze wybranego archiwum aby zobaczy� szczeg�y.
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> Archive# </td>
    <td align="center"> Rezultat </td>
    <td align="right"> Data rozpocz�cia</td>
    <td align="right"> Dur/mins</td>
</tr>
\$ArchiveStr
</table>
<p>
EOF

$Lang{BackupPC__Documentation} = "BackupPC: Dokumentacja";

$Lang{No} = "no";
$Lang{Yes} = "yes";

$Lang{The_directory_is_empty} = <<EOF;
<tr><td bgcolor="#ffffff">Katalog \${EscHTML(\$dirDisplay)} jest pusty
</td></tr>
EOF

#$Lang{on} = "on";
$Lang{off} = "off";

$Lang{backupType_full}    = "pe�ny";
$Lang{backupType_incr}    = "przyrostowy";
$Lang{backupType_partial} = "cz�ciowy";

$Lang{failed} = "nieudany";
$Lang{success} = "sukces";
$Lang{and} = "i";

# ------
# Hosts states and reasons
$Lang{Status_idle} = "idle";
$Lang{Status_backup_starting} = "backup starting";
$Lang{Status_backup_in_progress} = "backup w trakcie";
$Lang{Status_restore_starting} = "restore starting";
$Lang{Status_restore_in_progress} = "restore in progress";
$Lang{Status_link_pending} = "link pending";
$Lang{Status_link_running} = "link running";

$Lang{Reason_backup_done}    = "backup uko�czony";
$Lang{Reason_restore_done}   = "restore done";
$Lang{Reason_archive_done}   = "archive done";
$Lang{Reason_nothing_to_do}  = "nothing to do";
$Lang{Reason_backup_failed}  = "backup nieudany";
$Lang{Reason_restore_failed} = "restore failed";
$Lang{Reason_archive_failed} = "archive failed";
$Lang{Reason_no_ping}        = "no ping";
$Lang{Reason_backup_canceled_by_user}  = "backup canceled by user";
$Lang{Reason_restore_canceled_by_user} = "restore canceled by user";
$Lang{Reason_archive_canceled_by_user} = "archive canceled by user";

# ---------
# Email messages

# No backup ever
$Lang{EMailNoBackupEverSubj} = "BackupPC: no backups of \$host have succeeded";
$Lang{EMailNoBackupEverMesg} = <<'EOF';
To: $user$domain
cc:
Subject: $subj

Dear $userName,

Your PC ($host) has never been successfully backed up by our
PC backup software.  PC backups should occur automatically
when your PC is connected to the network.  You should contact
computer support if:

  - Your PC has been regularly connected to the network, meaning
    there is some configuration or setup problem preventing
    backups from occurring.

  - You don't want your PC backed up and you want these email
    messages to stop.

Otherwise, please make sure your PC is connected to the network
next time you are in the office.

Regards,
BackupPC Genie
http://backuppc.sourceforge.net
EOF

# No recent backup
$Lang{EMailNoBackupRecentSubj} = "BackupPC: no recent backups on \$host";
$Lang{EMailNoBackupRecentMesg} = <<'EOF';
To: $user$domain
cc:
Subject: $subj

Dear $userName,

Your PC ($host) has not been successfully backed up for $days days.
Your PC has been correctly backed up $numBackups times from $firstTime to $days
ago.  PC backups should occur automatically when your PC is connected
to the network.

If your PC has been connected for more than a few hours to the
network during the last $days days you should contact IS to find
out why backups are not working.

Otherwise, if you are out of the office, there's not much you can
do, other than manually copying especially critical files to other
media.  You should be aware that any files you have created or
changed in the last $days days (including all new email and
attachments) cannot be restored if your PC disk crashes.

Regards,
BackupPC Genie
http://backuppc.sourceforge.net
EOF

# Old Outlook files
$Lang{EMailOutlookBackupSubj} = "BackupPC: Outlook files on \$host need to be backed up";
$Lang{EMailOutlookBackupMesg} = <<'EOF';
To: $user$domain
cc:
Subject: $subj

Dear $userName,

The Outlook files on your PC have $howLong.
These files contain all your email, attachments, contact and calendar
information.  Your PC has been correctly backed up $numBackups times from
$firstTime to $lastTime days ago.  However, Outlook locks all its files when
it is running, preventing these files from being backed up.

It is recommended you backup the Outlook files when you are connected
to the network by exiting Outlook and all other applications, and,
using just your browser, go to this link:

    $CgiURL?host=$host

Select "Start Incr Backup" twice to start a new incremental backup.
You can select "Return to $host page" and then hit "reload" to check
the status of the backup.  It should take just a few minutes to
complete.

Regards,
BackupPC Genie
http://backuppc.sourceforge.net
EOF

$Lang{howLong_not_been_backed_up} = "not been backed up successfully";
$Lang{howLong_not_been_backed_up_for_days_days} = "not been backed up for \$days days";

#end of lang_en.pm
