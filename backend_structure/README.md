# Bhukampa Tech — Backend Architecture Documentation
## Firebase Realtime Database (RTDB) — Full Schema

> ⚠️ DOCUMENTATION ONLY. No backend logic is implemented.
> App runs in **DEMO MODE** — all earthquake data is simulated locally.

---

## Database Root Tree

```
ROOT
│
├── users/
│   └── {user_id}/
│       ├── name               (string)
│       ├── email              (string)
│       ├── role               (string: "admin" | "viewer")
│       ├── created_at         (ISO8601 timestamp)
│       └── device_ids[]       (array of device ID strings)
│
├── devices/
│   └── {device_id}/
│       ├── mac_address        (string)
│       ├── owner_id           (string → users/{user_id})
│       ├── device_name        (string)
│       ├── location/
│       │   ├── lat            (number)
│       │   ├── lng            (number)
│       │   └── label          (string — e.g. "Stasiun Bandung Utara")
│       ├── status/
│       │   ├── online         (bool)
│       │   ├── last_seen      (ISO8601 timestamp)
│       │   └── rssi           (number — signal strength dBm)
│       ├── settings/
│       │   ├── siren_enabled  (bool)
│       │   ├── alert_profile  (string: "low" | "medium" | "high" | "custom")
│       │   └── custom_threshold/
│       │       ├── magnitude  (number)
│       │       └── radius_km  (number)
│       └── created_at         (ISO8601 timestamp)
│
├── earthquake_data/
│   └── {event_id}/
│       ├── magnitude          (number — Richter scale)
│       ├── depth              (number — km below surface)
│       ├── epicenter_location (string — e.g. "12 km SE of Cianjur")
│       ├── timestamp          (ISO8601 timestamp)
│       └── source             (string: "BMKG")
│
├── alerts/
│   └── {alert_id}/
│       ├── user_id            (string → users/{user_id})
│       ├── device_id          (string → devices/{device_id})
│       ├── magnitude          (number)
│       ├── distance_km        (number)
│       ├── risk_level         (string: "aman" | "waspada" | "bahaya")
│       ├── triggered          (bool)
│       └── timestamp          (ISO8601 timestamp)
│
├── logs/
│   └── {log_id}/
│       ├── device_id          (string → devices/{device_id})
│       ├── type               (string: "sensor" | "manual" | "api")
│       ├── message            (string)
│       └── timestamp          (ISO8601 timestamp)
│
├── emergency_contacts/
│   └── {user_id}/
│       ├── name               (string)
│       ├── phone              (string — E.164 format: +628xxx)
│       └── type               (string: "family" | "medical" | "rescue" | "etc")
│
├── settings/
│   └── {user_id}/
│       ├── theme              (string: "dark" | "light" | "system")
│       ├── language           (string: "id" | "en")
│       └── notifications_enabled (bool)
│
└── DEMO MODE (aktif sekarang)
    ├── demo_environment/
    │   └── earthquake_data/
    │       ├── magnitude      (number)
    │       ├── distance_km    (number)
    │       └── status_trigger (bool)
    │
    └── demo_device_control/
        └── siren_active       (bool)
```

---

## Node Descriptions

### `/users/{user_id}/`
Menyimpan data akun operator. Dibuat saat registrasi via Firebase Auth.

| Field | Type | Keterangan |
|-------|------|-----------|
| `name` | string | Nama lengkap operator |
| `email` | string | Email akun |
| `role` | string | `"admin"` atau `"viewer"` |
| `created_at` | timestamp | Waktu registrasi |
| `device_ids[]` | array | Daftar ID perangkat yang terdaftar |

---

### `/devices/{device_id}/`
Setiap node IoT (ESP32/Arduino) mendaftarkan diri ke path ini.

| Field | Type | Keterangan |
|-------|------|-----------|
| `mac_address` | string | MAC address hardware unik |
| `owner_id` | string | Referensi ke `users/{user_id}` |
| `device_name` | string | Label perangkat yang dapat dikustom |
| `location.lat/lng` | number | Koordinat GPS pemasangan |
| `location.label` | string | Nama lokasi manusia-baca |
| `status.online` | bool | Heartbeat aktif/tidak |
| `status.last_seen` | timestamp | Terakhir terdeteksi aktif |
| `status.rssi` | number | Kekuatan sinyal WiFi (dBm) |
| `settings.siren_enabled` | bool | Siren dikontrol dari perangkat ini |
| `settings.alert_profile` | string | `"low"` / `"medium"` / `"high"` / `"custom"` |
| `settings.custom_threshold.magnitude` | number | Threshold magnitudo (jika custom) |
| `settings.custom_threshold.radius_km` | number | Radius bahaya (jika custom) |

---

### `/earthquake_data/{event_id}/`
Data gempa dari sumber BMKG (atau sensor). Setiap event punya ID unik.

| Field | Type | Keterangan |
|-------|------|-----------|
| `magnitude` | number | Skala Richter |
| `depth` | number | Kedalaman episenter (km) |
| `epicenter_location` | string | Deskripsi lokasi episenter |
| `timestamp` | timestamp | Waktu kejadian |
| `source` | string | `"BMKG"` atau `"sensor"` |

---

### `/alerts/{alert_id}/`
Setiap pemicu alert menghasilkan record di sini.

| Field | Type | Keterangan |
|-------|------|-----------|
| `user_id` | string | Operator yang menerima alert |
| `device_id` | string | Perangkat yang memicu |
| `magnitude` | number | Magnitudo saat alert |
| `distance_km` | number | Jarak episenter saat alert |
| `risk_level` | string | `"aman"` / `"waspada"` / `"bahaya"` |
| `triggered` | bool | `true` = alert aktif |
| `timestamp` | timestamp | Waktu alert dibuat |

---

### `/logs/{log_id}/`
Log aktivitas perangkat untuk debugging dan audit.

| Field | Type | Keterangan |
|-------|------|-----------|
| `device_id` | string | Perangkat sumber log |
| `type` | string | `"sensor"` / `"manual"` / `"api"` |
| `message` | string | Isi pesan log |
| `timestamp` | timestamp | Waktu log dibuat |

---

### `/emergency_contacts/{user_id}/`
Kontak darurat yang akan dihubungi saat bahaya.

| Field | Type | Keterangan |
|-------|------|-----------|
| `name` | string | Nama kontak |
| `phone` | string | Nomor telepon format E.164 |
| `type` | string | `"family"` / `"medical"` / `"rescue"` / dll |

---

### `/settings/{user_id}/`
Preferensi tampilan & notifikasi per user.

| Field | Type | Keterangan |
|-------|------|-----------|
| `theme` | string | `"dark"` / `"light"` / `"system"` |
| `language` | string | `"id"` (Indonesia) / `"en"` (English) |
| `notifications_enabled` | bool | Master switch notifikasi |

---

### `/demo_environment/earthquake_data/` ← AKTIF SEKARANG
Path yang dibaca aplikasi saat ini. Di produksi, ditulis oleh sensor IoT.

```json
{
  "magnitude": 1.2,
  "distance_km": 85.0,
  "status_trigger": false
}
```

### `/demo_device_control/siren_active` ← AKTIF SEKARANG
Ditulis oleh operator dari app, dibaca oleh node IoT.

```json
true
```

---

## Data Flow (Production)

```
IoT Sensor (ESP32)
      │ writes /earthquake_data/{event_id}
      │ reads  /demo_device_control/siren_active
      ▼
Firebase RTDB
      │ streams onValue
      ▼
EarthquakeProvider (Flutter)
      │
      ├─► RiskEngine.classify(magnitude, distance)
      │        └─► AMAN | WASPADA | BAHAYA
      │
      ├─► if status_trigger → AudioPlayer.play('alarm.mp3')
      │
      ├─► creates /alerts/{alert_id}
      │
      ├─► notifies /emergency_contacts/{user_id}
      │
      └─► UI: Dashboard, MetricCard, RiskIndicator, SeismicChart
```

---

## Local Risk Engine (Offline — No Backend)

```
getRiskLevel(magnitude, distance_km) → RiskLevel

  mag < 3.0                   → AMAN
  mag 3–5,  dist > 50 km      → AMAN
  mag 3–5,  dist 20–50 km     → WASPADA
  mag 3–5,  dist < 20 km      → BAHAYA
  mag 5–6.5, dist > 80 km     → WASPADA
  mag 5–6.5, dist ≤ 80 km     → BAHAYA
  mag ≥ 6.5  (berapapun jarak) → BAHAYA
```

---

*Bhukampa Tech v1.0 — Dokumentasi Backend Structure*
*Stack: Flutter · Firebase RTDB · ESP32 · audioplayers*
