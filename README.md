# PC Info Report

Script PowerShell sederhana untuk membuat laporan kondisi komputer Windows. Dibuat sebagai latihan otomatisasi tugas dasar IT Support.

## Fitur

- Menampilkan nama komputer, versi Windows, dan alamat IP
- Menampilkan sisa RAM dalam GB dan persen
- Menampilkan sisa ruang di setiap disk
- Menampilkan 5 program yang paling banyak memakai memori
- Memberi peringatan otomatis kalau RAM tinggal kurang dari 20% atau ruang disk tinggal kurang dari 15%
- Menyimpan laporan ke file `.txt` di folder `laporan/`

## Cara Menjalankan

1. Clone repo ini, lalu masuk ke foldernya.
2. Buka PowerShell di folder tersebut, lalu jalankan:
```
   powershell -ExecutionPolicy Bypass -File .\pc_info_report.ps1
```

Opsi `-ExecutionPolicy Bypass` hanya berlaku untuk satu kali jalan, karena Windows secara default memblokir script `.ps1`. Pengaturan keamanan komputer tidak diubah.

Tidak perlu memasang apa pun. Script hanya memakai perintah bawaan PowerShell.

## Contoh Hasil

Nama komputer dan alamat IP di bawah ini hanya contoh.

```
LAPORAN INFO KOMPUTER
Waktu           : 2026-10-16 07:03:17
Nama komputer   : DESKTOP-CONTOH
Sistem operasi  : Microsoft Windows 10 Home
Alamat IP       : 192.168.1.10
------------------------------------------------------------
RAM             : 2.08 GB bebas dari 7.92 GB (26% bebas)
Disk C:         : 204.81 GB bebas dari 344.44 GB (59% bebas)
------------------------------------------------------------
5 program paling banyak memakai memori:
  - msedge: 506 MB
  - Code: 432 MB
  - MsMpEng: 390 MB
------------------------------------------------------------
Peringatan: tidak ada.
```

## Perintah PowerShell yang Dipakai

| Perintah | Fungsi |
|---|---|
| `Get-CimInstance Win32_OperatingSystem` | Info Windows dan RAM |
| `Get-PSDrive -PSProvider FileSystem` | Info ruang disk |
| `Get-Process` | Daftar program yang berjalan |
| `Get-NetIPAddress` | Alamat IP |

## Rencana Pengembangan

- Menambah info prosesor dan lama komputer menyala
- Mengirim laporan dari beberapa komputer sekaligus
- Menjadwalkan laporan otomatis lewat Task Scheduler