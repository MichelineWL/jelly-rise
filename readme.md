# Jelly Rise: Echo Tide
**Solo Game Project - CSCE604021 Game Development**  
**Fakultas Ilmu Komputer, Universitas Indonesia**

---

## Informasi Mahasiswa
- **Nama:** Micheline Wijaya Limbergh
- **NPM:** 2306207013
- **Kelas:** Game Development

---

## Deskripsi Game
**Jelly Rise: Echo Tide** adalah sebuah game arkade vertikal bertema bawah laut yang menantang pemain untuk mengendalikan seekor ubur-ubur bercahaya (bioluminescent) untuk naik ke permukaan samudera. Pemain harus melewati celah-celah platform sembari menjaga stamina agar tidak kehabisan tenaga di tengah arus yang semakin kencang.

### **Gameplay Mechanics:**
- **Vertical Ascent:** Bergerak naik terus-menerus melewati rintangan.
- **Stamina Management:** Setiap dorongan (boost) mengonsumsi stamina yang harus dipulihkan dengan berhenti sejenak atau mengambil *Stamina Bubbles*.
- **Auto-Oscillation:** Karakter bergerak kiri-kanan secara otomatis dalam pola sinusoidal, menuntut ketepatan *timing* dari pemain.

---

## Implementasi Diversifier
Game ini mengimplementasikan 3 diversifier unik sebagai berikut:

1. **[D24] One-Button Control:**
   - Seluruh aspek kontrol permainan hanya menggunakan satu tombol (**Space**). 
   - Pemain menggunakan Space untuk dorongan kecil dan menahan Space untuk dorongan besar. Pergerakan horizontal diatur secara otomatis (Auto-Oscillation), sehingga tantangan terletak pada *timing* vertikal pemain.

2. **[D30] Save/Load System:**
   - Game memiliki sistem penyimpanan permanen untuk skor tertinggi (*High Score*).
   - Data disimpan dalam format JSON di direktori `user://` dan akan dimuat secara otomatis setiap kali game dijalankan kembali.

3. **[D31] Pity System (Echo Mode):**
   - Implementasi "Echo Mode" yang aktif secara otomatis jika pemain jatuh di bawah ambang batas (threshold) tertentu.
   - Saat aktif, pemain mendapatkan *Infinite Stamina* selama beberapa detik untuk memberikan kesempatan kedua bagi pemain bangkit kembali sebelum benar-benar kalah.

---

## Fitur Wajib (Mandatory Features)
1. **GDScript:** Menggunakan GDScript untuk seluruh logika permainan (Player, Spawner, Save Manager, dll).
2. **User Interface:** HUD real-time (Stamina bar, Score, Level) dan layar Game Over yang dinamis.
3. **Menu Awal:** Main Menu dengan opsi Play dan Exit.
4. **End Condition:** Game berakhir jika menabrak platform atau jatuh melewati batas layar.
5. **Level Playable:** Tantangan vertikal yang kesulitannya meningkat secara prosedural.
6. **Challenge:** Rintangan berupa platform yang celahnya semakin sempit dan kecepatan yang meningkat.
7. **Player Object:** Avatar ubur-ubur yang memiliki animasi responsif terhadap input.

---

## Cara Bermain
1. Jalankan game dan tekan **PLAY** pada Menu Utama.
2. Gunakan tombol **Space** untuk naik:
   - **Tekan sekali:** Dorongan kecil ke atas.
   - **Tahan:** Berenang cepat ke atas (menguras stamina lebih banyak).
3. Hindari menabrak bagian hitam platform. Lewati celah (Hole) yang tersedia.
4. Pantau **Stamina Bar** di bawah layar. Jika habis, ubur-ubur akan tenggelam.
5. Ambil **Bubble** hijau untuk memulihkan stamina secara instan.
6. Capai skor setinggi mungkin!

---

## Daftar Aset & Lisensi
- **Visual/Gambar:** Dibuat menggunakan bantuan **Generative AI (Gemini & DALL-E)** untuk Background, UI Assets (Game Over, Score Panel, Buttons), dan Spritesheet karakter.
- **Audio/Musik:** 
  - `background_music.mp3`: generate by gemini
  - `sfx_assets`: https://sounddino.com/en/effects/game-sounds/, https://sounddino.com/en/search/?s=game+over 
- **Engine:** Godot Engine 4.x

---

## 📂 Struktur Folder
- `audio/`: Berisi seluruh aset suara dan musik.
- `assets/`: Berisi seluruh aset visual (PNG, Spritesheets).
- `scripts/`: Berisi logika permainan (GDScript).
- `main.tscn`: Scene utama permainan.
- `game_over.tscn`: Scene layar kekalahan.
- `main_menu.tscn`: Scene layar awal.
