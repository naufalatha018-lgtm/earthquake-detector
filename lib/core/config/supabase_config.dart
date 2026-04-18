// lib/core/config/supabase_config.dart

class SupabaseConfig {
  // 🔑 GANTI INI DENGAN CREDENTIALS ANDA!
  // Dapatkan dari: Supabase Dashboard → Settings → API
  
  static const String supabaseUrl = 'https://nlfvkyxbkltdfpwsboav.supabase.co';
  // Contoh: 'https://xyzcompany.supabase.co'
  
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5sZnZreXhia2x0ZGZwd3Nib2F2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0NjA0NjMsImV4cCI6MjA5MjAzNjQ2M30.-oFGzGSbGWAUrGQ8LwGaYJobKfftB-z65yvHjSMS8mE';
  // Contoh: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
}

// ============================================
// CARA MENDAPATKAN CREDENTIALS:
// ============================================
// 1. Buka Supabase Dashboard
// 2. Pilih project Anda
// 3. Klik Settings (⚙️) di sidebar kiri
// 4. Klik "API"
// 5. Copy:
//    - Project URL → supabaseUrl
//    - anon public key → supabaseAnonKey
// ============================================

// ⚠️ PENTING:
// File ini bersifat PUBLIC (anon key).
// Jangan commit service_role key ke Git!
// ============================================