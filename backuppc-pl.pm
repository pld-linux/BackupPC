#!/usr/bin/perl

#my %lang;
#use strict;

# --------------------------------

$Lang{Start_Archive} = "Start archiwizacji";
$Lang{Stop_Dequeue_Archive} = "Zatrzymaj/Dequeue archiwizacje";
$Lang{Start_Full_Backup} = "Uruchom pe³ny Backup";
$Lang{Start_Incr_Backup} = "Uruchom przyrostowy Backup";
$Lang{Stop_Dequeue_Backup} = "Zatrzymaj/Dequeue Backup";
$Lang{Restore} = "Przywróæ";

$Lang{Type_full} = "Pe³ny";
$Lang{Type_incr} = "przyrostowy";

# -----

$Lang{Only_privileged_users_can_view_admin_options} = "Tylko u¿ytkownik posiadaj±cy uprawnienia ma dostêp do opcji administracyjnych.";
$Lang{H_Admin_Options} = "BackupPC serwer: administracja";
$Lang{Admin_Options} = "Administracja";
$Lang{Admin_Options_Page} = <<EOF;
\${h1(qq{$Lang{Admin_Options}})}
<br>
\${h2("Kontrola serwera")}
<form action="\$MyURL" method="get">
<table class="tableStnd">
  <!--<tr><td>Zatrzymanie serwera:<td><input type="submit" name="action" value="Stop">-->
  <tr><td>Wczytaj ponownie konfiguracjê:<td><input type="submit" name="action" value="Reload">
</table>
</form>
<!--
\${h2("Konfiguracja serwera")}
<ul>
  <li><i>Inne opcje mog± znajdowaæ siê tu:... n.p.,</i>
  <li>Edycja konfiguracji serwera
</ul>
-->
EOF
$Lang{Unable_to_connect_to_BackupPC_server} = "Nie mo¿na uzyskaæ po³±czenia z serwerem BackupPC",
            "Skrypt CGI (\$MyURL) nie mo¿e uzyskaæ po³±czenia z serwerem"
          . " BackupPC na \$Conf{ServerHost} port \$Conf{ServerPort}. Wyst±pi³"
          . " b³±d: \$err.",
            "Byæ mo¿e serwer BackupPC nie jest uruchomiony lub jest to "
          . " b³±d konfiguracji. Zawiadom administratora systemu.";
$Lang{Admin_Start_Server} = <<EOF;
\${h1(qq{$Lang{Unable_to_connect_to_BackupPC_server}})}
<form action="\$MyURL" method="get">
Serwer BackupPC na <tt>\$Conf{ServerHost}</tt> port <tt>\$Conf{ServerPort}</tt>
nie jest aktualnie uruchomiony (mo¿liwe, ¿e go tylko zatrzyma³e¶ lub jeszcze nie uruchomi³e¶).<br>
Czy chcesz uruchomiæ serwer?
<input type="hidden" name="action" value="startServer">
<input type="submit" value="Start Server" name="ignore">
</form>
EOF

# -----

$Lang{H_BackupPC_Server_Status} = "Status serwera BackupPC";

$Lang{BackupPC_Server_Status_General_Info}= <<EOF;
\${h2(\"Ogólne informacje o serwerze\")}

<ul>
<li> PID serwera: \$Info{pid}, na komputerze \$Conf{ServerHost},
     wersja \$Info{Version}, uruchomiony o \$serverStartTime.
<li> Status wygenerowano o \$now.
<li> Ostatnie wczytanie konfiguracji: \$configLoadTime.
<li> Sprawdzenie obecno¶ci nowych zleceñ o \$nextWakeupTime.
<li> Pozosta³e informacje:
    <ul>
        <li>\$numBgQueue oczekuj±ce zlecenia archiwizacji od ostatniego scheduled wakeup,
        <li>\$numUserQueue oczekuj±ce zlecenia u¿ytkownika,
        <li>\$numCmdQueue oczekuj±ce zlecenia,
        \$poolInfo
        <li>Pool file system was recently at \$Info{DUlastValue}%
            (\$DUlastTime), dzi¶ maksymalnie jest \$Info{DUDailyMax}% (\$DUmaxTime)
            wczoraj by³o maksymalnie \$Info{DUDailyMaxPrev}%.
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
    <td> U¿ytkownik </td>
    <td> Rozpoczêcie </td>
    <td> Polecenie </td>
    <td align="center"> PID </td>
    <td align="center"> Xfer PID </td>
    </tr>
\$jobStr
</table>
<p>

\${h2("B³êdy wymagaj±ce bli¿szej analizy")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3">
<tr class="tableheader"><td align="center"> Komputer </td>
    <td align="center"> Typ </td>
    <td align="center"> U¿ytkownik </td>
    <td align="center"> Ostatnia próba </td>
    <td align="center"> Szczegó³y </td>
    <td align="center"> B³±d o godzinie </td>
    <td> Ostatni b³±d (inny ni¿ brak ping) </td></tr>
\$statusStr
</table>
EOF

# --------------------------------
$Lang{BackupPC__Server_Summary} = "BackupPC: Podsumowanie ";
$Lang{BackupPC__Archive} = "BackupPC: Archiwizacja";
$Lang{BackupPC_Summary} = <<EOF;

\${h1(qq{$Lang{BackupPC__Server_Summary}})}
<p>
Status wygenerowano o \$now.
</p>

\${h2("Komputery z dobrymi kopiami zapasowymi")}
<p>
Jest \$hostCntGood komputerów, na których dokonano archiwizacji, ³±cznie:
<ul>
<li> \$fullTot pe³ny rozmiar archiwum: \${fullSizeTot}GB
     (prior to pooling and compression),
<li> \$incrTot incr backups of total size \${incrSizeTot}GB
     (prior to pooling and compression).
</ul>
</p>
<table class="tableStnd" border cellpadding="3" cellspacing="1">
<tr class="tableheader"><td> Komputer </td>
    <td align="center"> U¿ytkownik </td>
    <td align="center"> #Pe³ny </td>
    <td align="center"> Pe³ny Age/days </td>
    <td align="center"> Wielko¶æ/GB </td>
    <td align="center"> Szybko¶æ MB/sec </td>
    <td align="center"> #Przyrostowy </td>
    <td align="center"> Przyrost. Age/days </td>
    <td align="center"> Status </td>
    <td align="center"> Ostatnia próba </td></tr>
\$strGood
</table>
<br><br>
\${h2("Komputery bez kopii zapasowych")}
<p>
Jest \$hostCntNone komputerów bez kopii zapasowych.
<p>
<table class="tableStnd" border cellpadding="3" cellspacing="1">
<tr class="tableheader"><td> Komputer </td>
    <td align="center"> U¿ytkownik </td>
    <td align="center"> #Pe³ny </td>
    <td align="center"> Pe³ny Age/days </td>
    <td align="center"> Wielko¶æ/GB </td>
    <td align="center"> Szybko¶æ MB/sec </td>
    <td align="center"> #Przyrostowy </td>
    <td align="center"> Przyrost. Age/days </td>
    <td align="center"> Aktualny stan </td>
    <td align="center"> Ostatnia próba archiwizacji </td></tr>
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

Jest \$hostCntGood komputerów, na których dokonano archiwizacji, ³±cznie: \${fullSizeTot}GB
<p>
<form name="form1" method="post" action="\$MyURL">
<input type="hidden" name="fcbMax" value="\$checkBoxCnt">
<input type="hidden" name="type" value="1">
<input type="hidden" name="host" value="\${EscHTML(\$archHost)}">
<input type="hidden" name="action" value="Archive">
<table class="tableStnd" border cellpadding="3" cellspacing="1">
<tr class="tableheader"><td align=center> Komputer</td>
    <td align="center"> U¿ytkownik </td>
    <td align="center"> Wielko¶æ archiwum </td>
\$strGood
\$checkAllHosts
</table>
</form>
<p>

EOF

$Lang{BackupPC_Archive2} = <<EOF;
\${h1(qq{$Lang{BackupPC__Archive}})}
Archiwizacja nastêpuj±cych komputerów
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
    <td colspan=2><input type="submit" value="Rozpoczêcie archiwizacji" name=""></td>
</tr>
</form>
</table>
EOF

$Lang{BackupPC_Archive2_location} = <<EOF;
<tr>
    <td>Po³o¿enie Archiwum/Urz±dzenie</td>
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
    <td>Ilo¶æ danych kontrolnych (parzysto¶ci) (0 = brak ... 5 = normalna)</td>
    <td><input type="numeric" value="\$ArchivePar" name="par"></td>
</tr>
EOF

$Lang{BackupPC_Archive2_split} = <<EOF;
<tr>
    <td>Split output into</td>
    <td><input type="numeric" value="\$ArchiveSplit" name="splitsize">Megabajtów</td>
</tr>
EOF

# -----------------------------------
$Lang{Pool_Stat} = <<EOF;
        <li>Pool is \${poolSize}GB comprising \$info->{"\${name}FileCnt"} plików
            i \$info->{"\${name}DirCnt"} katalogów (as of \$poolTime),
        <li>Pool hashing gives \$info->{"\${name}FileCntRep"} repeated
            files with longest chain \$info->{"\${name}FileRepMax"},
        <li>Nightly cleanup removed \$info->{"\${name}FileCntRm"} files of
            size \${poolRmSize}GB (around \$poolTime),
EOF

# --------------------------------
$Lang{BackupPC__Backup_Requested_on__host} = "BackupPC: Tworzenie kopii zapasowej na \$host";
# --------------------------------
$Lang{REPLY_FROM_SERVER} = <<EOF;
\${h1(\$str)}
<p>
Odpowied¼ od serwera: \$reply
<p>
Powrót na <a href="\$MyURL?host=\$host">\$host stronê domow±</a>.
EOF
# --------------------------------
$Lang{BackupPC__Start_Backup_Confirm_on__host} = "BackupPC: Potwierdzenie tworzenia kopii zapasowej na \$host";
# --------------------------------
$Lang{Are_you_sure_start} = <<EOF;
\${h1("Jeste¶ pewien?")}
<p>
Rozpoczêcie archiwizacji \$type dla \$host.

<form action="\$MyURL" method="get">
<input type="hidden" name="host" value="\$host">
<input type="hidden" name="hostIP" value="\$ipAddr">
<input type="hidden" name="doit" value="1">
Czy chcesz to na pewno zrobiæ?
<input type="submit" value="\$In{action}" name="action">
<input type="submit" value="No" name="">
</form>
EOF
# --------------------------------
$Lang{BackupPC__Stop_Backup_Confirm_on__host} = "BackupPC: Potwierdzenie zatrzymania archiwizacji dla \$host";
# --------------------------------
$Lang{Are_you_sure_stop} = <<EOF;

\${h1("Czy jeste¶ pewny?")}

<p>
Zatrzymanie archiwizacji dla \$host;

<form action="\$MyURL" method="get">
<input type="hidden" name="host" value="\$host">
<input type="hidden" name="doit" value="1">
Nie rozpoczynaj archiwizacji przez okres
<input type="text" name="backoff" size="10" value="\$backoff"> godzin.
<p>
Czy na prawdê chcesz to zrobiæ?
<input type="submit" value="\$In{action}" name="action">
<input type="submit" value="No" name="">
</form>

EOF
# --------------------------------
$Lang{Only_privileged_users_can_view_queues_} = "Tylko uprzywilejowani u¿ytkownicy mog± przegl±daæ kolejki";
# --------------------------------
$Lang{Only_privileged_users_can_archive} = "Tylko U¿ytkownik z odpowiednimi uprawnieniami mo¿e archiwizowaæ.";
# --------------------------------
$Lang{BackupPC__Queue_Summary} = "BackupPC: Podsumowanie kolejek";
# --------------------------------
$Lang{Backup_Queue_Summary} = <<EOF;
\${h1("Backup Queue Summary")}
<br><br>
\${h2("User Queue Summary")}
<p>
Aktualnie w kolejce czekaj± nastêpuj±ce zlecenia u¿ytkownika:
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td> Host </td>
    <td> Req Time </td>
    <td> U¿ytkownik </td></tr>
\$strUser
</table>
<br><br>

\${h2("Background Queue Summary")}
<p>
W tle skolejkowane s± nastêpuj±ce zlecenia::
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td> Komputer </td>
    <td> Req Time </td>
    <td> U¿ytkownik </td></tr>
\$strBg
</table>
<br><br>
\${h2("Command Queue Summary")}
<p>
Aktualnie w kolejce oczekuj± nastêpuj±ce polecenia:
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td> Komputer </td>
    <td> Req Time </td>
    <td> U¿ytkownik </td>
    <td> Polecenie </td></tr>
\$strCmd
</table>
EOF

# --------------------------------
$Lang{Backup_PC__Log_File__file} = "BackupPC: Plik \$file";
$Lang{Log_File__file__comment} = <<EOF;
\${h1("Plik \$file \$comment")}
<p>
EOF
# --------------------------------
$Lang{Contents_of_log_file} = <<EOF;
Zawarto¶æ pliku <tt>\$file</tt>, zmodyfikiwany o \$mtimeStr \$comment
EOF

# --------------------------------
$Lang{skipped__skipped_lines} = "[ Pominiête \$skipped linie ]\n";
# --------------------------------
$Lang{_pre___Can_t_open_log_file__file} = "<pre>\nNie mo¿na otworzyæ pliku loguj±cego \$file\n";

# --------------------------------
$Lang{BackupPC__Log_File_History} = "BackupPC: Plik logu";
$Lang{Log_File_History__hdr} = <<EOF;
\${h1("Plik logu \$hdr")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> Plik </td>
    <td align="center"> Rozmiar </td>
    <td align="center"> Ostatnia modyfikacja </td></tr>
\$str
</table>
EOF

# -------------------------------
$Lang{Recent_Email_Summary} = <<EOF;
\${h1("Recent Email Summary (Reverse time order)")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> Adresat </td>
    <td align="center"> Komputer </td>
    <td align="center"> Czas </td>
    <td align="center"> Temat </td></tr>
\$str
</table>
EOF


# ------------------------------
$Lang{Browse_backup__num_for__host} = "BackupPC: Przegl±danie kopii \$num dla \$host";

# ------------------------------
$Lang{Restore_Options_for__host} = "BackupPC: Opcje przywracania dla \$host";
$Lang{Restore_Options_for__host2} = <<EOF;
\${h1("Opcje przywracania dla \$host")}
<p>
Wybra³e¶ nastêpuj±ce pliki/katalogi z
udzia³u \$share, numer archiwum #\$num:
<ul>
\$fileListStr
</ul>
</p><p>
Masz trzy mo¿liwo¶ci odzyskania tych plików/katalogów.
Wybierz, jedn± z nastêpuj±cych opcji:
</p>
\${h2("Option 1: Bezpo¶rednie odzyskiwanie")}
<p>
EOF

$Lang{Restore_Options_for__host_Option1} = <<EOF;
Mo¿esz zacz±æ odzyskiwanie, które przywróci te pliki bezpo¶rednio na
\$host.
</p><p>
<b>Ostrze¿enie:</b> Wszystkie pliki, pasuj±ce do tych, które wybra³e¶
zostan± nadpisane!
</p>
<form action="\$MyURL" method="post" name="direct">
<input type="hidden" name="host" value="\${EscHTML(\$host)}">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="type" value="3">
\$hiddenStr
<input type="hidden" value="\$In{action}" name="action">
<table border="0">
<tr>
    <td>Odzyskiwanie plików z komputera</td>
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
	 <!--<a href="javascript:myOpen('\$MyURL?action=findShares&host='+document.direct.hostDest.options.value)">Szukanie dostêpnych udzia³ów (NIE ZAIMPLEMENTOWANE)</a>--></td>
</tr><tr>
    <td>Odzyskiwanie plików udzia³u</td>
    <td><input type="text" size="40" value="\${EscHTML(\$share)}"
	 name="shareDest"></td>
</tr><tr>
    <td>Przywracanie plików katalogu poni¿ej<br>(relative to share)</td>
    <td valign="top"><input type="text" size="40" maxlength="256"
	value="\${EscHTML(\$pathHdr)}" name="pathHdr"></td>
</tr><tr>
    <td><input type="submit" value="Rozpoczêcie przywracania" name=""></td>
</table>
</form>
EOF

$Lang{Restore_Options_for__host_Option1_disabled} = <<EOF;
Bezpo¶rednie przywracanie zosta³o wy³±czone dla komputera \${EscHTML(\$hostDest)}.
Wybierz jedn± z innych mo¿liwo¶ci:
EOF

# ------------------------------
$Lang{Option_2__Download_Zip_archive} = <<EOF;
<p>
\${h2("Opcja 2: ¦ci±gnij jako archiwum Zip")}
<p>
Mo¿esz ¶ci±gn±æ archiwum Zip zawieraj±ce wszystkie pliki/katalogi, które 
wybra³e¶
Mo¿esz u¿ywaæ wtedy lokalnych aplikacji takich jak WinZip,
do przejrzenia lub wypakowania ka¿dego z plików.
</p><p>
<b>Ostrze¿enie:</b> w zale¿no¶ci od plików/katalogów, które wybra³e¶,
archiwum to, mo¿e byæ bardzo du¿e. Stworzenie i przeniesienie go
mo¿e zaj±æ kilka minut, ponadto bêdziesz potrzebowa³ wystarczaj±co wolnego miejsca na dysku, aby je przechowaæ.

</p>
<form action="\$MyURL" method="post">
<input type="hidden" name="host" value="\${EscHTML(\$host)}">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="type" value="2">
\$hiddenStr
<input type="hidden" value="\$In{action}" name="action">
<input type="checkbox" value="1" name="relative" checked> Tworzenie archiwum zale¿nego od \${EscHTML(\$pathHdr eq "" ? "/" : \$pathHdr)}
(w przeciwnym razie archiwum bêdzie zawiera³o pe³ne ¶cie¿ki do plików).
<br>
Kompresja (0=brak, 1=szybka,...,9=najlepsza)
<input type="text" size="6" value="5" name="compressLevel">
<br>
<input type="submit" value="¦ci±ganie pliku Zip" name="">
</form>
EOF

# ------------------------------

$Lang{Option_2__Download_Zip_archive2} = <<EOF;
<p>
\${h2("Option 2: ¦ci±gnij jako archiwum Zip")}
<p>
Modu³ Perl-a Archiwum::Zip nie jest zainstalowany. ¦ci±gniêcie jako archiwum Zip bêdzie 
niemo¿liwe.
Popro¶ o zainstalowanie Modu³u Perl-a Archiwum::Zip administratora systemu z
<a href="http://www.cpan.org">www.cpan.org</a>.
</p>
EOF


# ------------------------------
$Lang{Option_3__Download_Zip_archive} = <<EOF;
\${h2("Option 3: ¦ci±gnij jako archiwum Tar")}
<p>
Mo¿esz ¶ci±gn±æ archiwum Tar zawieraj±ce wszystkie pliki/katalogi, które
wybra³e¶.
Bêdziesz móg³ wtedy u¿ywaæ lokalnych aplikacji takich jak Tar lub WinZip, aby
przejrzeæ lub wypakowaæ ka¿dy z plików.
</p><p>
<b>Ostrze¿enie:</b> w zale¿no¶ci od plików/katalogów, które wybra³e¶
archiwum to mo¿e byæ bardzo du¿e. Stworzenie i przeniesienie go mo¿e zaj±æ
kilka minut, ponadto bêdziesz potrzebowa³ wystarczaj±co wolnego miejsca na 
dysku, aby je przechowaæ.
</p>
<form action="\$MyURL" method="post">
<input type="hidden" name="host" value="\${EscHTML(\$host)}">
<input type="hidden" name="num" value="\$num">
<input type="hidden" name="type" value="1">
\$hiddenStr
<input type="hidden" value="\$In{action}" name="action">
<input type="checkbox" value="1" name="relative" checked> Tworzenie archiwum relative
to \${EscHTML(\$pathHdr eq "" ? "/" : \$pathHdr)}
(w przeciwnym razie archiwum bêdzie zawiera³o pe³ne ¶cie¿ki).
<br>
<input type="submit" value="Pobieranie pliku Tar" name="">
</form>
EOF


# ------------------------------
$Lang{Restore_Confirm_on__host} = "BackupPC: Odzyskiwanie potwierdzone dla \$host";

$Lang{Are_you_sure} = <<EOF;
\${h1("Jeste¶ pewny?")}
<p>
You are about to start a restore directly to the machine \$In{hostDest}.
Nastêpuj±ce pliki zostanê odzyskane do udzia³u \$In{shareDest}, z
archiwum o numerze \$num:
<p>
<table border>
<tr><td>Oryginalne pliki/katalogi</td><td> zostan± przywrócone do</td></tr>
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
Chcesz na pewno to zrobiæ?
<input type="submit" value="\$In{action}" name="action">
<input type="submit" value="No" name="">
</form>
EOF


# --------------------------
$Lang{Restore_Requested_on__hostDest} = "BackupPC: Zlecenie odzyskiwania dla \$hostDest";
$Lang{Reply_from_server_was___reply} = <<EOF;
\${h1(\$str)}
<p>
Odpowied¼ z serwera: \$reply
<p>
Wróæ na <a href="\$MyURL?host=\$hostDest">\$hostDest stronê domow±</a>.
EOF

$Lang{BackupPC_Archive_Reply_from_server} = <<EOF;
\${h1(\$str)}
<p>
Odpowied¼ z serwera: \$reply
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
Kliknij na numer archiwum w celu przejrzenia i odzyskania plików.
</p>
<table class="tableStnd" border cellspacing="1" cellpadding="3">
<tr class="tableheader"><td align="center"> Backup# </td>
    <td align="center"> Typ </td>
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
    <td align="center"> Typ </td>
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
    <td align="center" colspan="3"> £±cznie </td>
    <td align="center" colspan="2"> Istniej±ce pliki </td>
    <td align="center" colspan="2"> Nowe pliki </td>
</tr>
<tr class="tableheader">
    <td align="center"> Backup# </td>
    <td align="center"> Typ </td>
    <td align="center"> #Pliki </td>
    <td align="center"> Wielko¶æ/MB </td>
    <td align="center"> MB/sec </td>
    <td align="center"> #Pliki </td>
    <td align="center"> Wielko¶æ/MB </td>
    <td align="center"> #Pliki </td>
    <td align="center"> Wielko¶æ/MB </td>
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
    <td align="center" colspan="3"> Istniej±ce pliki </td>
    <td align="center" colspan="3"> Nowe pliki </td>
</tr>
<tr class="tableheader"><td align="center"> Backup# </td>
    <td align="center"> Typ </td>
    <td align="center"> Poziom kompr. </td>
    <td align="center"> Wielko¶æ/MB </td>
    <td align="center"> Kompresja/MB </td>
    <td align="center"> Kompresja </td>
    <td align="center"> Wielko¶æ/MB </td>
    <td align="center"> Kompr./MB </td>
    <td align="center"> Kompresja</td>
</tr>
\$compStr
</table>
<br><br>
EOF

$Lang{Host__host_Archive_Summary} = "BackupPC: Komputer \$host Archive Summary";
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
\${h1("Poszukiwanie archiwum dla \$host")}

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
<li> Przeszukujesz archiwum #\$num, którego tworzenie zosta³o rozpoczête o \$backupTime
        (\$backupAge dni temu),
\$filledBackup
<li> Enter directory: <input type="text" name="dir" size="50" maxlength="4096" value="\${EscHTML(\$dir)}"> <input type="submit" value="\$Lang->{Go}" name="Submit">
<li> Click on a directory below to navigate into that directory,
<li> Kliknij na plik poni¿ej w celu jego przywrócenia,
<li> Mo¿esz obejrzeæ arhichiwum <a href="\$MyURL?action=dirHistory&host=\${EscURI(\$host)}&share=\$shareURI&dir=\$pathURI">historia</a> aktualnego katalogu.
</ul>
</form>

\${h2("Zawarto¶æ \${EscHTML(\$dirDisplay)}")}
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
<input type="submit" name="Submit" value="Przywróæ zaznaczone pliki">
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
<tr class="fviewheader"><td>Numer kopii</td>\$backupNumStr</tr>
<tr class="fviewheader"><td>Backup time</td>\$backupTimeStr</tr>
\$fileStr
</table>
EOF

# ------------------------------
$Lang{Restore___num_details_for__host} = "BackupPC: Odzyskiwanie #\$num szczegó³y dla \$host";

$Lang{Restore___num_details_for__host2} = <<EOF;
\${h1("Odzyskiwanie#\$num szczegó³y dla \$host")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="90%">
<tr><td class="tableheader"> Numer </td><td class="border"> \$Restores[\$i]{num} </td></tr>
<tr><td class="tableheader"> Requested by </td><td class="border"> \$RestoreReq{user} </td></tr>
<tr><td class="tableheader"> Request time </td><td class="border"> \$reqTime </td></tr>
<tr><td class="tableheader"> Rezultat </td><td class="border"> \$Restores[\$i]{result} </td></tr>
<tr><td class="tableheader"> Wiadomo¶c o b³êdzie </td><td class="border"> \$Restores[\$i]{errorMsg} </td></tr>
<tr><td class="tableheader"> ¬ród³owy komputer </td><td class="border"> \$RestoreReq{hostSrc} </td></tr>
<tr><td class="tableheader"> Source backup num </td><td class="border"> \$RestoreReq{num} </td></tr>
<tr><td class="tableheader"> ¬ród³owy udzia³ </td><td class="border"> \$RestoreReq{shareSrc} </td></tr>
<tr><td class="tableheader"> Docelowy komputer </td><td class="border"> \$RestoreReq{hostDest} </td></tr>
<tr><td class="tableheader"> Docelowy udzia³ </td><td class="border"> \$RestoreReq{shareDest} </td></tr>
<tr><td class="tableheader"> Czas rozpoczêcia </td><td class="border"> \$startTime </td></tr>
<tr><td class="tableheader"> Czas trwania </td><td class="border"> \$duration min </td></tr>
<tr><td class="tableheader"> Liczba plików </td><td class="border"> \$Restores[\$i]{nFiles} </td></tr>
<tr><td class="tableheader"> Total size </td><td class="border"> \${MB} MB </td></tr>
<tr><td class="tableheader"> Transfer rate </td><td class="border"> \$MBperSec MB/sec </td></tr>
<tr><td class="tableheader"> TarCreate errors </td><td class="border"> \$Restores[\$i]{tarCreateErrs} </td></tr>
<tr><td class="tableheader"> Xfer errors </td><td class="border"> \$Restores[\$i]{xferErrs} </td></tr>
<tr><td class="tableheader"> Xfer log file </td><td class="border">
<a href="\$MyURL?action=view&type=RestoreLOG&num=\$Restores[\$i]{num}&host=\$host">View</a>,
<a href="\$MyURL?action=view&type=RestoreErr&num=\$Restores[\$i]{num}&host=\$host">B³êdy</a>
</tr></tr>
</table>
</p>
\${h1("lista plików/katalogów")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="100%">
<tr class="tableheader"><td>Orginalny plik/katalog</td><td>Restored to</td></tr>
\$fileListStr
</table>
EOF

# ------------------------------
$Lang{Archive___num_details_for__host} = "BackupPC: Archiwum #\$num szczegó³y dla \$host";

$Lang{Archive___num_details_for__host2 } = <<EOF;
\${h1("Archiwum #\$num Szczegó³y dla \$host")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr><td class="tableheader"> Numer </td><td class="border"> \$Archives[\$i]{num} </td></tr>
<tr><td class="tableheader"> Requested by </td><td class="border"> \$ArchiveReq{user} </td></tr>
<tr><td class="tableheader"> Request time </td><td class="border"> \$reqTime </td></tr>
<tr><td class="tableheader"> Rezultat </td><td class="border"> \$Archives[\$i]{result} </td></tr>
<tr><td class="tableheader"> Wiadomo¶æ o b³êdzie </td><td class="border"> \$Archives[\$i]{errorMsg} </td></tr>
<tr><td class="tableheader"> Czas rozpoczêcia </td><td class="border"> \$startTime </td></tr>
<tr><td class="tableheader"> Czas trwania </td><td class="border"> \$duration min </td></tr>
<tr><td class="tableheader">Plik logu Xfer </td><td class="border">
<a href="\$MyURL?action=view&type=ArchiveLOG&num=\$Archives[\$i]{num}&host=\$host">View</a>,
<a href="\$MyURL?action=view&type=ArchiveErr&num=\$Archives[\$i]{num}&host=\$host">B³êdy</a>
</tr></tr>
</table>
<p>
\${h1("Host list")}
<p>
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td>Komputer</td><td>Numer kopii</td></tr>
\$HostListStr
</table>
EOF

# -----------------------------------
$Lang{Email_Summary} = "BackupPC: Podsumowanie Poczty";

# -----------------------------------
#  !! ERROR messages !!
# -----------------------------------
$Lang{BackupPC__Lib__new_failed__check_apache_error_log} = "BackupPC::Lib->new failed: sprawd¼ logi z b³êdami APACHE\n";
$Lang{Wrong_user__my_userid_is___} =
              "Niew³a¶ciwy u¿ytkownik: my userid jest \$>, instead of \$uid"
            . "(\$Conf{BackupPCUser})\n";
# $Lang{Only_privileged_users_can_view_PC_summaries} = "Tylko uprzywilejowany u¿ytkowmik mo¿e ogladac podsumowanie dla komputerów.";
$Lang{Only_privileged_users_can_stop_or_start_backups} =
                  "Tylko uprzywilejowany u¿ytkowmik mo¿e zatrzymaæ lub uruchomiæ sporz±dzanie kopii na"
		. " \${EscHTML(\$host)}.";
$Lang{Invalid_number__num} = "Niepoprawny numer \$num";
$Lang{Unable_to_open__file__configuration_problem} = "nie mo¿na odczytaæ \$file: problem z konfiguracj±?";
$Lang{Only_privileged_users_can_view_log_or_config_files} = "Tylko uprzywilejowany u¿ytkowmik mo¿e ogladac pliki z logami lub konfiguracyjne.";
$Lang{Only_privileged_users_can_view_log_files} = "Tylko uprzywilejowany u¿ytkowmik mo¿e ogladac pliki konfiguracyjne.";
$Lang{Only_privileged_users_can_view_email_summaries} = "Tylko uprzywilejowany u¿ytkowmik mo¿e ogl±daæ podsumowanie poczty.";
$Lang{Only_privileged_users_can_browse_backup_files} = "
Tylko uprzywilejowany u¿ytkowmik mo¿e ogladac pliki kopii zapasowych."
                . " dla komputera \${EscHTML(\$In{host})}.";
$Lang{Empty_host_name} = "Pusta nazwa komputera.";
$Lang{Directory___EscHTML} = "Katalog \${EscHTML(\"\$TopDir/pc/\$host/\$num\")}"
		    . " jest pusty";
$Lang{Can_t_browse_bad_directory_name2} = "Can\'t browse bad directory name"
	            . " \${EscHTML(\$relDir)}";
$Lang{Only_privileged_users_can_restore_backup_files} = "Tylko uprzywilejowany u¿ytkowmik mo¿e odzyskaæ pliki z kopii zapasowej"
                . " dla komputera \${EscHTML(\$In{host})}.";
$Lang{Bad_host_name} = "z³a nazwa hosta \${EscHTML(\$host)}";
$Lang{You_haven_t_selected_any_files__please_go_Back_to} = "Nie zosta³y wybrane ¿adne pliki. Wróæ i popraw"
                . " wybierz pliki.";
$Lang{You_haven_t_selected_any_hosts} = "Nie zosta³ wybrany ¿aden komputer. Wróæ i popraw."
                . " wybierz komputery.";
$Lang{Nice_try__but_you_can_t_put} = "Nice try, but you can\'t put \'..\' in any of the file names";
$Lang{Host__doesn_t_exist} = "Komputer \${EscHTML(\$In{hostDest})} nie istnieje";
$Lang{You_don_t_have_permission_to_restore_onto_host} = "You don\'t have permission to restore onto host"
		    . " \${EscHTML(\$In{hostDest})}";
$Lang{Can_t_open_create} = "Nie moge otworzyæ/utworzyæ "
                    . "\${EscHTML(\"\$TopDir/pc/\$hostDest/\$reqFileName\")}";
$Lang{Only_privileged_users_can_restore_backup_files2} = "Only privileged users can restore backup files"
                . " dla komputera \${EscHTML(\$host)}.";
$Lang{Empty_host_name} = "Pusta nazwa komputera";
$Lang{Unknown_host_or_user} = "Nieznany komputer lub u¿ytkownik \${EscHTML(\$host)}";
$Lang{Only_privileged_users_can_view_information_about} = "Only privileged users can view information about"
                . " komputer \${EscHTML(\$host)}." ;
$Lang{Only_privileged_users_can_view_archive_information} = "Only privileged users can view archive information.";
$Lang{Only_privileged_users_can_view_restore_information} = "Only privileged users can view restore information.";
$Lang{Restore_number__num_for_host__does_not_exist} = "Restore number \$num for host \${EscHTML(\$host)} does"
	        . " nie istnieje.";
$Lang{Archive_number__num_for_host__does_not_exist} = "Archive number \$num for host \${EscHTML(\$host)} does"
                . " nie istnieje.";
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
$Lang{Config_file} = "Plik konfiguracji";
$Lang{Hosts_file} = "Plik z komputerami";
$Lang{Current_queues} = "Current queues";
$Lang{Documentation} = "Dokumentacja";

#$Lang{Host_or_User_name} = "<small>Nazwa Komputera lub U¿ytkownika:</small>";
$Lang{Go} = "Go";
$Lang{Hosts} = "Komputery";
$Lang{Select_a_host} = "Wybierz komputer...";

$Lang{There_have_been_no_archives} = "<h2> There have been no archives </h2>\n";
$Lang{This_PC_has_never_been_backed_up} = "<h2> Ten komputer nigdy nie mia³ sporzadzanych kopii bezpieczeñstwa!! </h2>\n";
$Lang{This_PC_is_used_by} = "<li>Komputer jest u¿ywany przez \${UserLink(\$user)}";

$Lang{Extracting_only_Errors} = "(Poka¿ tylko b³êdy)";
$Lang{XferLOG} = "XferLOG";
$Lang{Errors}  = "B³êdy";

# ------------
$Lang{Last_email_sent_to__was_at___subject} = <<EOF;
<li>Ostatni email wys³any do \${UserLink(\$user)} o \$mailTime, temat "\$subj".
EOF
# ------------
$Lang{The_command_cmd_is_currently_running_for_started} = <<EOF;
<li>Polecenie \$cmd jest aktualnie uruchomione na \$host. Uruchomiono o \$startTime.
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
<li>Polecenie dla \$host is on the command queue (will run soon).
EOF

# --------
$Lang{Last_status_is_state_StatusHost_state_reason_as_of_startTime} = <<EOF;
<li>Ostatni znany status to \"\$Lang->{\$StatusHost{state}}\"\$reason o \$startTime.
EOF

# --------
$Lang{Last_error_is____EscHTML_StatusHost_error} = <<EOF;
<li>Ostatni b³±d to \"\${EscHTML(\$StatusHost{error})}\".
EOF

# ------
$Lang{Pings_to_host_have_failed_StatusHost_deadCnt__consecutive_times} = <<EOF;
<li>Pingi do \$host utracone kolejno \$StatusHost{deadCnt} razy.
EOF

# -----
$Lang{Prior_to_that__pings} = "Prior to that, pings";

# -----
$Lang{priorStr_to_host_have_succeeded_StatusHostaliveCnt_consecutive_times} = <<EOF;
<li>\$priorStr do \$host dosz³y kolejno \$StatusHost{aliveCnt} razy.
EOF

$Lang{Because__host_has_been_on_the_network_at_least__Conf_BlackoutGoodCnt_consecutive_times___} = <<EOF;
<li>Poniewa¿ \$host nie by³ obecny w sieci kolejno \$Conf{BlackoutGoodCnt}
razy, nie bêd± podejmowane próby sporz±dzenia kopii do \$blackoutStr.
EOF

$Lang{__time0_to__time1_on__days} = "\$t0 to \$t1 on \$days";

$Lang{Backups_are_deferred_for_hours_hours_change_this_number} = <<EOF;
<li>Backups are deferred for \$hours godzin
(<a href=\"\$MyURL?action=\${EscURI(\$Lang->{Stop_Dequeue_Archive})}&host=\$host\">Zmieñ numer</a>).
EOF

$Lang{tryIP} = " i \$StatusHost{dhcpHostIP}";

# $Lang{Host_Inhost} = "Host \$In{host}";

$Lang{checkAll} = <<EOF;
<tr><td class="fviewborder">
<input type="checkbox" name="allFiles" onClick="return checkAll('allFiles');">&nbsp;Wybierz wszystko</td>
<td colspan="5" align="center" class="fviewborder">
<input type="submit" name="Submit" value="Restore selected files">
</td></tr>
EOF

$Lang{checkAllHosts} = <<EOF;
<tr><td class="fviewborder">
<input type="checkbox" name="allFiles" onClick="return checkAll('allFiles');">&nbsp;Zaznacz wszystkie
</td><td colspan="2" align="center" class="fviewborder">
<input type="submit" name="Submit" value="Archive selected hosts">
</td></tr>
EOF

$Lang{fileHeader} = <<EOF;
    <tr class="fviewheader"><td align=center> Nazwa</td>
       <td align="center"> Typ</td>
       <td align="center"> Tryb</td>
       <td align="center"> #</td>
       <td align="center"> Wielko¶æ</td>
       <td align="center"> Data modyfikacji</td>
    </tr>
EOF

$Lang{Home} = "Home";
$Lang{Browse} = "Przegl±d kopii";
$Lang{Last_bad_XferLOG} = "Ostatni b³êdny XferLOG";
$Lang{Last_bad_XferLOG_errors_only} = "ostatni b³êdny XferLOG (errors&nbsp;only)";

$Lang{This_display_is_merged_with_backup} = <<EOF;
<li> This display is merged with backup #\$numF.
EOF

$Lang{Visit_this_directory_in_backup} = <<EOF;
<li> Select the backup you wish to view: <select onChange="window.location=this.value">\$otherDirs </select>
EOF

$Lang{Restore_Summary} = <<EOF;
\${h2("Restore Summary")}
<p>
Kliknij na numer aby uzyskaæ wiêcej szczegó³ów.
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> Odzyskiwanie# </td>
    <td align="center"> Rezultat </td>
    <td align="right"> Data rozpoczêcia</td>
    <td align="right"> Dur/mins</td>
    <td align="right"> #plików </td>
    <td align="right"> MB </td>
    <td align="right"> #b³êdy tar</td>
    <td align="right"> #b³êdy xfer</td>
</tr>
\$restoreStr
</table>
<p>
EOF

$Lang{Archive_Summary} = <<EOF;
\${h2("Archive Summary")}
<p>kliknij na numerze wybranego archiwum aby zobaczyæ szczegó³y.
<table class="tableStnd" border cellspacing="1" cellpadding="3" width="80%">
<tr class="tableheader"><td align="center"> Archiwum# </td>
    <td align="center"> Rezultat </td>
    <td align="right"> Data rozpoczêcia</td>
    <td align="right"> Dur/mins</td>
</tr>
\$ArchiveStr
</table>
<p>
EOF

$Lang{BackupPC__Documentation} = "BackupPC: Dokumentacja";

$Lang{No} = "nie";
$Lang{Yes} = "tak";

$Lang{The_directory_is_empty} = <<EOF;
<tr><td bgcolor="#ffffff">Katalog \${EscHTML(\$dirDisplay)} jest pusty
</td></tr>
EOF

#$Lang{on} = "on";
$Lang{off} = "wy³±czony";

$Lang{backupType_full}    = "pe³ny";
$Lang{backupType_incr}    = "przyrostowy";
$Lang{backupType_partial} = "czê¶ciowy";

$Lang{failed} = "nieudany";
$Lang{success} = "sukces";
$Lang{and} = "i";

# ------
# Hosts states and reasons
$Lang{Status_idle} = "bezczynny";
$Lang{Status_backup_starting} = "rozpoczêto sporz±dzanie kopii";
$Lang{Status_backup_in_progress} = "sporz±dzanie kopi w trakcie";
$Lang{Status_restore_starting} = "rozpoczêto odzyskiwanie";
$Lang{Status_restore_in_progress} = "odzyskiwanie w trakcie";
$Lang{Status_link_pending} = "link pending";
$Lang{Status_link_running} = "link running";

$Lang{Reason_backup_done}    = "ukoñczony sporz±dzanie kopie";
$Lang{Reason_restore_done}   = "odzyskiwanie ukoñczone";
$Lang{Reason_archive_done}   = "archiwizacja ukoñczona";
$Lang{Reason_nothing_to_do}  = "nie ma nic do zrobienia";
$Lang{Reason_backup_failed}  = "backup nie powiód³ siê";
$Lang{Reason_restore_failed} = "odzyskiwanie nie powiod³o siê";
$Lang{Reason_archive_failed} = "archiwizacja nie powiod³a siê";
$Lang{Reason_no_ping}        = "brak ping";
$Lang{Reason_backup_canceled_by_user}  = "sporz±dzanie kopii przerwane przez u¿ytkownika";
$Lang{Reason_restore_canceled_by_user} = "odzyskiwanie przerwane przez u¿ytkownika";
$Lang{Reason_archive_canceled_by_user} = "archiwizowanie przerwane przez u¿ytkownika";

# ---------
# Email messages

# No backup ever
$Lang{EMailNoBackupEverSubj} = "BackupPC: brak kopii zapasowych z \$host ";
$Lang{EMailNoBackupEverMesg} = <<'EOF';
To: $user$domain
cc:
Subject: $subj

Szanowny $userName,

Twój komputer ($host) nie jest aktualnie zabezpieczony przed utrat± danych
przez nasze oprogramowanie BackupPC.
Archiwizacja przez BackupPC sporz±dzana jest automatycznie gdy Twój PC jest 
pod³±czony do sieci. Powiniene¶ skontaktowaæ siê z dzia³em IT je¶li:

  - Twój komputer by³ regularnie pod³±czony do sieci, tzn
    wystêpuje problem w konfiguracji uniemo¿liwiaj±cy wykonywanie
	kopii zapasowych.

  - Nie chcesz aby Twój PC by³ archiwizowany i nie chcesz otrzymywaæ 
    tych emaili.

W innym przypadku zadbaj o to aby Twój PC by³ pod³±czony do sieci gdy 
przebywasz w biurze.

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

$Lang{howLong_not_been_backed_up} = "nie sporz±dzono kopii poprawnie";
$Lang{howLong_not_been_backed_up_for_days_days} = "nie sporz±dzono kopi przez \$days dni";

#end of lang_pl.pm
