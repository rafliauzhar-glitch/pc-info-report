# pc_info_report.ps1
# Membuat laporan kondisi komputer dan menyimpannya ke folder laporan

function Baris($label, $isi) {
    return $label.PadRight(16) + ": " + $isi
}

$waktu = Get-Date
$os = Get-CimInstance Win32_OperatingSystem
$peringatan = @()

# RAM (nilai asli dalam KB, dibagi 1MB agar menjadi GB)
$ramTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$ramBebas = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$persenRam = [math]::Round(($os.FreePhysicalMemory / $os.TotalVisibleMemorySize) * 100, 0)
if ($persenRam -lt 20) {
    $peringatan += "RAM tinggal $persenRam% - tutup program yang tidak dipakai."
}

# Alamat IP (tanpa alamat internal 127.x dan 169.254.x)
$ip = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -notlike "127.*" -and $_.IPAddress -notlike "169.254.*" }).IPAddress -join ", "

# Disk (nilai asli dalam byte, dibagi 1GB agar menjadi GB)
$barisDisk = @()
$drive = Get-PSDrive -PSProvider FileSystem | Where-Object { $null -ne $_.Used }
foreach ($d in $drive) {
    $total = $d.Used + $d.Free
    if ($total -eq 0) { continue }
    $bebasGB = [math]::Round($d.Free / 1GB, 2)
    $totalGB = [math]::Round($total / 1GB, 2)
    $persenDisk = [math]::Round(($d.Free / $total) * 100, 0)
    $barisDisk += Baris ("Disk " + $d.Name + ":") "$bebasGB GB bebas dari $totalGB GB ($persenDisk% bebas)"
    if ($persenDisk -lt 15) {
        $peringatan += "Disk $($d.Name): tinggal $persenDisk% - segera bersihkan file."
    }
}

# 5 program paling banyak memakai memori
$topProses = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5

# Susun laporan
$baris = @()
$baris += "LAPORAN INFO KOMPUTER"
$baris += Baris "Waktu" $waktu.ToString("yyyy-MM-dd HH:mm:ss")
$baris += Baris "Nama komputer" $env:COMPUTERNAME
$baris += Baris "Sistem operasi" $os.Caption
$baris += Baris "Alamat IP" $ip
$baris += ("-" * 60)
$baris += Baris "RAM" "$ramBebas GB bebas dari $ramTotal GB ($persenRam% bebas)"
$baris += $barisDisk
$baris += ("-" * 60)
$baris += "5 program paling banyak memakai memori:"
foreach ($pr in $topProses) {
    $mb = [math]::Round($pr.WorkingSet / 1MB, 0)
    $baris += "  - $($pr.Name): $mb MB"
}
$baris += ("-" * 60)
if ($peringatan.Count -eq 0) {
    $baris += "Peringatan: tidak ada."
} else {
    foreach ($w in $peringatan) { $baris += "PERINGATAN: $w" }
}

# Tampilkan dan simpan
$baris | ForEach-Object { Write-Host $_ }

$folder = "laporan"
New-Item -ItemType Directory -Force -Path $folder | Out-Null
$namaFile = "laporan_" + $waktu.ToString("yyyy-MM-dd_HH-mm-ss") + ".txt"
$baris | Out-File -FilePath (Join-Path $folder $namaFile) -Encoding utf8
Write-Host ""
Write-Host "Laporan disimpan: $folder\$namaFile"