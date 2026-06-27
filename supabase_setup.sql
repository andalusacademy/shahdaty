-- ══════════════════════════════════════════════
-- شهادتي العلمية — إعداد قاعدة البيانات
-- ══════════════════════════════════════════════

-- 1. تفعيل UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. جدول المؤسسات
CREATE TABLE IF NOT EXISTS institutions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  license_number TEXT UNIQUE,
  password TEXT,
  package TEXT DEFAULT 'basic',
  quota_limit INTEGER DEFAULT 50,
  quota_used INTEGER DEFAULT 0,
  logo_url TEXT,
  email TEXT,
  phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. جدول الشهادات
CREATE TABLE IF NOT EXISTS certificates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cert_number TEXT UNIQUE,
  student_name TEXT NOT NULL,
  student_id TEXT NOT NULL,
  major TEXT,
  gpa NUMERIC(4,2),
  graduation_date DATE,
  grade TEXT,
  blockchain_hash TEXT UNIQUE,
  institution_id UUID REFERENCES institutions(id) ON DELETE SET NULL,
  pdf_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. جدول طلبات الاعتماد
CREATE TABLE IF NOT EXISTS accreditation_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  institution_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  type TEXT,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. RLS - السماح للعموم بالتحقق من الشهادات
ALTER TABLE certificates ENABLE ROW LEVEL SECURITY;
ALTER TABLE institutions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_verify_certificates"
  ON certificates FOR SELECT TO anon
  USING (true);

CREATE POLICY "authenticated_manage_certificates"
  ON certificates FOR ALL TO authenticated
  USING (true);

CREATE POLICY "public_read_institutions"
  ON institutions FOR SELECT TO anon
  USING (true);

CREATE POLICY "authenticated_manage_institutions"
  ON institutions FOR ALL TO authenticated
  USING (true);

-- 6. بيانات تجريبية
INSERT INTO institutions (name, license_number, password, package, quota_limit, quota_used)
VALUES ('مركز الاندلس للتدريب', 'LIC-AND-2024', 'andalus2024', 'gold', 2000, 150)
ON CONFLICT DO NOTHING;
